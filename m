Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXCLVuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXCLVuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbXCLVuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:50:19 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36745 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbXCLVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:50:16 -0400
X-IronPort-AV: i="4.14,275,1170651600"; 
   d="scan'208"; a="24276879:sNHT26020267"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: David Howells <dhowells@redhat.com>
Subject: Re: Move to unshared VMAs in NOMMU mode?
Date: Mon, 12 Mar 2007 16:50:34 -0400
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, bryan.wu@analog.com,
       Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, haoki@redhat.com,
       Bernd Schmidt <bernds_cb1@t-online.de>
References: <3378.1173204813@redhat.com> <29317.1172931029@redhat.com> <12852.1173449522@redhat.com>
In-Reply-To: <12852.1173449522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703121650.35699.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 12 Mar 2007 21:49:28.0930 (UTC) FILETIME=[4F55CC20:01C764F0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 9 Mar 2007 09:12, David Howells pondered:
> I've been considering how to deal with the SYSV SHM problem, and I think we
> may have to move to unshared VMAs in NOMMU mode to deal with this. 

Thanks for putting some good thoughts down.

> Currently, what we have is each mm_struct has in its arch-specific context
> argument a list of VMLs.  Take the FRV context for example:
>
> 	[include/asm-frv/mmu.h]
> 	typedef struct {
> 	#ifdef CONFIG_MMU
> 	...
> 		struct vm_list_struct	*vmlist;
> 		unsigned long		end_brk;
>
> 	#endif
> 	...
> 	} mm_context_t;
>
> Each VML struct containes a pointer to a systemwide VMA and the next VML in
> the list:
>
> 	struct vm_list_struct {
> 		struct vm_list_struct	*next;
> 		struct vm_area_struct	*vma;
> 	};
>
> The VMAs themselves are kept in an rb-tree in mm/nommu.c:
>
> 	/* list of shareable VMAs */
> 	struct rb_root nommu_vma_tree = RB_ROOT;
>
> which can then be displayed through /proc/maps.
>
> There are some restrictions of this system, mainly due to the NOMMU
> constraints:
>
>  (*) mmap() may not be used to overlay one mapping upon another
>
>  (*) mmap() may not be used with MAP_FIXED.
>
>  (*) mmap()'s of the same part of the same file will result in multiple
>      mappings returning the same base address, assuming the maps are
> shareable. If they aren't shareable, they'll be at different base
> addresses.
>
>  (*) for normal shareable file mappings, two mappings will only be shared
> if they precisely match offset, size and protection, otherwise a new
> mapping will be created (this is because VMAs will be shared).  Splitting
> VMAs would reduce the this restriction, though subsequent mappings would
> have to be bounded by the first mapping, but wouldn't have to be the same
> size.
>
>  (*) munmap() may only unmap a precise match amongst the mappings made; it
> may not be used to cut down or punch a hole in an existing mapping.
>
> The VMAs for private file mappings, private blockdev mappings and anonymous
> mappings, be they shared[*] or unshared, hold a pointer to the kmalloc()'d
> region of memory in which the mapping contents reside.  This region is
> discarded when the VMA is deleted.  When a region can be shared the VMA is
> also shared, and so no reference counting need take place on the mapping
> contents as that is implied by the VMA.
>
> [*] MAP_PRIVATE+!PROT_WRITE+!PT_PTRACED regions may be shared
>
> Note that for mappable chardevs with special BDI capability flags, extra
> VMAs may be allocated because (a) they may need to overlap non-exactly, and
> (b) the chardev itself pins the backing storage, if the backing storage is
> potentially transient.
>
>
> If VMAs are not shared for shared memory regions then some other means of
> retaining the actual allocated memory region must be found.  The obvious
> way to do this is to have the VMA point to a shared, refcounted record that
> keeps track of the region:
>
> 	struct vm_region {
> 		/* the first parameters define the region as for the VMA */
> 		pgprot_t	vm_page_prot;
> 		unsigned long	vm_start;
> 		unsigned long	vm_end
> 		unsigned long	vm_pgoff;
> 		struct file	*vm_file;
>
> 		atomic_t	vm_usage;	/* region usage count */
> 		struct rb_node	vm_rb;		/* region tree */
> 	};
>
> The VMA itself would then have to be modified to include a pointer to this,
> but wouldn't then need its own refcount.  VMAs would belong, once again, to
> the mm_struct, the VML struct would vanish, and the VML list rooted in
> mm_context_t would vanish.
>
> For R/O shareable file mappings, it might be possible to actually use the
> target file's pagecache for the mapping.  I do something of that sort for
> shared-writable mappings on ramfs files (to support POSIX SHM and SYSV
> SHM).
>
> The downside of allocating all these extra VMAs is that, of course, it
> takes up more memory, though that may not be too bad, especially if it's at
> the gain of additional consistency with the MM code.

I guess I don't look at it as consistency with the MM code as being the 
primary request, but consistency in operation with the MM code from a user 
space perspective - hopefully the two goals are not divergent.

> However, consistency isn't for the most part a real issue.  As I see it,
> drivers and filesystems should not concern themselves with anything other
> than the VMA they're given, and so it doesn't matter if these are shared or
> not.
>
> That brings us on to the problem with SYSV SHM which keeps an attachment
> count that the VMA mmap(), open() and release() ops manipulate.  This means
> that the nattch count comes out wrong on NOMMU systems.  Note that on MMU
> systems, doing a munmap() in the middle of an attached region will *also*
> break the nattch count, though this is self-correcting.
>
> Another way of dealing with the nattch count on NOMMU systems is to do it
> through the VML list, but that then needs more special casing in the SHM
> driver and perhaps others.

We (noMMU) folks need to have special code anyway - so why not put it there, 
and try not to increase memory footprint?

-Robin
