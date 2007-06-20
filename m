Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXFTVQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXFTVQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXFTVQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:16:37 -0400
Received: from host-69-39-86-10.a2webhosting.com ([69.39.86.10]:56372 "EHLO
	a2s21.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXFTVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:16:37 -0400
Message-ID: <4679990C.4070801@banksresearch.com>
Date: Wed, 20 Jun 2007 17:15:56 -0400
From: Wyatt Banks <wyatt@banksresearch.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] HFSPlus: fix mount uid/gid bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-A2hosting-MailScanner-Information: Please contact the ISP for more information
X-A2hosting-MailScanner: Found to be clean
X-A2hosting-MailScanner-SpamCheck: 
X-A2hosting-MailScanner-From: wyatt@banksresearch.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s21.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - banksresearch.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Wyatt Banks <wyatt@banksresearch.com>

HFSPlus: fix broken logic for mount uid=xxx,gid=xxx. (bug 3533)

Signed-off-by	Wyatt Banks <wyatt@banksresearch.com>

---

Patched against 2.6.21.5

Tested on an x86 machine with USB hard drive formatted by a
PowerPC Mac.

This is a patch to address bug 3533.

The 2 lines that should be setting the uid/gid:

if (!inode->i_uid && !mode)
if (!inode->i_gid && !mode)

always evaluate as false.  mode is the BSD file type and mode bits.
These lines do nothing since the file type bits are not masked off
with S_IFMT.

References:

http://bugzilla.kernel.org/show_bug.cgi?id=3533
http://developer.apple.com/technotes/tn/tn1150.html


diff -uprN -X linux-2.6.21.5/Documentation/dontdiff linux-2.6.21.5/fs/hfsplus/hfsplus_fs.h linux-2.6.21.5-devel/fs/hfsplus/hfsplus_fs.h
--- linux-2.6.21.5/fs/hfsplus/hfsplus_fs.h	2007-06-11 14:37:06.000000000 -0400
+++ linux-2.6.21.5-devel/fs/hfsplus/hfsplus_fs.h	2007-06-16 23:35:43.000000000 -0400
@@ -139,6 +139,8 @@ struct hfsplus_sb_info {
	uid_t uid;
	gid_t gid;

+	int uid_provided, gid_provided;
+
	int part, session;

	unsigned long flags;
diff -uprN -X linux-2.6.21.5/Documentation/dontdiff linux-2.6.21.5/fs/hfsplus/inode.c linux-2.6.21.5-devel/fs/hfsplus/inode.c
--- linux-2.6.21.5/fs/hfsplus/inode.c	2007-06-11 14:37:06.000000000 -0400
+++ linux-2.6.21.5-devel/fs/hfsplus/inode.c	2007-06-18 20:11:18.000000000 -0400
@@ -181,11 +181,11 @@ static void hfsplus_get_perms(struct ino
	mode = be16_to_cpu(perms->mode);

	inode->i_uid = be32_to_cpu(perms->owner);
-	if (!inode->i_uid && !mode)
+	if (HFSPLUS_SB(sb).uid_provided)
		inode->i_uid = HFSPLUS_SB(sb).uid;

	inode->i_gid = be32_to_cpu(perms->group);
-	if (!inode->i_gid && !mode)
+	if (HFSPLUS_SB(sb).gid_provided)
		inode->i_gid = HFSPLUS_SB(sb).gid;

	if (dir) {
diff -uprN -X linux-2.6.21.5/Documentation/dontdiff linux-2.6.21.5/fs/hfsplus/options.c linux-2.6.21.5-devel/fs/hfsplus/options.c
--- linux-2.6.21.5/fs/hfsplus/options.c	2007-06-11 14:37:06.000000000 -0400
+++ linux-2.6.21.5-devel/fs/hfsplus/options.c	2007-06-16 23:36:30.000000000 -0400
@@ -106,6 +106,7 @@ int hfsplus_parse_options(char *input, s
				return 0;
			}
			sbi->uid = (uid_t)tmp;
+			sbi->uid_provided = 1;
			break;
		case opt_gid:
			if (match_int(&args[0], &tmp)) {
@@ -113,6 +114,7 @@ int hfsplus_parse_options(char *input, s
				return 0;
			}
			sbi->gid = (gid_t)tmp;
+			sbi->gid_provided = 1;
			break;
		case opt_part:
			if (match_int(&args[0], &sbi->part)) {
	
