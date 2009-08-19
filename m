Return-Path: <linux-kernel-owner+w=401wt.eu-S1750883AbZHSD32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbZHSD32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZHSD31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:29:27 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:2981 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZHSD30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EbvElP+yQBfPNOQtTemPAanZy17Ql+d3PDlyKTIjB4w1Hyyem3po8XWqPEG8cZKcV1
         h721Sjf3WTKHjwrRByTOgGMWTZ8MJWbpL1ql6EAd248E4/DS1ejO/A6IA/sXjoaGO2Z8
         /TortGGgG9oKPMEkV8hCrSpaeyGZrN2+yC830=
MIME-Version: 1.0
In-Reply-To: <20090818082247.GA31469@csn.ul.ie>
References: <alpine.LFD.2.00.0908172324130.32114@casper.infradead.org>
	 <20090818082247.GA31469@csn.ul.ie>
Date: Wed, 19 Aug 2009 15:29:27 +1200
Message-ID: <202cde0e0908182029k73292ee9k6d2782b40beaaa1c@mail.gmail.com>
Subject: Re: [PATCH 1/3]HTLB mapping for drivers. Alloc functions & some 
	export symbols(take 2)
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Alexey Korolev <akorolev@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>>   * Use a helper variable to find the next node and then
>>   * copy it back to hugetlb_next_nid afterwards:
>>   * otherwise there's a window in which a racer might
>
> I haven't read through the whole patchset properly yet, but at this
> point it's looking like you are going to expect drivers to create a file
> and then manually populate the page cache with hugepages they allocate
> directly from here. That would appear to put a large burden of VM
> knowledge upon a device driver author. The patch would also appear to
> expose a lot of hugetlbfs internals.
>
> Have you looked at Eric Munson's patches on the implementation of
> MAP_HUGETLB in the patch set
>
> http://marc.info/?l=linux-mm&m=125025895815115&w=2
>
> ?
Right. Simplicity is very important here and I just haven't find a
good way to make it simpler yet.
Thanks for the link neat approach is a thing I really need now. I've
studied the code and it has quite nice approach which could be
helpful.

>
> In that patchset, it was a very small number of changes required to
> expose a mapping private or shared to userspace.
>
> Would it make more sense to take an approach like that and instead add
> an additional helper within hugetlbfs (instead of the driver) that would
> return a pinned page at a given offset within a hugetlbfs file?
>
I believe it possible to to have a helper. The main problem here is
this: we need to
have a file which provides hugetlb mapping and which is not a part of
Hugetlbfs. So
the file does not have hugetlbfs file operations.It means it is
necessary to call somehow
hugetlb_get_unmapped_area & hugetlbfs_file_mmap for the file on
hugetlbfs associated
with the file related to device.

Probably, if we have non-hugetlbfs file and want to have huge pages
mappings it could make sense to have this approach:

add the following lines to mmap.c/get_unmapped_area function:

         get_area = current->mm->get_unmapped_area;
         if (file && file->f_op && file->f_op->get_unmapped_area)
                get_area = file->f_op->get_unmapped_area;
+       /* Call hugetlb_get_unmapped_area If non hugetlbfs file has
huge page mapping */
+       if (file && mapping_hugetlb(file->f_mapping) &&
!is_file_hugepages(file))
+               get_area = hugetlb_get_unmapped_area;
        addr = get_area(file, addr, len, pgoff, flags);
        if (IS_ERR_VALUE(addr))
                return addr;

add the following lines to mmap.c/mmap_region function:
                }
                vma->vm_file = file;
                get_file(file);
                error = file->f_op->mmap(file, vma);
                if (error)
                        goto unmap_and_free_vma;
+               /*
+                * If non non hugetlbfs file has huge page mapping
mmap must be called twice
+                * first time for proceeding file->fops->mmap second
time we must call hugetlbfs mmap
+               */
+               if (mapping_hugetlb(file->f_mapping) &&
!is_file_hugepages(file))
+                       error =hugetlbfs_file_mmap(file, vma);
+                if (error)
+                        goto unmap_and_free_vma;

                if (vm_flags & VM_EXECUTABLE)

Where mapping_hugetlb is
+static inline int mapping_hugetlb(struct address_space *mapping)
+{
+	if (likely(mapping))
+		return test_bit(AS_HUGETLB, &mapping->flags);
+	return 0;
+}
+
In addition we also need to introduce hugetlbfs_sb_info getting macro
to avoid issues in hugetlb_get_quota/hugetlb_put_quota functions.

In this case a driver just need to announce that file has huge page
mapping (mapping_set_hugetlb(file->f_mapping)), add some pages to page
cache and set-up proper VM flag in flie->f_ops->mmap.

Do you see anything really important being missed in this approach?

Thanks,
Alexey
