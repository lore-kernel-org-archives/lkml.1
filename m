Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZIAWp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZIAWp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbZIAWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:45:27 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38123 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbZIAWp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=j0axum4Gus4wXheZt0uCCQwb/9F330wft4dDudfAlp+FQW/TLXhjyRJBp9DNk4G2VK
         qGD2hEd7EHRIZk9M0Q9knMX8lY2hDpBh4KxdDS+hOfliphlnqAgG8KoJ3LQlASbtJeyq
         IVRCXtKmXXqTVD7xj2kMnIG8GvqWMsOcfohXo=
Date: Wed, 2 Sep 2009 02:45:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] viafb: switch to seq_file
Message-ID: <20090901224525.GA3404@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/video/via/viafbdev.c |  179 ++++++++++++++++++++++++++-----------------
 1 file changed, 110 insertions(+), 69 deletions(-)

--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/seq_file.h>
 #define _MASTER_FILE
 
 #include "global.h"
@@ -1754,10 +1755,8 @@ static void parse_dvi_port(void)
  * DVP1Driving, DFPHigh, DFPLow CR96,   SR2A[5], SR1B[1], SR2A[4], SR1E[2],
  * CR9B,    SR65,    CR97,    CR99
  */
-static int viafb_dvp0_proc_read(char *buf, char **start, off_t offset,
-int count, int *eof, void *data)
+static int viafb_dvp0_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dvp0_data_dri = 0, dvp0_clk_dri = 0, dvp0 = 0;
 	dvp0_data_dri =
 	    (viafb_read_reg(VIASR, SR2A) & BIT5) >> 4 |
@@ -1766,13 +1765,17 @@ int count, int *eof, void *data)
 	    (viafb_read_reg(VIASR, SR2A) & BIT4) >> 3 |
 	    (viafb_read_reg(VIASR, SR1E) & BIT2) >> 2;
 	dvp0 = viafb_read_reg(VIACR, CR96) & 0x0f;
-	len +=
-	    sprintf(buf + len, "%x %x %x\n", dvp0, dvp0_data_dri, dvp0_clk_dri);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x %x %x\n", dvp0, dvp0_data_dri, dvp0_clk_dri);
+	return 0;
+}
+
+static int viafb_dvp0_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dvp0_proc_show, NULL);
 }
-static int viafb_dvp0_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static ssize_t viafb_dvp0_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1816,21 +1819,33 @@ static int viafb_dvp0_proc_write(struct file *file,
 	}
 	return count;
 }
-static int viafb_dvp1_proc_read(char *buf, char **start, off_t offset,
-	int count, int *eof, void *data)
+
+static const struct file_operations viafb_dvp0_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dvp0_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dvp0_proc_write,
+};
+
+static int viafb_dvp1_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dvp1 = 0, dvp1_data_dri = 0, dvp1_clk_dri = 0;
 	dvp1 = viafb_read_reg(VIACR, CR9B) & 0x0f;
 	dvp1_data_dri = (viafb_read_reg(VIASR, SR65) & 0x0c) >> 2;
 	dvp1_clk_dri = viafb_read_reg(VIASR, SR65) & 0x03;
-	len +=
-	    sprintf(buf + len, "%x %x %x\n", dvp1, dvp1_data_dri, dvp1_clk_dri);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x %x %x\n", dvp1, dvp1_data_dri, dvp1_clk_dri);
+	return 0;
+}
+
+static int viafb_dvp1_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dvp1_proc_show, NULL);
 }
-static int viafb_dvp1_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static ssize_t viafb_dvp1_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1869,18 +1884,30 @@ static int viafb_dvp1_proc_write(struct file *file,
 	return count;
 }
 
-static int viafb_dfph_proc_read(char *buf, char **start, off_t offset,
-	int count, int *eof, void *data)
+static const struct file_operations viafb_dvp1_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dvp1_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dvp1_proc_write,
+};
+
+static int viafb_dfph_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dfp_high = 0;
 	dfp_high = viafb_read_reg(VIACR, CR97) & 0x0f;
-	len += sprintf(buf + len, "%x\n", dfp_high);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x\n", dfp_high);
+	return 0;
 }
-static int viafb_dfph_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static int viafb_dfph_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dfph_proc_show, NULL);
+}
+
+static ssize_t viafb_dfph_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20];
 	u8 reg_val = 0;
@@ -1895,18 +1922,31 @@ static int viafb_dfph_proc_write(struct file *file,
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
-static int viafb_dfpl_proc_read(char *buf, char **start, off_t offset,
-	int count, int *eof, void *data)
+
+static const struct file_operations viafb_dfph_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dfph_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dfph_proc_write,
+};
+
+static int viafb_dfpl_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 dfp_low = 0;
 	dfp_low = viafb_read_reg(VIACR, CR99) & 0x0f;
