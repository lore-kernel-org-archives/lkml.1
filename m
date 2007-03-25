Return-Path: <linux-kernel-owner+w=401wt.eu-S964773AbXCYBsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbXCYBsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 21:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964788AbXCYBsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 21:48:32 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:4236 "EHLO
	nlpi053.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964773AbXCYBsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 21:48:31 -0400
Message-ID: <4605D4EB.5060205@gmail.com>
Date: Sat, 24 Mar 2007 20:48:27 -0500
From: Bruce Dubbs <bruce.dubbs@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070119 SeaMonkey/1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add additional error check to mm/mincore.c
Content-Type: multipart/mixed;
 boundary="------------090303020209070108000601"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090303020209070108000601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I some circumstances, mincore can succeed when it shouldn't.

Example:
  Two files are mmapped to a process and they are adjacent in memory.
If mincore is run with a requested length that is too large, the
function does not differentiate between the different file pointers
within the different vma structures and inappropriately returns success.

The attached patch, against 2.6.20.3, fixes this behavior.

This behavior was found when running the Linux Test Project's mincore01
on an IA32 system.  Test 3 "unexpectedly" succeeds.

  -- Bruce

--------------090303020209070108000601
Content-Type: text/plain;
 name="mincore.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mincore.patch"

--- mm/mincore.c.old	2007-03-24 19:55:01.000000000 -0500
+++ mm/mincore.c	2007-03-24 20:13:43.000000000 -0500
@@ -43,7 +43,8 @@
  * all the arguments, we hold the mmap semaphore: we should
  * just return the amount of info we're asked for.
  */
-static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages)
+static long do_mincore(unsigned long addr, unsigned char *vec, unsigned long pages,
+        struct file** file_struct)
 {
 	unsigned long i, nr, pgoff;
 	struct vm_area_struct *vma = find_vma(current->mm, addr);
@@ -64,7 +65,19 @@
 	 * this is what we've traditionally done, so we'll just
 	 * continue doing it.
 	 */
-	if (!vma->vm_file)
+
+    /* 
+     * Initialize file pointer to the value in the first vma structure
+     */
+
+    if ( *file_struct == NULL && vma->vm_file )
+        *file_struct = vma->vm_file;
+
+    /*
+     * Return an error if the is no file mapped of the file is different
+     */
+ 
+	if (!vma->vm_file || vma->vm_file != *file_struct)
 		return -ENOMEM;
 
 	/*
@@ -115,6 +128,7 @@
 	long retval;
 	unsigned long pages;
 	unsigned char *tmp;
+    static struct file* file = NULL;
 
 	/* Check the start address: needs to be page-aligned.. */
  	if (start & ~PAGE_CACHE_MASK)
@@ -142,7 +156,7 @@
 		 * the temporary buffer size.
 		 */
 		down_read(&current->mm->mmap_sem);
-		retval = do_mincore(start, tmp, min(pages, PAGE_SIZE));
+		retval = do_mincore(start, tmp, min(pages, PAGE_SIZE), &file);
 		up_read(&current->mm->mmap_sem);
 
 		if (retval <= 0)

--------------090303020209070108000601--
