Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbZJNKbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbZJNKbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbZJNKbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:31:15 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4378 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbZJNKbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:31:14 -0400
X-IronPort-AV: E=Sophos;i="4.44,556,1249272000"; 
   d="scan'208";a="7587520"
From: <graff.yang@gmail.com>
To: <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>,
       <gyang@blackfin.uclinux.org>
CC: <akpm@linux-foundation.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
       Graff Yang <graf.yang@analog.com>
Subject: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Date: Wed, 14 Oct 2009 18:28:54 +0800
Message-ID: <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
X-Mailer: git-send-email 1.6.4.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graff Yang <graf.yang@analog.com>

The original code calling security_file_mmap() use user's hint address
as it's 5th argument(addr). This is improper, as the hint address may be
NULL.
In this case, the security_file_mmap() may incorrectly return -EPERM.

This patch moved the calling of security_file_mmap() out of
validate_mmap_request() to do_mmap_pgoff(), and call this
security API with the address that attempting to mmap.

Signed-off-by: Graff Yang <graf.yang@analog.com>
---
 mm/nommu.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 3a5e989..fc986d4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -862,7 +862,6 @@ static int validate_mmap_request(struct file *file,
 				 unsigned long *_capabilities)
 {
 	unsigned long capabilities, rlen;
-	unsigned long reqprot = prot;
 	int ret;
 
 	/* do the simple checks first */
@@ -1013,11 +1012,6 @@ static int validate_mmap_request(struct file *file,
 			prot |= PROT_EXEC;
 	}
 
-	/* allow the security API to have its say */
-	ret = security_file_mmap(file, reqprot, prot, flags, addr, 0);
-	if (ret < 0)
-		return ret;
-
 	/* looks okay */
 	*_capabilities = capabilities;
 	return 0;
@@ -1231,6 +1225,7 @@ unsigned long do_mmap_pgoff(struct file *file,
 	struct vm_area_struct *vma;
 	struct vm_region *region;
 	struct rb_node *rb;
+	unsigned long reqprot = prot;
 	unsigned long capabilities, vm_flags, result;
 	int ret;
 
@@ -1327,6 +1322,12 @@ unsigned long do_mmap_pgoff(struct file *file,
 				continue;
 			}
 
+			/* allow the security API to have its say */
+			ret = security_file_mmap(file, reqprot, prot, flags,
+							pregion->vm_start, 0);
+			if (ret < 0)
+				goto error_just_free;
+
 			/* we've found a region we can share */
 			atomic_inc(&pregion->vm_usage);
 			vma->vm_region = pregion;
@@ -1394,6 +1395,11 @@ unsigned long do_mmap_pgoff(struct file *file,
 	if (ret < 0)
 		goto error_put_region;
 
+	ret = security_file_mmap(file, reqprot, prot, flags,
+					vma->vm_start, 0);
+	if (ret < 0)
+		goto error_put_region;
+
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
-- 
1.6.4.4

