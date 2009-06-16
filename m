Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZFPOUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZFPOUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZFPOUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:20:44 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42428 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZFPOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:20:43 -0400
Message-ID: <4A37AA0C.40507@gmail.com>
Date: Tue, 16 Jun 2009 16:19:56 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu,
       alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
References: <20090616094813.GA1686@elte.hu>	<20090616.025659.224075454.davem@davemloft.net>	<20090616101132.GA28204@elte.hu> <20090616.033554.102149558.davem@davemloft.net> <4A37A058.1030701@gmail.com>
In-Reply-To: <4A37A058.1030701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 16 Jun 2009 16:19:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> David Miller a écrit :
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Tue, 16 Jun 2009 12:11:32 +0200
>>
>>> sure, here you go (i also added a stack dump, just in case it's some 
>>> kernel-internal socket open):
>>>
>>>  [ifconfig:3516]: Creates X25 socket.
>>>
>>> so plain ifconfig. Part of the ~1.5 years old net-tools-1.60-84.fc8.
>> Ok, ifconfig seems to open one of every socket type when it starts up.
>> That explains why an X25 socket is openned and then closed.
>>
>> Now the question is why is the X25 socket released by a timer?  This
>> should only happen if some socket memory is still pending in the
>> socket buffers.
>>
>> Wait, I know why this is triggering now.  It's Eric Dumazet's SKB
>> accounting optimizations.
>>
>> So, I'll fix the X25 timer bug.  It's always been there, but
>> beforehand this deferred-via-timer x25 socket destruction path almost
>> never triggers.  So we never saw it.  Now it happens every time.
>>
>> Eric can you sniff around and see what you think about this unforseen
>> (at least for me) consequence of your changes?  Socket layers that use
>> the current sk_wmem_alloc/sk_rmem_alloc value at destroy time to
>> determine if a socket can be killed immediately, or need to be killed
>> later via timer, will always see that dummy one byte allocation you
>> now put there.
>>
>> Can you look into that?
>>
>> Thanks.
> 
> 
> Sure I can look if a layer uses sk_wmem_alloc as you describe.
> 
> (I take you refer to commit 2b85a34e911bf483c27cfdd124aeb1605145dc80 :
> net: No more expensive sock_hold()/sock_put() on each tx)
> 
> So there is no impact for sk_rmem_alloc AFAIK
> 

Here is first patch to take into account this initial offset in sk_wmem_alloc

(Only compiled, not tested)

A second patch will follow to correct /prov/net/udp and other PROC_FS files, and
also SIOCOUTQ/TIOCOUTQ, as we currently give off-by-one values, it certainly can
break some apps.

Thank you

[PATCH] net: sk_wmem_alloc has initial value of one, not zero

commit 2b85a34e911bf483c27cfdd124aeb1605145dc80 
(net: No more expensive sock_hold()/sock_put() on each tx)
changed initial sk_wmem_alloc value.

Some protocols check sk_wmem_alloc value to determine if a timer
must delay socket deallocation. We must take care of the sk_wmem_alloc
value being one instead of zero.

Reported by Ingo Molnar, and full diagnostic from David Miller.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/appletalk/ddp.c    |    4 ++--
 net/ax25/af_ax25.c     |    2 +-
 net/econet/af_econet.c |    4 ++--
 net/netrom/af_netrom.c |    2 +-
 net/rose/af_rose.c     |    2 +-
 net/x25/af_x25.c       |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index b603cba..048cfd0 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -162,7 +162,7 @@ static void atalk_destroy_timer(unsigned long data)
 {
 	struct sock *sk = (struct sock *)data;
 
-	if (atomic_read(&sk->sk_wmem_alloc) ||
+	if (atomic_read(&sk->sk_wmem_alloc) > 1 ||
 	    atomic_read(&sk->sk_rmem_alloc)) {
 		sk->sk_timer.expires = jiffies + SOCK_DESTROY_TIME;
 		add_timer(&sk->sk_timer);
@@ -175,7 +175,7 @@ static inline void atalk_destroy_socket(struct sock *sk)
 	atalk_remove_socket(sk);
 	skb_queue_purge(&sk->sk_receive_queue);
 
-	if (atomic_read(&sk->sk_wmem_alloc) ||
+	if (atomic_read(&sk->sk_wmem_alloc) > 1 ||
 	    atomic_read(&sk->sk_rmem_alloc)) {
 		setup_timer(&sk->sk_timer, atalk_destroy_timer,
 				(unsigned long)sk);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index fd9d06f..2e81b1d 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -330,7 +330,7 @@ void ax25_destroy_socket(ax25_cb *ax25)
 	}
 
 	if (ax25->sk != NULL) {
-		if (atomic_read(&ax25->sk->sk_wmem_alloc) ||
+		if (atomic_read(&ax25->sk->sk_wmem_alloc) > 1 ||
 		    atomic_read(&ax25->sk->sk_rmem_alloc)) {
 			/* Defer: outstanding buffers */
 			setup_timer(&ax25->dtimer, ax25_destroy_timer,
diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 8121bf0..051dcb6 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -540,7 +540,7 @@ static void econet_destroy_timer(unsigned long data)
 {
 	struct sock *sk=(struct sock *)data;
 
-	if (!atomic_read(&sk->sk_wmem_alloc) &&
+	if (atomic_read(&sk->sk_wmem_alloc) <= 1 &&
 	    !atomic_read(&sk->sk_rmem_alloc)) {
 		sk_free(sk);
 		return;
@@ -580,7 +580,7 @@ static int econet_release(struct socket *sock)
 	skb_queue_purge(&sk->sk_receive_queue);
 
 	if (atomic_read(&sk->sk_rmem_alloc) ||
-	    atomic_read(&sk->sk_wmem_alloc)) {
+	    atomic_read(&sk->sk_wmem_alloc) > 1) {
 		sk->sk_timer.data     = (unsigned long)sk;
 		sk->sk_timer.expires  = jiffies + HZ;
 		sk->sk_timer.function = econet_destroy_timer;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 3be0e01..8126bd4 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -286,7 +286,7 @@ void nr_destroy_socket(struct sock *sk)
 		kfree_skb(skb);
 	}
 
-	if (atomic_read(&sk->sk_wmem_alloc) ||
+	if (atomic_read(&sk->sk_wmem_alloc) > 1 ||
 	    atomic_read(&sk->sk_rmem_alloc)) {
 		/* Defer: outstanding buffers */
 		sk->sk_timer.function = nr_destroy_timer;
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 877a7f6..0ab0f4d 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -356,7 +356,7 @@ void rose_destroy_socket(struct sock *sk)
 		kfree_skb(skb);
 	}
 
-	if (atomic_read(&sk->sk_wmem_alloc) ||
+	if (atomic_read(&sk->sk_wmem_alloc) > 1 ||
 	    atomic_read(&sk->sk_rmem_alloc)) {
 		/* Defer: outstanding buffers */
 		setup_timer(&sk->sk_timer, rose_destroy_timer,
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index c51f309..57dd5d3 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -372,7 +372,7 @@ static void __x25_destroy_socket(struct sock *sk)
 		kfree_skb(skb);
 	}
 
-	if (atomic_read(&sk->sk_wmem_alloc) ||
+	if (atomic_read(&sk->sk_wmem_alloc) > 1 ||
 	    atomic_read(&sk->sk_rmem_alloc)) {
 		/* Defer: outstanding buffers */
 		sk->sk_timer.expires  = jiffies + 10 * HZ;
