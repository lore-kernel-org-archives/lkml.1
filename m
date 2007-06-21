Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbXFUNST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbXFUNST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbXFUNSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:18:04 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:49741 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbXFUNSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:18:01 -0400
Subject: Re: [BUG?]Set XIP mount option on ext2 bypass check.
From: Carsten Otte <cotte@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yan Zheng <yanzheng@21cn.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <467A5E36.9030904@de.ibm.com>
References: <4679A58C.2080008@21cn.com>
	 <3d0408630706201840o5b1c2454n75d1ebbd26d660d6@mail.gmail.com>
	 <467A5E36.9030904@de.ibm.com>
Content-Type: text/plain
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
	Aufsichtsrats: Johann Weihen =?ISO-8859-1?Q?Gesch=E4ftsf=FChrung=3A?=
	Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-1?Q?B=F6blingen?=
	Registergericht: Amtsgericht Stuttgart, HRB 243294
Date: Thu, 21 Jun 2007 15:17:49 +0200
Message-Id: <1182431869.7145.7.camel@cotte.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of my bugfix patch. Yan Zheng pointed out,
that ext2_remount lacks checking if -o xip should be enabled or not.
This patch checks for presence of direct_access on the backing block
device and if the blocksize meets the requirements.
Andrew, please consider adding this patch to -mm.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
---
Index: linux-2.6.22-rc4-mm/fs/ext2/super.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/fs/ext2/super.c
+++ linux-2.6.22-rc4-mm/fs/ext2/super.c
@@ -1071,6 +1071,14 @@ static int ext2_remount (struct super_bl
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((sbi->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
+	ext2_xip_verify_sb(sb); /* see if bdev supports xip, unset
+				    EXT2_MOUNT_XIP if not */
+
+	if ((ext2_use_xip(sb)) && (sb->s_blocksize != PAGE_SIZE)) {
+		printk("XIP: Unsupported blocksize\n");
+		goto restore_opts; 
+	}
+
 	es = sbi->s_es;
 	if (((sbi->s_mount_opt & EXT2_MOUNT_XIP) !=
 	    (old_mount_opt & EXT2_MOUNT_XIP)) &&


