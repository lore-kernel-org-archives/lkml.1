Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZH2QiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZH2QiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 12:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZH2QiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 12:38:08 -0400
Received: from www84.your-server.de ([213.133.104.84]:60905 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZH2QiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 12:38:06 -0400
Subject: [PATCH] Fix proc_file_write missing ppos update
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 29 Aug 2009 18:38:12 +0200
Message-Id: <1251563892.13287.11.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fix a long standing issue in the proc_file_write function,
which doesn't update the ppos file position pointer.

This prevent the usage of multiple sequently writes on an opened proc
file, because it is impossible to distinguish these due the offset is
always 0.

The patch has no side effects, because the old implementaion has
no ability to access the file offset pointer.

Out of tree should work, also if there not using the new prototype definition, 
because the new file offset pointer argument will be passed as last parameter.

The patch is against 2.6.31-rc8

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 fs/proc/generic.c                                      |    5 ++--
 include/linux/proc_fs.h                                |    2 -
 Documentation/DocBook/procfs-guide.tmpl                |    1 
 Documentation/DocBook/procfs_example.c                 |    3 +-
 arch/alpha/kernel/srm_env.c                            |    2 -
 arch/arm/mm/alignment.c                                |    2 -
 arch/blackfin/kernel/kgdb_test.c                       |    2 -
 arch/mips/lasat/picvue_proc.c                          |    4 +--
 arch/powerpc/platforms/iseries/mf.c                    |    6 ++---
 arch/um/drivers/mconsole_kern.c                        |    2 -
 arch/um/kernel/exitcode.c                              |    2 -
 arch/um/kernel/process.c                               |    3 +-
 drivers/acpi/debug.c                                   |    2 -
 drivers/block/DAC960.c                                 |    3 +-
 drivers/ide/ide-proc.c                                 |    6 +++--
 drivers/isdn/hardware/eicon/divasproc.c                |    8 +++----
 drivers/macintosh/via-pmu.c                            |    4 +--
 drivers/media/dvb/ttpci/av7110_ir.c                    |    2 -
 drivers/media/video/cpia.c                             |    2 -
 drivers/net/wireless/ipw2x00/libipw_module.c           |    2 -
 drivers/net/wireless/ray_cs.c                          |    4 +--
 drivers/parisc/led.c                                   |    2 -
 drivers/platform/x86/asus_acpi.c                       |   18 ++++++++---------
 drivers/platform/x86/thinkpad_acpi.c                   |    2 -
 drivers/platform/x86/toshiba_acpi.c                    |    2 -
 drivers/pnp/pnpbios/proc.c                             |    2 -
 drivers/s390/block/dasd_proc.c                         |    2 -
 drivers/s390/crypto/zcrypt_api.c                       |    2 -
 drivers/scsi/scsi_proc.c                               |    2 -
 drivers/staging/epl/proc_fs.c                          |    4 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_module.c |    2 -
 drivers/video/clps711xfb.c                             |    4 +--
 drivers/video/via/viafbdev.c                           |   15 +++++++++-----
 kernel/profile.c                                       |    2 -
 34 files changed, 69 insertions(+), 57 deletions(-)

diff -u -N -r write_proc.orig/include/linux/proc_fs.h write_proc/include/linux/proc_fs.h
--- write_proc.orig/include/linux/proc_fs.h	2009-08-29 15:53:44.000000000 +0200
+++ write_proc/include/linux/proc_fs.h	2009-08-29 15:44:44.000000000 +0200
@@ -46,7 +46,7 @@
 typedef	int (read_proc_t)(char *page, char **start, off_t off,
 			  int count, int *eof, void *data);
 typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
-			   unsigned long count, void *data);
+			   unsigned long count, void *data, off_t off);
 
 struct proc_dir_entry {
 	unsigned int low_ino;
diff -u -N -r write_proc.orig/fs/proc/generic.c write_proc/fs/proc/generic.c
--- write_proc.orig/fs/proc/generic.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/fs/proc/generic.c	2009-08-29 15:43:46.000000000 +0200
@@ -219,9 +219,10 @@
 		pde->pde_users++;
 		spin_unlock(&pde->pde_unload_lock);
 
-		/* FIXME: does this routine need ppos?  probably... */
-		rv = pde->write_proc(file, buffer, count, pde->data);
+		rv = pde->write_proc(file, buffer, count, pde->data, *ppos);
 		pde_users_dec(pde);
+		if (rv > 0)
+			*ppos += rv;
 	}
 	return rv;
 }
