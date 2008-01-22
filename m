Return-Path: <linux-kernel-owner+w=401wt.eu-S1762920AbYAVDRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762920AbYAVDRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759210AbYAVDHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:07:10 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65238 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757519AbYAVDHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:07:01 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 22/49] ext4: Change the default behaviour on error
Date: Mon, 21 Jan 2008 22:02:01 -0500
Message-Id: <1200970948-17903-23-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-22-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

ext4 file system was by default ignoring errors and continuing. This
is not a good default as continuing on error could lead to file system
corruption. Change the default to mark the file system
readonly. Debian and ubuntu already does this as the default in their
fstab.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32e3ecb..effd375 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -688,16 +688,16 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	    le16_to_cpu(es->s_def_resgid) != EXT4_DEF_RESGID) {
 		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
 	}
-	if (test_opt(sb, ERRORS_CONT)) {
+	if (test_opt(sb, ERRORS_RO)) {
 		int def_errors = le16_to_cpu(es->s_errors);
 
 		if (def_errors == EXT4_ERRORS_PANIC ||
-		    def_errors == EXT4_ERRORS_RO) {
-			seq_puts(seq, ",errors=continue");
+		    def_errors == EXT4_ERRORS_CONTINUE) {
+			seq_puts(seq, ",errors=remount-ro");
 		}
 	}
-	if (test_opt(sb, ERRORS_RO))
-		seq_puts(seq, ",errors=remount-ro");
+	if (test_opt(sb, ERRORS_CONT))
+		seq_puts(seq, ",errors=continue");
 	if (test_opt(sb, ERRORS_PANIC))
 		seq_puts(seq, ",errors=panic");
 	if (test_opt(sb, NO_UID32))
@@ -1819,10 +1819,10 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
-	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_RO)
-		set_opt(sbi->s_mount_opt, ERRORS_RO);
-	else
+	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT4_ERRORS_CONTINUE)
 		set_opt(sbi->s_mount_opt, ERRORS_CONT);
+	else
+		set_opt(sbi->s_mount_opt, ERRORS_RO);
 
 	sbi->s_resuid = le16_to_cpu(es->s_def_resuid);
 	sbi->s_resgid = le16_to_cpu(es->s_def_resgid);
-- 
1.5.4.rc3.31.g1271-dirty

