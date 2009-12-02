Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZLBOQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZLBOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbZLBOQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:16:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZLBOQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:16:25 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
References: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, Paul Mundt <lethal@linux-sh.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
Date: Wed, 02 Dec 2009 14:15:30 +0000
Message-ID: <15859.1259763330@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> (yes, this now does the icache flush while holding the
> nommu_region_sem, but i'm interested if the _idea_ is OK)

Yes...  But it's not quite as simple as you think.  The first mapping made of
a file could be PROT_READ only, in which case a second, executable mapping
made that shares it would not get flushed from the icache.

How about the attached patch?

David
---
From: Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] NOMMU: Avoiding duplicate icache flushes of shared maps

When working with FDPIC, there are many shared mappings of read-only code
regions between applications (the C library, applet packages like busybox,
etc.), but the current do_mmap_pgoff() function will issue an icache flush
whenever a VMA is added to an MM instead of only doing it when the map is
initially created.

The flush can instead be done when a region is first mmapped PROT_EXEC.  Note
that we may not rely on the first mapping of a region being executable - it's
possible for it to be PROT_READ only, so we have to remember whether we've
flushed the region or not, and then flush the entire region when a bit of it is
made executable.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mm_types.h |    2 ++
 mm/nommu.c               |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 84a524a..84d020b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -123,6 +123,8 @@ struct vm_region {
 	struct file	*vm_file;	/* the backing file or NULL */
 
 	atomic_t	vm_usage;	/* region usage count */
+	bool		vm_icache_flushed : 1; /* true if the icache has been flushed for
+						* this region */
 };
 
 /*
diff --git a/mm/nommu.c b/mm/nommu.c
index 969392c..95159a1 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1353,10 +1353,15 @@ unsigned long do_mmap_pgoff(struct file *file,
 share:
 	add_vma_to_mm(current->mm, vma);
 
-	up_write(&nommu_region_sem);
+	/* we flush the region from the icache only when the first executable
+	 * mapping of it is made  */
+	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
+		flush_icache_range(region->vm_start,
+				   region->vm_end - region->vm_start);
+		region->vm_icache_flushed = true;
+	}
 
-	if (prot & PROT_EXEC)
-		flush_icache_range(result, result + len);
+	up_write(&nommu_region_sem);
 
 	kleave(" = %lx", result);
 	return result;