diff -u -N -r write_proc.orig/arch/alpha/kernel/srm_env.c write_proc/arch/alpha/kernel/srm_env.c
--- write_proc.orig/arch/alpha/kernel/srm_env.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/arch/alpha/kernel/srm_env.c	2009-08-29 15:43:46.000000000 +0200
@@ -106,7 +106,7 @@
 
 static int
 srm_env_write(struct file *file, const char __user *buffer, unsigned long count,
-		void *data)
+		void *data, off_t off)
 {
 	int res;
 	srm_env_t	*entry;
diff -u -N -r write_proc.orig/arch/arm/mm/alignment.c write_proc/arch/arm/mm/alignment.c
--- write_proc.orig/arch/arm/mm/alignment.c	2009-08-29 15:53:40.000000000 +0200
+++ write_proc/arch/arm/mm/alignment.c	2009-08-29 15:43:46.000000000 +0200
@@ -120,7 +120,7 @@
 }
 
 static int proc_alignment_write(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+				unsigned long count, void *data, off_t off)
 {
 	char mode;
 
diff -u -N -r write_proc.orig/arch/blackfin/kernel/kgdb_test.c write_proc/arch/blackfin/kernel/kgdb_test.c
--- write_proc.orig/arch/blackfin/kernel/kgdb_test.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/arch/blackfin/kernel/kgdb_test.c	2009-08-29 15:43:46.000000000 +0200
@@ -90,7 +90,7 @@
 }
 
 static int test_write_proc(struct file *file, const char *buffer,
-				 unsigned long count, void *data)
+				 unsigned long count, void *data, off_t off)
 {
 	if (count >= 256)
 		len = 255;
diff -u -N -r write_proc.orig/arch/mips/lasat/picvue_proc.c write_proc/arch/mips/lasat/picvue_proc.c
--- write_proc.orig/arch/mips/lasat/picvue_proc.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/arch/mips/lasat/picvue_proc.c	2009-08-29 15:43:46.000000000 +0200
@@ -58,7 +58,7 @@
 }
 
 static int pvc_proc_write_line(struct file *file, const char *buffer,
-			   unsigned long count, void *data)
+			   unsigned long count, void *data, off_t off)
 {
 	int origcount = count;
 	int lineno = *(int *)data;
@@ -86,7 +86,7 @@
 }
 
 static int pvc_proc_write_scroll(struct file *file, const char *buffer,
-			   unsigned long count, void *data)
+			   unsigned long count, void *data, off_t off)
 {
 	int origcount = count;
 	int cmd = simple_strtol(buffer, NULL, 10);
diff -u -N -r write_proc.orig/arch/powerpc/platforms/iseries/mf.c write_proc/arch/powerpc/platforms/iseries/mf.c
--- write_proc.orig/arch/powerpc/platforms/iseries/mf.c	2009-08-29 15:53:40.000000000 +0200
+++ write_proc/arch/powerpc/platforms/iseries/mf.c	2009-08-29 15:43:46.000000000 +0200
@@ -1003,7 +1003,7 @@
 }
 
 static int proc_mf_change_side(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	char side;
 	u64 newSide;
@@ -1110,7 +1110,7 @@
 }
 
 static int proc_mf_change_src(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	char stkbuf[10];
 
@@ -1136,7 +1136,7 @@
 }
 
 static int proc_mf_change_cmdline(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	struct vsp_cmd_data vsp_cmd;
 	dma_addr_t dma_addr;
diff -u -N -r write_proc.orig/arch/um/drivers/mconsole_kern.c write_proc/arch/um/drivers/mconsole_kern.c
--- write_proc.orig/arch/um/drivers/mconsole_kern.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/arch/um/drivers/mconsole_kern.c	2009-08-29 15:43:46.000000000 +0200
@@ -834,7 +834,7 @@
 __initcall(mconsole_init);
 
 static int write_proc_mconsole(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+			       unsigned long count, void *data, off_t off)
 {
 	char *buf;
 
diff -u -N -r write_proc.orig/arch/um/kernel/exitcode.c write_proc/arch/um/kernel/exitcode.c
--- write_proc.orig/arch/um/kernel/exitcode.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/arch/um/kernel/exitcode.c	2009-08-29 15:43:46.000000000 +0200
@@ -39,7 +39,7 @@
 }
 
 static int write_proc_exitcode(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+			       unsigned long count, void *data, off_t off)
 {
 	char *end, buf[sizeof("nnnnn\0")];
 	int tmp;
diff -u -N -r write_proc.orig/arch/um/kernel/process.c write_proc/arch/um/kernel/process.c
--- write_proc.orig/arch/um/kernel/process.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/arch/um/kernel/process.c	2009-08-29 15:43:46.000000000 +0200
@@ -345,7 +345,8 @@
 	return strlen(buf);
 }
 
-static int proc_write_sysemu(struct file *file,const char __user *buf, unsigned long count,void *data)
+static int proc_write_sysemu(struct file *file, const char __user *buf,
+		unsigned long count, void *data, off_t off)
 {
 	char tmp[2];
 
diff -u -N -r write_proc.orig/Documentation/DocBook/procfs_example.c write_proc/Documentation/DocBook/procfs_example.c
--- write_proc.orig/Documentation/DocBook/procfs_example.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/Documentation/DocBook/procfs_example.c	2009-08-29 15:43:46.000000000 +0200
@@ -88,7 +88,8 @@
 static int proc_write_foobar(struct file *file,
 			     const char *buffer,
 			     unsigned long count, 
-			     void *data)
+			     void *data,
+			     off_t off)
 {
 	int len;
 	struct fb_data_t *fb_data = (struct fb_data_t *)data;
diff -u -N -r write_proc.orig/drivers/acpi/debug.c write_proc/drivers/acpi/debug.c
--- write_proc.orig/drivers/acpi/debug.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/acpi/debug.c	2009-08-29 16:18:44.000000000 +0200
@@ -266,7 +266,7 @@
 static int
 acpi_system_write_debug(struct file *file,
 			const char __user * buffer,
-			unsigned long count, void *data)
+			unsigned long count, void *data, off_t off)
 {
 	char debug_string[12] = { '\0' };
 
diff -u -N -r write_proc.orig/drivers/block/DAC960.c write_proc/drivers/block/DAC960.c
--- write_proc.orig/drivers/block/DAC960.c	2009-08-29 15:53:41.000000000 +0200
+++ write_proc/drivers/block/DAC960.c	2009-08-29 15:43:46.000000000 +0200
@@ -6553,7 +6553,8 @@
 
 static int DAC960_ProcWriteUserCommand(struct file *file,
 				       const char __user *Buffer,
-				       unsigned long Count, void *Data)
+				       unsigned long Count, void *Data,
+				       off_t Offset)
 {
   DAC960_Controller_T *Controller = (DAC960_Controller_T *) Data;
   unsigned char CommandBuffer[80];
diff -u -N -r write_proc.orig/drivers/ide/ide-proc.c write_proc/drivers/ide/ide-proc.c
--- write_proc.orig/drivers/ide/ide-proc.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/ide/ide-proc.c	2009-08-29 15:43:46.000000000 +0200
@@ -297,7 +297,8 @@
 #define MAX_LEN	30
 
 static int proc_ide_write_settings(struct file *file, const char __user *buffer,
-				   unsigned long count, void *data)
+				   unsigned long count, void *data,
+				   off_t off)
 {
 	ide_drive_t	*drive = (ide_drive_t *) data;
 	char		name[MAX_LEN + 1];
@@ -481,7 +482,8 @@
 }
 
 static int proc_ide_write_driver
-	(struct file *file, const char __user *buffer, unsigned long count, void *data)
+	(struct file *file, const char __user *buffer, unsigned long count,
+	 void *data, off_t off)
 {
 	ide_drive_t	*drive = (ide_drive_t *) data;
 	char name[32];
diff -u -N -r write_proc.orig/drivers/isdn/hardware/eicon/divasproc.c write_proc/drivers/isdn/hardware/eicon/divasproc.c
--- write_proc.orig/drivers/isdn/hardware/eicon/divasproc.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/isdn/hardware/eicon/divasproc.c	2009-08-29 15:43:46.000000000 +0200
@@ -146,7 +146,7 @@
 */
 static int
 write_grp_opt(struct file *file, const char __user *buffer, unsigned long count,
-	      void *data)
+	      void *data, off_t off)
 {
 	diva_os_xdi_adapter_t *a = (diva_os_xdi_adapter_t *) data;
 	PISDN_ADAPTER IoAdapter = IoAdapters[a->controller - 1];
@@ -176,8 +176,8 @@
 ** write dynamic_l1_down
 */
 static int
-write_d_l1_down(struct file *file, const char __user *buffer, unsigned long count,
-		void *data)
+write_d_l1_down(struct file *file, const char __user *buffer,
+		unsigned long count, void *data, off_t off)
 {
 	diva_os_xdi_adapter_t *a = (diva_os_xdi_adapter_t *) data;
 	PISDN_ADAPTER IoAdapter = IoAdapters[a->controller - 1];
@@ -257,7 +257,7 @@
 */
 static int
 info_write(struct file *file, const char __user *buffer, unsigned long count,
-	   void *data)
+	   void *data, off_t off)
 {
 	diva_os_xdi_adapter_t *a = (diva_os_xdi_adapter_t *) data;
 	PISDN_ADAPTER IoAdapter = IoAdapters[a->controller - 1];
diff -u -N -r write_proc.orig/drivers/macintosh/via-pmu.c write_proc/drivers/macintosh/via-pmu.c
--- write_proc.orig/drivers/macintosh/via-pmu.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/macintosh/via-pmu.c	2009-08-29 15:43:46.000000000 +0200
@@ -196,7 +196,7 @@
 static int proc_read_options(char *page, char **start, off_t off,
 			int count, int *eof, void *data);
 static int proc_write_options(struct file *file, const char __user *buffer,
-			unsigned long count, void *data);
+			unsigned long count, void *data, off_t off);
 
 #ifdef CONFIG_ADB
 struct adb_driver via_pmu_driver = {
@@ -880,7 +880,7 @@
 			
 static int
 proc_write_options(struct file *file, const char __user *buffer,
-			unsigned long count, void *data)
+			unsigned long count, void *data, off_t off)
 {
 	char tmp[33];
 	char *label, *val;
diff -u -N -r write_proc.orig/drivers/media/dvb/ttpci/av7110_ir.c write_proc/drivers/media/dvb/ttpci/av7110_ir.c
--- write_proc.orig/drivers/media/dvb/ttpci/av7110_ir.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/media/dvb/ttpci/av7110_ir.c	2009-08-29 15:43:46.000000000 +0200
@@ -269,7 +269,7 @@
 
 /* /proc/av7110_ir interface */
 static int av7110_ir_write_proc(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+				unsigned long count, void *data, off_t off)
 {
 	char *page;
 	u32 ir_config;
diff -u -N -r write_proc.orig/drivers/media/video/cpia.c write_proc/drivers/media/video/cpia.c
--- write_proc.orig/drivers/media/video/cpia.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/media/video/cpia.c	2009-08-29 15:43:46.000000000 +0200
@@ -565,7 +565,7 @@
 }
 
 static int cpia_write_proc(struct file *file, const char __user *buf,
-			   unsigned long count, void *data)
+			   unsigned long count, void *data, off_t off)
 {
 	struct cam_data *cam = data;
 	struct cam_params new_params;
diff -u -N -r write_proc.orig/drivers/net/wireless/ipw2x00/libipw_module.c write_proc/drivers/net/wireless/ipw2x00/libipw_module.c
--- write_proc.orig/drivers/net/wireless/ipw2x00/libipw_module.c	2009-08-29 15:53:42.000000000 +0200
+++ write_proc/drivers/net/wireless/ipw2x00/libipw_module.c	2009-08-29 15:43:46.000000000 +0200
@@ -223,7 +223,7 @@
 }
 
 static int store_debug_level(struct file *file, const char __user * buffer,
-			     unsigned long count, void *data)
+			     unsigned long count, void *data, off_t off)
 {
 	char buf[] = "0x00000000\n";
 	unsigned long len = min((unsigned long)sizeof(buf) - 1, count);
diff -u -N -r write_proc.orig/drivers/net/wireless/ray_cs.c write_proc/drivers/net/wireless/ray_cs.c
--- write_proc.orig/drivers/net/wireless/ray_cs.c	2009-08-29 15:53:42.000000000 +0200
+++ write_proc/drivers/net/wireless/ray_cs.c	2009-08-29 15:43:46.000000000 +0200
@@ -2875,7 +2875,7 @@
 }
 
 static int write_essid(struct file *file, const char __user *buffer,
-		       unsigned long count, void *data)
+		       unsigned long count, void *data, off_t off)
 {
 	static char proc_essid[33];
 	int len = count;
@@ -2890,7 +2890,7 @@
 }
 
 static int write_int(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data)
