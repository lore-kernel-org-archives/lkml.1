Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYEHM2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYEHM2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYEHM2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:28:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35261 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYEHM2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:28:20 -0400
Date: Thu, 8 May 2008 14:28:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508122802.GA4880@elte.hu>
References: <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508120130.GA2860@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> +	if (unlikely(sem->count <= 0))
>  		__down(sem);
> +	sem->count--;

Peter pointed it out that because sem->count is u32, the <= 0 is in fact 
a "== 0" condition - the patch below does that. As expected gcc figured 
out the same thing too so the resulting code output did not change. (so 
this is just a cleanup)

i've got this lined up in sched.git and it's undergoing testing right 
now. If that testing goes fine and if there are no objections i'll send 
a pull request for it later today.

	Ingo

---------------->
Subject: semaphores: improve code
From: Ingo Molnar <mingo@elte.hu>
Date: Thu May 08 14:19:23 CEST 2008

No code changed:

kernel/semaphore.o:

   text	   data	    bss	    dec	    hex	filename
   1207	      0	      0	   1207	    4b7	semaphore.o.before
   1207	      0	      0	   1207	    4b7	semaphore.o.after

md5:
   c10198c2952bd345a1edaac6db891548  semaphore.o.before.asm
   c10198c2952bd345a1edaac6db891548  semaphore.o.after.asm

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/semaphore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/kernel/semaphore.c
===================================================================
--- linux.orig/kernel/semaphore.c
+++ linux/kernel/semaphore.c
@@ -54,7 +54,7 @@ void down(struct semaphore *sem)
 	unsigned long flags;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count <= 0))
+	if (unlikely(!sem->count))
 		__down(sem);
 	sem->count--;
 	spin_unlock_irqrestore(&sem->lock, flags);
@@ -76,7 +76,7 @@ int down_interruptible(struct semaphore 
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count <= 0))
+	if (unlikely(!sem->count))
 		result = __down_interruptible(sem);
 	if (!result)
 		sem->count--;
@@ -102,7 +102,7 @@ int down_killable(struct semaphore *sem)
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count <= 0))
+	if (unlikely(!sem->count))
 		result = __down_killable(sem);
 	if (!result)
 		sem->count--;
@@ -156,7 +156,7 @@ int down_timeout(struct semaphore *sem, 
 	int result = 0;
 
 	spin_lock_irqsave(&sem->lock, flags);
-	if (unlikely(sem->count <= 0))
+	if (unlikely(!sem->count))
 		result = __down_timeout(sem, jiffies);
 	if (!result)
 		sem->count--;
