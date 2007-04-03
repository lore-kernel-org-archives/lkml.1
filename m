Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbXDCFqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbXDCFqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXDCFqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:46:19 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45523 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbXDCFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:46:17 -0400
Date: Tue, 3 Apr 2007 11:19:43 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Maneesh Soni <maneesh@in.ibm.com>
Subject: Re: [PATCH] Kprobes: Print details of kretprobe on assertion failure
Message-ID: <20070403054943.GA18459@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070402092636.GA27905@in.ibm.com> <20070402141732.166f50bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402141732.166f50bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 02:17:32PM -0700, Andrew Morton wrote:
> On Mon, 2 Apr 2007 14:56:36 +0530
> Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > In certain cases like when the real return address can't be found or
> > when the number of tracked calls to a kretprobed function is less than
> > the number of returns, we may not be able to find the correct return
> > address after processing a kretprobe. Currently we just do a BUG_ON, but
> > no information is provided about the actual failing kretprobe.
> > 
> > Print out details of the kretprobe before calling BUG().
> > 
> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > 
> > ---
> >  arch/i386/kernel/kprobes.c    |    6 +++++-
> >  arch/ia64/kernel/kprobes.c    |    7 ++++++-
> >  arch/powerpc/kernel/kprobes.c |    7 ++++++-
> >  arch/x86_64/kernel/kprobes.c  |    7 ++++++-
> >  4 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > Index: linux-2.6.21-rc5/arch/i386/kernel/kprobes.c
> > ===================================================================
> > --- linux-2.6.21-rc5.orig/arch/i386/kernel/kprobes.c
> > +++ linux-2.6.21-rc5/arch/i386/kernel/kprobes.c
> > @@ -440,7 +440,11 @@ fastcall void *__kprobes trampoline_hand
> >  			break;
> >  	}
> >  
> > -	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
> > +	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
> > +		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
> > +				ri->rp, ri->rp->kp.addr);
> > +		BUG();
> > +	}
> >  
> >  	spin_unlock_irqrestore(&kretprobe_lock, flags);
> >  
> > Index: linux-2.6.21-rc5/arch/ia64/kernel/kprobes.c
> > ===================================================================
> > --- linux-2.6.21-rc5.orig/arch/ia64/kernel/kprobes.c
> > +++ linux-2.6.21-rc5/arch/ia64/kernel/kprobes.c
> > @@ -444,7 +444,12 @@ int __kprobes trampoline_probe_handler(s
> >  			break;
> >  	}
> >  
> > -	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
> > +	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
> > +		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
> > +				ri->rp, ri->rp->kp.addr);
> > +		BUG();
> > +	}
> > +
> >  	regs->cr_iip = orig_ret_address;
> >  
> >  	reset_current_kprobe();
> > Index: linux-2.6.21-rc5/arch/powerpc/kernel/kprobes.c
> > ===================================================================
> > --- linux-2.6.21-rc5.orig/arch/powerpc/kernel/kprobes.c
> > +++ linux-2.6.21-rc5/arch/powerpc/kernel/kprobes.c
> > @@ -293,7 +293,12 @@ int __kprobes trampoline_probe_handler(s
> >  			break;
> >  	}
> >  
> > -	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
> > +	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
> > +		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
> > +				ri->rp, ri->rp->kp.addr);
> > +		BUG();
> > +	}
> > +
> >  	regs->nip = orig_ret_address;
> >  
> >  	reset_current_kprobe();
> > Index: linux-2.6.21-rc5/arch/x86_64/kernel/kprobes.c
> > ===================================================================
> > --- linux-2.6.21-rc5.orig/arch/x86_64/kernel/kprobes.c
> > +++ linux-2.6.21-rc5/arch/x86_64/kernel/kprobes.c
> > @@ -438,7 +438,12 @@ int __kprobes trampoline_probe_handler(s
> >  			break;
> >  	}
> >  
> > -	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
> > +	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
> > +		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
> > +				ri->rp, ri->rp->kp.addr);
> > +		BUG();
> > +	}
> > +
> >  	regs->rip = orig_ret_address;
> >  
> 
> A lot of copying-and-pasting there.  Would it be better if this assertion
> was performed in a library function in kernel/kprobes.c?

Indeed. Here is the updated patch...

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

In certain cases like when the real return address can't be found or
when the number of tracked calls to a kretprobed function is less than
the number of returns, we may not be able to find the correct return
address after processing a kretprobe. Currently we just do a BUG_ON, but
no information is provided about the actual failing kretprobe.

Print out details of the kretprobe before calling BUG().

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

---
 arch/i386/kernel/kprobes.c    |    3 +--
 arch/ia64/kernel/kprobes.c    |    3 ++-
 arch/powerpc/kernel/kprobes.c |    2 +-
 arch/x86_64/kernel/kprobes.c  |    2 +-
 include/linux/kprobes.h       |   10 ++++++++++
 5 files changed, 15 insertions(+), 5 deletions(-)

Index: linux-2.6.21-rc5/arch/i386/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/i386/kernel/kprobes.c
@@ -440,8 +440,7 @@ fastcall void *__kprobes trampoline_hand
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
-
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
Index: linux-2.6.21-rc5/arch/ia64/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/ia64/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/ia64/kernel/kprobes.c
@@ -444,7 +444,8 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
 	regs->cr_iip = orig_ret_address;
 
 	reset_current_kprobe();
Index: linux-2.6.21-rc5/arch/powerpc/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/powerpc/kernel/kprobes.c
@@ -293,7 +293,7 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	regs->nip = orig_ret_address;
 
 	reset_current_kprobe();
Index: linux-2.6.21-rc5/arch/x86_64/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/kprobes.c
+++ linux-2.6.21-rc5/arch/x86_64/kernel/kprobes.c
@@ -438,7 +438,7 @@ int __kprobes trampoline_probe_handler(s
 			break;
 	}
 
-	BUG_ON(!orig_ret_address || (orig_ret_address == trampoline_address));
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 	regs->rip = orig_ret_address;
 
 	reset_current_kprobe();
Index: linux-2.6.21-rc5/include/linux/kprobes.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/kprobes.h
+++ linux-2.6.21-rc5/include/linux/kprobes.h
@@ -158,6 +158,16 @@ struct kretprobe_instance {
 	struct task_struct *task;
 };
 
+static inline void kretprobe_assert(struct kretprobe_instance *ri,
+	unsigned long orig_ret_address, unsigned long trampoline_address)
+{
+	if (!orig_ret_address || (orig_ret_address == trampoline_address)) {
+		printk("kretprobe BUG!: Processing kretprobe %p @ %p\n",
+				ri->rp, ri->rp->kp.addr);
+		BUG();
+	}
+}
+
 extern spinlock_t kretprobe_lock;
 extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
