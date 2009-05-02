Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZEBLml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZEBLml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZEBLmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:42:31 -0400
Received: from mail.samba.org ([66.70.73.150]:59759 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbZEBLma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:42:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18940.12667.429391.927727@samba.org>
Date: Sat, 2 May 2009 21:41:47 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
In-Reply-To: <87ocub7ngh.fsf@devron.myhome.or.jp>
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
	<87ab5v9381.fsf@devron.myhome.or.jp>
	<18940.10942.989329.993465@samba.org>
	<87ocub7ngh.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hirofumi-san,

 > Yes. I guess -ENAMETOOLONG would not good for !valid, and !(is_shortname
 > && base_info.valid && ext_info.valid) or add "else" part is more prefer
 > though.

ok, new patch below. 

 > Yes. The case-insensitive is ok, the dcache can handle case-insensitive.

good, that makes life simpler :-)

Are you happy with the shortname_flags hackery in
vfat_create_shortname() ?

Cheers, Tridge


Signed-off-by: Andrew Tridgell <tridge@samba.org>
diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
index 182f9ff..66623d0 100644
--- a/fs/fat/Kconfig
+++ b/fs/fat/Kconfig
@@ -98,3 +98,14 @@ config FAT_DEFAULT_IOCHARSET
 
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
+	  be permitted.  Reading files with long file names is still permitted.
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a0e00e3..4169ec7 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -316,6 +316,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
 	int is_shortname;
 	struct shortname_info base_info, ext_info;
+	unsigned shortname_flags = opts->shortname;
 
 	is_shortname = 1;
 	INIT_SHORTNAME_INFO(&base_info);
@@ -424,13 +425,22 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	memcpy(name_res, base, baselen);
 	memcpy(name_res + 8, ext, extlen);
 	*lcase = 0;
+
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	if (is_shortname == 0)
+		return -ENAMETOOLONG;
+	if (!base_info.valid || !ext_info.valid)
+		return -EINVAL;
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
@@ -628,6 +638,9 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 		goto shortname;
 	}
 
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	de = (struct msdos_dir_entry *)slots;
+#else
 	/* build the entry of long file name */
 	cksum = fat_checksum(msdos_name);
 
@@ -645,6 +658,7 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 	}
 	slots[0].id |= 0x40;
 	de = (struct msdos_dir_entry *)ps;
+#endif
 
 shortname:
 	/* build the entry of 8.3 alias name */
