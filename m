Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbXENKwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbXENKwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 06:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbXENKvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 06:51:54 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:49779 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbXENKvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 06:51:53 -0400
Message-ID: <46483FAC.60503@freescale.com>
Date: Mon, 14 May 2007 18:53:32 +0800
From: Li Yang <leoli@freescale.com>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Linus <torvalds@linux-foundation.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/2] kbuild: Add "Section mismatch" warning whitelist for
 powerpc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2007 10:51:47.0016 (UTC) FILETIME=[DE39D480:01C79615]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following "Section mismatch" warnings when
build powerpc platforms.

-------------
WARNING: arch/powerpc/mm/built-in.o - Section mismatch: reference to .init.text:early_get_page from .text between 'pte_alloc_one_kernel' (at offset 0xc68) and 'pte_alloc_one'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text:set_up_list3s from .text between 'kmem_cache_create' (at offset 0x20300) and 'cache_reap'
-------------

Massive warnings represented by:
-------------
WARNING: arch/powerpc/kernel/built-in.o - Section mismatch: reference to .init.data:.got2 from prom_entry (offset 0x0)
WARNING: arch/powerpc/platforms/built-in.o - Section mismatch: reference to .init.text:mpc8313_rdb_probe from .machine.desc after 'mach_mpc8313_rdb' (at offset 0x4)
-------------

Signed-off-by: Li Yang <leoli@freescale.com>
---
 scripts/mod/modpost.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c89cb71..aa3a881 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -649,9 +649,10 @@ static int strrcmp(const char *s, const char *sub)
  *  tosec    = .init.text
  *
  * Pattern 10:
- *  ia64 has machvec table for each platform. It is mixture of function
- *  pointer of .init.text and .text.
- *  fromsec  = .machvec
+ *  ia64 has machvec table and powerpc has machine desc table for each
+ *  platform. It is mixture of function pointer of .init.text and .text.
+ *  fromsec  = .machvec | .machine.desc
+ *
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
 			    const char *fromsec, const char *atsym,
@@ -681,6 +682,8 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	const char *pat4sym[] = {
 		"sparse_index_alloc",
 		"zone_wait_table_init",
+		"pte_alloc_one_kernel",
+		"kmem_cache_create",
 		NULL
 	};
 
@@ -750,7 +753,8 @@ static int secref_whitelist(const char *modname, const char *tosec,
 				return 1;
 
 	/* Check for pattern 10 */
-	if (strcmp(fromsec, ".machvec") == 0)
+	if ((strcmp(fromsec, ".machvec") == 0) ||
+	    (strcmp(fromsec, ".machine.desc") == 0))
 		return 1;
 
 	return 0;
@@ -883,6 +887,10 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 	    secref_whitelist(modname, secname, fromsec,
 			     elf->strtab + before->st_name, refsymname))
 		return;
+	/* fromsec whitelist - without a valid 'before' */
+	/* powerpc has a GOT table in .got2 section */
+	if (strcmp(fromsec, ".got2") == 0)
+		return;
 
 	if (before && after) {
 		warn("%s - Section mismatch: reference to %s:%s from %s "

