Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYL3IoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYL3IoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYL3Inu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:43:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbYL3Int (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:43:49 -0500
Date: Tue, 30 Dec 2008 00:42:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, bernds_cb1@t-online.de,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] NOMMU mmap changes
Message-Id: <20081230004246.4aa62478.akpm@linux-foundation.org>
In-Reply-To: <21562.1230572526@redhat.com>
References: <21562.1230572526@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008 17:42:06 +0000 David Howells <dhowells@redhat.com> wrote:

> Can you pull the attached request please?  It makes the following changes:
> 
>  (1) Discard the askedalloc and realalloc variables from NOMMU mmap as nothing
>      uses the values computed.
> 
>  (2) Stop ELF-FDPIC and FLAT binary formats from using kobjsize() by stopping
>      them from attempting to expand the stack segments to use the full amount
>      allocated (we'd like to get rid of kobjsize()).
> 
>  (3) Support XIP on initramfs.  This is simply a matter of using truncate() to
>      pre-size the files ramfs files so generated so that they are constructed
>      from contiguous pages, and so can be mapped in place with NOMMU mmap().
> 
>  (4) Make NOMMU VMAs per-MM as for MMU-mode Linux.  Whilst this uses more
>      memory, it also fixes a couple of bugs:
> 
>      (*) The SYSV SHM nattch count for a segment must reflect the number of
>      	 attachments made, but since attachments were being shared, it did
>      	 not.
> 
>      (*) The VMA's vm_mm is set to point to the parent mm by an exec'ing
>      	 process when VM_EXECUTABLE is specified, but vm_mm was being shared
>      	 by all the processes that shared that VMA.
> 
>  (5) NOMMU private non-shared mmaps are allocated with alloc_pages() rather
>      than kmalloc(), and without using __GFP_COMP.  This makes handling of
>      the pages in an mmap() region simpler.  Excess space can be trimmed after
>      allocation (configurable in /proc/sys).
> 
>  (6) A new struct (vm_region) is introduced to track mapped regions in NOMMU
>      mode, and to handle the sharing of backing stores.  This required the
>      vm_region structs of PowerPC and ARM to be renamed (the former patch has
>      been pulled via the ppc tree).
> 
>  (7) NOMMU VMAs are attached to their parent inodes as for MMU VMAs.
> 
>  (8) munmap() may do a partial unmapping.
> 
>  (9) Core dumping for ELF-FDPIC is simplified as the NOMMU- and MMU-mode code
>      behaves more similarly.
> 
> (10) /proc/maps provided in NOMMU mode now shows the regions allocated rather
>      than the common VMA list.  /proc/meminfo now shows the amount of RAM
>      currently allocated to private copies by private mmaps.
> 
> These patches have had some soak time in linux-next.  I've also applied them
> as-are to the latest merge window and tested that on my FRV board.
> 
> David
> ---
> The following changes since commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nommu.git master
> 
> David Howells (8):
>       NOMMU: Rename PowerPC's struct vm_region
>       NOMMU: Rename ARM's struct vm_region
>       NOMMU: Delete askedalloc and realalloc variables
>       NOMMU: Make VMAs per MM as for MMU-mode linux
>       NOMMU: Improve procfs output using per-MM VMAs
>       FDPIC: Don't attempt to expand the userspace stack to fill the space allocated
>       FLAT: Don't attempt to expand the userspace stack to fill the space allocated
>       NOMMU: Support XIP on initramfs
> 
> Matt Mackall (1):
>       shmem: remove unused shmem_get_unmapped_area
> 
> Paul Mundt (2):
>       NOMMU: Make mmap allocation page trimming behaviour configurable.
>       NOMMU: Teach kobjsize() about VMA regions.

hm, has this all been suitably reviewed/publicised?  afacit "Make VMAs
per MM as for MMU-mode linux" hasn't been published since mid-2007. 
Maybe my googling fails me.  The introduction of the new (albeit
apparently nommu-only) MM type `vm_region' is worth telling people about.

<has a quick peek>

The mmap_pages_allocated handling looks odd.  It's incremented when
pages are allocated, but it's decremented at put_page()-time.  But
put_page() won't necessarily return the page to the page allocator?

The conversion of arm's vm_region to arm_vm_region somehow missed
several code comments.

