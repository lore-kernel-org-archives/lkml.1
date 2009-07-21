Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZGUDLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZGUDLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZGUDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:11:18 -0400
Received: from fn.samba.org ([216.83.154.106]:55193 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754592AbZGUDLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:11:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19045.11460.815706.98797@samba.org>
Date: Tue, 21 Jul 2009 12:49:40 +1000
To: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: torvalds@linux-foundation.org,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, john.lanza@linux.com
Subject: [PATCH 1/2] FAT: Add FAT_NO_83NAME flag
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first of two patches which attempt to address the
technical concerns raised by the previous round of VFAT patent
workaround patches.

This patch adds a new flag field 'FAT_NO_83NAME' for FAT files. When
this flag is set on an 8.3 FAT entry, both the MSDOS and VFAT
filesystems will skip the entry. For MSDOS this makes the file
inaccessible. For VFAT it makes the file only accessible by the long
filename.

The justification for this patch is to provide a clean way to
distinguish files created on VFAT filesystems with long filenames but
without a 8.3 short name. It uses a unused bit in the FAT directory
entry to store the FAT_NO_83NAME flag.

This patch, combined with the following VFAT_FS_NO_DUALNAMES patch,
address the following technical issues found with the last series of
patches:

  - Fixed problems with Win98, although some cosmetic issues remain
  - Fixed problems with all tested MP3 players and similar devices
  - Lowers the probability of a WinXP bluescreen by a factor of about 80x
  - Fixed problems with mtools, although some cosmetic issues remain
    that require a small mtools patch to fix

More details and testing tools are available at

  http://kernel.org/pub/linux/kernel/people/tridge/VFAT/

Signed-off-by: Andrew Tridgell <tridge@samba.org>
---
 fs/fat/dir.c             |   14 ++++++++++++++
 include/linux/msdos_fs.h |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 38ff75a..902e84c 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -385,6 +385,13 @@ parse_record:
 				goto end_of_dir;
 		}
 
+		/*
+		 * The FAT_NO_83NAME flag is used to mark files
+		 * created with no 8.3 short name
+		 */
+		if (de->lcase & FAT_NO_83NAME)
+			goto compare_longname;
+
 		memcpy(work, de->name, sizeof(de->name));
 		/* see namei.c, msdos_format_name */
 		if (work[0] == 0x05)
@@ -429,6 +436,7 @@ parse_record:
 		if (fat_name_match(sbi, name, name_len, bufname, len))
 			goto found;
 
+compare_longname:
 		if (nr_slots) {
 			void *longname = unicode + FAT_MAX_UNI_CHARS;
 			int size = PATH_MAX - FAT_MAX_UNI_SIZE;
@@ -530,6 +538,8 @@ parse_record:
 		if (de->attr != ATTR_EXT && IS_FREE(de->name))
 			goto record_end;
 	} else {
+		if (de->lcase & FAT_NO_83NAME)
+			goto record_end;
 		if ((de->attr & ATTR_VOLUME) || IS_FREE(de->name))
 			goto record_end;
 	}
@@ -935,6 +945,10 @@ int fat_scan(struct inode *dir, const unsigned char *name,
 	sinfo->bh = NULL;
 	while (fat_get_short_entry(dir, &sinfo->slot_off, &sinfo->bh,
 				   &sinfo->de) >= 0) {
+		/* skip files marked as having no 8.3 short name  */
+		if (sinfo->de->lcase & FAT_NO_83NAME)
+			continue;
+
 		if (!strncmp(sinfo->de->name, name, MSDOS_NAME)) {
 			sinfo->slot_off -= sizeof(*sinfo->de);
 			sinfo->nr_slots = 1;
diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index ce38f1c..639e6a4 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -43,6 +43,7 @@
 
 #define CASE_LOWER_BASE	8	/* base is lower case */
 #define CASE_LOWER_EXT	16	/* extension is lower case */
+#define FAT_NO_83NAME	32	/* no 8.3 short filename for this file */
 
 #define DELETED_FLAG	0xe5	/* marks file as deleted when in name[0] */
 #define IS_FREE(n)	(!*(n) || *(n) == DELETED_FLAG)
-- 
1.6.0.4

