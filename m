Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZETKzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZETKzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 06:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZETKzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 06:55:40 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:44009 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZETKzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 06:55:39 -0400
Date: Wed, 20 May 2009 16:25:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Patch 1/2] Improvements and minor fixes to HW Breakpoint
	interface
Message-ID: <20090520105535.GA17181@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090519162459.GB26009@in.ibm.com> <Pine.LNX.4.44L0.0905191351380.10557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905191351380.10557-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 02:09:12PM -0400, Alan Stern wrote:
> On Tue, 19 May 2009, K.Prasad wrote:
> 
> > This patch brings a couple of changes to the HW Breakpoint infrastructure:
> > 
> > - Set/clear TIF_DEBUG task flag in <un>register_user_hw_breakpoint()
> >   instead of being done by users of this interface (such as ptrace).
> > 
> > - Modify return code of hw_breakpoint_handler() to NOTIFY_STOP if
> >   triggered due to lazy debug register switching.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kernel/hw_breakpoint.c |    4 +++-
> >  arch/x86/kernel/ptrace.c        |    4 +---
> >  kernel/hw_breakpoint.c          |   16 +++++++++++++---
> >  3 files changed, 17 insertions(+), 7 deletions(-)
> > 
> > Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
> > ===================================================================
> > --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
> > +++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
> > @@ -346,8 +346,10 @@ int __kprobes hw_breakpoint_handler(stru
> >  		 * or due to the delay between updates of hbp_kernel_pos
> >  		 * and this_hbp_kernel.
> >  		 */
> > -		if (!bp)
> > +		if (!bp) {
> > +			rc = NOTIFY_STOP;
> >  			continue;
> > +		}
> >  
> >  		(bp->triggered)(bp, args->regs);
> >  		/*
> 
> This doesn't look right.  You want to return NOTIFY_DONE if any
> breakpoints were triggered or any non-breakpoint bits were set in DR6,
> right?  Otherwise return NOTIFY_STOP.  So this code should be:
> 

Agreed, we want to return NOTIFY_DONE in the above two cases and the
patch does the same.

If there are any more breakpoints (basically more trap bits in DR6 set)
that require handling, the "continue" statement allows it to be done.

If the non-breakpoint bits were set in DR6, then "rc" value is
over-written in hw_breakpoint_handler() below the "if (!bp)" check.

	if (dr6 & (~DR_TRAP_BITS))
		rc = NOTIFY_DONE;

The issue in the original hw_breakpoint_handler() is the return of
NOTIFY_DONE during lazy debug register switching or mismatched
this_hbp_kernel[], that may cause SIGTRAP signal for user-space
in do_debug() function.

> 		if (!bp)
> 			continue;
> 
> 		rc = NOTIFY_DONE;
> 		(bp->triggered)(bp, args->regs);
> 
> and take out the "rc = NOTIFY_DONE" line in the i < hbp_kernel_pos 
> case earlier.
> 

This change will unconditionally return NOTIFY_DONE even if exception
was triggered due to a single kernel-space HW breakpoint.

> It also would be a good idea to add a comment near the start of the
> function explaining the return value (just paraphrase what I wrote
> above).
> 
> 

I've added a descriptive comment. Let me know if it can be improved.

> > Index: linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
> > ===================================================================
> > --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/ptrace.c
> > +++ linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
> > @@ -530,9 +530,7 @@ restore:
> >  				bp->info.len = len;
> >  				bp->info.type = type;
> >  				rc = register_user_hw_breakpoint(tsk, bp);
> > -				if (!rc)
> > -					set_tsk_thread_flag(tsk, TIF_DEBUG);
> > -				else
> > +				if (rc)
> >  					kfree(bp);
> >  			}
> >  		} else
> > Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> > ===================================================================
> > --- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
> > +++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> > @@ -233,6 +233,8 @@ int register_user_hw_breakpoint(struct t
> >  			break;
> >  		}
> >  	}
> > +	if (!rc)
> > +		set_tsk_thread_flag(tsk, TIF_DEBUG);
> >  
> >  	spin_unlock_bh(&hw_breakpoint_lock);
> >  	return rc;
> > @@ -272,15 +274,23 @@ void unregister_user_hw_breakpoint(struc
> >  						struct hw_breakpoint *bp)
> >  {
> >  	struct thread_struct *thread = &(tsk->thread);
> > -	int i;
> > +	int i, pos = -1, clear_tsk_debug_counter = 0;
> 
> I think "hbp_counter" would be a better name.  It's up to you.
> 

Changed.

> >  
> >  	spin_lock_bh(&hw_breakpoint_lock);
> >  	for (i = 0; i < hbp_kernel_pos; i++) {
> > +		if (thread->hbp[i])
> > +			clear_tsk_debug_counter++;
> >  		if (bp == thread->hbp[i]) {
> > -			__unregister_user_hw_breakpoint(i, tsk);
> > -			break;
> > +			clear_tsk_debug_counter--;
> > +			pos = i;
> >  		}
> >  	}
> > +	if (pos >= 0)
> > +		__unregister_user_hw_breakpoint(pos, tsk);
> > +
> > +	if (!clear_tsk_debug_counter)
> > +		clear_tsk_thread_flag(tsk, TIF_DEBUG);
> 
> This logic could be rearranged a little:
> 
> 	for (i = 0; i < hbp_kernel_pos; i++) {
> 		if (thread->hbp[i])
> 			clear_tsk_debug_counter++;
> 		if (bp == thread->hbp[i])
> 			pos = i;
> 	}
> 	if (pos >= 0) {
> 		__unregister_user_hw_breakpoint(pos, tsk);
> 		clear_tsk_debug_counter--;
> 	}
> 	if (!clear_tsk_debug_counter)
> 		clear_tsk_thread_flag(tsk, TIF_DEBUG);
> 
> Not a big deal; this way is a little more robust in case two 
> thread->hbp[] entries somehow contain the same pointer.
> 

Ok. I have changed it.

> > +
> >  	spin_unlock_bh(&hw_breakpoint_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
> 
> Alan Stern
> 

Please find the updated patch below and kindly let me know your
comments on the same.


Improvements and minor fixes to HW Breakpoint interface

This patch brings a couple of changes to the HW Breakpoint infrastructure:

- Set/clear TIF_DEBUG task flag in <un>register_user_hw_breakpoint()
  instead of being done by users of this interface (such as ptrace).

- Modify return code of hw_breakpoint_handler() to NOTIFY_STOP if
  triggered due to lazy debug register switching.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c |   17 ++++++++++++++++-
 arch/x86/kernel/ptrace.c        |    4 +---
 kernel/hw_breakpoint.c          |   19 ++++++++++++++-----
 3 files changed, 31 insertions(+), 9 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/hw_breakpoint.c
@@ -296,6 +296,19 @@ void arch_flush_thread_hw_breakpoint(str
 
 /*
  * Handle debug exception notifications.
+ *
+ * Return value is either NOTIFY_STOP or NOTIFY_DONE as explained below.
+ *
+ * NOTIFY_DONE returned if one of the following conditions is true.
+ * i) When the causative address is from user-space and the exception
+ * is a valid one i.e. not triggered a result of lazy debug register
+ * switching
+ * ii) When there are more bits than trap<n> set in DR6 register (such
+ * as BD, BS or BT) indicating that more than one debug condition is
+ * met and requires some more action in do_debug().
+ *
+ * NOTIFY_STOP returned for all other cases
+ *
  */
 int __kprobes hw_breakpoint_handler(struct die_args *args)
 {
@@ -346,8 +359,10 @@ int __kprobes hw_breakpoint_handler(stru
 		 * or due to the delay between updates of hbp_kernel_pos
 		 * and this_hbp_kernel.
 		 */
-		if (!bp)
+		if (!bp) {
+			rc = NOTIFY_STOP;
 			continue;
+		}
 
 		(bp->triggered)(bp, args->regs);
 		/*
Index: linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/ptrace.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
@@ -530,9 +530,7 @@ restore:
 				bp->info.len = len;
 				bp->info.type = type;
 				rc = register_user_hw_breakpoint(tsk, bp);
-				if (!rc)
-					set_tsk_thread_flag(tsk, TIF_DEBUG);
-				else
+				if (rc)
 					kfree(bp);
 			}
 		} else
Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -233,6 +233,8 @@ int register_user_hw_breakpoint(struct t
 			break;
 		}
 	}
+	if (!rc)
+		set_tsk_thread_flag(tsk, TIF_DEBUG);
 
 	spin_unlock_bh(&hw_breakpoint_lock);
 	return rc;
@@ -272,15 +274,22 @@ void unregister_user_hw_breakpoint(struc
 						struct hw_breakpoint *bp)
 {
 	struct thread_struct *thread = &(tsk->thread);
-	int i;
+	int i, pos = -1, hbp_counter = 0;
 
 	spin_lock_bh(&hw_breakpoint_lock);
 	for (i = 0; i < hbp_kernel_pos; i++) {
-		if (bp == thread->hbp[i]) {
-			__unregister_user_hw_breakpoint(i, tsk);
-			break;
-		}
+		if (thread->hbp[i])
+			hbp_counter++;
+		if (bp == thread->hbp[i])
+			pos = i;
 	}
+	if (pos >= 0) {
+		__unregister_user_hw_breakpoint(pos, tsk);
+		hbp_counter--;
+	}
+	if (!hbp_counter)
+		clear_tsk_thread_flag(tsk, TIF_DEBUG);
+
 	spin_unlock_bh(&hw_breakpoint_lock);
 }
 EXPORT_SYMBOL_GPL(unregister_user_hw_breakpoint);
