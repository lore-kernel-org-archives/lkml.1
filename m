Return-Path: <linux-kernel-owner+w=401wt.eu-S1030867AbXAZQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030867AbXAZQvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030852AbXAZQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:51:14 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25548 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030786AbXAZQu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:50:26 -0500
Date: Fri, 26 Jan 2007 17:50:20 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: geraldsc@de.ibm.com
Subject: [S390] Show loaded DCSS segments under /proc/iomem.
Message-ID: <20070126165020.GL11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <geraldsc@de.ibm.com>

[S390] Show loaded DCSS segments under /proc/iomem.

Currently loaded DCSS segments are now listed in /proc/iomem with
their name followed by a trailing "(DCSS)".

Signed-off-by: Gerald Schaefer <geraldsc@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/mm/extmem.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/arch/s390/mm/extmem.c linux-2.6-patched/arch/s390/mm/extmem.c
--- linux-2.6/arch/s390/mm/extmem.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/extmem.c	2007-01-26 17:27:57.000000000 +0100
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/bootmem.h>
 #include <linux/ctype.h>
+#include <linux/ioport.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/ebcdic.h>
@@ -70,6 +71,7 @@ struct qin64 {
 struct dcss_segment {
 	struct list_head list;
 	char dcss_name[8];
+	char res_name[15];
 	unsigned long start_addr;
 	unsigned long end;
 	atomic_t ref_count;
@@ -77,6 +79,7 @@ struct dcss_segment {
 	unsigned int vm_segtype;
 	struct qrange range[6];
 	int segcnt;
+	struct resource *res;
 };
 
 static DEFINE_MUTEX(dcss_lock);
@@ -303,6 +306,26 @@ __segment_load (char *name, int do_nonsh
 		goto out_free;
 	}
 
+	seg->res = kzalloc(sizeof(struct resource), GFP_KERNEL);
+	if (seg->res == NULL) {
+		rc = -ENOMEM;
+		goto out_shared;
+	}
+	seg->res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
+	seg->res->start = seg->start_addr;
+	seg->res->end = seg->end;
+	memcpy(&seg->res_name, seg->dcss_name, 8);
+	EBCASC(seg->res_name, 8);
+	seg->res_name[8] = '\0';
+	strncat(seg->res_name, " (DCSS)", 7);
+	seg->res->name = seg->res_name;
+	rc = request_resource(&iomem_resource, seg->res);
+	if (rc) {
+		rc = -EBUSY;
+		kfree(seg->res);
+		goto out_shared;
+	}
+
 	if (do_nonshared)
 		dcss_command = DCSS_LOADNSR;
 	else
@@ -316,12 +339,14 @@ __segment_load (char *name, int do_nonsh
 		rc = dcss_diag_translate_rc (seg->end);
 		dcss_diag(DCSS_PURGESEG, seg->dcss_name,
 				&seg->start_addr, &seg->end);
-		goto out_shared;
+		goto out_resource;
 	}
 	seg->do_nonshared = do_nonshared;
 	atomic_set(&seg->ref_count, 1);
 	list_add(&seg->list, &dcss_list);
 	rc = seg->vm_segtype;
+	if (rc == SEG_TYPE_SC)
+			seg->res->flags |= IORESOURCE_READONLY;
 	*addr = seg->start_addr;
 	*end  = seg->end;
 	if (do_nonshared)
@@ -329,12 +354,18 @@ __segment_load (char *name, int do_nonsh
 				"type %s in non-shared mode\n", name,
 				(void*)seg->start_addr, (void*)seg->end,
 				segtype_string[seg->vm_segtype]);
-	else
+	else {
 		PRINT_INFO ("segment_load: loaded segment %s range %p .. %p "
 				"type %s in shared mode\n", name,
 				(void*)seg->start_addr, (void*)seg->end,
 				segtype_string[seg->vm_segtype]);
+		if (rc == SEG_TYPE_SR || rc == SEG_TYPE_ER)
+			seg->res->flags |= IORESOURCE_READONLY;
+	}
 	goto out;
+ out_resource:
+	release_resource(seg->res);
+	kfree(seg->res);
  out_shared:
 	remove_shared_memory(seg->start_addr, seg->end - seg->start_addr + 1);
  out_free:
@@ -433,7 +464,7 @@ segment_modify_shared (char *name, int d
 	if (do_nonshared)
 		dcss_command = DCSS_LOADNSR;
 	else
-	dcss_command = DCSS_LOADNOLY;
+		dcss_command = DCSS_LOADNOLY;
 	diag_cc = dcss_diag(dcss_command, seg->dcss_name,
 			&seg->start_addr, &seg->end);
 	if (diag_cc > 1) {
@@ -443,6 +474,13 @@ segment_modify_shared (char *name, int d
 		goto out_del;
 	}
 	seg->do_nonshared = do_nonshared;
+	if (do_nonshared)
+		seg->res->flags &= ~IORESOURCE_READONLY;
+	else
+		if (seg->vm_segtype == SEG_TYPE_SR ||
+		    seg->vm_segtype == SEG_TYPE_ER)
+			seg->res->flags |= IORESOURCE_READONLY;
+
 	rc = 0;
 	goto out_unlock;
  out_del:
@@ -478,6 +516,8 @@ segment_unload(char *name)
 	}
 	if (atomic_dec_return(&seg->ref_count) != 0)
 		goto out_unlock;
+	release_resource(seg->res);
+	kfree(seg->res);
 	remove_shared_memory(seg->start_addr, seg->end - seg->start_addr + 1);
 	list_del(&seg->list);
 	dcss_diag(DCSS_PURGESEG, seg->dcss_name, &dummy, &dummy);
