Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbXAWULm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbXAWULm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbXAWULm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:11:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920AbXAWULl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:11:41 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/11] i386 vDSO: use VM_ALWAYSDUMP
In-Reply-To: Linus Torvalds's message of  Tuesday, 23 January 2007 11:57:12 -0800 <Pine.LNX.4.64.0701231154030.32200@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070123201103.E4CAD1800E9@magilla.sf.frob.com>
Date: Tue, 23 Jan 2007 12:11:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Not that the old code did either, so it's not like it's a new bug, but I 
> thought I'd point it out anyway. As if we care (but you can probably 
> trigger this by having an app that does
> 
> 	munmap(NULL, TASK_SIZE);
>
> which will cause a SIGSEGV on return (because the stack doesn't exist) and 
> then the core-dump should be empty.

Ok, damn you.  I admit I thought of exactly this case and then glossed it
over because I didn't want to complicate the patch and discuss the arcane
justification.  And I was doing a good job of repressing the memory of it
completely before you dredged it up.

> Not that I tested anythign that evil anyway, nor do I think we really care 
> if it means that the gate_vma doesn't get shown in the core-dump either.

I didn't test it either.  And I do sort of think the vDSO should be (the
only thing) in that case's core dump on anal principle.  Now that you've
brought it up, I feel all dirty for ever having sent in code that doesn't
cover the case.  (Not that we really care, since CONFIG_COMPAT_VDSO won't
actually be turned on in practice.)

Starting the loops with "vma = current->mm->mmap ?: gate_vma" should do it.
But I guess Andrew would prefer it:

static struct vm_area_struct *first_vma(struct task_struct *tsk,
					struct vm_area_struct *gate_vma) 
{
	struct vm_area_struct *ret = tsk->mm->mmap;
	if (ret)
		return ret;
	return gate_vma;
}

and:

	for (vma = first_vma(current); vma; vma = next_vma(vma, gate_vma)) {


Thanks,
Roland
