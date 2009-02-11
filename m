Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZBKLPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZBKLPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 06:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbZBKLP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 06:15:26 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34445 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZBKLPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 06:15:25 -0500
Date: Wed, 11 Feb 2009 11:15:22 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, hugh@veritas.com,
       Lee.Schermerhorn@hp.com, gregkh@suse.de, maksim.yevmenkin@gmail.com,
       npiggin@suse.de, will@crowder-design.com, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, miklos@szeredi.hu, apw@canonical.com,
       wli@movementarian.org
Subject: Re: [PATCH] Do not account for the address space used by hugetlbfs
	using VM_ACCOUNT V2 (Was Linus 2.6.29-rc4)
Message-ID: <20090211111522.GB2416@csn.ul.ie>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <20090210140227.GC4023@csn.ul.ie> <20090210154549.2bbb1a6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090210154549.2bbb1a6e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 03:45:49PM -0800, Andrew Morton wrote:
> On Tue, 10 Feb 2009 14:02:27 +0000
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Sun, Feb 08, 2009 at 01:01:04PM -0800, Linus Torvalds wrote:
> > > 
> > > Another week (and a half), another -rc.
> > > 
> > > Arch updates (sparc, blackfin), driver updates (dvb, mmc, ide), ACPI 
> > > updates, FS updates (ubifs, btrfs), you name it. It's all there.
> > > 
> > > But more importantly, people really have been working on regressions, and 
> > > hopefully this closes a nice set of the top one, and hopefully without 
> > > introducing too many new ones.
> > > 
> > 
> > Hugepages are currently busted due to commit
> > fc8744adc870a8d4366908221508bb113d8b72ee and the problem is in
> > 2.6.29-rc4. There was a bit of a discussion but it didn't get very far and
> > then I went offline for the weekend. Here is a revised patch that tries to
> > bring hugetlbfs more in line with what the core VM is doing by dealing with
> > VM_ACCOUNT and VM_NORESERVE.
> > 
> > =============
> > Do not account for the address space used by hugetlbfs using VM_ACCOUNT
> > 
> > When overcommit is disabled, the core VM accounts for pages used by anonymous
> > shared, private mappings and special mappings. It keeps track of VMAs that
> > should be accounted for with VM_ACCOUNT and VMAs that never had a reserve
> > with VM_NORESERVE.
> > 
> > Overcommit for hugetlbfs is much riskier than overcommit for base pages
> > due to contiguity requirements. It avoids overcommiting on both shared and
> > private mappings using reservation counters that are checked and updated
> > during mmap(). This ensures (within limits) that hugepages exist in the
> > future when faults occurs or it is too easy to applications to be SIGKILLed.
> > 
> > As hugetlbfs makes its own reservations of a different unit to the base page
> > size, VM_ACCOUNT should never be set. Even if the units were correct, we would
> > double account for the usage in the core VM and hugetlbfs. VM_NORESERVE may
> > be set because an application can request no reserves be made for hugetlbfs
> > at the risk of getting killed later.
> > 
> > With commit fc8744adc870a8d4366908221508bb113d8b72ee, VM_NORESERVE and
> > VM_ACCOUNT are getting unconditionally set for hugetlbfs-backed mappings. This
> > breaks the accounting for both the core VM and hugetlbfs, can trigger an
> > OOM storm when hugepage pools are too small lockups and corrupted counters
> > otherwise are used. This patch brings hugetlbfs more in line with how the
> > core VM treats VM_NORESERVE but prevents VM_ACCOUNT being set.
> > 
> > ...
> >
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -108,7 +108,8 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> >  
> >  	if (hugetlb_reserve_pages(inode,
> >  				vma->vm_pgoff >> huge_page_order(h),
> > -				len >> huge_page_shift(h), vma))
> > +				len >> huge_page_shift(h), vma,
> > +				vma->vm_flags))
> >  		goto out;
> >  
> >  	ret = 0;
> > @@ -947,7 +948,7 @@ static int can_do_hugetlb_shm(void)
> >  			can_do_mlock());
> >  }
> >  
> > -struct file *hugetlb_file_setup(const char *name, size_t size)
> > +struct file *hugetlb_file_setup(const char *name, size_t size, int acctflag)
> 
> This superundocumented acctflag looks like a poorly-named boolean.  But
> it is fact a composition of VM_foo bits.
> 

