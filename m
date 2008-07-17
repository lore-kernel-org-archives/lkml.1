Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYGRQ36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYGRQ36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbYGRQ3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:29:49 -0400
Received: from smtp.net4india.com ([202.71.148.84]:35488 "EHLO
	smtp.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbYGRQ3s (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:29:48 -0400
X-Greylist: delayed 83337 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 12:29:48 EDT
Subject: Patch [1/1] minor bugfix in 2.6.26/arch/x86/mm/pat.c - caused
	problems in mmap() of /dev/mem character file
From: "V.Radhakrishnan" <rk@atr-labs.com>
To: Linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Content-Type: text/plain
Date: Thu, 17 Jul 2008 22:55:16 +0530
Message-Id: <1216315516.2324.10.camel@atlas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FROM: V.Radhakrishnan <rk@atr-labs.com>

Description:

This is a 1-line bugfix !

The program linux-2.6.26/arch/x86/mm/pat.c has the following code

#ifdef CONFIG_NONPROMISC_DEVMEM
/* This check is done in drivers/char/mem.c in case of
NONPROMISC_DEVMEM*/
static inline int range_is_allowed(unsigned long pfn, unsigned long
size)
{
	return 1;
}
#else { ... }

The above #ifdef must be actually #ifndef and not #ifdef
The bug does not allow a valid user (root) from accessing /dev/mem even
though the CONFIG_PROMISC_DEVMEM is NOT selected.

Actual patch for fix follows ...

------

--- arch/x86/mm/pat.c.orig	2008-07-17 22:04:18.000000000 +0530
+++ arch/x86/mm/pat.c	2008-07-17 22:43:39.000000000 +0530
@@ -5,7 +5,11 @@
  *          Suresh B Siddha <suresh.b.siddha@intel.com>
  *
  * Loosely based on earlier PAT patchset from Eric Biederman and Andi
Kleen.
- */
+ *
+ * Bug fixed - V. Radhakrishnan <rk@atr-labs.com> on 17-07-2008
+		#ifdef CONFIG_NONPROMISC_DEVMEM changed to
+		#ifndef CONFIG_NONPROMISC_DEVMEM
+*/
 
 #include <linux/mm.h>
 #include <linux/kernel.h>
@@ -471,7 +475,7 @@ pgprot_t phys_mem_access_prot(struct fil
 	return vma_prot;
 }
 
-#ifdef CONFIG_NONPROMISC_DEVMEM
+#ifndef CONFIG_NONPROMISC_DEVMEM
 /* This check is done in drivers/char/mem.c in case of
NONPROMISC_DEVMEM*/
 static inline int range_is_allowed(unsigned long pfn, unsigned long
size)
 {
@@ -586,4 +590,3 @@ void unmap_devmem(unsigned long pfn, uns
 
 	free_memtype(addr, addr + size);
 }
-
Signed-off-by: Radhakrishnan <rk@atr-labs.com>