+		     unsigned long count, void *data, off_t off)
 {
 	static char proc_number[10];
 	char *p;
diff -u -N -r write_proc.orig/drivers/parisc/led.c write_proc/drivers/parisc/led.c
--- write_proc.orig/drivers/parisc/led.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/parisc/led.c	2009-08-29 15:43:46.000000000 +0200
@@ -180,7 +180,7 @@
 }
 
 static int led_proc_write(struct file *file, const char *buf, 
-	unsigned long count, void *data)
+	unsigned long count, void *data, off_t off)
 {
 	char *cur, lbuf[count + 1];
 	int d;
diff -u -N -r write_proc.orig/drivers/platform/x86/asus_acpi.c write_proc/drivers/platform/x86/asus_acpi.c
--- write_proc.orig/drivers/platform/x86/asus_acpi.c	2009-08-29 15:53:42.000000000 +0200
+++ write_proc/drivers/platform/x86/asus_acpi.c	2009-08-29 15:43:46.000000000 +0200
@@ -648,7 +648,7 @@
 
 static int
 proc_write_mled(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	return write_led(buffer, count, hotk->methods->mt_mled, MLED_ON, 1);
 }
@@ -665,7 +665,7 @@
 
 static int
 proc_write_ledd(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t ppos)
 {
 	int rv, value;
 
@@ -694,7 +694,7 @@
 
 static int
 proc_write_wled(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	return write_led(buffer, count, hotk->methods->mt_wled, WLED_ON, 0);
 }
@@ -711,7 +711,7 @@
 
 static int
 proc_write_bluetooth(struct file *file, const char __user *buffer,
-		     unsigned long count, void *data)
+		     unsigned long count, void *data, off_t off)
 {
 	/* Note: mt_bt_switch controls both internal Bluetooth adapter's
 	   presence and its LED */
@@ -731,7 +731,7 @@
 
 static int
 proc_write_tled(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	return write_led(buffer, count, hotk->methods->mt_tled, TLED_ON, 0);
 }
@@ -837,7 +837,7 @@
 
 static int
 proc_write_lcd(struct file *file, const char __user *buffer,
-	       unsigned long count, void *data)
+	       unsigned long count, void *data, off_t off)
 {
 	int rv, value;
 
@@ -915,7 +915,7 @@
 
 static int
 proc_write_brn(struct file *file, const char __user *buffer,
-	       unsigned long count, void *data)
+	       unsigned long count, void *data, off_t off)
 {
 	int rv, value;
 
@@ -962,7 +962,7 @@
  */
 static int
 proc_write_disp(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	int rv, value;
 
@@ -975,7 +975,7 @@
 typedef int (proc_readfunc) (char *page, char **start, off_t off, int count,
 			     int *eof, void *data);
 typedef int (proc_writefunc) (struct file *file, const char __user *buffer,
-			      unsigned long count, void *data);
+			      unsigned long count, void *data, off_t off);
 
 static int
 asus_proc_add(char *name, proc_writefunc *writefunc,
diff -u -N -r write_proc.orig/drivers/platform/x86/thinkpad_acpi.c write_proc/drivers/platform/x86/thinkpad_acpi.c
--- write_proc.orig/drivers/platform/x86/thinkpad_acpi.c	2009-08-29 15:53:42.000000000 +0200
+++ write_proc/drivers/platform/x86/thinkpad_acpi.c	2009-08-29 16:25:21.000000000 +0200
@@ -758,7 +758,7 @@
 
 static int dispatch_procfs_write(struct file *file,
 			const char __user *userbuf,
-			unsigned long count, void *data)
+			unsigned long count, void *data, off_t off)
 {
 	struct ibm_struct *ibm = data;
 	char *kernbuf;
diff -u -N -r write_proc.orig/drivers/platform/x86/toshiba_acpi.c write_proc/drivers/platform/x86/toshiba_acpi.c
--- write_proc.orig/drivers/platform/x86/toshiba_acpi.c	2009-08-29 15:53:42.000000000 +0200
+++ write_proc/drivers/platform/x86/toshiba_acpi.c	2009-08-29 15:43:46.000000000 +0200
@@ -390,7 +390,7 @@
 
 static int
 dispatch_write(struct file *file, const char __user * buffer,
-	       unsigned long count, ProcItem * item)
+	       unsigned long count, ProcItem * item, off_t off)
 {
 	int result;
 	char *tmp_buffer;
diff -u -N -r write_proc.orig/drivers/pnp/pnpbios/proc.c write_proc/drivers/pnp/pnpbios/proc.c
--- write_proc.orig/drivers/pnp/pnpbios/proc.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/pnp/pnpbios/proc.c	2009-08-29 15:47:33.000000000 +0200
@@ -186,7 +186,7 @@
 }
 
 static int proc_write_node(struct file *file, const char __user * buf,
-			   unsigned long count, void *data)
+			   unsigned long count, void *data, off_t off)
 {
 	struct pnp_bios_node *node;
 	int boot = (long)data >> 8;
diff -u -N -r write_proc.orig/drivers/s390/block/dasd_proc.c write_proc/drivers/s390/block/dasd_proc.c
--- write_proc.orig/drivers/s390/block/dasd_proc.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/s390/block/dasd_proc.c	2009-08-29 15:43:46.000000000 +0200
@@ -259,7 +259,7 @@
 
 static int
 dasd_statistics_write(struct file *file, const char __user *user_buf,
-		      unsigned long user_len, void *data)
+		      unsigned long user_len, void *data, off_t off)
 {
 #ifdef CONFIG_DASD_PROFILE
 	char *buffer, *str;
diff -u -N -r write_proc.orig/drivers/s390/crypto/zcrypt_api.c write_proc/drivers/s390/crypto/zcrypt_api.c
--- write_proc.orig/drivers/s390/crypto/zcrypt_api.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/s390/crypto/zcrypt_api.c	2009-08-29 15:43:46.000000000 +0200
@@ -1058,7 +1058,7 @@
 }
 
 static int zcrypt_status_write(struct file *file, const char __user *buffer,
-			       unsigned long count, void *data)
+			       unsigned long count, void *data, off_t off)
 {
 	unsigned char *lbuf, *ptr;
 	unsigned long local_count;
diff -u -N -r write_proc.orig/drivers/scsi/scsi_proc.c write_proc/drivers/scsi/scsi_proc.c
--- write_proc.orig/drivers/scsi/scsi_proc.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/scsi/scsi_proc.c	2009-08-29 16:28:51.000000000 +0200
@@ -75,7 +75,7 @@
  * @data: pointer to &struct Scsi_Host
  */
 static int proc_scsi_write_proc(struct file *file, const char __user *buf,
-                           unsigned long count, void *data)
+                           unsigned long count, void *data, off_t off)
 {
 	struct Scsi_Host *shost = data;
 	ssize_t ret = -ENOMEM;
diff -u -N -r write_proc.orig/drivers/staging/epl/proc_fs.c write_proc/drivers/staging/epl/proc_fs.c
--- write_proc.orig/drivers/staging/epl/proc_fs.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/staging/epl/proc_fs.c	2009-08-29 15:43:46.000000000 +0200
@@ -144,7 +144,7 @@
 static int EplLinProcRead(char *pcBuffer_p, char **ppcStart_p, off_t Offset_p,
 			  int nBufferSize_p, int *pEof_p, void *pData_p);
 static int EplLinProcWrite(struct file *file, const char __user * buffer,
-			   unsigned long count, void *data);
+			   unsigned long count, void *data, off_t off);
 
 void TgtDbgSignalTracePoint(u8 bTracePointNumber_p);
 void TgtDbgPostTraceValue(u32 dwTraceValue_p);
