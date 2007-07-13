Return-Path: <linux-kernel-owner+w=401wt.eu-S935910AbXGMHOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935910AbXGMHOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXGMHOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:14:47 -0400
Received: from qsrv01ps.mx.bigpond.com ([144.140.82.181]:50987 "EHLO
	qsrv01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXGMHOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:14:45 -0400
Message-ID: <46971ADC.3030700@bigpond.net.au>
Date: Fri, 13 Jul 2007 16:25:32 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gregory Haskins <ghaskins@novell.com>, jim.houston@ccur.com,
       joe.korty@ccur.com, rostedt@goodmis.org, tglx@linutronix.de,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22	available
References: <4695E5BB0200005A0002763E@mcclure.wal.novell.com> <20070712130958.GB17494@elte.hu>
In-Reply-To: <20070712130958.GB17494@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------040700070604070106090803"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [58.170.68.8] using ID pwil3058@bigpond.net.au at Fri, 13 Jul 2007 06:26:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040700070604070106090803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
>> On Thu, 2007-07-12 at 14:07 +0200, Ingo Molnar wrote:
>>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>>
>>>> Hi Ingo, Thomas, and the greater linux-rt community,
>>>>   
>>>> 	I just wanted to let you guys know that our team has a port of 
>>>> the 21.5-rt20 patch for the 2.6.22 kernel available. [...]
>>> great! We had the upstream -rt port to .22 in the works too, it was just 
>>> held up by the hpet breakage - which Thomas managed to fix earlier 
>>> today. I've released the 2.6.22.1-rt1 patch to the usual place:
>>>
>>>     http://redhat.com/~mingo/realtime-preempt/
>> Thats awesome, Ingo!  Thanks!  Could you publish a broken out version 
>> as well?  We found it extremely valuable to be able to bisect this 
>> beast while working on the 21-22 port.
> 
> we are working on something in this area :) Stay tuned ...

I've just been reviewing these patches and have spotted an error in the
file mm/slob.c at lines 500-501 whereby a non existent variable "c" is
referenced.  The attached patch is a proposed fix to the problem.

-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
 -- Ambrose Bierce

--------------040700070604070106090803
Content-Type: text/x-patch;
 name="fix-slob-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-slob-error.patch"

Fix error in realtime-preempt patch for mm/slob.c

This error was caused by a change to slob_free()'s interface.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

diff -r cb0010b7bffe mm/slob.c
--- a/mm/slob.c	Fri Jul 13 15:24:45 2007 +1000
+++ b/mm/slob.c	Fri Jul 13 16:23:02 2007 +1000
@@ -493,14 +493,14 @@ void *kmem_cache_zalloc(struct kmem_cach
 }
 EXPORT_SYMBOL(kmem_cache_zalloc);
 
-static void __kmem_cache_free(void *b, int size)
+static void __kmem_cache_free(struct kmem_cache *c, void *b)
 {
 	atomic_dec(&c->items);
 
 	if (c->size <= MAX_SLOB_CACHE_SIZE)
 		slob_free(c, b, c->size);
 	else
-		free_pages((unsigned long)b, get_order(size));
+		free_pages((unsigned long)b, get_order(c->size));
 }
 
 static void kmem_rcu_free(struct rcu_head *head)
@@ -508,7 +508,7 @@ static void kmem_rcu_free(struct rcu_hea
 	struct slob_rcu *slob_rcu = (struct slob_rcu *)head;
 	void *b = (void *)slob_rcu - (slob_rcu->size - sizeof(struct slob_rcu));
 
-	__kmem_cache_free(b, slob_rcu->size);
+	__kmem_cache_free(slob_rcu, b);
 }
 
 void kmem_cache_free(struct kmem_cache *c, void *b)
@@ -520,7 +520,7 @@ void kmem_cache_free(struct kmem_cache *
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
-		__kmem_cache_free(b, c->size);
+		__kmem_cache_free(c, b);
 	}
 }
 EXPORT_SYMBOL(kmem_cache_free);

--------------040700070604070106090803--
