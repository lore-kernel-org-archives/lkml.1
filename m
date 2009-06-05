Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZFEDtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZFEDtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZFEDtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:49:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34511 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZFEDtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:49:41 -0400
Date: Thu, 4 Jun 2009 20:49:40 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: xemul@parallels.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090605034940.GC9285@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604224239.GA10666@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009, Alexey Dobriyan wrote:
> On Thu, Jun 04, 2009 at 02:30:33PM -0700, Matt Helsley wrote:
> > On Thu, Jun 04, 2009 at 08:07:23AM -0700, Linus Torvalds wrote:
> > > On Thu, 4 Jun 2009, Matt Helsley wrote:
> > > > 
> > > > Doesn't this pin the vfs mount of the executable for the lifetime
> > > > of
> > > > the task?
> > > 
> > > Well, yes, but so does the current code.
> > 
> > Not quite. The current code pins it as long as the corresponding VMAs
> > are mapped -- not for the lifetime of the task.
> > 
> > > Sure, in _theory_ it can be a non-mmap executable (maybe people
> > > still have 
> > > those old OMAGIC a.out executables), and in _theory_ you could unmap
> > > the 
> > > executable even if it was originally mmap'ed, but neither of those
> > > is 
> > > exactly common, are they?
> > 
> > Not common to my knowledge, no.
> > 
> > > 
> > > So in practice, nothing has changed wrt lifetime of the executable.
> > 
> > Almost all of the time, yes.
> 
> And year ago executable wasn't pinned at all, so if you're opposing
> widening of time executable is pinned, you should revert your own patch
> which introduced it in first place.

You're wrong -- my patch did not widen the time the executable is pinned.
Read the exe_file changelog and give the code a more thorough read:

	[The exe_file] reference would prevent the filesystem holding the executable
	file from being unmounted even after unmapping the VMAs. So we track the
	number of VM_EXECUTABLE VMAs and drop the new reference when the last one is
	unmapped. This avoids pinning the mounted filesystem.

So long as the VMAs are mapped the filesystem is pinned. Until these VMAs are
unmapped exe_file does not extend the time that the filesystem is pinned. So
dropping the exe_file reference when the last VMA goes away should suffice in
preserving this property of the old VMA walk. The code does this by:

When exe_file is set from the bprm during exec we also set num_exe_file_vmas to 0.

When a VMA with VM_EXECUTABLE is mapped we call added_exe_file_vma() since
MAP_EXECUTABLE is only used for this (binfmt_* do_mmap() calls pass MAP_EXECUTABLE).
added_exe_file_vma() increments num_exe_file_vmas.

When a VM_EXECUTABLE VMA is split in two we call added_exe_file_vma() since there
is one more VMA.

When two VM_EXECUTABLE VMAs are merged we call removed_exe_file_vma() since there
is one less VMA. See removed_exe_file_vma() below.

When a VM_EXECUTABLE VMA is unmapped we call removed_exe_file_vma() since there
is one less VMA. When the last VM_EXECUTABLE VMA is unmapped num_exe_file_vmas 
drops to 0 and we trigger fput(exe_file):

void removed_exe_file_vma(struct mm_struct *mm)
{
       mm->num_exe_file_vmas--;
       if ((mm->num_exe_file_vmas == 0) && mm->exe_file){
               fput(mm->exe_file);
               mm->exe_file = NULL;
       }
}

which avoids pinning the VFS mount after the last VM_EXECUTABLE VMA is unmapped.

This is what used to happen with the old VMA-walk code too -- when the last
VM_EXECUTABLE VMA was unmapped the /proc/*/exe link disappeared  (as you've noted)
and the vfs mount was no longer pinned by the /proc/*/exe code.

In case you're curious here's what Al said when my original patch lacked this code
and hence ignored mount pinning:

	http://lkml.org/lkml/2007/7/12/398

So I added the VMA tracking code.

Since Linus seems to think vfs mount pinning is inconsequential
I don't mind dropping this objection. Please feel free to add my:

Acked-by: Matt Helsley <matthltc@us.ibm.com>

to this entire series.

> 
> ->exec_path merely makes /proc/*/exe very unheuristical (binfmt loader
> decides, nothing else) and suitable for other code as demonstrated.

Yes, the VMA walk that exe_file replaced was a bit of a heuristic.

Cheers,
	-Matt Helsley
