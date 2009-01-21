Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZAUTqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZAUTqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 14:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZAUTpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 14:45:50 -0500
Received: from cmpxchg.org ([85.214.51.133]:55619 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZAUTpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 14:45:49 -0500
Date: Wed, 21 Jan 2009 20:45:41 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: optimise page fault entry
Message-ID: <20090121194541.GA22911@cmpxchg.org>
References: <20090120032426.GE16304@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120032426.GE16304@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick, here is the patch.  Ingo could you fold that one into Nick's as
a micro-mini minor fix?

On Tue, Jan 20, 2009 at 04:24:26AM +0100, Nick Piggin wrote:

> Index: linux-2.6/arch/x86/mm/fault.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/fault.c
> +++ linux-2.6/arch/x86/mm/fault.c

> @@ -409,15 +409,15 @@ static void show_fault_oops(struct pt_re
>  }
>  
>  #ifdef CONFIG_X86_64
> -static noinline void pgtable_bad(unsigned long address, struct pt_regs *regs,
> -				 unsigned long error_code)
> +static noinline void pgtable_bad(struct pt_regs *regs,
> +			 unsigned long error_code, unsigned long address)
>  {
>  	unsigned long flags = oops_begin();
>  	int sig = SIGKILL;
> -	struct task_struct *tsk;
> +	struct task_struct *tsk = current;
>  
>  	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
> -	       current->comm, address);
> +	       tsk->comm, address);
>  	dump_pagetable(address);
>  	tsk = current;

---
tsk is already assigned to current, drop the redundant second
assignment which Nick probably just overlooked when doing the cleanup.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/x86/mm/fault.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -419,7 +419,6 @@ static noinline void pgtable_bad(struct 
 	printk(KERN_ALERT "%s: Corrupted page table at address %lx\n",
 	       tsk->comm, address);
 	dump_pagetable(address);
-	tsk = current;
 	tsk->thread.cr2 = address;
 	tsk->thread.trap_no = 14;
 	tsk->thread.error_code = error_code;
