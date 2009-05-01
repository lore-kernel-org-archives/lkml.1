Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbZEARlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbZEARlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbZEARle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:41:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46975 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbZEARld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:41:33 -0400
Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Tridgell <tridge@samba.org>, Steve French <sfrench@us.ibm.com>,
       Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 May 2009 12:41:29 -0500
Message-Id: <1241199689.13073.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Tridgell <tridge@samba.org>
Subject: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option

When this option is enabled the VFAT filesystem will refuse to create
new files with long names. Accessing existing files with long names
will continue to work.

File names to be created must conform to the 8.3 format.  Mixed case is
not allowed in either the prefix or the suffix.

Signed-off-by: Andrew Tridgell <tridge@samba.org>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Acked-by: Steve French <sfrench@us.ibm.com>
Cc: Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Mingming Cao <cmm@us.ibm.com>
---
 fs/fat/Kconfig      |   18 ++++++++++++++++++
 fs/fat/namei_vfat.c |   26 +++++++++++++++++++++-----
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
index 182f9ff..1439681 100644
--- a/fs/fat/Kconfig
+++ b/fs/fat/Kconfig
@@ -98,3 +98,21 @@ config FAT_DEFAULT_IOCHARSET
 
 	  Enable any character sets you need in File Systems/Native Language
 	  Support.
+
+config VFAT_NO_CREATE_WITH_LONGNAMES
+	bool "Disable creating files with long names"
+	depends on VFAT_FS
+	default n
+	help
+	  Set this to disable support for creating files or directories with
+	  names longer than 8.3 (the original DOS maximum file name length)
+	  e.g. naming a file FILE1234.TXT would be allowed but creating or
+	  renaming a file to FILE12345.TXT or FILE1234.TEXT would not
+	  be permitted.
+
+	  Case on files is only preserved if all of the prefix is the same
+	  case and all of the extension is the same case. So the names
+	  "FILE.txt", "file.TXT" would be case preserved, but if you create a
+	  file called "File.TxT" then it will be stored on disk as "FILE.TXT".
+
+	  Reading files with long file names is still permitted.
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a0e00e3..cf0400e 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -316,6 +316,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
 	int is_shortname;
 	struct shortname_info base_info, ext_info;
+	unsigned shortname_flags = opts->shortname;
 
 	is_shortname = 1;
 	INIT_SHORTNAME_INFO(&base_info);
@@ -424,13 +425,20 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	memcpy(name_res, base, baselen);
 	memcpy(name_res + 8, ext, extlen);
 	*lcase = 0;
+
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	if (is_shortname == 0)
+		return -ENAMETOOLONG;
+	shortname_flags = VFAT_SFN_CREATE_WINNT;
+#endif
+
 	if (is_shortname && base_info.valid && ext_info.valid) {
 		if (vfat_find_form(dir, name_res) == 0)
 			return -EEXIST;
 
-		if (opts->shortname & VFAT_SFN_CREATE_WIN95) {
+		if (shortname_flags & VFAT_SFN_CREATE_WIN95) {
 			return (base_info.upper && ext_info.upper);
-		} else if (opts->shortname & VFAT_SFN_CREATE_WINNT) {
+		} else if (shortname_flags & VFAT_SFN_CREATE_WINNT) {
 			if ((base_info.upper || base_info.lower) &&
 			    (ext_info.upper || ext_info.lower)) {
 				if (!base_info.upper && base_info.lower)
@@ -593,15 +601,19 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dir->i_sb);
 	struct fat_mount_options *opts = &sbi->options;
-	struct msdos_dir_slot *ps;
 	struct msdos_dir_entry *de;
-	unsigned char cksum, lcase;
+	unsigned char lcase;
 	unsigned char msdos_name[MSDOS_NAME];
 	wchar_t *uname;
 	__le16 time, date;
 	u8 time_cs;
-	int err, ulen, usize, i;
+	int err, ulen, usize;
+#ifndef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	unsigned char cksum;
+	int i;
 	loff_t offset;
+	struct msdos_dir_slot *ps;
+#endif
 
 	*nr_slots = 0;
 
@@ -628,6 +640,9 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 		goto shortname;
 	}
 
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	de = (struct msdos_dir_entry *)slots;
+#else
 	/* build the entry of long file name */
 	cksum = fat_checksum(msdos_name);
 
@@ -645,6 +660,7 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 	}
 	slots[0].id |= 0x40;
 	de = (struct msdos_dir_entry *)ps;
+#endif
 
 shortname:
 	/* build the entry of 8.3 alias name */

-- 
David Kleikamp
IBM Linux Technology Center