It's matching naming at the call site. The call to shmem_file_setup()
looks like

	file = shmem_file_setup(name, size, acctflag);

so, the call to hugetlb_file_setup looks like

	hugetlb_file_setup(name, size, acctflag);

and the name in the signature matches. shmem doesn't match like this, it
just called its parameter "flags" and uses a different unit for size. The
different in unit is bad in itself and I need to check that out.

> Would it not be clearer to name it `vm_flags'?

It's not all the flags either so vm_flags is confusing for other reasons.
At least, at the time of writing the flags were meant to be VM_ACCOUNT and
VM_NORESERVE but in reality, only VM_NORESERVE appears to be sent in but
maybe that will change. 

That said..... newseg() passes VM_NORESERVE as a flag to shmem_file_setup(). It
in turn checks for VM_ACCOUNT in shmem_acct_size(), not VM_NORESERVE. Right
now we may have an issue there too. Later it uses shmem_acct_block() but at
that point VM_ACCOUNT has been set properly. shmem also has a VM_ACCT macro
that has very little to do with VM_ACCOUNT. Naming rocks.

I'll look at a patch that makes the signatures of *_file_setup() match. I'll
then check if it should be vm_acct_flags (both VM_ACCOUNT and VM_NORESERVE
possible) or vm_resv_flag (VM_NORESERVE only).

> 
> >  {
> >  	int error = -ENOMEM;
> >  	struct file *file;
> > @@ -981,7 +982,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size)
> >  
> >  	error = -ENOMEM;
> >  	if (hugetlb_reserve_pages(inode, 0,
> > -			size >> huge_page_shift(hstate_inode(inode)), NULL))
> > +			size >> huge_page_shift(hstate_inode(inode)), NULL,
> > +			acctflag))
> >  		goto out_inode;
> >  
> >  	d_instantiate(dentry, inode);
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index f1d2fba..af09660 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -33,7 +33,8 @@ unsigned long hugetlb_total_pages(void);
> >  int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> >  			unsigned long address, int write_access);
> >  int hugetlb_reserve_pages(struct inode *inode, long from, long to,
> > -						struct vm_area_struct *vma);
> > +						struct vm_area_struct *vma,
> > +						int acctflags);
> 
> here it went plural.
> 

Because I was thinking of VM_ACCOUNT and VM_NORESERVE, hence plural.

> >  void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
> >  
> >  extern unsigned long hugepages_treat_as_movable;
> > @@ -138,7 +139,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
> >  
> >  extern const struct file_operations hugetlbfs_file_operations;
> >  extern struct vm_operations_struct hugetlb_vm_ops;
> > -struct file *hugetlb_file_setup(const char *name, size_t);
> > +struct file *hugetlb_file_setup(const char *name, size_t, int);
> 
> Here it is omitted altogether.  We now have one named parameter and two
> secret ones.
> 

Dirt, that was matching what was happening for size_t but it's fugly. I
should have fixed size_t while I was there rather than making it look worse.

> Also, the patch forgot to update this:
> 
> #define hugetlb_file_setup(name,size)   ERR_PTR(-ENOSYS)
> 
> Which I assume breaks CONFIG_HUGETLBFS=n.
> 

Yeah, it broke and has been fixed since.

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index e8ddc98..3235615 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1129,8 +1129,7 @@ extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
> >  	unsigned long flag, unsigned long pgoff);
> >  extern unsigned long mmap_region(struct file *file, unsigned long addr,
> >  	unsigned long len, unsigned long flags,
> > -	unsigned int vm_flags, unsigned long pgoff,
> > -	int accountable);
> > +	unsigned int vm_flags, unsigned long pgoff);
> 
> And there is a vm_flags which has type `unsigned int'.
> 
> Your newly-added should-have-been-called-vm_flags has type `int'.
> 
> The vm_flagses in `struct vm_region' and `struct vm_area_struct' have type
> `unsigned long'.
> 

Yes, they all should have been unsigned long.

> It'd be nice to get these consistent.  We only have two bits left in
> the vm_flags namespace so arguably we could add a vm_flags_t while
> fixing this up, with a view to makeing it u64 later.  Maybe.
> 

I'll look at a vm_flags_t that works similar in principal to gfp_t and making
the signatures match up.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
