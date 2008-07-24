Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYGXJvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYGXJvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYGXJva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:51:30 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:21341 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744AbYGXJva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:51:30 -0400
Date: Thu, 24 Jul 2008 18:51:22 +0900 (JST)
Message-Id: <20080724.185122.139681307.nemoto@toshiba-tops.co.jp>
To: linux-kernel@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 2.6.26-git] Fix oops on remounting nfsroot
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this oops when remounting nfsroot using busybox's mount:

VFS: Mounted root (nfs filesystem) readonly.
Freeing unused kernel memory: 180k freed
CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 801c3160, ra == 801744d0
...
Call Trace:
[<801c3160>] nfs_remount+0x60/0x2e0
[<801744d0>] do_remount_sb+0x184/0x1fc
[<8018b7a8>] do_remount+0x140/0x194
[<8018d824>] do_mount+0x138/0x1f0
[<8018d970>] sys_mount+0x94/0x1b4
[<80108df0>] stack_done+0x20/0x3c

This is a quick workaround, but I'm not sure this is proper fix.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 1b94e36..adc96cd 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1718,7 +1718,8 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data)
 	 * ones were explicitly specified. Fall back to legacy behavior and
 	 * just return success.
 	 */
-	if ((nfsvers == 4 && options4->version == 1) ||
+	if (!options ||
+	    (nfsvers == 4 && options4->version == 1) ||
 	    (nfsvers <= 3 && options->version >= 1 &&
 	     options->version <= 6))
 		return 0;
