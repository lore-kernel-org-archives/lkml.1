Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbXCZKX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbXCZKX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXCZKX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:23:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5502 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbXCZKX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:23:26 -0400
X-IronPort-AV: i="4.14,329,1170651600"; 
   d="scan'208"; a="25490771:sNHT33536734"
Subject: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 26 Mar 2007 18:23:57 +0800
Message-Id: <1174904637.32691.86.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

As struct mm_struct vm_mm is hidden in struct vm_area_struct in NOMMU
arch, this is a fixing method when compiling failure on blackfin arch.

Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
---

 fs/revoke.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/revoke.c
===================================================================
--- linux-2.6.orig/fs/revoke.c
+++ linux-2.6/fs/revoke.c
@@ -207,13 +207,21 @@
 /*
  *	LOCKING: spin_lock(&mapping->i_mmap_lock)
  */
-static int revoke_mm(struct mm_struct *mm, struct address_space *mapping,
+static int revoke_mm(struct vm_area_struct *vma, struct address_space *mapping,
 		     struct file *to_exclude)
 {
-	struct vm_area_struct *vma;
+#ifdef CONFIG_MMU
+	struct mm_struct *mm = vma->vm_mm;
+#else
+	struct mm_struct *mm = 0;
+#endif
+	struct vm_area_struct *_vma;
 	struct zap_details details;
 	int err = 0;
 
+	if (!mm)
+		return -ENOENT;
+
 	details.i_mmap_lock = &mapping->i_mmap_lock;
 
 	/*
@@ -224,11 +232,11 @@
 		err = -EAGAIN;
 		goto out;
 	}
-	for (vma = mm->mmap; vma != NULL; vma = vma->vm_next) {
-		if (!need_revoke(vma, to_exclude))
+	for (_vma = mm->mmap; _vma != NULL; _vma = _vma->vm_next) {
+		if (!need_revoke(_vma, to_exclude))
 			continue;
 
-		err = revoke_vma(vma, &details);
+		err = revoke_vma(_vma, &details);
 		if (err)
 			break;
 	}
@@ -254,7 +262,7 @@
 		if (likely(!need_revoke(vma, to_exclude)))
 			continue;
 
-		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		err = revoke_mm(vma, mapping, to_exclude);
 		if (err == -EAGAIN) {
 			try_again = 1;
 			continue;
@@ -284,7 +292,7 @@
 		if (likely(!need_revoke(vma, to_exclude)))
 			continue;
 
-		err = revoke_mm(vma->vm_mm, mapping, to_exclude);
+		err = revoke_mm(vma, mapping, to_exclude);
 		if (err == -EAGAIN) {
 			try_again = 1;
 			continue;
_

Thanks,
-Bryan Wu
