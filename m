Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZGUDLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZGUDLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZGUDLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:11:16 -0400
Received: from fn.samba.org ([216.83.154.106]:55190 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbZGUDLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:11:15 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 23:11:15 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19045.12300.679794.541907@samba.org>
Date: Tue, 21 Jul 2009 13:03:40 +1000
To: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: torvalds@linux-foundation.org,
       Ogawa Hirofumi <hirofumi@mail.parknet.co.jp>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, john.lanza@linux.com
Subject: [PATCH 2/2] FAT: Add CONFIG_VFAT_FS_NO_DUALNAMES option
In-Reply-To: <19045.11460.815706.98797@samba.org>
References: <19045.11460.815706.98797@samba.org>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second of two patches which attempt to address the
technical concerns raised by the previous round of VFAT patent
workaround patches.

This patch adds a new config option VFAT_FS_NO_DUALNAMES. When
VFAT_FS_NO_DUALNAMES is enabled, VFAT will never create a file with
both a long and a short filename. If a long filename is needed, then
dummy bytes are stored in the 8.3 entry, and the 8.3 entry is marked
as having no short name using the FAT_NO_83NAME flag.

This patch is similar in concept to the previously posted dualnames
patch, but changes the bytes put in the 8.3 directory entry when long
filenames are created. The new values work with Win98, MP3 players and
other devices that have been tested.

This patch depends on the FAT_NO_83NAME flag added in the first patch
in this series.

More details and testing tools are available at
 
   http://kernel.org/pub/linux/kernel/people/tridge/VFAT/

Signed-off-by: Andrew Tridgell <tridge@samba.org>
---
 fs/fat/Kconfig      |   21 +++++++++++++
 fs/fat/namei_vfat.c |   83 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
index 182f9ff..d1c10a1 100644
--- a/fs/fat/Kconfig
+++ b/fs/fat/Kconfig
@@ -74,6 +74,27 @@ config VFAT_FS
 	  To compile this as a module, choose M here: the module will be called
 	  vfat.
 
+config VFAT_FS_NO_DUALNAMES
+	bool "disable VFAT dual names support (patent workaround)"
+	depends on VFAT_FS
+	help
+	  This option disables support for dual filenames on VFAT filesystems.
+	  If this option is enabled then file creation will either put
+	  a short (8.3) name or a long name on the file, but never both.
+	  The field where a shortname would normally go is filled with
+	  invalid characters such that it cannot be considered a valid
+	  short filename.
+
+	  That means that long filenames created with this option
+	  disabled will not be accessible at all to operating systems
+	  that do not understand the FAT long filename extensions.
+
+	  Users considering disabling this option should consider the
+	  implications of any patents that may exist on dual filenames
+	  in VFAT.
+
+	  If unsure, say N
+
 config FAT_DEFAULT_CODEPAGE
 	int "Default codepage for FAT"
 	depends on MSDOS_FS || VFAT_FS
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 73471b7..02d5d64 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -22,6 +22,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
+#include <linux/random.h>
 #include "fat.h"
 
 /*
@@ -316,6 +317,17 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
 	int is_shortname;
 	struct shortname_info base_info, ext_info;
+	unsigned opts_shortname = opts->shortname;
+
+#ifdef CONFIG_VFAT_FS_NO_DUALNAMES
+	/*
+	 * When we do not have dualnames, we want to maximise the
+	 * chance that a file will be able to be represented with just
+	 * a 8.3 entry. We can do that by using the WINNT case
+	 * handling extensions to FAT.
+	 */
+	opts_shortname = VFAT_SFN_CREATE_WINNT;
+#endif
 
 	is_shortname = 1;
 	INIT_SHORTNAME_INFO(&base_info);
@@ -428,9 +440,9 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
 		if (vfat_find_form(dir, name_res) == 0)
 			return -EEXIST;
 
-		if (opts->shortname & VFAT_SFN_CREATE_WIN95) {
+		if (opts_shortname & VFAT_SFN_CREATE_WIN95) {
 			return (base_info.upper && ext_info.upper);
-		} else if (opts->shortname & VFAT_SFN_CREATE_WINNT) {
+		} else if (opts_shortname & VFAT_SFN_CREATE_WINNT) {
 			if ((base_info.upper || base_info.lower) &&
 			    (ext_info.upper || ext_info.lower)) {
 				if (!base_info.upper && base_info.lower)
@@ -586,6 +598,66 @@ xlate_to_uni(const unsigned char *name, int len, unsigned char *outname,
 	return 0;
 }
 
+#ifdef CONFIG_VFAT_FS_NO_DUALNAMES
+/*
+ * This function creates a dummy 8.3 entry which is as compatible as
+ * possible with existing FAT devices, while not being a valid
+ * filename under windows or Linux
+ */
+static void vfat_build_dummy_83_buffer(struct inode *dir, char *msdos_name,
+				       int is_dir)
+{
+	/*
+	 * These characters are all invalid in 8.3 names, plus have
+	 * been shown to be harmless on all tested devices
+	 */
+	const char invalidchar[] = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x0B,
+				     0x0C, 0x0E, 0x0F, 0x10, 0x11, 0x12, 0x13,
+				     0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A,
+				     0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x22, 0x2a,
+				     0x3a, 0x3c, 0x3e, 0x3f, 0x5b, 0x5d, 0x7c };
+	int i, tilde_pos, slash_pos;
+	u32 rand_num = random32();
+
+	/* We need a '~' in the prefix to make Win98 happy. */
+	tilde_pos = rand_num % 8;
+	rand_num >>= 3;
+
+	/*
+	 * the '/' makes sure that even unpatched Linux systems can't
+	 * get at files by the 8.3 entry. Don't put in a / in
+	 * directories as it can cause problems with some
+	 * photo frames
+	 */
+	if (is_dir)
+		slash_pos = -1;
+	else {
+		slash_pos = (tilde_pos + 1 + rand_num % 7) % 8;
+		rand_num >>= 3;
+	}
+
+	/*
+	 * fill in the first 8 bytes with invalid characters. Note
+	 * that we need to be careful not to run out of randomness. We
+	 * leave the 3 byte extension in place as some cheap MP3
+	 * players need them.
+	 */
+	for (i = 0; i < 8; i++) {
+		if (i == tilde_pos)
+			msdos_name[i] = '~';
+		else if (i == slash_pos)
+			msdos_name[i] = '/';
+		else {
+			msdos_name[i] =
+				invalidchar[rand_num % sizeof(invalidchar)];
+			rand_num /= sizeof(invalidchar);
+			if (rand_num < sizeof(invalidchar))
+				rand_num = random32();
+		}
+	}
+}
+#endif
+
 static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 			    int len, int is_dir, int cluster,
 			    struct timespec *ts,
@@ -628,6 +700,13 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 		goto shortname;
 	}
 
+#ifdef CONFIG_VFAT_FS_NO_DUALNAMES
+	printk_once(KERN_INFO
+		    "VFAT: not creating 8.3 short filenames for long names\n");
+	vfat_build_dummy_83_buffer(dir, msdos_name, is_dir);
+	lcase = FAT_NO_83NAME;
+#endif
+
 	/* build the entry of long file name */
 	cksum = fat_checksum(msdos_name);
 
-- 
1.6.0.4

