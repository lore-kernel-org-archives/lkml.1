Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbXCUTZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbXCUTZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933814AbXCUTZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:25:18 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57414 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbXCUTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=ntH8jCL31KzhGMhxk7xNHRvFRMJheo9GzZRfnJptqEomUu4co5mEqozxNztdcVusw4lD48PsO8/AvpQ3oHvB1AoVk3zVjQMTsik9Qk8Sk8HJ3O+oH3aJWr4uRfi4V5UYWMAUkzV58JQzamEMCPIpJjBuRebhAJpqNGGjyXCRDUU=
Date: Wed, 21 Mar 2007 21:25:04 +0200
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: i386: Why putting __USER_DS in kernel threads stack initialization?
Message-ID: <20070321192504.GB5835@Ahmed>
References: <20070318225831.GB3802@Ahmed> <Pine.LNX.4.61.0703190717240.19254@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703190717240.19254@chaos.analogic.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 07:23:25AM -0400, linux-os (Dick Johnson) wrote:
> 
> On Sun, 18 Mar 2007, Ahmed S. Darwish wrote:
> 
> > Hi list,
> >
> > Reading the kernel threads initialization code I see:
> >
> > int kernel_thread(...) {
> >
> > 	struct pt_regs regs;
> > 	memset(&regs, 0, sizeof(regs));
> > 	[...]
> > **	regs.xds = __USER_DS;
> > **	regs.xes = __USER_DS;
> > 	[...]
> > 	/* Ok, create the new process.. */
> > 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, \
> > 	       	       0, NULL, NULL);
> >
> > Continuing with the code, the threads stack (beginning from %esp) is
> > initialized with the passed *regs from do_fork:
> >
> > int copy_thread(..., struct task_struct *p, struct pt_regs *regs) {
> >
> > 	struct pt_regs * childregs;
> > 	struct task_struct *tsk;
> > 	childregs = task_pt_regs(p);
> > **	*childregs = *regs;
> > 	[...]
> > ** 	p->thread.esp = (unsigned long) childregs;
> >
> >
> > So the question is what will a _kernel_ thread do with the Usermode Segment
> > address ?
> >
> > Thanks,
> >
> > P.S. I've tried commenting out both lines which led to a non functional init,
> > Also setting them to __USER_DS made init start but stopped issuing the error:
> > `Panic: Segment violation at 0x8049798 - Sleeping for 30 seconds'
> >

Sorry, I meant "setting them to __KERNEL_DS" here.

> 
> You might be confusing two routines. The kernel thread routine sets
> DS and ES to the kernel data segment, __KERNEL_DS, not the user data
> segment. 

And that's what's _not_ happening in the code as I mentioned in original post.

> This is so the kernel thread can access the kernel data. Note
> that this is done by putting the values in the pt_regs structure so
> it doesn't happen 'now', but after the fork.

I've searched the code for such case (setting xds to __KERNEL_DS _After_ 
copy_thread()) with no success. As I understand, the kernel thread 
executes the passed function immediately (when given control by scheduler):

i386/kernel/process::kernel_thread():
**	regs.ebx = (unsigned long) fn;
	regs.edx = (unsigned long) arg;
	regs.xds = __USER_DS;
	regs.xes = __USER_DS;
	regs.xfs = __KERNEL_PDA;
	regs.orig_eax = -1;
**	regs.eip = (unsigned long) kernel_thread_helper;
	do_fork(...)

entry.S::kernel_thread_helper (removing CFI_* pseudo ops):

   ENTRY(kernel_thread_helper)
	pushl $0		
	movl %edx,%eax
	push %edx
**	call *%ebx
	push %eax
	call do_exit
	
Am I interpreting the forking process completely wrong?. I'm just curious why 
the __USER_DS is playing a vital rule in kernel threads regs/stack ?

Thanks alot,

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

