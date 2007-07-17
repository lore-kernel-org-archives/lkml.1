Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbXGQFg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbXGQFg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXGQFgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:36:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53488 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbXGQFgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:36:16 -0400
Date: Tue, 17 Jul 2007 11:08:03 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: Re: [patch 1/8] Kprobes - do not use kprobes mutex in arch code
Message-ID: <20070717053803.GA7033@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012411.262873138@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:21:34PM -0400, Mathieu Desnoyers wrote:
> Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
> remove all use of this mutex in the architecture specific code, replacing it by
> a proper mutex lock/unlock in the architecture agnostic code.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Mathieu.

> CC: prasanna@in.ibm.com
> CC: ananth@in.ibm.com
> CC: anil.s.keshavamurthy@intel.com
> CC: davem@davemloft.net
> ---
>  arch/i386/kernel/kprobes.c    |    2 --
>  arch/ia64/kernel/kprobes.c    |    2 --
>  arch/powerpc/kernel/kprobes.c |    2 --
>  arch/s390/kernel/kprobes.c    |    2 --
>  arch/x86_64/kernel/kprobes.c  |    2 --
>  include/linux/kprobes.h       |    2 --
>  kernel/kprobes.c              |    2 ++
>  7 files changed, 2 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6-lttng/include/linux/kprobes.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/kprobes.h	2007-07-13 18:42:08.000000000 -0400
> +++ linux-2.6-lttng/include/linux/kprobes.h	2007-07-13 18:42:52.000000000 -0400
> @@ -35,7 +35,6 @@
>  #include <linux/percpu.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> -#include <linux/mutex.h>
> 
>  #ifdef CONFIG_KPROBES
>  #include <asm/kprobes.h>
> @@ -177,7 +176,6 @@
>  }
> 
>  extern spinlock_t kretprobe_lock;
> -extern struct mutex kprobe_mutex;
>  extern int arch_prepare_kprobe(struct kprobe *p);
>  extern void arch_arm_kprobe(struct kprobe *p);
>  extern void arch_disarm_kprobe(struct kprobe *p);
> Index: linux-2.6-lttng/arch/i386/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/kernel/kprobes.c	2007-07-13 18:42:08.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/kernel/kprobes.c	2007-07-13 18:42:52.000000000 -0400
> @@ -209,9 +209,7 @@
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
>  {
> -	mutex_lock(&kprobe_mutex);
>  	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
> -	mutex_unlock(&kprobe_mutex);
>  }
> 
>  static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
> Index: linux-2.6-lttng/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/kprobes.c	2007-07-13 18:42:10.000000000 -0400
> +++ linux-2.6-lttng/kernel/kprobes.c	2007-07-13 18:43:17.000000000 -0400
> @@ -641,7 +641,9 @@
>  			list_del_rcu(&p->list);
>  			kfree(old_p);
>  		}
> +		mutex_lock(&kprobe_mutex);
>  		arch_remove_kprobe(p);
> +		mutex_unlock(&kprobe_mutex);
>  	} else {
>  		mutex_lock(&kprobe_mutex);
>  		if (p->break_handler)
> Index: linux-2.6-lttng/arch/ia64/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/ia64/kernel/kprobes.c	2007-07-13 18:43:59.000000000 -0400
> +++ linux-2.6-lttng/arch/ia64/kernel/kprobes.c	2007-07-13 18:44:03.000000000 -0400
> @@ -565,9 +565,7 @@
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
>  {
> -	mutex_lock(&kprobe_mutex);
>  	free_insn_slot(p->ainsn.insn, 0);
> -	mutex_unlock(&kprobe_mutex);
>  }
>  /*
>   * We are resuming execution after a single step fault, so the pt_regs
> Index: linux-2.6-lttng/arch/powerpc/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/powerpc/kernel/kprobes.c	2007-07-13 18:44:20.000000000 -0400
> +++ linux-2.6-lttng/arch/powerpc/kernel/kprobes.c	2007-07-13 18:44:26.000000000 -0400
> @@ -86,9 +86,7 @@
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
>  {
> -	mutex_lock(&kprobe_mutex);
>  	free_insn_slot(p->ainsn.insn, 0);
> -	mutex_unlock(&kprobe_mutex);
>  }
> 
>  static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
> Index: linux-2.6-lttng/arch/s390/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/s390/kernel/kprobes.c	2007-07-13 18:44:43.000000000 -0400
> +++ linux-2.6-lttng/arch/s390/kernel/kprobes.c	2007-07-13 18:44:46.000000000 -0400
> @@ -218,9 +218,7 @@
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
>  {
> -	mutex_lock(&kprobe_mutex);
>  	free_insn_slot(p->ainsn.insn, 0);
> -	mutex_unlock(&kprobe_mutex);
>  }
> 
>  static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
> Index: linux-2.6-lttng/arch/x86_64/kernel/kprobes.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86_64/kernel/kprobes.c	2007-07-13 18:45:08.000000000 -0400
> +++ linux-2.6-lttng/arch/x86_64/kernel/kprobes.c	2007-07-13 18:45:14.000000000 -0400
> @@ -249,9 +249,7 @@
> 
>  void __kprobes arch_remove_kprobe(struct kprobe *p)
>  {
> -	mutex_lock(&kprobe_mutex);
>  	free_insn_slot(p->ainsn.insn, 0);
> -	mutex_unlock(&kprobe_mutex);
>  }
> 
>  static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
