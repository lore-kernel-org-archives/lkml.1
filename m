Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbZBBM4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbZBBM4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZBBMz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:55:56 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38794 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbZBBMzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:55:55 -0500
Date: Mon, 2 Feb 2009 12:54:15 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0902021215060.18750@blonde.anvils>
References: <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
 <alpine.LFD.2.00.0901311010460.3150@localhost.localdomain>
 <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, KOSAKI Motohiro wrote:
> >  
> > -	if (flags & MAP_NORESERVE)
> > +	/*
> > +	 * Set 'VM_NORESERVE' if we should not account for the
> > +	 * memory use of this mapping. We only honor MAP_NORESERVE
> > +	 * if we're allowed to overcommit memory.
> > +	 */
> > +	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
> 
> I afraid this line a bit.
> if following scenario happend, we can lost VM_NORESERVE?
> 
> 1. admin set overcommit_memory to "never"
> 2. mmap
> 3. admin set overcommit_memory to "guess"

I still haven't reviewed it fully myself (and note that what
Linus put in his tree is not identical to this posted patch),
but I do believe this is okay.

When admin changes overcommit_memory, we don't make a pass across
every vma of every mm in the system, to adjust all the accounting
of VM_NORESERVE areas; so I think it's quite reasonable to take
VM_NORESERVE as reflecting the policy in force when that vma was
created.  And nothing is displaying the VM_NORESERVE flag.

Ah, you're actually thinking of
4. mprotect
with the original flags (!VM_WRITE) such that no VM_ACCOUNT was done,
and now VM_WRITE is added and the accounting is done despite it having
been mapped MAP_NORESERVE originally.  Whereas before Linus's change,
VM_NORESERVE would have still exempted it.

Well... I don't think I care!

But I wonder what the hugetlb situation is: that
	if (!accountable)
		vm_flags |= VM_NORESERVE;
looks suspicious to me, they look as if they're exempting all
the hugetlb pages from its accounting, whereas !accountable was
only supposed to exempt them from mmap_region()'s own accounting.

Perhaps.  I'm still looking at other things,
not given this the time it needs yet.

Hugh
