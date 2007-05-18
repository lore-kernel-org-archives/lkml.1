Return-Path: <linux-kernel-owner+w=401wt.eu-S1763123AbXERG73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763123AbXERG73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXERG7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:59:22 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59144 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbXERG7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:59:21 -0400
Date: Fri, 18 May 2007 09:00:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/14] kbuild: add support for squashing uid/gid in gen_initramfs_list.sh
Message-ID: <20070518070018.GL12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2ecaa761242e76780a35647f3d3749ee6d04d618 Mon Sep 17 00:00:00 2001
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 10 May 2007 22:44:28 -0700
Subject: [PATCH 12/14] kbuild: add support for squashing uid/gid in gen_initramfs_list.sh

Sometimes it is useful to squash all uid's/gid's to 0:0 regardless of
current owner.  For example, in build systems that get run as arbitrary
users (uClinux-dist).  This adds a special "squash" keyword so you can do
'-g squash -u squash' and have ownership squashed to root.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/gen_initramfs_list.sh |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 683eb12..684fb9c 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -19,11 +19,11 @@ $0 [-o <file>] [-u <uid>] [-g <gid>] {-d | <cpio_source>} ...
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
-- 
1.5.1.rc3.20.gaa453

