Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYKKMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYKKMHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYKKMHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:07:08 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:61194 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbYKKMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:07:06 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhAFABMEGUlR9dQn/2dsb2JhbACBdss6g1c
Date: Tue, 11 Nov 2008 13:07:04 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] drivers/char/nvram.c
Message-ID: <20081111120704.GK2690@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8587b33f4adee4e7614ea7f443346c3b6bb5427a
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Nov 11 09:56:00 2008 +0000

    [PATCH] nvram - convert PRINT_PROC to seq_file
    
    Convert the /proc/drivers/nvram file from the old PRINT_PROC macro
    to the new seq_file filesystem.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 1a04f3d..88cee40 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -32,9 +32,10 @@
  * 		added changelog
  * 	1.2	Erik Gilling: Cobalt Networks support
  * 		Tim Hockin: general cleanup, Cobalt support
+ * 	1.3	Wim Van Sebroeck: convert PRINT_PROC to seq_file
  */
 
-#define NVRAM_VERSION	"1.2"
+#define NVRAM_VERSION	"1.3"
 
 #include <linux/module.h>
 #include <linux/smp_lock.h>
@@ -106,6 +107,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
@@ -122,8 +124,8 @@ static int mach_check_checksum(void);
 static void mach_set_checksum(void);
 
 #ifdef CONFIG_PROC_FS
-static int mach_proc_infos(unsigned char *contents, char *buffer, int *len,
-					off_t *begin, off_t offset, int size);
+static void mach_proc_infos(unsigned char *contents, struct seq_file *seq,
+								void *offset);
 #endif
 
 /*
@@ -370,46 +372,47 @@ static int nvram_release(struct inode *inode, struct file *file)
 }
 
 #ifndef CONFIG_PROC_FS
-static int nvram_read_proc(char *buffer, char **start, off_t offset,
-						int size, int *eof, void *data)
+static int nvram_add_proc_fs(void)
 {
 	return 0;
 }
+
 #else
 
-static int nvram_read_proc(char *buffer, char **start, off_t offset,
-						int size, int *eof, void *data)
+static int nvram_proc_read(struct seq_file *seq, void *offset)
 {
 	unsigned char contents[NVRAM_BYTES];
-	int i, len = 0;
-	off_t begin = 0;
+	int i = 0;
 
 	spin_lock_irq(&rtc_lock);
 	for (i = 0; i < NVRAM_BYTES; ++i)
 		contents[i] = __nvram_read_byte(i);
 	spin_unlock_irq(&rtc_lock);
 
-	*eof = mach_proc_infos(contents, buffer, &len, &begin, offset, size);
+	mach_proc_infos(contents, seq, offset);
 
-	if (offset >= begin + len)
-		return 0;
-	*start = buffer + (offset - begin);
-	return (size < begin + len - offset) ? size : begin + len - offset;
+	return 0;
+}
 
+static int nvram_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nvram_proc_read, NULL);
 }
 
-/* This macro frees the machine specific function from bounds checking and
- * this like that... */
-#define PRINT_PROC(fmt,args...)					\
-	do {							\
-		*len += sprintf(buffer + *len, fmt, ##args);	\
-		if (*begin + *len > offset + size)		\
-			return 0;				\
-		if (*begin + *len < offset) {			\
-			*begin += *len;				\
-			*len = 0;				\
-		}						\
-	} while (0)
+static const struct file_operations nvram_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nvram_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int nvram_add_proc_fs(void)
+{
+	if (!proc_create("driver/nvram", 0, NULL, &nvram_proc_fops))
+		return -ENOMEM;
+	return 0;
+}
 
 #endif /* CONFIG_PROC_FS */
 
@@ -443,10 +446,9 @@ static int __init nvram_init(void)
 		    NVRAM_MINOR);
 		goto out;
 	}
