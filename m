Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbXIBRjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbXIBRjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXIBRi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:38:58 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55537 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXIBRi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:38:57 -0400
Message-ID: <46DAF511.6030406@suse.de>
Date: Mon, 03 Sep 2007 01:38:25 +0800
From: Coly Li <coyli@suse.de>
Reply-To: coyli@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] use VM_READ/WRITE/EXEC to set vm_page_prot
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0CF293FF192443070E8F2C41"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0CF293FF192443070E8F2C41
Content-Type: multipart/mixed;
 boundary="------------070401050803040409060400"

This is a multi-part message in MIME format.
--------------070401050803040409060400
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

When setup vm_page_prot, some code use 0x7 instead of  (VM_READ|VM_WRITE|=
VM_EXEC). It does works
well, but it will be better if we use the VM_READ/WRITE/EXEC MACRO :-)

This patch uses (VM_READ|VM_WRITE|VM_EXEC) to replace 0x7 in vm_page_prot=
 setup.

Signed-Off-By: Coly Li <coyli@suse.de>

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index c14abef..864a9f3 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -130,7 +130,8 @@ ia64_init_addr_space (void)
 		vma->vm_mm =3D current->mm;
 		vma->vm_start =3D current->thread.rbs_bot & PAGE_MASK;
 		vma->vm_end =3D vma->vm_start + PAGE_SIZE;
-		vma->vm_page_prot =3D protection_map[VM_DATA_DEFAULT_FLAGS & 0x7];
+		vma->vm_page_prot =3D protection_map[VM_DATA_DEFAULT_FLAGS &
+					(VM_READ|VM_WRITE|VM_EXEC)];
 		vma->vm_flags =3D VM_DATA_DEFAULT_FLAGS|VM_GROWSUP|VM_ACCOUNT;
 		down_write(&current->mm->mmap_sem);
 		if (insert_vm_struct(current->mm, vma)) {
diff --git a/fs/exec.c b/fs/exec.c
index c21a8cc..cca277f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -261,7 +261,8 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
 	vma->vm_start =3D vma->vm_end - PAGE_SIZE;

 	vma->vm_flags =3D VM_STACK_FLAGS;
-	vma->vm_page_prot =3D protection_map[vma->vm_flags & 0x7];
+	vma->vm_page_prot =3D protection_map[vma->vm_flags &
+				(VM_READ|VM_WRITE|VM_EXEC)];
 	err =3D insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
diff --git a/mm/mmap.c b/mm/mmap.c
index 0d40e66..18d33f2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2210,7 +2210,8 @@ int install_special_mapping(struct mm_struct *mm,
 	vma->vm_end =3D addr + len;

 	vma->vm_flags =3D vm_flags | mm->def_flags;
-	vma->vm_page_prot =3D protection_map[vma->vm_flags & 7];
+	vma->vm_page_prot =3D protection_map[vma->vm_flags &
+				(VM_READ|VM_WRITE|VM_EXEC)];

 	vma->vm_ops =3D &special_mapping_vmops;
 	vma->vm_private_data =3D pages;



--------------070401050803040409060400
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjIuMC40LXN2
bjAgKEdOVS9MaW51eCkKQ29tbWVudDogVXNpbmcgR251UEcgd2l0aCBTVVNFIC0gaHR0cDov
L2VuaWdtYWlsLm1vemRldi5vcmcKCmlEOERCUUZHMnZDa3VUcDhjeVo1bFRFUkF0WnBBSjl3
SXJ6aWt2NTFyNW5hdUtrRThvcGhORG44ZWdDZEZmeEIKd0N2UFNhTzlycHVVUUhXSjJUSHIv
TEE9Cj1ZYUs5Ci0tLS0tRU5EIFBHUCBTSUdOQVRVUkUtLS0tLQoK
--------------070401050803040409060400--

--------------enig0CF293FF192443070E8F2C41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFG2vUVuTp8cyZ5lTERAiTTAJ9im5vzUP+EJFbwUG5xfTsPymg93ACghSQ8
UHfThTr6yfDiTugdxNyEKRg=
=4rqA
-----END PGP SIGNATURE-----

--------------enig0CF293FF192443070E8F2C41--