-	len += sprintf(buf + len, "%x\n", dfp_low);
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	seq_printf(m, "%x\n", dfp_low);
+	return 0;
+}
+
+static int viafb_dfpl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_dfpl_proc_show, NULL);
 }
-static int viafb_dfpl_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static ssize_t viafb_dfpl_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20];
 	u8 reg_val = 0;
@@ -1921,10 +1961,18 @@ static int viafb_dfpl_proc_write(struct file *file,
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
-static int viafb_vt1636_proc_read(char *buf, char **start,
-	off_t offset, int count, int *eof, void *data)
+
+static const struct file_operations viafb_dfpl_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_dfpl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_dfpl_proc_write,
+};
+
+static int viafb_vt1636_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	u8 vt1636_08 = 0, vt1636_09 = 0;
 	switch (viaparinfo->chip_info->lvds_chip_info.lvds_chip_name) {
 	case VT1636_LVDS:
@@ -1934,7 +1982,7 @@ static int viafb_vt1636_proc_read(char *buf, char **start,
 		vt1636_09 =
 		    viafb_gpio_i2c_read_lvds(viaparinfo->lvds_setting_info,
 		    &viaparinfo->chip_info->lvds_chip_info, 0x09) & 0x1f;
-		len += sprintf(buf + len, "%x %x\n", vt1636_08, vt1636_09);
+		seq_printf(m, "%x %x\n", vt1636_08, vt1636_09);
 		break;
 	default:
 		break;
@@ -1947,16 +1995,21 @@ static int viafb_vt1636_proc_read(char *buf, char **start,
 		vt1636_09 =
 		    viafb_gpio_i2c_read_lvds(viaparinfo->lvds_setting_info2,
 			&viaparinfo->chip_info->lvds_chip_info2, 0x09) & 0x1f;
-		len += sprintf(buf + len, " %x %x\n", vt1636_08, vt1636_09);
+		seq_printf(m, " %x %x\n", vt1636_08, vt1636_09);
 		break;
 	default:
 		break;
 	}
-	*eof = 1;		/*Inform kernel end of data */
-	return len;
+	return 0;
 }
-static int viafb_vt1636_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+
+static int viafb_vt1636_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, viafb_vt1636_proc_show, NULL);
+}
+
+static ssize_t viafb_vt1636_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[30], *value, *pbuf;
 	struct IODATA reg_val;
@@ -2045,39 +2098,27 @@ static int viafb_vt1636_proc_write(struct file *file,
 	return count;
 }
 
+static const struct file_operations viafb_vt1636_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= viafb_vt1636_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= viafb_vt1636_proc_write,
+};
+
 static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 {
-	struct proc_dir_entry *entry;
 	*viafb_entry = proc_mkdir("viafb", NULL);
 	if (viafb_entry) {
-		entry = create_proc_entry("dvp0", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dvp0_proc_read;
-			entry->write_proc = viafb_dvp0_proc_write;
-		}
-		entry = create_proc_entry("dvp1", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dvp1_proc_read;
-			entry->write_proc = viafb_dvp1_proc_write;
-		}
-		entry = create_proc_entry("dfph", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dfph_proc_read;
-			entry->write_proc = viafb_dfph_proc_write;
-		}
-		entry = create_proc_entry("dfpl", 0, *viafb_entry);
-		if (entry) {
-			entry->read_proc = viafb_dfpl_proc_read;
-			entry->write_proc = viafb_dfpl_proc_write;
-		}
+		proc_create("dvp0", 0, *viafb_entry, &viafb_dvp0_proc_fops);
+		proc_create("dvp1", 0, *viafb_entry, &viafb_dvp1_proc_fops);
+		proc_create("dfph", 0, *viafb_entry, &viafb_dfph_proc_fops);
+		proc_create("dfpl", 0, *viafb_entry, &viafb_dfpl_proc_fops);
 		if (VT1636_LVDS == viaparinfo->chip_info->lvds_chip_info.
 			lvds_chip_name || VT1636_LVDS ==
 		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
-			entry = create_proc_entry("vt1636", 0, *viafb_entry);
-			if (entry) {
-				entry->read_proc = viafb_vt1636_proc_read;
-				entry->write_proc = viafb_vt1636_proc_write;
-			}
+			proc_create("vt1636", 0, *viafb_entry, &viafb_vt1636_proc_fops);
 		}
 
 	}
