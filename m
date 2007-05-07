Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXEGJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXEGJjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 05:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXEGJjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 05:39:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45754 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbXEGJjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 05:39:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch] add support for squashing uid/gid in gen_initramfs_list.sh
Date: Mon, 7 May 2007 05:40:11 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705070540.12166.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is useful to squash all uid's/gid's to 0:0 regardless of current 
owner.  For example, in build systems that get run as arbitrary users 
(uClinux-dist).  This adds a special "squash" keyword so you can do '-g 
squash -u squash' and have ownership squashed to root.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 683eb12..684fb9c 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -19,11 +19,11 @@ $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | 
<cpio_source>} ...
 	-o <file>      Create gzipped initramfs file named <file> using
 		       gen_init_cpio and gzip
 	-u <uid>       User ID to map to user ID 0 (root).
-		       <uid> is only meaningful if <cpio_source>
-		       is a directory.
+		       <uid> is only meaningful if <cpio_source> is a
+		       directory.  "squash" forces all files to uid 0.
 	-g <gid>       Group ID to map to group ID 0 (root).
-		       <gid> is only meaningful if <cpio_source>
-		       is a directory.
+		       <gid> is only meaningful if <cpio_source> is a
+		       directory.  "squash" forces all files to gid 0.
 	<cpio_source>  File list or directory for cpio archive.
 		       If <cpio_source> is a .cpio file it will be used
 		       as direct input to initramfs.
@@ -113,8 +113,8 @@ parse() {
 	local gid="$4"
 	local ftype=$(filetype "${location}")
 	# remap uid/gid to 0 if necessary
-	[ "$uid" -eq "$root_uid" ] && uid=0
-	[ "$gid" -eq "$root_gid" ] && gid=0
+	[ "$root_uid" = "squash" ] && uid=0 || [ "$uid" -eq "$root_uid" ] && uid=0
+	[ "$root_gid" = "squash" ] && gid=0 || [ "$gid" -eq "$root_gid" ] && gid=0
 	local str="${mode} ${uid} ${gid}"
 
 	[ "${ftype}" == "invalid" ] && return 0
