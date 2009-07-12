Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZGLTkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZGLTkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 15:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZGLTjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 15:39:52 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:47881 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZGLTjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 15:39:51 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, tridge@samba.org,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<873a96a23x.fsf@devron.myhome.or.jp>
Date: Mon, 13 Jul 2009 04:39:40 +0900
In-Reply-To: <873a96a23x.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Thu, 09 Jul 2009 13:53:38 +0900")
Message-ID: <87hbxhwv0j.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>
>> Sure and I'd say the technical issues are simple
>>
>> - Tridge's patch breaks stuff
>> - Tridge's patch masquerades as vfat but isn't.
>>
>> We can fix those by only creating short names (but honouring existing
>> long ones) and by not claiming its vfat.
>
> As technical stand, I agree with this approach. And my poor brain can't
> consider other than technical thing, it is purely my problem though. So
> I'll try to create the patch based on first version, and I'll apply it
> instead.
>
> And could you please stop talking about other than technical issues? My
> poor brain is already overflowed.
>
> I'm a fool?  Yes, I agree.

My patch is following. Sorry. But I'm still worrying about this myself.

It seems my skill and knowledge for the issue are too small.  My time
for fat was already small before this, and honestly, I don't think I can
maintain/support all issues well.

So, finally, I thought the best for us which I can is to find new
maintainer for fat.

Could you help to find the new maintainer?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



From: tridge@samba.org

When this option is enabled this will refuse to create new files with
long names. Accessing existing files with long names will continue to
work.

File names to be created must conform to the 8.3 format.  Mixed case is
not allowed in either the prefix or the suffix.

Signed-off-by: Andrew Tridgell <tridge@samba.org>
[Add "lfat", comment out Kconfig]
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/Kconfig      |   11 +++++++++++
 fs/fat/namei_vfat.c |   35 ++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 5 deletions(-)

diff -puN fs/fat/Kconfig~fat-disable-longname fs/fat/Kconfig
--- fatfs-2.6-2/fs/fat/Kconfig~fat-disable-longname	2009-07-10 16:16:47.000000000 +0900
+++ fatfs-2.6-2-hirofumi/fs/fat/Kconfig	2009-07-12 12:50:52.000000000 +0900
@@ -98,3 +98,14 @@ config FAT_DEFAULT_IOCHARSET
 
 	  Enable any character sets you need in File Systems/Native Language
 	  Support.
+
+#config VFAT_NO_CREATE_WITH_LONGNAMES
+#	bool "Disable creating files with long names"
+#	depends on VFAT_FS
+#	default n
+#	help
+#	  Set this to disable support for creating files or directories with
+#	  names longer than 8.3 (the original DOS maximum file name length)
+#	  e.g. naming a file FILE1234.TXT would be allowed but creating or
+#	  renaming a file to FILE12345.TXT or FILE1234.TEXT would not
+#	  be permitted.  Reading files with long file names is still permitted.
diff -puN fs/fat/namei_vfat.c~fat-disable-longname fs/fat/namei_vfat.c
--- fatfs-2.6-2/fs/fat/namei_vfat.c~fat-disable-longname	2009-07-10 16:16:47.000000000 +0900
+++ fatfs-2.6-2-hirofumi/fs/fat/namei_vfat.c	2009-07-11 16:26:24.000000000 +0900
@@ -316,6 +316,7 @@ static int vfat_create_shortname(struct 
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
 	int is_shortname;
 	struct shortname_info base_info, ext_info;
+	unsigned opt_shortname = opts->shortname;
 
 	is_shortname = 1;
 	INIT_SHORTNAME_INFO(&base_info);
@@ -424,13 +425,22 @@ static int vfat_create_shortname(struct 
 	memcpy(name_res, base, baselen);
 	memcpy(name_res + 8, ext, extlen);
 	*lcase = 0;
+
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	if (is_shortname == 0)
+		return -ENAMETOOLONG;
+	if (!base_info.valid || !ext_info.valid)
+		return -EINVAL;
+	opt_shortname = VFAT_SFN_CREATE_WINNT;
+#endif
+
 	if (is_shortname && base_info.valid && ext_info.valid) {
 		if (vfat_find_form(dir, name_res) == 0)
 			return -EEXIST;
 
-		if (opts->shortname & VFAT_SFN_CREATE_WIN95) {
+		if (opt_shortname & VFAT_SFN_CREATE_WIN95) {
 			return (base_info.upper && ext_info.upper);
-		} else if (opts->shortname & VFAT_SFN_CREATE_WINNT) {
+		} else if (opt_shortname & VFAT_SFN_CREATE_WINNT) {
 			if ((base_info.upper || base_info.lower) &&
 			    (ext_info.upper || ext_info.lower)) {
 				if (!base_info.upper && base_info.lower)
@@ -593,15 +603,19 @@ static int vfat_build_slots(struct inode
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
+	int i;
+	struct msdos_dir_slot *ps;
+	unsigned char cksum;
 	loff_t offset;
+#endif
 
 	*nr_slots = 0;
 
@@ -628,6 +642,9 @@ static int vfat_build_slots(struct inode
 		goto shortname;
 	}
 
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	de = (struct msdos_dir_entry *)slots;
+#else
 	/* build the entry of long file name */
 	cksum = fat_checksum(msdos_name);
 
@@ -645,6 +662,7 @@ static int vfat_build_slots(struct inode
 	}
 	slots[0].id |= 0x40;
 	de = (struct msdos_dir_entry *)ps;
+#endif
 
 shortname:
 	/* build the entry of 8.3 alias name */
@@ -1074,7 +1092,11 @@ static int vfat_get_sb(struct file_syste
 
 static struct file_system_type vfat_fs_type = {
 	.owner		= THIS_MODULE,
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+	.name		= "lfat",
+#else
 	.name		= "vfat",
+#endif
 	.get_sb		= vfat_get_sb,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
@@ -1093,6 +1115,9 @@ static void __exit exit_vfat_fs(void)
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VFAT filesystem support");
 MODULE_AUTHOR("Gordon Chaffee");
+#ifdef CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES
+MODULE_ALIAS("lfat");
+#endif
 
 module_init(init_vfat_fs)
 module_exit(exit_vfat_fs)
_
