Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYDHO6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYDHO6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYDHO5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:57:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37749 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbYDHO5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:57:49 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 06/12] proc: switch /proc/bus/ecard/devices to seq_file interface
Date: Tue, 8 Apr 2008 18:57:13 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081857.13566.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/arm/kernel/ecard.c |   54 +++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

--- a/arch/arm/kernel/ecard.c
+++ b/arch/arm/kernel/ecard.c
@@ -37,6 +37,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
@@ -723,17 +724,14 @@ unsigned int __ecard_address(ecard_t *ec, card_type_t type, card_speed_t speed)
 	return address;
 }
 
-static int ecard_prints(char *buffer, ecard_t *ec)
+static int ecard_prints(struct seq_file *m, ecard_t *ec)
 {
-	char *start = buffer;
-
-	buffer += sprintf(buffer, "  %d: %s ", ec->slot_no,
-			  ec->easi ? "EASI" : "    ");
+	seq_printf(m, "  %d: %s ", ec->slot_no, ec->easi ? "EASI" : "    ");
 
 	if (ec->cid.id == 0) {
 		struct in_chunk_dir incd;
 
-		buffer += sprintf(buffer, "[%04X:%04X] ",
+		seq_printf(m, "[%04X:%04X] ",
 			ec->cid.manufacturer, ec->cid.product);
 
 		if (!ec->card_desc && ec->cid.cd &&
@@ -744,43 +742,43 @@ static int ecard_prints(char *buffer, ecard_t *ec)
 				strcpy((char *)ec->card_desc, incd.d.string);
 		}
 
-		buffer += sprintf(buffer, "%s\n", ec->card_desc ? ec->card_desc : "*unknown*");
+		seq_printf(m, "%s\n", ec->card_desc ? ec->card_desc : "*unknown*");
 	} else
-		buffer += sprintf(buffer, "Simple card %d\n", ec->cid.id);
+		seq_printf(m, "Simple card %d\n", ec->cid.id);
 
-	return buffer - start;
+	return 0;
 }
 
-static int get_ecard_dev_info(char *buf, char **start, off_t pos, int count)
+static int ecard_devices_proc_show(struct seq_file *m, void *v)
 {
 	ecard_t *ec = cards;
-	off_t at = 0;
-	int len, cnt;
-
-	cnt = 0;
-	while (ec && count > cnt) {
-		len = ecard_prints(buf, ec);
-		at += len;
-		if (at >= pos) {
-			if (!*start) {
-				*start = buf + (pos - (at - len));
-				cnt = at - pos;
-			} else
-				cnt += len;
-			buf += len;
-		}
+
+	while (ec) {
+		ecard_prints(m, ec);
 		ec = ec->next;
 	}
-	return (count > cnt) ? cnt : count;
+	return 0;
 }
 
+static int ecard_devices_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ecard_devices_proc_show, NULL);
+}
+
+static const struct file_operations bus_ecard_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ecard_devices_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static struct proc_dir_entry *proc_bus_ecard_dir = NULL;
 
 static void ecard_proc_init(void)
 {
 	proc_bus_ecard_dir = proc_mkdir("bus/ecard", NULL);
-	create_proc_info_entry("devices", 0, proc_bus_ecard_dir,
-		get_ecard_dev_info);
+	proc_create("devices", 0, proc_bus_ecard_dir, &bus_ecard_proc_fops);
 }
 
 #define ec_set_resource(ec,nr,st,sz)				\
-- 
1.5.4.3

