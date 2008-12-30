Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYL3IsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYL3IsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYL3Ir4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:47:56 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:9469 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYL3Iry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:47:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rEIoRtrR+MVzHnXuEaTMUHv3d2G0pk4zOfFTIWxij6VlzjrGKAjtcOkGy0Jr2MU+Yd
         FSzwSjdCYnYUv38acb+PzmUhqu91Bc9o1+36Tb4ab8vr9LHyXBCg33uxn0f8k/E1hevB
         vqGLvtZJQXWo4whGuBaEXK8NqrKSXZjlNcL+k=
Message-ID: <8bd0f97a0812300047n32c81957u60b3d83c41422486@mail.gmail.com>
Date: Tue, 30 Dec 2008 03:47:53 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [GIT] NOMMU mmap changes
Cc: "David Howells" <dhowells@redhat.com>, torvalds@linux-foundation.org,
       rgetz@blackfin.uclinux.org, lethal@linux-sh.org, bernds_cb1@t-online.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081230004246.4aa62478.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21562.1230572526@redhat.com>
	 <20081230004246.4aa62478.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2008 at 03:42, Andrew Morton wrote:
> On Mon, 29 Dec 2008 17:42:06 +0000 David Howells wrote:
>> Can you pull the attached request please?  It makes the following changes:
>>
>>  (1) Discard the askedalloc and realalloc variables from NOMMU mmap as nothing
>>      uses the values computed.
>>
>>  (2) Stop ELF-FDPIC and FLAT binary formats from using kobjsize() by stopping
>>      them from attempting to expand the stack segments to use the full amount
>>      allocated (we'd like to get rid of kobjsize()).
>>
>>  (3) Support XIP on initramfs.  This is simply a matter of using truncate() to
>>      pre-size the files ramfs files so generated so that they are constructed
>>      from contiguous pages, and so can be mapped in place with NOMMU mmap().
>>
>>  (4) Make NOMMU VMAs per-MM as for MMU-mode Linux.  Whilst this uses more
>>      memory, it also fixes a couple of bugs:
>>
>>      (*) The SYSV SHM nattch count for a segment must reflect the number of
>>        attachments made, but since attachments were being shared, it did
>>        not.
>>
>>      (*) The VMA's vm_mm is set to point to the parent mm by an exec'ing
>>        process when VM_EXECUTABLE is specified, but vm_mm was being shared
>>        by all the processes that shared that VMA.
>>
>>  (5) NOMMU private non-shared mmaps are allocated with alloc_pages() rather
>>      than kmalloc(), and without using __GFP_COMP.  This makes handling of
>>      the pages in an mmap() region simpler.  Excess space can be trimmed after
>>      allocation (configurable in /proc/sys).
>>
>>  (6) A new struct (vm_region) is introduced to track mapped regions in NOMMU
>>      mode, and to handle the sharing of backing stores.  This required the
>>      vm_region structs of PowerPC and ARM to be renamed (the former patch has
>>      been pulled via the ppc tree).
>>
>>  (7) NOMMU VMAs are attached to their parent inodes as for MMU VMAs.
>>
>>  (8) munmap() may do a partial unmapping.
>>
>>  (9) Core dumping for ELF-FDPIC is simplified as the NOMMU- and MMU-mode code
>>      behaves more similarly.
>>
>> (10) /proc/maps provided in NOMMU mode now shows the regions allocated rather
>>      than the common VMA list.  /proc/meminfo now shows the amount of RAM
>>      currently allocated to private copies by private mmaps.
>>
>> These patches have had some soak time in linux-next.  I've also applied them
>> as-are to the latest merge window and tested that on my FRV board.
>>
>> David
>> ---
>> The following changes since commit 1bda71282ded6a2e09a2db7c8884542fb46bfd4f:
>>   Linus Torvalds (1):
>>         Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nommu.git master
>>
>> David Howells (8):
>>       NOMMU: Rename PowerPC's struct vm_region
>>       NOMMU: Rename ARM's struct vm_region
>>       NOMMU: Delete askedalloc and realalloc variables
>>       NOMMU: Make VMAs per MM as for MMU-mode linux
>>       NOMMU: Improve procfs output using per-MM VMAs
>>       FDPIC: Don't attempt to expand the userspace stack to fill the space allocated
>>       FLAT: Don't attempt to expand the userspace stack to fill the space allocated
>>       NOMMU: Support XIP on initramfs
>>
>> Matt Mackall (1):
>>       shmem: remove unused shmem_get_unmapped_area
>>
>> Paul Mundt (2):
>>       NOMMU: Make mmap allocation page trimming behaviour configurable.
>>       NOMMU: Teach kobjsize() about VMA regions.
>
> hm, has this all been suitably reviewed/publicised?

it has been among the people who actually use nommu (frv/sh/blackfin).
 i think we've been ragging on David for not getting this stuff in two
releases ago ;).
-mike
