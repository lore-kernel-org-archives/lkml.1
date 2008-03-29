Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbYC2DKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbYC2DKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759854AbYC2DJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:09:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49925 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759828AbYC2DJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] vma_map: use proper pointer types
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <E1JfRRC-0002k0-Jr@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:08:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/oprofile/cell/vma_map.c |   37 ++++++++++++++-------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
index 76ec1d1..9a93217 100644
--- a/arch/powerpc/oprofile/cell/vma_map.c
+++ b/arch/powerpc/oprofile/cell/vma_map.c
@@ -92,7 +92,7 @@ vma_map_add(struct vma_to_fileoffset_map *map, unsigned int vma,
  * A pointer to the first vma_map in the generated list
  * of vma_maps is returned.  */
 struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
-					     unsigned long spu_elf_start)
+					     unsigned long __spu_elf_start)
 {
 	static const unsigned char expected[EI_PAD] = {
 		[EI_MAG0] = ELFMAG0,
@@ -107,9 +107,11 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 
 	int grd_val;
 	struct vma_to_fileoffset_map *map = NULL;
+	void __user *spu_elf_start = (void __user *)__spu_elf_start;
 	struct spu_overlay_info ovly;
 	unsigned int overlay_tbl_offset = -1;
-	unsigned long phdr_start, shdr_start;
+	Elf32_Phdr __user *phdr_start;
+	Elf32_Shdr __user *shdr_start;
 	Elf32_Ehdr ehdr;
 	Elf32_Phdr phdr;
 	Elf32_Shdr shdr, shdr_str;
@@ -121,12 +123,12 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 	unsigned int ovly_buf_table_sym = 0;
 	unsigned int ovly_table_end_sym = 0;
 	unsigned int ovly_buf_table_end_sym = 0;
-	unsigned long ovly_table;
+	struct spu_overlay_info __user *ovly_table;
 	unsigned int n_ovlys;
 
 	/* Get and validate ELF header.	 */
 
-	if (copy_from_user(&ehdr, (void *) spu_elf_start, sizeof (ehdr)))
+	if (copy_from_user(&ehdr, spu_elf_start, sizeof (ehdr)))
 		goto fail;
 
 	if (memcmp(ehdr.e_ident, expected, EI_PAD) != 0) {
@@ -152,9 +154,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 
 	/* Traverse program headers.  */
 	for (i = 0; i < ehdr.e_phnum; i++) {
-		if (copy_from_user(&phdr,
-				   (void *) (phdr_start + i * sizeof(phdr)),
-				   sizeof(phdr)))
+		if (copy_from_user(&phdr, phdr_start + i, sizeof(phdr)))
 			goto fail;
 
 		if (phdr.p_type != PT_LOAD)
@@ -171,9 +171,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 	pr_debug("SPU_PROF: Created non-overlay maps\n");
 	/* Traverse section table and search for overlay-related symbols.  */
 	for (i = 0; i < ehdr.e_shnum; i++) {
-		if (copy_from_user(&shdr,
-				   (void *) (shdr_start + i * sizeof(shdr)),
-				   sizeof(shdr)))
+		if (copy_from_user(&shdr, shdr_start + i, sizeof(shdr)))
 			goto fail;
 
 		if (shdr.sh_type != SHT_SYMTAB)
@@ -182,8 +180,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 			continue;
 
 		if (copy_from_user(&shdr_str,
-				   (void *) (shdr_start + shdr.sh_link *
-					     sizeof(shdr)),
+				   shdr_start + shdr.sh_link,
 				   sizeof(shdr)))
 			goto fail;
 
@@ -191,15 +188,15 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 			goto fail;;
 
 		for (j = 0; j < shdr.sh_size / sizeof (sym); j++) {
-			if (copy_from_user(&sym, (void *) (spu_elf_start +
-						       shdr.sh_offset + j *
-							   sizeof (sym)),
+			if (copy_from_user(&sym, spu_elf_start +
+						 shdr.sh_offset +
+						 j * sizeof (sym),
 					   sizeof (sym)))
 				goto fail;
 
-			if (copy_from_user(name, (void *)
-					   (spu_elf_start + shdr_str.sh_offset +
-					    sym.st_name),
+			if (copy_from_user(name, 
+					   spu_elf_start + shdr_str.sh_offset +
+					   sym.st_name,
 					   20))
 				goto fail;
 
@@ -245,9 +242,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 
 	/* Traverse overlay table.  */
 	for (i = 0; i < n_ovlys; i++) {
-		if (copy_from_user(&ovly, (void *)
-				   (ovly_table + i * sizeof (ovly)),
-				   sizeof (ovly)))
+		if (copy_from_user(&ovly, ovly_table + i, sizeof (ovly)))
 			goto fail;
 
 		/* The ovly.vma/size/offset arguments are analogous to the same
-- 
1.5.3.GIT


