Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXJVMbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXJVMbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXJVMbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:31:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbXJVMbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:31:06 -0400
Date: Mon, 22 Oct 2007 14:30:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071022123041.GA4990@elte.hu>
References: <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071022122504.GL2998@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> On Mon, Oct 22, 2007 at 12:36:00PM +0100, Al Viro wrote:
> >On Mon, Oct 22, 2007 at 03:48:23PM +0800, WANG Cong wrote:
> >> I just followed what Sam told me, errors are much fewer this time,
> >> but still exist. Error messages are:
> >> 
> >>   CC      arch/um/kernel/syscall.o
> >>   CC      arch/um/kernel/sysrq.o
> >> arch/um/kernel/sysrq.c: In function ???show_stack???:
> >> arch/um/kernel/sysrq.c:63: error: ???UESP??? undeclared (first use in this function)
> >> arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported only once
> >> arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
> >> make[1]: *** [arch/um/kernel/sysrq.o] Error 1
> >> make: *** [arch/um/kernel] Error 2
> >> 
> >> Or I missed something again?
> >> 
> >> And I use `make defconfig ARCH=um' to generate .config, my tree
> >> is 2.6.23-git16 (Al, is this OK?).
> >
> >Now apply the patch upthread, it should've fixed that one (and yes, you
> >are down to the stuff this patch is supposed to fix - and does so here).
> 
> Yes, this one is fixed. Thanks for your patch.
> 
> But another one comes out. ;(
> 
>   CC      kernel/sched.o
> kernel/sched.c:3902: error: conflicting types for ‘wait_for_completion_interruptible’
> include/linux/completion.h:46: error: previous declaration of ‘wait_for_completion_interruptible’ was here
> kernel/sched.c:3908: error: conflicting types for ‘wait_for_completion_interruptible’
> include/linux/completion.h:46: error: previous declaration of ‘wait_for_completion_interruptible’ was here
> make[1]: *** [kernel/sched.o] Error 1
> make: *** [kernel] Error 2

does the patch below ontop of latest -git help?

	Ingo

---------------->
Subject: sched: fix fastcall mismatch in completion APIs
From: Ingo Molnar <mingo@elte.hu>

Jeff Dike noticed that wait_for_completion_interruptible()'s prototype
had a mismatched fastcall.

Fix this by removing the fastcall attributes from all the completion APIs.

Found-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/completion.h |   16 ++++++++--------
 kernel/sched.c             |   10 +++++-----
 2 files changed, 13 insertions(+), 13 deletions(-)

Index: linux/include/linux/completion.h
===================================================================
--- linux.orig/include/linux/completion.h
+++ linux/include/linux/completion.h
@@ -42,15 +42,15 @@ static inline void init_completion(struc
 	init_waitqueue_head(&x->wait);
 }
 
-extern void FASTCALL(wait_for_completion(struct completion *));
-extern int FASTCALL(wait_for_completion_interruptible(struct completion *x));
-extern unsigned long FASTCALL(wait_for_completion_timeout(struct completion *x,
-						   unsigned long timeout));
-extern unsigned long FASTCALL(wait_for_completion_interruptible_timeout(
-			struct completion *x, unsigned long timeout));
+extern void wait_for_completion(struct completion *);
+extern int wait_for_completion_interruptible(struct completion *x);
+extern unsigned long wait_for_completion_timeout(struct completion *x,
+						   unsigned long timeout);
+extern unsigned long wait_for_completion_interruptible_timeout(
+			struct completion *x, unsigned long timeout);
 
-extern void FASTCALL(complete(struct completion *));
-extern void FASTCALL(complete_all(struct completion *));
+extern void complete(struct completion *);
+extern void complete_all(struct completion *);
 
 #define INIT_COMPLETION(x)	((x).done = 0)
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -3821,7 +3821,7 @@ __wake_up_sync(wait_queue_head_t *q, uns
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
-void fastcall complete(struct completion *x)
+void complete(struct completion *x)
 {
 	unsigned long flags;
 
@@ -3833,7 +3833,7 @@ void fastcall complete(struct completion
 }
 EXPORT_SYMBOL(complete);
 
-void fastcall complete_all(struct completion *x)
+void complete_all(struct completion *x)
 {
 	unsigned long flags;
 
@@ -3885,13 +3885,13 @@ wait_for_common(struct completion *x, lo
 	return timeout;
 }
 
-void fastcall __sched wait_for_completion(struct completion *x)
+void __sched wait_for_completion(struct completion *x)
 {
 	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(wait_for_completion);
 
-unsigned long fastcall __sched
+unsigned long __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 {
 	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
@@ -3907,7 +3907,7 @@ int __sched wait_for_completion_interrup
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible);
 
-unsigned long fastcall __sched
+unsigned long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
 {
