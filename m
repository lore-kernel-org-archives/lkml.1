Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZBBOK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZBBOK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZBBOKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:10:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33587 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbZBBOKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:10:46 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED file segments
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <Pine.LNX.4.64.0902021215060.18750@blonde.anvils>
References: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0902021215060.18750@blonde.anvils>
Message-Id: <20090202224410.EC95.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  2 Feb 2009 23:10:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to mel)

> On Mon, 2 Feb 2009, KOSAKI Motohiro wrote:
> > >  
> > > -	if (flags & MAP_NORESERVE)
> > > +	/*
> > > +	 * Set 'VM_NORESERVE' if we should not account for the
> > > +	 * memory use of this mapping. We only honor MAP_NORESERVE
> > > +	 * if we're allowed to overcommit memory.
> > > +	 */
> > > +	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
> > 
> > I afraid this line a bit.
> > if following scenario happend, we can lost VM_NORESERVE?
> > 
> > 1. admin set overcommit_memory to "never"
> > 2. mmap
> > 3. admin set overcommit_memory to "guess"
> 
> I still haven't reviewed it fully myself (and note that what
> Linus put in his tree is not identical to this posted patch),
> but I do believe this is okay.
> 
> When admin changes overcommit_memory, we don't make a pass across
> every vma of every mm in the system, to adjust all the accounting
> of VM_NORESERVE areas; so I think it's quite reasonable to take
> VM_NORESERVE as reflecting the policy in force when that vma was
> created.  And nothing is displaying the VM_NORESERVE flag.

hmhm, I see.


> Ah, you're actually thinking of
> 4. mprotect
> with the original flags (!VM_WRITE) such that no VM_ACCOUNT was done,
> and now VM_WRITE is added and the accounting is done despite it having
> been mapped MAP_NORESERVE originally.  Whereas before Linus's change,
> VM_NORESERVE would have still exempted it.
> 
> Well... I don't think I care!

Yeah.

FWIW, we don't need VM_NORESERVE checking now because VM_NORESERVE and VM_ACCOUNT
are exclusive condition now :)



> But I wonder what the hugetlb situation is: that
> 	if (!accountable)
> 		vm_flags |= VM_NORESERVE;
> looks suspicious to me, they look as if they're exempting all
> the hugetlb pages from its accounting, whereas !accountable was
> only supposed to exempt them from mmap_region()'s own accounting.

HAHAHA, Indeed.

when hugepage shared read-only mapping  -> hugepage shared writable maping,
following code seems to cause calling vm_enough_memory() although hugepage.

========================================================
mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
        unsigned long start, unsigned long end, unsigned long newflags)
{
        if (newflags & VM_WRITE) {
                if (!(oldflags & (VM_ACCOUNT|VM_WRITE|
                                                VM_SHARED|VM_NORESERVE))) {
                        charged = nrpages;
                        if (security_vm_enough_memory(charged))
                                return -ENOMEM;
                        newflags |= VM_ACCOUNT;
                }
        }
==========================================================

mel, what do you think this?

> 
> Perhaps.  I'm still looking at other things,
> not given this the time it needs yet.
> 
> Hugh



