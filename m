Return-Path: <linux-kernel-owner+w=401wt.eu-S1422889AbXCBEtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbXCBEtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422893AbXCBEtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:49:23 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:56844 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422889AbXCBEtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:49:21 -0500
Message-ID: <45E7ACC9.6030907@hitachi.com>
Date: Fri, 02 Mar 2007 13:49:13 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: [PATCH 2/4] coredump: ELF: enable to omit anonymous shared memory
References: <45E7AAFA.4070402@hitachi.com>
In-Reply-To: <45E7AAFA.4070402@hitachi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables to omit anonymous shared memory from an ELF
formatted core file when it is generated.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/binfmt_elf.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.20-mm2/fs/binfmt_elf.c
===================================================================
--- linux-2.6.20-mm2.orig/fs/binfmt_elf.c
+++ linux-2.6.20-mm2/fs/binfmt_elf.c
@@ -1191,9 +1191,15 @@ static int maydump(struct vm_area_struct
 	if (vma->vm_flags & (VM_IO | VM_RESERVED))
 		return 0;
 
-	/* Dump shared memory only if mapped from an anonymous file. */
-	if (vma->vm_flags & VM_SHARED)
-		return vma->vm_file->f_path.dentry->d_inode->i_nlink == 0;
+	/*
+	 * Dump shared memory only if mapped from an anonymous file and
+	 * /proc/<pid>/coredump_omit_anonymous_shared flag is not set.
+	 */
+	if (vma->vm_flags & VM_SHARED) {
+		if (vma->vm_file->f_path.dentry->d_inode->i_nlink)
+			return 0;
+		return vma->vm_mm->coredump_omit_anon_shared == 0;
+	}
 
 	/* If it hasn't been written to, don't write it out */
 	if (!vma->anon_vma)


