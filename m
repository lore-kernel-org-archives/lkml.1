Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZKIXWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZKIXWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZKIXWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:22:31 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:46401 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbZKIXWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:22:30 -0500
Message-ID: <4AF8A40B.10708@gmail.com>
Date: Tue, 10 Nov 2009 00:21:47 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC,PATCH] mutex: mutex_is_owner() helper
References: <4AF19D06.3060401@gmail.com> <20091104154015.GA32567@elte.hu>	 <4AF1B7A7.6030902@gmail.com> <1257792987.4108.364.camel@laptop>
In-Reply-To: <1257792987.4108.364.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 10 Nov 2009 00:21:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Wed, 2009-11-04 at 18:19 +0100, Eric Dumazet wrote:
>> BTW, I was thinking of a mutex_yield() implementation, but could not
>> cook it without hard thinking, maybe you already have some nice
>> implementation ?
> 
> Why? Yield sets off alarm bells, since 99.9%, and possibly more, of its
> uses are wrong.

If I remember well, I had problems doing "modprobe dummy numdummies=30000",
because it creates 30000 netdevices, and thanks to hotplug starts 30000 udev
that all wait that my modprobe is finished... Nice to see load average going
so big by the way :)

I tried following patch without success, because rtnl_unlock()/rtnl_lock()
is too fast (awaken process(es) ha(s/ve) no chance to get the lock, as we
take it immediately after releasing it)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 37dcfdc..3de1466 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -138,8 +138,11 @@ static int __init dummy_init_module(void)
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
 
-	for (i = 0; i < numdummies && !err; i++)
+	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
+		rtnl_unlock();
+		rtnl_lock();
+	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
 	rtnl_unlock();



Then I added a msleep(1) between the unlock/lock and got beter results.



diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index 37dcfdc..108c4fa 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -138,8 +138,12 @@ static int __init dummy_init_module(void)
 	rtnl_lock();
 	err = __rtnl_link_register(&dummy_link_ops);
 
-	for (i = 0; i < numdummies && !err; i++)
+	for (i = 0; i < numdummies && !err; i++) {
 		err = dummy_init_one();
+		rtnl_unlock();
+		msleep(1);
+		rtnl_lock();
+	}
 	if (err < 0)
 		__rtnl_link_unregister(&dummy_link_ops);
 	rtnl_unlock();

But if hotplug is disabled, this force a useless msleep(1) * 30000 -> this is bit slow

Yes, this code is stupid, but I use it to stress network stack
with insane number of devices, to spot scalability problems.


mutex_yield() could help in this situation.

mutex is said to be FIFO, but its not exactly true : A new comer can take the mutex
even if 10000 threads are waiting on mutex...

I wont mention other problems, because mutex_{try}lock() has no timedwait variant, and
funny code doing :

if (!rtnl_trylock())
	return restart_syscall();

Making 30000 processes running/fighting to get the mutex :(