-	if (!create_proc_read_entry("driver/nvram", 0, NULL, nvram_read_proc,
-		NULL)) {
+	ret = nvram_add_proc_fs();
+	if (ret) {
 		printk(KERN_ERR "nvram: can't create /proc/driver/nvram\n");
-		ret = -ENOMEM;
 		goto outmisc;
 	}
 	ret = 0;
@@ -511,8 +513,8 @@ static char *gfx_types[] = {
 	"monochrome",
 };
 
-static int pc_proc_infos(unsigned char *nvram, char *buffer, int *len,
-					off_t *begin, off_t offset, int size)
+static void pc_proc_infos(unsigned char *nvram, struct seq_file *seq,
+								void *offset)
 {
 	int checksum;
 	int type;
@@ -521,56 +523,57 @@ static int pc_proc_infos(unsigned char *nvram, char *buffer, int *len,
 	checksum = __nvram_check_checksum();
 	spin_unlock_irq(&rtc_lock);
 
-	PRINT_PROC("Checksum status: %svalid\n", checksum ? "" : "not ");
+	seq_printf(seq, "Checksum status: %svalid\n", checksum ? "" : "not ");
 
-	PRINT_PROC("# floppies     : %d\n",
+	seq_printf(seq, "# floppies     : %d\n",
 	    (nvram[6] & 1) ? (nvram[6] >> 6) + 1 : 0);
-	PRINT_PROC("Floppy 0 type  : ");
+	seq_printf(seq, "Floppy 0 type  : ");
 	type = nvram[2] >> 4;
 	if (type < ARRAY_SIZE(floppy_types))
-		PRINT_PROC("%s\n", floppy_types[type]);
+		seq_printf(seq, "%s\n", floppy_types[type]);
 	else
-		PRINT_PROC("%d (unknown)\n", type);
-	PRINT_PROC("Floppy 1 type  : ");
+		seq_printf(seq, "%d (unknown)\n", type);
+	seq_printf(seq, "Floppy 1 type  : ");
 	type = nvram[2] & 0x0f;
 	if (type < ARRAY_SIZE(floppy_types))
-		PRINT_PROC("%s\n", floppy_types[type]);
+		seq_printf(seq, "%s\n", floppy_types[type]);
 	else
-		PRINT_PROC("%d (unknown)\n", type);
+		seq_printf(seq, "%d (unknown)\n", type);
 
-	PRINT_PROC("HD 0 type      : ");
+	seq_printf(seq, "HD 0 type      : ");
 	type = nvram[4] >> 4;
 	if (type)
-		PRINT_PROC("%02x\n", type == 0x0f ? nvram[11] : type);
+		seq_printf(seq, "%02x\n", type == 0x0f ? nvram[11] : type);
 	else
-		PRINT_PROC("none\n");
+		seq_printf(seq, "none\n");
 
-	PRINT_PROC("HD 1 type      : ");
+	seq_printf(seq, "HD 1 type      : ");
 	type = nvram[4] & 0x0f;
 	if (type)
-		PRINT_PROC("%02x\n", type == 0x0f ? nvram[12] : type);
+		seq_printf(seq, "%02x\n", type == 0x0f ? nvram[12] : type);
 	else
-		PRINT_PROC("none\n");
+		seq_printf(seq, "none\n");
 
-	PRINT_PROC("HD type 48 data: %d/%d/%d C/H/S, precomp %d, lz %d\n",
+	seq_printf(seq, "HD type 48 data: %d/%d/%d C/H/S, precomp %d, lz %d\n",
 	    nvram[18] | (nvram[19] << 8),
 	    nvram[20], nvram[25],
 	    nvram[21] | (nvram[22] << 8), nvram[23] | (nvram[24] << 8));
-	PRINT_PROC("HD type 49 data: %d/%d/%d C/H/S, precomp %d, lz %d\n",
+	seq_printf(seq, "HD type 49 data: %d/%d/%d C/H/S, precomp %d, lz %d\n",
 	    nvram[39] | (nvram[40] << 8),
 	    nvram[41], nvram[46],
 	    nvram[42] | (nvram[43] << 8), nvram[44] | (nvram[45] << 8));
 
-	PRINT_PROC("DOS base memory: %d kB\n", nvram[7] | (nvram[8] << 8));
-	PRINT_PROC("Extended memory: %d kB (configured), %d kB (tested)\n",
+	seq_printf(seq, "DOS base memory: %d kB\n", nvram[7] | (nvram[8] << 8));
+	seq_printf(seq, "Extended memory: %d kB (configured), %d kB (tested)\n",
 	    nvram[9] | (nvram[10] << 8), nvram[34] | (nvram[35] << 8));
 
-	PRINT_PROC("Gfx adapter    : %s\n", gfx_types[(nvram[6] >> 4) & 3]);
+	seq_printf(seq, "Gfx adapter    : %s\n",
+	    gfx_types[(nvram[6] >> 4) & 3]);
 
-	PRINT_PROC("FPU            : %sinstalled\n",
+	seq_printf(seq, "FPU            : %sinstalled\n",
 	    (nvram[6] & 2) ? "" : "not ");
 
-	return 1;
+	return;
 }
 #endif
 
@@ -640,70 +643,71 @@ static char *colors[] = {
 	"2", "4", "16", "256", "65536", "??", "??", "??"
 };
 
-static int atari_proc_infos(unsigned char *nvram, char *buffer, int *len,
-					off_t *begin, off_t offset, int size)
+static void atari_proc_infos(unsigned char *nvram, struct seq_file *seq,
+								void *offset)
 {
 	int checksum = nvram_check_checksum();
 	int i;
 	unsigned vmode;
 
-	PRINT_PROC("Checksum status  : %svalid\n", checksum ? "" : "not ");
+	seq_printf(seq, "Checksum status  : %svalid\n", checksum ? "" : "not ");
 
-	PRINT_PROC("Boot preference  : ");
+	seq_printf(seq, "Boot preference  : ");
 	for (i = ARRAY_SIZE(boot_prefs) - 1; i >= 0; --i) {
 		if (nvram[1] == boot_prefs[i].val) {
-			PRINT_PROC("%s\n", boot_prefs[i].name);
+			seq_printf(seq, "%s\n", boot_prefs[i].name);
 			break;
 		}
 	}
 	if (i < 0)
-		PRINT_PROC("0x%02x (undefined)\n", nvram[1]);
+		seq_printf(seq, "0x%02x (undefined)\n", nvram[1]);
 
-	PRINT_PROC("SCSI arbitration : %s\n",
+	seq_printf(seq, "SCSI arbitration : %s\n",
 	    (nvram[16] & 0x80) ? "on" : "off");
-	PRINT_PROC("SCSI host ID     : ");
+	seq_printf(seq, "SCSI host ID     : ");
 	if (nvram[16] & 0x80)
-		PRINT_PROC("%d\n", nvram[16] & 7);
+		seq_printf(seq, "%d\n", nvram[16] & 7);
 	else
-		PRINT_PROC("n/a\n");
+		seq_printf(seq, "n/a\n");
 
 	/* the following entries are defined only for the Falcon */
 	if ((atari_mch_cookie >> 16) != ATARI_MCH_FALCON)
-		return 1;
+		return;
 
-	PRINT_PROC("OS language      : ");
+	seq_printf(seq, "OS language      : ");
 	if (nvram[6] < ARRAY_SIZE(languages))
-		PRINT_PROC("%s\n", languages[nvram[6]]);
+		seq_printf(seq, "%s\n", languages[nvram[6]]);
 	else
-		PRINT_PROC("%u (undefined)\n", nvram[6]);
-	PRINT_PROC("Keyboard language: ");
+		seq_printf(seq, "%u (undefined)\n", nvram[6]);
+	seq_printf(seq, "Keyboard language: ");
 	if (nvram[7] < ARRAY_SIZE(languages))
-		PRINT_PROC("%s\n", languages[nvram[7]]);
+		seq_printf(seq, "%s\n", languages[nvram[7]]);
 	else
-		PRINT_PROC("%u (undefined)\n", nvram[7]);
-	PRINT_PROC("Date format      : ");
-	PRINT_PROC(dateformat[nvram[8] & 7],
+		seq_printf(seq, "%u (undefined)\n", nvram[7]);
+	seq_printf(seq, "Date format      : ");
+	seq_printf(seq, dateformat[nvram[8] & 7],
 	    nvram[9] ? nvram[9] : '/', nvram[9] ? nvram[9] : '/');
-	PRINT_PROC(", %dh clock\n", nvram[8] & 16 ? 24 : 12);
-	PRINT_PROC("Boot delay       : ");
+	seq_printf(seq, ", %dh clock\n", nvram[8] & 16 ? 24 : 12);
+	seq_printf(seq, "Boot delay       : ");
 	if (nvram[10] == 0)
-		PRINT_PROC("default");
+		seq_printf(seq, "default");
 	else
-		PRINT_PROC("%ds%s\n", nvram[10],
+		seq_printf(seq, "%ds%s\n", nvram[10],
 		    nvram[10] < 8 ? ", no memory test" : "");
 
 	vmode = (nvram[14] << 8) || nvram[15];
-	PRINT_PROC("Video mode       : %s colors, %d columns, %s %s monitor\n",
+	seq_printf(seq,
+	    "Video mode       : %s colors, %d columns, %s %s monitor\n",
 	    colors[vmode & 7],
 	    vmode & 8 ? 80 : 40,
 	    vmode & 16 ? "VGA" : "TV", vmode & 32 ? "PAL" : "NTSC");
-	PRINT_PROC("                   %soverscan, compat. mode %s%s\n",
+	seq_printf(seq, "                   %soverscan, compat. mode %s%s\n",
 	    vmode & 64 ? "" : "no ",
 	    vmode & 128 ? "on" : "off",
 	    vmode & 256 ?
 	    (vmode & 16 ? ", line doubling" : ", half screen") : "");
 
-	return 1;
+	return;
 }
 #endif
 
