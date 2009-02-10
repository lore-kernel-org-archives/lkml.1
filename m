Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZBJVpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZBJVpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbZBJVpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:45:10 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39834 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468AbZBJVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:45:09 -0500
Subject: Re: [PATCH] mm: rearrange exit_mmap() to unlock before
	arch_exit_mmap
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jeremy@goop.org,
       keir.fraser@eu.citrix.com, christophe@saout.de, alex.williamson@hp.com,
       npiggin@suse.de
In-Reply-To: <20090210133102.9573b2a7.akpm@linux-foundation.org>
References: <1234200588.22359.30.camel@lts-notebook>
	 <20090210133102.9573b2a7.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 10 Feb 2009 16:45:05 -0500
Message-Id: <1234302305.6200.117.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 13:31 -0800, Andrew Morton wrote:
> On Mon, 09 Feb 2009 12:29:48 -0500
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > From: Jeremy Fitzhardinge <jeremy@goop.org>
> > 
> > Subject: mm: rearrange exit_mmap() to unlock before arch_exit_mmap
> > 
> > Applicable to 29-rc4 and 28-stable
> > 
> > Christophe Saout reported [in precursor to:
> > http://marc.info/?l=linux-kernel&m=123209902707347&w=4]:
> > 
> > > Note that I also some a different issue with CONFIG_UNEVICTABLE_LRU.
> > > Seems like Xen tears down current->mm early on process termination, so
> > > that __get_user_pages in exit_mmap causes nasty messages when the
> > > process had any mlocked pages.  (in fact, it somehow manages to get into
> > > the swapping code and produces a null pointer dereference trying to get
> > > a swap token)
> > 
> > Jeremy explained:
> > 
> > Yes.  In the normal case under Xen, an in-use pagetable is "pinned", 
> > meaning that it is RO to the kernel, and all updates must go via 
> > hypercall (or writes are trapped and emulated, which is much the same 
> > thing).  An unpinned pagetable is not currently in use by any process, 
> > and can be directly accessed as normal RW pages.
> > 
> > As an optimisation at process exit time, we unpin the pagetable as early 
> > as possible (switching the process to init_mm), so that all the normal 
> > pagetable teardown can happen with direct memory accesses.
> > 
> > This happens in exit_mmap() -> arch_exit_mmap().  The munlocking happens 
> > a few lines below.  The obvious thing to do would be to move 
> > arch_exit_mmap() to below the munlock code, but I think we'd want to 
> > call it even if mm->mmap is NULL, just to be on the safe side.
> > 
> > Thus, this patch:
> > 
> > exit_mmap() needs to unlock any locked vmas before calling
> > arch_exit_mmap, as the latter may switch the current mm to init_mm,
> > which would cause the former to fail.
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Acked-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
> > 
> > ---
> >  mm/mmap.c |   10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > ===================================================================
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -2078,12 +2078,8 @@
> >  	unsigned long end;
> >  
> >  	/* mm's last user has gone, and its about to be pulled down */
> > -	arch_exit_mmap(mm);
> >  	mmu_notifier_release(mm);
> >  
> > -	if (!mm->mmap)	/* Can happen if dup_mmap() received an OOM */
> > -		return;
> > -
> >  	if (mm->locked_vm) {
> >  		vma = mm->mmap;
> >  		while (vma) {
> > @@ -2092,7 +2088,13 @@
> >  			vma = vma->vm_next;
> >  		}
> >  	}
> > +
> > +	arch_exit_mmap(mm);
> > +
> >  	vma = mm->mmap;
> > +	if (!vma)	/* Can happen if dup_mmap() received an OOM */
> > +		return;
> > +
> >  	lru_add_drain();
> >  	flush_cache_mm(mm);
> >  	tlb = tlb_gather_mmu(mm, 1);
> 
> The patch as it stands doesn't apply cleanly to 2.6.28.  I didn't look
> into what needs to be done to fix it up.  Presumably the stable beavers
> would like a fixed-up and tested version for backporting sometime.

The only difference I can see in this area, looking at a 28.2 tree I
have, the 28.4 patch on kernel.org and the context in the patch, is that
"flush_cache_mm(mm);" line.

Lee



