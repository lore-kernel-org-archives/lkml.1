Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbZI3FSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbZI3FSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 01:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZI3FSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 01:18:05 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:47526 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbZI3FSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 01:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=dVCKmqdVVmd2ph+iQIpcyWwHMpucQ9URYRca2hF3Cu2Yq/g2uneZ99EDPQMfFTrPxa
         52r8S9s+vF7TGheYSuapcREp4LOOhASLoBHBLlMVHuxT4L7Q+VimAXMptt6VquLYFMeW
         VXqolQFUu9Sn4Fvi24+MYHSRXRgXFPobu5L0k=
MIME-Version: 1.0
Date: Wed, 30 Sep 2009 11:18:07 +0600
Message-ID: <b9df5fa10909292218j5b3f022bmfb3f089ee08fed66@mail.gmail.com>
Subject: [PATCH] sfi: Fix section mismatch warnings in sfi_core.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The function sfi_map_memory/sfi_unmap_memory uses
early_ioremap/early_iounmap respectively, which refers to a __init
function. And function sfi_check_table also refers to a __init
function sfi_verify_table. Since the references are valid, so use
__ref to get rid of the warnings.

 We were warned by the following warnings:

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xb6ba3a): Section mismatch in reference from
the function sfi_map_memory() to the function
.init.text:early_ioremap()
The function sfi_map_memory() references
the function __init early_ioremap().
This is often because sfi_map_memory lacks a __init
annotation or the annotation of early_ioremap is wrong.

WARNING: vmlinux.o(.text+0xb6bab6): Section mismatch in reference from
the function sfi_unmap_memory() to the function
.init.text:early_iounmap()
The function sfi_unmap_memory() references
the function __init early_iounmap().
This is often because sfi_unmap_memory lacks a __init
annotation or the annotation of early_iounmap is wrong.

WARNING: vmlinux.o(.text+0xb6be30): Section mismatch in reference from
the function sfi_check_table() to the function
.init.text:sfi_verify_table()
The function sfi_check_table() references
the function __init sfi_verify_table().
This is often because sfi_check_table lacks a __init
annotation or the annotation of sfi_verify_table is wrong.

---

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>


--- linus/drivers/sfi/sfi_core.c	2009-09-29 20:02:37.000000000 +0600
+++ rakib/drivers/sfi/sfi_core.c	2009-09-29 23:11:09.000000000 +0600
@@ -90,7 +90,11 @@ static struct sfi_table_simple *syst_va
  */
 static u32 sfi_use_ioremap __read_mostly;

-static void __iomem *sfi_map_memory(u64 phys, u32 size)
+/*
+ * sfi_un/map_memory calls early_ioremap/iounmap which is a __init function
+ * and introduces section mismatch. So use __ref to make it calm.
+ */
+static void __iomem * __ref sfi_map_memory(u64 phys, u32 size)
 {
 	if (!phys || !size)
 		return NULL;
@@ -101,7 +105,7 @@ static void __iomem *sfi_map_memory(u64
 		return early_ioremap(phys, size);
 }

-static void sfi_unmap_memory(void __iomem *virt, u32 size)
+static void __ref sfi_unmap_memory(void __iomem *virt, u32 size)
 {
 	if (!virt || !size)
 		return;
@@ -213,12 +217,17 @@ static int sfi_table_check_key(struct sf
  *    the mapped virt address will be returned, and the virt space
  *    will be released by call sfi_put_table() later
  *
+ * This two cases are from two different functions with two different
+ * sections and causes section mismatch warning. So use __ref to tell
+ * modpost not to make any noise.
+ *
  * Return value:
  *	NULL:			when can't find a table matching the key
  *	ERR_PTR(error):		error value
  *	virt table address:	when a matched table is found
  */
-struct sfi_table_header *sfi_check_table(u64 pa, struct sfi_table_key *key)
+struct sfi_table_header *
+ __ref sfi_check_table(u64 pa, struct sfi_table_key *key)
 {
 	struct sfi_table_header *th;
 	void *ret = NULL;