@@ -382,7 +382,7 @@
 //---------------------------------------------------------------------------
 
 static int EplLinProcWrite(struct file *file, const char __user * buffer,
-			   unsigned long count, void *data)
+			   unsigned long count, void *data, off_t off)
 {
 	char abBuffer[count + 1];
 	int iErr;
diff -u -N -r write_proc.orig/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c write_proc/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
--- write_proc.orig/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c	2009-08-29 15:53:42.000000000 +0200
+++ write_proc/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c	2009-08-29 15:43:46.000000000 +0200
@@ -301,7 +301,7 @@
 }
 
 static int store_debug_level(struct file *file, const char *buffer,
-			     unsigned long count, void *data)
+			     unsigned long count, void *data, off_t off)
 {
 	char buf[] = "0x00000000";
 	unsigned long len = min(sizeof(buf) - 1, (u32)count);
diff -u -N -r write_proc.orig/drivers/video/clps711xfb.c write_proc/drivers/video/clps711xfb.c
--- write_proc.orig/drivers/video/clps711xfb.c	2009-06-10 05:05:27.000000000 +0200
+++ write_proc/drivers/video/clps711xfb.c	2009-08-29 15:43:46.000000000 +0200
@@ -44,7 +44,7 @@
 static int clps7111fb_proc_backlight_read(char *page, char **start, off_t off,
 		int count, int *eof, void *data);
 static int clps7111fb_proc_backlight_write(struct file *file, 
-		const char *buffer, unsigned long count, void *data);
+		const char *buffer, unsigned long count, void *data, off_t off);
 
 /*
  * LCD AC Prescale.  This comes from the LCD panel manufacturers specifications.
@@ -240,7 +240,7 @@
 
 static int 
 clps7111fb_proc_backlight_write(struct file *file, const char *buffer, 
-		unsigned long count, void *data)
+		unsigned long count, void *data, off_t off)
 {
 	unsigned char char_value;
 	int value;
diff -u -N -r write_proc.orig/drivers/video/via/viafbdev.c write_proc/drivers/video/via/viafbdev.c
--- write_proc.orig/drivers/video/via/viafbdev.c	2009-08-29 15:53:43.000000000 +0200
+++ write_proc/drivers/video/via/viafbdev.c	2009-08-29 16:20:28.000000000 +0200
@@ -1772,7 +1772,8 @@
 	return len;
 }
 static int viafb_dvp0_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+	const char __user *buffer, unsigned long count, void *data,
+	off_t offset)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1830,7 +1831,8 @@
 	return len;
 }
 static int viafb_dvp1_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+	const char __user *buffer, unsigned long count, void *data,
+	off_t offset)
 {
 	char buf[20], *value, *pbuf;
 	u8 reg_val = 0;
@@ -1880,7 +1882,8 @@
 	return len;
 }
 static int viafb_dfph_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+	const char __user *buffer, unsigned long count, void *data,
+	off_t offset)
 {
 	char buf[20];
 	u8 reg_val = 0;
@@ -1906,7 +1909,8 @@
 	return len;
 }
 static int viafb_dfpl_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+	const char __user *buffer, unsigned long count, void *data,
+	off_t offset)
 {
 	char buf[20];
 	u8 reg_val = 0;
@@ -1956,7 +1960,8 @@
 	return len;
 }
 static int viafb_vt1636_proc_write(struct file *file,
-	const char __user *buffer, unsigned long count, void *data)
+	const char __user *buffer, unsigned long count, void *data,
+	off_t offset)
 {
 	char buf[30], *value, *pbuf;
 	struct IODATA reg_val;
diff -u -N -r write_proc.orig/kernel/profile.c write_proc/kernel/profile.c
--- write_proc.orig/kernel/profile.c	2009-08-29 15:53:44.000000000 +0200
+++ write_proc/kernel/profile.c	2009-08-29 16:15:35.000000000 +0200
@@ -455,7 +455,7 @@
 }
 
 static int prof_cpu_mask_write_proc(struct file *file,
-	const char __user *buffer,  unsigned long count, void *data)
+	const char __user *buffer,  unsigned long count, void *data, off_t off)
 {
 	struct cpumask *mask = data;
 	unsigned long full_count = count, err;
diff -u -N -r write_proc.orig/Documentation/DocBook/procfs-guide.tmpl write_proc/Documentation/DocBook/procfs-guide.tmpl
--- write_proc.orig/Documentation/DocBook/procfs-guide.tmpl	2009-08-29 18:21:36.000000000 +0200
+++ write_proc/Documentation/DocBook/procfs-guide.tmpl	2009-08-29 18:22:27.000000000 +0200
@@ -455,6 +455,7 @@
 	  <paramdef>const char* <parameter>buffer</parameter></paramdef>
 	  <paramdef>unsigned long <parameter>count</parameter></paramdef>
 	  <paramdef>void* <parameter>data</parameter></paramdef>
+	  <paramdef>off_t <parameter>off</parameter></paramdef>
 	</funcprototype>
       </funcsynopsis>
 


