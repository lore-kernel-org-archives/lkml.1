Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYDHO6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYDHO6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYDHO6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:58:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6983 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbYDHO6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:58:24 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Subject: [PATCH 07/12] proc: switch /proc/excite/unit_id to seq_file interface
Date: Tue, 8 Apr 2008 18:57:48 +0400
User-Agent: KMail/1.9.9
Cc: devel@openvz.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081857.48631.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/mips/basler/excite/excite_procfs.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/arch/mips/basler/excite/excite_procfs.c
+++ b/arch/mips/basler/excite/excite_procfs.c
@@ -18,8 +18,9 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-
+#include <linux/module.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
 #include <asm/page.h>
 #include <asm/io.h>
@@ -28,14 +29,25 @@
 
 #include <excite.h>
 
-static int excite_get_unit_id(char *buf, char **addr, off_t offs, int size)
+static int excite_unit_id_proc_show(struct seq_file *m, void *v)
 {
-	const int len = snprintf(buf, PAGE_SIZE, "%06x", unit_id);
-	const int w = len - offs;
-	*addr = buf + offs;
-	return w < size ? w : size;
+	seq_printf(m, "%06x", unit_id);
+	return 0;
 }
 
+static int excite_unit_id_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, excite_unit_id_proc_show, NULL);
+}
+
+static const struct file_operations excite_unit_id_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= excite_unit_id_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int
 excite_bootrom_read(char *page, char **start, off_t off, int count,
 		  int *eof, void *data)
@@ -69,8 +81,8 @@ void excite_procfs_init(void)
 	if (pdir) {
 		struct proc_dir_entry * e;
 
-		e = create_proc_info_entry("unit_id", S_IRUGO, pdir,
-					   excite_get_unit_id);
+		e = proc_create("unit_id", S_IRUGO, pdir,
+				&excite_unit_id_proc_fops);
 		if (e) e->size = 6;
 
 		e = create_proc_read_entry("bootrom", S_IRUGO, pdir,
-- 
1.5.4.3

