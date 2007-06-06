Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXFFW1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXFFW1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934646AbXFFW1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:27:33 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:33918 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbXFFW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:27:31 -0400
Date: Wed, 6 Jun 2007 15:27:22 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
Message-ID: <20070606222721.GB13713@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com> <alpine.DEB.0.99.0706040729230.10505@chino.kir.corp.google.com> <20070605211711.GD11693@frankl.hpl.hp.com> <alpine.DEB.0.99.0706051826330.23799@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0706051826330.23799@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Tue, Jun 05, 2007 at 06:34:56PM -0700, David Rientjes wrote:
> 
> > > > +int pfm_get_task(struct pfm_context *ctx, pid_t pid, struct task_struct **task)
> > > > +{
> > > 
> > > This function could be marked static even though it's exported through 
> > > perfmon.h in patch 13.  It is unreferenced elsewhere.
> > > 
> > No because it is used in another module on IA-64 (for compatibility with older versions).
> > 
> 
> Is this ia64 patch the one you mentioned that you did not post to LKML 
> because it was too large in patch 0?  Is there any way you could break 
> that patch up itself and post it for comments?
> 
Yes, this is the patch. It would be hard to break up in pieces.
The reason it is big is because it has to remove the older IA-64-only
implementation which was all in a single file whose size
was bigger than 100kB. It is hard to break this, unless I explicitely
remove the 'remove old file' diff from the patch.


> > > Why can't this be done with just struct task_struct *task as the third 
> > > formal and change the assignment later to task = p?
> > > 
> > Because we need to carry the errno back: ESRCH or EPERM.
> > 
> 
> Your formal is "struct task_struct **task" yet the only actual to this 
> function is the memory address of a pointer to a single struct task_struct 
> (i.e. it's never passed an array of struct task_struct pointers, which 
> "struct task_struct **task" is).
> 
> And since you only ever use this has *task to get the pointer, you can 
> change the formal to just be "struct task_struct *task" and then pass in a 
> pointer to a single struct task_struct.
> 
I must be missing something here. I am modifying the address of task * in
the function. This is my second return value.

int pfm_get_task(void **p)
{
        *p = 0x1000;
	return 0;
}

int main(void)
{
        void *p;

        p = 0x2000;
        printf("p=%p\n", p);
        pfm_get_task(&p);
        printf("p=%p\n", p);
        return 0;
}
I am not passing a pointer to an array of struct ask *, but merely the address of a pointer
to struct task *. 

> > > > +
> > > > +asmlinkage long sys_pfm_write_pmcs(int fd, struct pfarg_pmc __user *ureq, int count)
> > > > +{
> > > > +	struct pfm_context *ctx;
> > > > +	struct file *filp;
> > > > +	struct pfarg_pmc pmcs[PFM_PMC_STK_ARG];
> > > > +	struct pfarg_pmc *req;
> > > > +	void *fptr;
> > > > +	unsigned long flags;
> > > > +	size_t sz;
> > > > +	int ret, fput_needed;
> > > > +
> > > 
> > > Could this have a stack overflow on powerpc?
> > > 
> > The PFM_PMC_STK_ARG is per-arch,  so you could chose a very low value. 
> > I think it is set to 4. pfarg_pmc s 48 bytes and pfarg_pmd is 176 bytes
> > regardless of LP64 vs. ILP32.
> > 
> 
> Stack overflows like that are annoying to track down and powerpc has the 
> highest PFM_PMC_STK_ARG of the entire patchset.
> 
The function using this is a system call, so it is not too deep in the call stack
and then the perfmon function never go very deep.


> 
> I'm looking forward to seeing the next patchset and I'll give it a 
> thorough test run on x86_64.  It'd probably be best to base that patchset 
> off 2.6.22 when it's released.
> 
Very good thanks. I still need to go through all your other comments.

-- 

-Stephane
