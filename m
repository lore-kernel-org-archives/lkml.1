Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYGBIDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYGBIDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYGBICy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:02:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYGBICw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:02:52 -0400
Date: Wed, 2 Jul 2008 01:02:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [-mmotm] some different buliding failures
Message-Id: <20080702010212.7b4b9301.akpm@linux-foundation.org>
In-Reply-To: <486B1EE0.9060303@cn.fujitsu.com>
References: <486B1EE0.9060303@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 14:23:28 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> 
> drivers/mfd/sm501.c:39: error: field 'gpio' has incomplete type
> 

Ben, can you please take a look?  I suspect the fix is to disable this
driver on x86.

> 
> drivers/media/video/ivtv/ivtv-ioctl.c: In function 'ivtv_set_funcs':
> drivers/media/video/ivtv/ivtv-ioctl.c:1899: error: 'struct video_device' has no member named 'vidioc_g_register'
> drivers/media/video/ivtv/ivtv-ioctl.c:1900: error: 'struct video_device' has no member named 'vidioc_s_register'

Seems to have been fixed.

> 
> mm/hugetlb.c: In function 'vma_needs_reservation':
> mm/hugetlb.c:859: error: implicit declaration of function 'vma_pagecache_offset'

Against hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch:

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2-fix
+++ a/mm/hugetlb.c
@@ -856,7 +856,7 @@ static int vma_needs_reservation(struct 
 
 	} else  {
 		int err;
-		pgoff_t idx = vma_pagecache_offset(h, vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		err = region_chg(&reservations->regions, idx, idx + 1);
@@ -876,7 +876,7 @@ static void vma_commit_reservation(struc
 		region_add(&inode->i_mapping->private_list, idx, idx + 1);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
-		pgoff_t idx = vma_pagecache_offset(h, vma, addr);
+		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
@@ -1553,8 +1553,8 @@ static void hugetlb_vm_op_close(struct v
 	unsigned long end;
 
 	if (reservations) {
-		start = vma_pagecache_offset(h, vma, vma->vm_start);
-		end = vma_pagecache_offset(h, vma, vma->vm_end);
+		start = vma_hugecache_offset(h, vma, vma->vm_start);
+		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 		reserve = (end - start) -
 			region_count(&reservations->regions, start, end);
_

