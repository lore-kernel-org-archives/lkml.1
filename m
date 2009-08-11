Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZHKTrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZHKTrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZHKTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:47:36 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38348 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZHKTra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:47:30 -0400
Date: Tue, 11 Aug 2009 21:47:25 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH][RFC] security: constify seq_operations
In-Reply-To: <alpine.LRH.2.00.0908120129290.22015@tundra.namei.org>
Message-ID: <Pine.LNX.4.64.0908112138290.9996@ask.diku.dk>
References: <alpine.LRH.2.00.0908112337450.21218@tundra.namei.org>
 <20090811143643.GA15096@us.ibm.com> <alpine.LRH.2.00.0908120129290.22015@tundra.namei.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago I made a semantic patch to introduce const on file_operations 
and and input_device_id types.  I tested it on 142 files in which the 
change had already been made and got the same result in each case.  I have 
run it on linux-next and obtained the attached result.  However, I have 
not checked any of these results, so this is not meant as a submitted 
patch, but as a starting point for someone who wants to look further into 
the problem.

julia

-------------------
semantic patch (http://coccinelle.lip6.fr)

@ rule1 @
struct file_operations x;
identifier fld;
expression E;
@@

x.fld = E

@ rule2 depends on !rule1 disable optional_qualifier @ @@

+ const
    struct file_operations

@ rule3 @
struct input_device_id x;
identifier fld;
expression E;
@@

x.fld = E

@ rule4 depends on !rule3 disable optional_qualifier @ @@

+ const
    struct input_device_id


// The following rules are not super nice, because we are cleaning up bad
// things we have made ourselves.  And the first one is a problem because
// in general there can be any number of stars.  This is indeed part of why
// we can't just enumerate the positive possibilities.

@@
expression E;
@@

(
 (const struct file_operations *) NULL
|
 (
- const
  struct file_operations *)
 E
|
  sizeof (
- const
  struct file_operations)
)

@@
@@

- const
  struct file_operations;

@@
expression E;
@@

(
 (const struct input_device_id *) NULL
|
 (
- const
  struct input_device_id *)
 E
|
  sizeof (
- const
  struct input_device_id)
)

@@
@@

- const
  struct input_device_id;

-------------------

the generated patch, based on linux-next, 
b142f4b663cbd2d359eb9e7733e7136f8205434d

diff -u -p a/arch/arm/mach-ns9xxx/clock.c b/arch/arm/mach-ns9xxx/clock.c
--- a/arch/arm/mach-ns9xxx/clock.c 2008-12-07 19:29:05.000000000 +0100
+++ b/arch/arm/mach-ns9xxx/clock.c 2009-08-11 22:41:55.000000000 +0200
@@ -195,7 +195,7 @@ static int clk_debugfs_open(struct inode
 	return single_open(file, clk_debugfs_show, NULL);
 }
 
-static struct file_operations clk_debugfs_operations = {
+static const struct file_operations clk_debugfs_operations = {
 	.open = clk_debugfs_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -u -p a/arch/blackfin/mach-bf561/coreb.c b/arch/blackfin/mach-bf561/coreb.c
--- a/arch/blackfin/mach-bf561/coreb.c 2009-06-15 17:50:04.000000000 +0200
+++ b/arch/blackfin/mach-bf561/coreb.c 2009-08-11 22:42:01.000000000 +0200
@@ -48,7 +48,7 @@ coreb_ioctl(struct inode *inode, struct 
 	return ret;
 }
 
-static struct file_operations coreb_fops = {
+static const struct file_operations coreb_fops = {
 	.owner   = THIS_MODULE,
 	.ioctl   = coreb_ioctl,
 };
diff -u -p a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
--- a/arch/cris/arch-v10/drivers/sync_serial.c 2008-12-07 19:29:05.000000000 +0100
+++ b/arch/cris/arch-v10/drivers/sync_serial.c 2009-08-11 22:41:50.000000000 +0200
@@ -244,7 +244,7 @@ static unsigned sync_serial_prescale_sha
 
 #define NUMBER_OF_PORTS 2
 
-static struct file_operations sync_serial_fops = {
+static const struct file_operations sync_serial_fops = {
 	.owner   = THIS_MODULE,
 	.write   = sync_serial_write,
 	.read    = sync_serial_read,
diff -u -p a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c 2008-12-07 19:29:05.000000000 +0100
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c 2009-08-11 22:41:51.000000000 +0200
@@ -855,7 +855,7 @@ gpio_leds_ioctl(unsigned int cmd, unsign
 	return 0;
 }
 
-struct file_operations gpio_fops = {
+const struct file_operations gpio_fops = {
 	.owner       = THIS_MODULE,
 	.poll        = gpio_poll,
 	.ioctl       = gpio_ioctl,
diff -u -p a/arch/powerpc/kvm/timing.c b/arch/powerpc/kvm/timing.c
--- a/arch/powerpc/kvm/timing.c 2009-01-06 15:34:28.000000000 +0100
+++ b/arch/powerpc/kvm/timing.c 2009-08-11 22:41:42.000000000 +0200
@@ -201,7 +201,7 @@ static int kvmppc_exit_timing_open(struc
 	return single_open(file, kvmppc_exit_timing_show, inode->i_private);
 }
 
-static struct file_operations kvmppc_exit_timing_fops = {
+static const struct file_operations kvmppc_exit_timing_fops = {
 	.owner   = THIS_MODULE,
 	.open    = kvmppc_exit_timing_open,
 	.read    = seq_read,
diff -u -p a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
--- a/arch/powerpc/platforms/pseries/dtl.c 2009-04-23 17:28:18.000000000 +0200
+++ b/arch/powerpc/platforms/pseries/dtl.c 2009-08-11 22:41:43.000000000 +0200
@@ -209,7 +209,7 @@ static ssize_t dtl_file_read(struct file
 	return n_read * sizeof(struct dtl_entry);
 }
 
-static struct file_operations dtl_fops = {
+static const struct file_operations dtl_fops = {
 	.open		= dtl_file_open,
 	.release	= dtl_file_release,
 	.read		= dtl_file_read,
diff -u -p a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c 2009-08-11 22:10:21.000000000 +0200
+++ b/arch/x86/kernel/cpu/mcheck/mce.c 2009-08-11 22:41:57.000000000 +0200
@@ -1531,7 +1531,7 @@ static long mce_ioctl(struct file *f, un
 }
 
 /* Modified in mce-inject.c, so not static or const */
-struct file_operations mce_chrdev_ops = {
+const struct file_operations mce_chrdev_ops = {
 	.open			= mce_open,
 	.release		= mce_release,
 	.read			= mce_read,
diff -u -p a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
--- a/arch/x86/xen/debugfs.c 2008-12-07 19:29:05.000000000 +0100
+++ b/arch/x86/xen/debugfs.c 2009-08-11 22:41:59.000000000 +0200
@@ -100,7 +100,7 @@ static int xen_array_release(struct inod
 	return 0;
 }
 
-static struct file_operations u32_array_fops = {
+static const struct file_operations u32_array_fops = {
 	.owner	= THIS_MODULE,
 	.open	= u32_array_open,
 	.release= xen_array_release,
diff -u -p a/drivers/acpi/battery.c b/drivers/acpi/battery.c
--- a/drivers/acpi/battery.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/acpi/battery.c 2009-08-11 22:41:41.000000000 +0200
@@ -743,7 +743,7 @@ DECLARE_FILE_FUNCTIONS(alarm);
 	}
 
 static struct battery_file {
-	struct file_operations ops;
+	const struct file_operations ops;
 	mode_t mode;
 	const char *name;
 } acpi_battery_file[] = {
diff -u -p a/drivers/acpi/video.c b/drivers/acpi/video.c
--- a/drivers/acpi/video.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/acpi/video.c 2009-08-11 22:41:43.000000000 +0200
@@ -285,7 +285,7 @@ static int acpi_video_device_brightness_
 						struct file *file);
 static ssize_t acpi_video_device_write_brightness(struct file *file,
 	const char __user *buffer, size_t count, loff_t *data);
-static struct file_operations acpi_video_device_brightness_fops = {
+static const struct file_operations acpi_video_device_brightness_fops = {
 	.owner = THIS_MODULE,
 	.open = acpi_video_device_brightness_open_fs,
 	.read = seq_read,
diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
--- a/drivers/block/cciss.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/block/cciss.c 2009-08-11 22:41:54.000000000 +0200
@@ -432,7 +432,7 @@ out:
 	return err;
 }
 
-static struct file_operations cciss_proc_fops = {
+static const struct file_operations cciss_proc_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = cciss_seq_open,
 	.read    = seq_read,
diff -u -p a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/block/drbd/drbd_int.h 2009-08-11 22:41:59.000000000 +0200
@@ -1485,7 +1485,7 @@ void drbd_bump_write_ordering(struct drb
 
 /* drbd_proc.c */
 extern struct proc_dir_entry *drbd_proc;
-extern struct file_operations drbd_proc_fops;
+extern const struct file_operations drbd_proc_fops;
 extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
diff -u -p a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
--- a/drivers/block/drbd/drbd_proc.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/block/drbd/drbd_proc.c 2009-08-11 22:42:00.000000000 +0200
@@ -39,7 +39,7 @@ static int drbd_proc_open(struct inode *
 
 
 struct proc_dir_entry *drbd_proc;
-struct file_operations drbd_proc_fops = {
+const struct file_operations drbd_proc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= drbd_proc_open,
 	.read		= seq_read,
diff -u -p a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c 2008-12-07 19:29:06.000000000 +0100
+++ b/drivers/char/apm-emulation.c 2009-08-11 22:41:42.000000000 +0200
@@ -393,7 +393,7 @@ static int apm_open(struct inode * inode
 	return as ? 0 : -ENOMEM;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
diff -u -p a/drivers/char/bfin-otp.c b/drivers/char/bfin-otp.c
--- a/drivers/char/bfin-otp.c 2008-12-07 19:29:06.000000000 +0100
+++ b/drivers/char/bfin-otp.c 2009-08-11 22:42:07.000000000 +0200
@@ -133,7 +133,7 @@ static ssize_t bfin_otp_write(struct fil
 # define bfin_otp_write NULL
 #endif
 
-static struct file_operations bfin_otp_fops = {
+static const struct file_operations bfin_otp_fops = {
 	.owner    = THIS_MODULE,
 	.read     = bfin_otp_read,
 	.write    = bfin_otp_write,
diff -u -p a/drivers/char/tty_io.c b/drivers/char/tty_io.c
--- a/drivers/char/tty_io.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/char/tty_io.c 2009-08-11 22:41:53.000000000 +0200
@@ -3041,7 +3041,7 @@ struct tty_struct *get_current_tty(void)
 }
 EXPORT_SYMBOL_GPL(get_current_tty);
 
-void tty_default_fops(struct file_operations *fops)
+void tty_default_fops(const struct file_operations *fops)
 {
 	*fops = tty_fops;
 }
diff -u -p a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c 2008-12-19 10:51:57.000000000 +0100
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c 2009-08-11 22:42:07.000000000 +0200
@@ -559,7 +559,7 @@ static int hwicap_release(struct inode *
 	return status;
 }
 
-static struct file_operations hwicap_fops = {
+static const struct file_operations hwicap_fops = {
 	.owner = THIS_MODULE,
 	.write = hwicap_write,
 	.read = hwicap_read,
diff -u -p a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c 2009-04-13 16:04:29.000000000 +0200
+++ b/drivers/gpio/gpiolib.c 2009-08-11 22:42:03.000000000 +0200
@@ -1244,7 +1244,7 @@ static int gpiolib_open(struct inode *in
 	return single_open(file, gpiolib_show, NULL);
 }
 
-static struct file_operations gpiolib_operations = {
+static const struct file_operations gpiolib_operations = {
 	.open		= gpiolib_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -u -p a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
--- a/drivers/hwmon/fschmd.c 2009-04-13 16:04:29.000000000 +0200
+++ b/drivers/hwmon/fschmd.c 2009-08-11 22:42:06.000000000 +0200
@@ -915,7 +915,7 @@ static int watchdog_ioctl(struct inode *
 	return ret;
 }
 
-static struct file_operations watchdog_fops = {
+static const struct file_operations watchdog_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.open = watchdog_open,
diff -u -p a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c 2009-08-01 12:06:12.000000000 +0200
+++ b/drivers/lguest/lguest_user.c 2009-08-11 22:41:42.000000000 +0200
@@ -508,7 +508,7 @@ static int close(struct inode *inode, st
  * uses: reading and writing a character device called /dev/lguest.  All the
  * work happens in the read(), write() and close() routines:
  */
-static struct file_operations lguest_fops = {
+static const struct file_operations lguest_fops = {
 	.owner	 = THIS_MODULE,
 	.release = close,
 	.write	 = write,
diff -u -p a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/media/dvb/dvb-core/dmxdev.c 2009-08-11 22:42:24.000000000 +0200
@@ -1203,7 +1203,7 @@ static unsigned int dvb_dvr_poll(struct 
 	return mask;
 }
 
-static struct file_operations dvb_dvr_fops = {
+static const struct file_operations dvb_dvr_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_dvr_read,
 	.write = dvb_dvr_write,
diff -u -p a/drivers/media/dvb/firewire/firedtv-ci.c b/drivers/media/dvb/firewire/firedtv-ci.c
--- a/drivers/media/dvb/firewire/firedtv-ci.c 2009-03-02 11:33:15.000000000 +0100
+++ b/drivers/media/dvb/firewire/firedtv-ci.c 2009-08-11 22:42:21.000000000 +0200
@@ -215,7 +215,7 @@ static unsigned int fdtv_ca_io_poll(stru
 	return POLLIN;
 }
 
-static struct file_operations fdtv_ca_fops = {
+static const struct file_operations fdtv_ca_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= dvb_generic_ioctl,
 	.open		= dvb_generic_open,
diff -u -p a/drivers/misc/phantom.c b/drivers/misc/phantom.c
--- a/drivers/misc/phantom.c 2009-01-09 22:41:02.000000000 +0100
+++ b/drivers/misc/phantom.c 2009-08-11 22:41:49.000000000 +0200
@@ -271,7 +271,7 @@ static unsigned int phantom_poll(struct 
 	return mask;
 }
 
-static struct file_operations phantom_file_ops = {
+static const struct file_operations phantom_file_ops = {
 	.open = phantom_open,
 	.release = phantom_release,
 	.unlocked_ioctl = phantom_ioctl,
diff -u -p a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c 2009-07-18 21:09:26.000000000 +0200
+++ b/drivers/misc/sgi-gru/grufile.c 2009-08-11 22:41:49.000000000 +0200
@@ -53,7 +53,7 @@ struct gru_stats_s gru_stats;
 /* Guaranteed user available resources on each node */
 static int max_user_cbrs, max_user_dsr_bytes;
 
-static struct file_operations gru_fops;
+static const struct file_operations gru_fops;
 static struct miscdevice gru_miscdev;
 
 
@@ -426,7 +426,7 @@ static void __exit gru_exit(void)
 	gru_proc_exit();
 }
 
-static struct file_operations gru_fops = {
+static const struct file_operations gru_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= gru_file_unlocked_ioctl,
 	.mmap		= gru_file_mmap,
diff -u -p a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
--- a/drivers/mmc/core/debugfs.c 2009-04-13 16:04:29.000000000 +0200
+++ b/drivers/mmc/core/debugfs.c 2009-08-11 22:41:42.000000000 +0200
@@ -240,7 +240,7 @@ static int mmc_ext_csd_release(struct in
 	return 0;
 }
 
-static struct file_operations mmc_dbg_ext_csd_fops = {
+static const struct file_operations mmc_dbg_ext_csd_fops = {
 	.open		= mmc_ext_csd_open,
 	.read		= mmc_ext_csd_read,
 	.release	= mmc_ext_csd_release,
diff -u -p a/drivers/net/wireless/b43/debugfs.c b/drivers/net/wireless/b43/debugfs.c
--- a/drivers/net/wireless/b43/debugfs.c 2009-03-28 23:34:54.000000000 +0100
+++ b/drivers/net/wireless/b43/debugfs.c 2009-08-11 22:41:55.000000000 +0200
@@ -43,7 +43,7 @@ static struct dentry *rootdir;
 struct b43_debugfs_fops {
 	ssize_t (*read)(struct b43_wldev *dev, char *buf, size_t bufsize);
 	int (*write)(struct b43_wldev *dev, const char *buf, size_t count);
-	struct file_operations fops;
+	const struct file_operations fops;
 	/* Offset of struct b43_dfs_file in struct b43_dfsentry */
 	size_t file_struct_offset;
 	/* Take wl->irq_lock before calling read/write? */
diff -u -p a/drivers/net/wireless/b43legacy/debugfs.c b/drivers/net/wireless/b43legacy/debugfs.c
--- a/drivers/net/wireless/b43legacy/debugfs.c 2009-01-03 11:31:03.000000000 +0100
+++ b/drivers/net/wireless/b43legacy/debugfs.c 2009-08-11 22:42:05.000000000 +0200
@@ -44,7 +44,7 @@ static struct dentry *rootdir;
 struct b43legacy_debugfs_fops {
 	ssize_t (*read)(struct b43legacy_wldev *dev, char *buf, size_t bufsize);
 	int (*write)(struct b43legacy_wldev *dev, const char *buf, size_t count);
-	struct file_operations fops;
+	const struct file_operations fops;
 	/* Offset of struct b43legacy_dfs_file in struct b43legacy_dfsentry */
 	size_t file_struct_offset;
 	/* Take wl->irq_lock before calling read/write? */
diff -u -p a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
--- a/drivers/net/wireless/libertas/debugfs.c 2009-06-24 21:18:49.000000000 +0200
+++ b/drivers/net/wireless/libertas/debugfs.c 2009-08-11 22:41:57.000000000 +0200
@@ -682,7 +682,7 @@ out_unlock:
 struct lbs_debugfs_files {
 	const char *name;
 	int perm;
-	struct file_operations fops;
+	const struct file_operations fops;
 };
 
 static const struct lbs_debugfs_files debugfs_files[] = {
diff -u -p a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
--- a/drivers/s390/cio/qdio_debug.c 2009-08-11 22:10:21.000000000 +0200
+++ b/drivers/s390/cio/qdio_debug.c 2009-08-11 22:42:26.000000000 +0200
@@ -125,7 +125,7 @@ static int qstat_seq_open(struct inode *
 			   filp->f_path.dentry->d_inode->i_private);
 }
 
-static struct file_operations debugfs_fops = {
+static const struct file_operations debugfs_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = qstat_seq_open,
 	.read	 = seq_read,
diff -u -p a/drivers/s390/cio/qdio_perf.c b/drivers/s390/cio/qdio_perf.c
--- a/drivers/s390/cio/qdio_perf.c 2009-06-15 17:50:05.000000000 +0200
+++ b/drivers/s390/cio/qdio_perf.c 2009-08-11 22:42:26.000000000 +0200
@@ -84,7 +84,7 @@ static int qdio_perf_seq_open(struct ino
 	return single_open(filp, qdio_perf_proc_show, NULL);
 }
 
-static struct file_operations qdio_perf_proc_fops = {
+static const struct file_operations qdio_perf_proc_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = qdio_perf_seq_open,
 	.read	 = seq_read,
diff -u -p a/drivers/spi/spidev.c b/drivers/spi/spidev.c
--- a/drivers/spi/spidev.c 2009-07-04 21:27:34.000000000 +0200
+++ b/drivers/spi/spidev.c 2009-08-11 22:41:48.000000000 +0200
@@ -537,7 +537,7 @@ static int spidev_release(struct inode *
 	return status;
 }
 
-static struct file_operations spidev_fops = {
+static const struct file_operations spidev_fops = {
 	.owner =	THIS_MODULE,
 	/* REVISIT switch to aio primitives, so that userspace
 	 * gets more complete API coverage.  It'll simplify things
diff -u -p a/drivers/staging/b3dfg/b3dfg.c b/drivers/staging/b3dfg/b3dfg.c
--- a/drivers/staging/b3dfg/b3dfg.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/b3dfg/b3dfg.c 2009-08-11 22:42:22.000000000 +0200
@@ -847,7 +847,7 @@ static int b3dfg_mmap(struct file *filp,
 	return r;
 }
 
-static struct file_operations b3dfg_fops = {
+static const struct file_operations b3dfg_fops = {
 	.owner = THIS_MODULE,
 	.open = b3dfg_open,
 	.release = b3dfg_release,
diff -u -p a/drivers/staging/cpc-usb/cpc-usb_drv.c b/drivers/staging/cpc-usb/cpc-usb_drv.c
--- a/drivers/staging/cpc-usb/cpc-usb_drv.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/cpc-usb/cpc-usb_drv.c 2009-08-11 22:42:39.000000000 +0200
@@ -103,7 +103,7 @@ static void cpcusb_read_interrupt_callba
 
 static int cpcusb_setup_intrep(CPC_USB_T *card);
 
-static struct file_operations cpcusb_fops = {
+static const struct file_operations cpcusb_fops = {
 	/*
 	 * The owner field is part of the module-locking
 	 * mechanism. The idea is that the kernel knows
diff -u -p a/drivers/staging/dream/qdsp5/adsp_driver.c b/drivers/staging/dream/qdsp5/adsp_driver.c
--- a/drivers/staging/dream/qdsp5/adsp_driver.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/adsp_driver.c 2009-08-11 22:42:36.000000000 +0200
@@ -576,7 +576,7 @@ static struct adsp_device *inode_to_devi
 static dev_t adsp_devno;
 static struct class *adsp_class;
 
-static struct file_operations adsp_fops = {
+static const struct file_operations adsp_fops = {
 	.owner = THIS_MODULE,
 	.open = adsp_open,
 	.unlocked_ioctl = adsp_ioctl,
diff -u -p a/drivers/staging/dream/qdsp5/audio_aac.c b/drivers/staging/dream/qdsp5/audio_aac.c
--- a/drivers/staging/dream/qdsp5/audio_aac.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_aac.c 2009-08-11 22:42:37.000000000 +0200
@@ -1022,7 +1022,7 @@ done:
 	return rc;
 }
 
-static struct file_operations audio_aac_fops = {
+static const struct file_operations audio_aac_fops = {
 	.owner = THIS_MODULE,
 	.open = audio_open,
 	.release = audio_release,
diff -u -p a/drivers/staging/dream/qdsp5/audio_amrnb.c b/drivers/staging/dream/qdsp5/audio_amrnb.c
--- a/drivers/staging/dream/qdsp5/audio_amrnb.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_amrnb.c 2009-08-11 22:42:38.000000000 +0200
@@ -833,7 +833,7 @@ done:
 	return rc;
 }
 
-static struct file_operations audio_amrnb_fops = {
+static const struct file_operations audio_amrnb_fops = {
 	.owner = THIS_MODULE,
 	.open = audamrnb_open,
 	.release = audamrnb_release,
diff -u -p a/drivers/staging/dream/qdsp5/audio_evrc.c b/drivers/staging/dream/qdsp5/audio_evrc.c
--- a/drivers/staging/dream/qdsp5/audio_evrc.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_evrc.c 2009-08-11 22:42:36.000000000 +0200
@@ -805,7 +805,7 @@ dma_fail:
 	return rc;
 }
 
-static struct file_operations audio_evrc_fops = {
+static const struct file_operations audio_evrc_fops = {
 	.owner = THIS_MODULE,
 	.open = audevrc_open,
 	.release = audevrc_release,
diff -u -p a/drivers/staging/dream/qdsp5/audio_in.c b/drivers/staging/dream/qdsp5/audio_in.c
--- a/drivers/staging/dream/qdsp5/audio_in.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_in.c 2009-08-11 22:42:37.000000000 +0200
@@ -913,7 +913,7 @@ static int audpre_open(struct inode *ino
 	return 0;
 }
 
-static struct file_operations audio_fops = {
+static const struct file_operations audio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audio_in_open,
 	.release	= audio_in_release,
@@ -922,7 +922,7 @@ static struct file_operations audio_fops
 	.unlocked_ioctl	= audio_in_ioctl,
 };
 
-static struct file_operations audpre_fops = {
+static const struct file_operations audpre_fops = {
 	.owner          = THIS_MODULE,
 	.open           = audpre_open,
 	.unlocked_ioctl = audpre_ioctl,
diff -u -p a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
--- a/drivers/staging/dream/qdsp5/audio_mp3.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c 2009-08-11 22:42:36.000000000 +0200
@@ -941,7 +941,7 @@ done:
 	return rc;
 }
 
-static struct file_operations audio_mp3_fops = {
+static const struct file_operations audio_mp3_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audio_open,
 	.release	= audio_release,
diff -u -p a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
--- a/drivers/staging/dream/qdsp5/audio_out.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_out.c 2009-08-11 22:42:37.000000000 +0200
@@ -810,7 +810,7 @@ static int audpp_open(struct inode *inod
 	return 0;
 }
 
-static struct file_operations audio_fops = {
+static const struct file_operations audio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audio_open,
 	.release	= audio_release,
@@ -819,7 +819,7 @@ static struct file_operations audio_fops
 	.unlocked_ioctl	= audio_ioctl,
 };
 
-static struct file_operations audpp_fops = {
+static const struct file_operations audpp_fops = {
 	.owner		= THIS_MODULE,
 	.open		= audpp_open,
 	.unlocked_ioctl	= audpp_ioctl,
diff -u -p a/drivers/staging/dream/qdsp5/audio_qcelp.c b/drivers/staging/dream/qdsp5/audio_qcelp.c
--- a/drivers/staging/dream/qdsp5/audio_qcelp.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/audio_qcelp.c 2009-08-11 22:42:37.000000000 +0200
@@ -816,7 +816,7 @@ err:
 	return rc;
 }
 
-static struct file_operations audio_qcelp_fops = {
+static const struct file_operations audio_qcelp_fops = {
 	.owner = THIS_MODULE,
 	.open = audqcelp_open,
 	.release = audqcelp_release,
diff -u -p a/drivers/staging/dream/qdsp5/snd.c b/drivers/staging/dream/qdsp5/snd.c
--- a/drivers/staging/dream/qdsp5/snd.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/qdsp5/snd.c 2009-08-11 22:42:36.000000000 +0200
@@ -242,7 +242,7 @@ err:
 	return rc;
 }
 
-static struct file_operations snd_fops = {
+static const struct file_operations snd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= snd_open,
 	.release	= snd_release,
diff -u -p a/drivers/staging/dream/smd/smd_qmi.c b/drivers/staging/dream/smd/smd_qmi.c
--- a/drivers/staging/dream/smd/smd_qmi.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/smd/smd_qmi.c 2009-08-11 22:42:38.000000000 +0200
@@ -793,7 +793,7 @@ static int qmi_release(struct inode *ip,
 	return 0;
 }
 
-static struct file_operations qmi_fops = {
+static const struct file_operations qmi_fops = {
 	.owner = THIS_MODULE,
 	.read = qmi_read,
 	.write = qmi_write,
diff -u -p a/drivers/staging/dream/smd/smd_rpcrouter_device.c b/drivers/staging/dream/smd/smd_rpcrouter_device.c
--- a/drivers/staging/dream/smd/smd_rpcrouter_device.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/dream/smd/smd_rpcrouter_device.c 2009-08-11 22:42:38.000000000 +0200
@@ -214,7 +214,7 @@ static long rpcrouter_ioctl(struct file 
 	return rc;
 }
 
-static struct file_operations rpcrouter_server_fops = {
+static const struct file_operations rpcrouter_server_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rpcrouter_open,
 	.release = rpcrouter_release,
@@ -224,7 +224,7 @@ static struct file_operations rpcrouter_
 	.unlocked_ioctl	 = rpcrouter_ioctl,
 };
 
-static struct file_operations rpcrouter_router_fops = {
+static const struct file_operations rpcrouter_router_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = rpcrouter_open,
 	.release = rpcrouter_release,
diff -u -p a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
--- a/drivers/staging/panel/panel.c 2009-03-02 11:33:15.000000000 +0100
+++ b/drivers/staging/panel/panel.c 2009-08-11 22:42:38.000000000 +0200
@@ -1263,7 +1263,7 @@ static int lcd_release(struct inode *ino
 	return 0;
 }
 
-static struct file_operations lcd_fops = {
+static const struct file_operations lcd_fops = {
 	.write   = lcd_write,
 	.open    = lcd_open,
 	.release = lcd_release,
@@ -1519,7 +1519,7 @@ static int keypad_release(struct inode *
 	return 0;
 }
 
-static struct file_operations keypad_fops = {
+static const struct file_operations keypad_fops = {
 	.read    = keypad_read,		/* read */
 	.open    = keypad_open,		/* open */
 	.release = keypad_release,	/* close */
diff -u -p a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
--- a/drivers/staging/poch/poch.c 2009-02-16 21:07:00.000000000 +0100
+++ b/drivers/staging/poch/poch.c 2009-08-11 22:42:33.000000000 +0200
@@ -1056,7 +1056,7 @@ static int poch_ioctl(struct inode *inod
 	return 0;
 }
 
-static struct file_operations poch_fops = {
+static const struct file_operations poch_fops = {
 	.owner = THIS_MODULE,
 	.open = poch_open,
 	.release = poch_release,
diff -u -p a/drivers/staging/rtl8192e/ieee80211/proc.c b/drivers/staging/rtl8192e/ieee80211/proc.c
--- a/drivers/staging/rtl8192e/ieee80211/proc.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/rtl8192e/ieee80211/proc.c 2009-08-11 22:42:33.000000000 +0200
@@ -99,7 +99,7 @@ static int crypto_info_open(struct inode
 	return seq_open(file, &crypto_seq_ops);
 }
 
-static struct file_operations proc_crypto_ops = {
+static const struct file_operations proc_crypto_ops = {
 	.open		= crypto_info_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -u -p a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
--- a/drivers/staging/vme/devices/vme_user.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/staging/vme/devices/vme_user.c 2009-08-11 22:42:40.000000000 +0200
@@ -127,7 +127,7 @@ static int vme_user_ioctl(struct inode *
 
 static int __init vme_user_probe(struct device *dev);
 
-static struct file_operations vme_user_fops = {
+static const struct file_operations vme_user_fops = {
         .open = vme_user_open,
         .release = vme_user_release,
         .read = vme_user_read,
diff -u -p a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
--- a/drivers/usb/class/usbtmc.c 2009-08-11 22:10:22.000000000 +0200
+++ b/drivers/usb/class/usbtmc.c 2009-08-11 22:41:48.000000000 +0200
@@ -985,7 +985,7 @@ skip_io_on_zombie:
 	return retval;
 }
 
-static struct file_operations fops = {
+static const struct file_operations fops = {
 	.owner		= THIS_MODULE,
 	.read		= usbtmc_read,
 	.write		= usbtmc_write,
diff -u -p a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
--- a/drivers/usb/gadget/printer.c 2009-03-28 23:34:54.000000000 +0100
+++ b/drivers/usb/gadget/printer.c 2009-08-11 22:41:55.000000000 +0200
@@ -875,7 +875,7 @@ printer_ioctl(struct file *fd, unsigned 
 }
 
 /* used after endpoint configuration */
-static struct file_operations printer_io_operations = {
+static const struct file_operations printer_io_operations = {
 	.owner =	THIS_MODULE,
 	.open =		printer_open,
 	.read =		printer_read,
diff -u -p a/drivers/usb/host/whci/debug.c b/drivers/usb/host/whci/debug.c
--- a/drivers/usb/host/whci/debug.c 2009-01-03 11:31:04.000000000 +0100
+++ b/drivers/usb/host/whci/debug.c 2009-08-11 22:41:46.000000000 +0200
@@ -134,7 +134,7 @@ static int pzl_open(struct inode *inode,
 	return single_open(file, pzl_print, inode->i_private);
 }
 
-static struct file_operations di_fops = {
+static const struct file_operations di_fops = {
 	.open    = di_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -142,7 +142,7 @@ static struct file_operations di_fops = 
 	.owner   = THIS_MODULE,
 };
 
-static struct file_operations asl_fops = {
+static const struct file_operations asl_fops = {
 	.open    = asl_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -150,7 +150,7 @@ static struct file_operations asl_fops =
 	.owner   = THIS_MODULE,
 };
 
-static struct file_operations pzl_fops = {
+static const struct file_operations pzl_fops = {
 	.open    = pzl_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff -u -p a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
--- a/drivers/usb/misc/rio500.c 2009-07-18 21:09:26.000000000 +0200
+++ b/drivers/usb/misc/rio500.c 2009-08-11 22:41:41.000000000 +0200
@@ -429,7 +429,7 @@ read_rio(struct file *file, char __user 
 	return read_count;
 }
 
-static struct
+static const struct
 file_operations usb_rio_fops = {
 	.owner =	THIS_MODULE,
 	.read =		read_rio,
diff -u -p a/drivers/uwb/uwb-debug.c b/drivers/uwb/uwb-debug.c
--- a/drivers/uwb/uwb-debug.c 2009-01-03 11:31:04.000000000 +0100
+++ b/drivers/uwb/uwb-debug.c 2009-08-11 22:42:29.000000000 +0200
@@ -205,7 +205,7 @@ static ssize_t command_write(struct file
 	return ret < 0 ? ret : len;
 }
 
-static struct file_operations command_fops = {
+static const struct file_operations command_fops = {
 	.open   = command_open,
 	.write  = command_write,
 	.read   = NULL,
@@ -255,7 +255,7 @@ static int reservations_open(struct inod
 	return single_open(file, reservations_print, inode->i_private);
 }
 
-static struct file_operations reservations_fops = {
+static const struct file_operations reservations_fops = {
 	.open    = reservations_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
@@ -283,7 +283,7 @@ static int drp_avail_open(struct inode *
 	return single_open(file, drp_avail_print, inode->i_private);
 }
 
-static struct file_operations drp_avail_fops = {
+static const struct file_operations drp_avail_fops = {
 	.open    = drp_avail_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
diff -u -p a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h 2009-08-01 12:06:13.000000000 +0200
+++ b/fs/btrfs/ctree.h 2009-08-11 22:42:14.000000000 +0200
@@ -2286,7 +2286,7 @@ int btrfs_sync_file(struct file *file, s
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
-extern struct file_operations btrfs_file_operations;
+extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 locked_end,
diff -u -p a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h 2009-08-01 12:06:13.000000000 +0200
+++ b/fs/btrfs/ctree.h 2009-08-11 22:42:18.000000000 +0200
@@ -2286,7 +2286,7 @@ int btrfs_sync_file(struct file *file, s
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
-extern struct file_operations btrfs_file_operations;
+extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 locked_end,
diff -u -p a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
--- a/fs/btrfs/ctree.h 2009-08-01 12:06:13.000000000 +0200
+++ b/fs/btrfs/ctree.h 2009-08-11 22:42:20.000000000 +0200
@@ -2286,7 +2286,7 @@ int btrfs_sync_file(struct file *file, s
 int btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
 			    int skip_pinned);
 int btrfs_check_file(struct btrfs_root *root, struct inode *inode);
-extern struct file_operations btrfs_file_operations;
+extern const struct file_operations btrfs_file_operations;
 int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root, struct inode *inode,
 		       u64 start, u64 end, u64 locked_end,
diff -u -p a/fs/btrfs/file.c b/fs/btrfs/file.c
--- a/fs/btrfs/file.c 2009-07-18 21:09:26.000000000 +0200
+++ b/fs/btrfs/file.c 2009-08-11 22:42:19.000000000 +0200
@@ -1215,7 +1215,7 @@ static int btrfs_file_mmap(struct file	*
 	return 0;
 }
 
-struct file_operations btrfs_file_operations = {
+const struct file_operations btrfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.aio_read       = generic_file_aio_read,
diff -u -p a/fs/btrfs/inode.c b/fs/btrfs/inode.c
--- a/fs/btrfs/inode.c 2009-08-11 22:10:18.000000000 +0200
+++ b/fs/btrfs/inode.c 2009-08-11 22:42:15.000000000 +0200
@@ -62,7 +62,7 @@ static struct inode_operations btrfs_spe
 static struct inode_operations btrfs_file_inode_operations;
 static struct address_space_operations btrfs_aops;
 static struct address_space_operations btrfs_symlink_aops;
-static struct file_operations btrfs_dir_file_operations;
+static const struct file_operations btrfs_dir_file_operations;
 static struct extent_io_ops btrfs_extent_io_ops;
 
 static struct kmem_cache *btrfs_inode_cachep;
@@ -5216,7 +5216,7 @@ static struct inode_operations btrfs_dir
 	.lookup		= btrfs_lookup,
 	.permission	= btrfs_permission,
 };
-static struct file_operations btrfs_dir_file_operations = {
+static const struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= btrfs_real_readdir,
diff -u -p a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c 2009-08-11 22:10:22.000000000 +0200
+++ b/fs/ext4/mballoc.c 2009-08-11 22:42:15.000000000 +0200
@@ -2287,7 +2287,7 @@ static ssize_t ext4_mb_seq_history_write
 	return count;
 }
 
-static struct file_operations ext4_mb_seq_history_fops = {
+static const struct file_operations ext4_mb_seq_history_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ext4_mb_seq_history_open,
 	.read		= seq_read,
@@ -2387,7 +2387,7 @@ static int ext4_mb_seq_groups_open(struc
 
 }
 
-static struct file_operations ext4_mb_seq_groups_fops = {
+static const struct file_operations ext4_mb_seq_groups_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ext4_mb_seq_groups_open,
 	.read		= seq_read,
diff -u -p a/fs/jbd2/journal.c b/fs/jbd2/journal.c
--- a/fs/jbd2/journal.c 2009-07-18 21:09:26.000000000 +0200
+++ b/fs/jbd2/journal.c 2009-08-11 22:41:42.000000000 +0200
@@ -818,7 +818,7 @@ static int jbd2_seq_history_release(stru
 	return seq_release(inode, file);
 }
 
-static struct file_operations jbd2_seq_history_fops = {
+static const struct file_operations jbd2_seq_history_fops = {
 	.owner		= THIS_MODULE,
 	.open           = jbd2_seq_history_open,
 	.read           = seq_read,
@@ -920,7 +920,7 @@ static int jbd2_seq_info_release(struct 
 	return seq_release(inode, file);
 }
 
-static struct file_operations jbd2_seq_info_fops = {
+static const struct file_operations jbd2_seq_info_fops = {
 	.owner		= THIS_MODULE,
 	.open           = jbd2_seq_info_open,
 	.read           = seq_read,
diff -u -p a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
--- a/fs/nfsd/nfsctl.c 2009-08-11 22:10:22.000000000 +0200
+++ b/fs/nfsd/nfsctl.c 2009-08-11 22:41:47.000000000 +0200
@@ -175,7 +175,7 @@ static const struct file_operations expo
 
 extern int nfsd_pool_stats_open(struct inode *inode, struct file *file);
 
-static struct file_operations pool_stats_operations = {
+static const struct file_operations pool_stats_operations = {
 	.open		= nfsd_pool_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -u -p a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
--- a/fs/nilfs2/dir.c 2009-07-18 21:09:26.000000000 +0200
+++ b/fs/nilfs2/dir.c 2009-08-11 22:42:25.000000000 +0200
@@ -697,7 +697,7 @@ not_empty:
 	return 0;
 }
 
-struct file_operations nilfs_dir_operations = {
+const struct file_operations nilfs_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= nilfs_readdir,
diff -u -p a/fs/nilfs2/file.c b/fs/nilfs2/file.c
--- a/fs/nilfs2/file.c 2009-04-13 16:04:31.000000000 +0200
+++ b/fs/nilfs2/file.c 2009-08-11 22:42:25.000000000 +0200
@@ -134,7 +134,7 @@ static int nilfs_file_mmap(struct file *
  * We have mostly NULL's here: the current defaults are ok for
  * the nilfs filesystem.
  */
-struct file_operations nilfs_file_operations = {
+const struct file_operations nilfs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
diff -u -p a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
--- a/fs/nilfs2/mdt.c 2009-08-11 22:10:22.000000000 +0200
+++ b/fs/nilfs2/mdt.c 2009-08-11 22:42:25.000000000 +0200
@@ -438,7 +438,7 @@ static struct address_space_operations d
 };
 
 static struct inode_operations def_mdt_iops;
-static struct file_operations def_mdt_fops;
+static const struct file_operations def_mdt_fops;
 
 /*
  * NILFS2 uses pseudo inodes for meta data files such as DAT, cpfile, sufile,
diff -u -p a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h 2009-06-27 09:35:06.000000000 +0200
+++ b/fs/nilfs2/nilfs.h 2009-08-11 22:42:24.000000000 +0200
@@ -294,9 +294,9 @@ void nilfs_clear_gcdat_inode(struct the_
 /*
  * Inodes and files operations
  */
-extern struct file_operations nilfs_dir_operations;
+extern const struct file_operations nilfs_dir_operations;
 extern struct inode_operations nilfs_file_inode_operations;
-extern struct file_operations nilfs_file_operations;
+extern const struct file_operations nilfs_file_operations;
 extern struct address_space_operations nilfs_aops;
 extern struct inode_operations nilfs_dir_inode_operations;
 extern struct inode_operations nilfs_special_inode_operations;
diff -u -p a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h 2009-06-27 09:35:06.000000000 +0200
+++ b/fs/nilfs2/nilfs.h 2009-08-11 22:42:24.000000000 +0200
@@ -294,9 +294,9 @@ void nilfs_clear_gcdat_inode(struct the_
 /*
  * Inodes and files operations
  */
-extern struct file_operations nilfs_dir_operations;
+extern const struct file_operations nilfs_dir_operations;
 extern struct inode_operations nilfs_file_inode_operations;
-extern struct file_operations nilfs_file_operations;
+extern const struct file_operations nilfs_file_operations;
 extern struct address_space_operations nilfs_aops;
 extern struct inode_operations nilfs_dir_inode_operations;
 extern struct inode_operations nilfs_special_inode_operations;
diff -u -p a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h 2009-06-27 09:35:06.000000000 +0200
+++ b/fs/nilfs2/nilfs.h 2009-08-11 22:42:24.000000000 +0200
@@ -294,9 +294,9 @@ void nilfs_clear_gcdat_inode(struct the_
 /*
  * Inodes and files operations
  */
-extern struct file_operations nilfs_dir_operations;
+extern const struct file_operations nilfs_dir_operations;
 extern struct inode_operations nilfs_file_inode_operations;
-extern struct file_operations nilfs_file_operations;
+extern const struct file_operations nilfs_file_operations;
 extern struct address_space_operations nilfs_aops;
 extern struct inode_operations nilfs_dir_inode_operations;
 extern struct inode_operations nilfs_special_inode_operations;
diff -u -p a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h 2009-06-27 09:35:06.000000000 +0200
+++ b/fs/nilfs2/nilfs.h 2009-08-11 22:42:25.000000000 +0200
@@ -294,9 +294,9 @@ void nilfs_clear_gcdat_inode(struct the_
 /*
  * Inodes and files operations
  */
-extern struct file_operations nilfs_dir_operations;
+extern const struct file_operations nilfs_dir_operations;
 extern struct inode_operations nilfs_file_inode_operations;
-extern struct file_operations nilfs_file_operations;
+extern const struct file_operations nilfs_file_operations;
 extern struct address_space_operations nilfs_aops;
 extern struct inode_operations nilfs_dir_inode_operations;
 extern struct inode_operations nilfs_special_inode_operations;
diff -u -p a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h 2009-06-27 09:35:06.000000000 +0200
+++ b/fs/nilfs2/nilfs.h 2009-08-11 22:42:25.000000000 +0200
@@ -294,9 +294,9 @@ void nilfs_clear_gcdat_inode(struct the_
 /*
  * Inodes and files operations
  */
-extern struct file_operations nilfs_dir_operations;
+extern const struct file_operations nilfs_dir_operations;
 extern struct inode_operations nilfs_file_inode_operations;
-extern struct file_operations nilfs_file_operations;
+extern const struct file_operations nilfs_file_operations;
 extern struct address_space_operations nilfs_aops;
 extern struct inode_operations nilfs_dir_inode_operations;
 extern struct inode_operations nilfs_special_inode_operations;
diff -u -p a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c 2009-06-15 17:50:05.000000000 +0200
+++ b/fs/ocfs2/cluster/heartbeat.c 2009-08-11 22:42:02.000000000 +0200
@@ -966,7 +966,7 @@ static ssize_t o2hb_debug_read(struct fi
 }
 #endif  /* CONFIG_DEBUG_FS */
 
-static struct file_operations o2hb_debug_fops = {
+static const struct file_operations o2hb_debug_fops = {
 	.open =		o2hb_debug_open,
 	.release =	o2hb_debug_release,
 	.read =		o2hb_debug_read,
diff -u -p a/fs/ocfs2/cluster/netdebug.c b/fs/ocfs2/cluster/netdebug.c
--- a/fs/ocfs2/cluster/netdebug.c 2009-01-03 11:31:04.000000000 +0100
+++ b/fs/ocfs2/cluster/netdebug.c 2009-08-11 22:42:02.000000000 +0200
@@ -207,7 +207,7 @@ static int nst_fop_release(struct inode 
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations nst_seq_fops = {
+static const struct file_operations nst_seq_fops = {
 	.open = nst_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -388,7 +388,7 @@ static int sc_fop_release(struct inode *
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations sc_seq_fops = {
+static const struct file_operations sc_seq_fops = {
 	.open = sc_fop_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -u -p a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
--- a/fs/ocfs2/dlm/dlmdebug.c 2009-04-13 16:04:31.000000000 +0200
+++ b/fs/ocfs2/dlm/dlmdebug.c 2009-08-11 22:42:04.000000000 +0200
@@ -479,7 +479,7 @@ bail:
 	return -ENOMEM;
 }
 
-static struct file_operations debug_purgelist_fops = {
+static const struct file_operations debug_purgelist_fops = {
 	.open =		debug_purgelist_open,
 	.release =	debug_buffer_release,
 	.read =		debug_buffer_read,
@@ -539,7 +539,7 @@ bail:
 	return -ENOMEM;
 }
 
-static struct file_operations debug_mle_fops = {
+static const struct file_operations debug_mle_fops = {
 	.open =		debug_mle_open,
 	.release =	debug_buffer_release,
 	.read =		debug_buffer_read,
@@ -742,7 +742,7 @@ static int debug_lockres_release(struct 
 	return seq_release_private(inode, file);
 }
 
-static struct file_operations debug_lockres_fops = {
+static const struct file_operations debug_lockres_fops = {
 	.open =		debug_lockres_open,
 	.release =	debug_lockres_release,
 	.read =		seq_read,
@@ -926,7 +926,7 @@ bail:
 	return -ENOMEM;
 }
 
-static struct file_operations debug_state_fops = {
+static const struct file_operations debug_state_fops = {
 	.open =		debug_state_open,
 	.release =	debug_buffer_release,
 	.read =		debug_buffer_read,
diff -u -p a/fs/ocfs2/super.c b/fs/ocfs2/super.c
--- a/fs/ocfs2/super.c 2009-08-11 22:10:22.000000000 +0200
+++ b/fs/ocfs2/super.c 2009-08-11 22:42:08.000000000 +0200
@@ -373,7 +373,7 @@ static ssize_t ocfs2_debug_read(struct f
 }
 #endif	/* CONFIG_DEBUG_FS */
 
-static struct file_operations ocfs2_osb_debug_fops = {
+static const struct file_operations ocfs2_osb_debug_fops = {
 	.open =		ocfs2_osb_debug_open,
 	.release =	ocfs2_debug_release,
 	.read =		ocfs2_debug_read,
diff -u -p a/fs/omfs/dir.c b/fs/omfs/dir.c
--- a/fs/omfs/dir.c 2008-12-07 19:29:06.000000000 +0100
+++ b/fs/omfs/dir.c 2009-08-11 22:42:01.000000000 +0200
@@ -498,7 +498,7 @@ struct inode_operations omfs_dir_inops =
 	.rmdir = omfs_rmdir,
 };
 
-struct file_operations omfs_dir_operations = {
+const struct file_operations omfs_dir_operations = {
 	.read = generic_read_dir,
 	.readdir = omfs_readdir,
 	.llseek = generic_file_llseek,
diff -u -p a/fs/omfs/file.c b/fs/omfs/file.c
--- a/fs/omfs/file.c 2009-06-15 17:50:05.000000000 +0200
+++ b/fs/omfs/file.c 2009-08-11 22:42:01.000000000 +0200
@@ -322,7 +322,7 @@ static sector_t omfs_bmap(struct address
 	return generic_block_bmap(mapping, block, omfs_get_block);
 }
 
-struct file_operations omfs_file_operations = {
+const struct file_operations omfs_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.write = do_sync_write,
diff -u -p a/fs/omfs/omfs.h b/fs/omfs/omfs.h
--- a/fs/omfs/omfs.h 2008-12-07 19:29:06.000000000 +0100
+++ b/fs/omfs/omfs.h 2009-08-11 22:42:00.000000000 +0200
@@ -44,14 +44,14 @@ extern int omfs_allocate_range(struct su
 extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
 
 /* dir.c */
-extern struct file_operations omfs_dir_operations;
+extern const struct file_operations omfs_dir_operations;
 extern struct inode_operations omfs_dir_inops;
 extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
 extern int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header,
 			u64 fsblock);
 
 /* file.c */
-extern struct file_operations omfs_file_operations;
+extern const struct file_operations omfs_file_operations;
 extern struct inode_operations omfs_file_inops;
 extern struct address_space_operations omfs_aops;
 extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
diff -u -p a/fs/omfs/omfs.h b/fs/omfs/omfs.h
--- a/fs/omfs/omfs.h 2008-12-07 19:29:06.000000000 +0100
+++ b/fs/omfs/omfs.h 2009-08-11 22:42:00.000000000 +0200
@@ -44,14 +44,14 @@ extern int omfs_allocate_range(struct su
 extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
 
 /* dir.c */
-extern struct file_operations omfs_dir_operations;
+extern const struct file_operations omfs_dir_operations;
 extern struct inode_operations omfs_dir_inops;
 extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
 extern int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header,
 			u64 fsblock);
 
 /* file.c */
-extern struct file_operations omfs_file_operations;
+extern const struct file_operations omfs_file_operations;
 extern struct inode_operations omfs_file_inops;
 extern struct address_space_operations omfs_aops;
 extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
diff -u -p a/fs/omfs/omfs.h b/fs/omfs/omfs.h
--- a/fs/omfs/omfs.h 2008-12-07 19:29:06.000000000 +0100
+++ b/fs/omfs/omfs.h 2009-08-11 22:42:01.000000000 +0200
@@ -44,14 +44,14 @@ extern int omfs_allocate_range(struct su
 extern int omfs_clear_range(struct super_block *sb, u64 block, int count);
 
 /* dir.c */
-extern struct file_operations omfs_dir_operations;
+extern const struct file_operations omfs_dir_operations;
 extern struct inode_operations omfs_dir_inops;
 extern int omfs_make_empty(struct inode *inode, struct super_block *sb);
 extern int omfs_is_bad(struct omfs_sb_info *sbi, struct omfs_header *header,
 			u64 fsblock);
 
 /* file.c */
-extern struct file_operations omfs_file_operations;
+extern const struct file_operations omfs_file_operations;
 extern struct inode_operations omfs_file_inops;
 extern struct address_space_operations omfs_aops;
 extern void omfs_make_empty_table(struct buffer_head *bh, int offset);
diff -u -p a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
--- a/fs/ubifs/xattr.c 2009-06-27 09:35:06.000000000 +0200
+++ b/fs/ubifs/xattr.c 2009-08-11 22:42:24.000000000 +0200
@@ -80,7 +80,7 @@ enum {
 
 static struct inode_operations none_inode_operations;
 static struct address_space_operations none_address_operations;
-static struct file_operations none_file_operations;
+static const struct file_operations none_file_operations;
 
 /**
  * create_xattr - create an extended attribute.
diff -u -p a/kernel/cgroup.c b/kernel/cgroup.c
--- a/kernel/cgroup.c 2009-08-11 22:10:22.000000000 +0200
+++ b/kernel/cgroup.c 2009-08-11 22:41:53.000000000 +0200
@@ -597,7 +597,7 @@ static int cgroup_mkdir(struct inode *di
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
 static struct inode_operations cgroup_dir_inode_operations;
-static struct file_operations proc_cgroupstats_operations;
+static const struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
 	.name		= "cgroup",
@@ -1644,7 +1644,7 @@ static int cgroup_seqfile_release(struct
 	return single_release(inode, file);
 }
 
-static struct file_operations cgroup_seqfile_operations = {
+static const struct file_operations cgroup_seqfile_operations = {
 	.read = seq_read,
 	.write = cgroup_file_write,
 	.llseek = seq_lseek,
@@ -1703,7 +1703,7 @@ static int cgroup_rename(struct inode *o
 	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
-static struct file_operations cgroup_file_operations = {
+static const struct file_operations cgroup_file_operations = {
 	.read = cgroup_file_read,
 	.write = cgroup_file_write,
 	.llseek = generic_file_llseek,
@@ -2351,7 +2351,7 @@ static int cgroup_tasks_release(struct i
 	return seq_release(inode, file);
 }
 
-static struct file_operations cgroup_tasks_operations = {
+static const struct file_operations cgroup_tasks_operations = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.write = cgroup_file_write,
@@ -3017,7 +3017,7 @@ static int cgroup_open(struct inode *ino
 	return single_open(file, proc_cgroup_show, pid);
 }
 
-struct file_operations proc_cgroup_operations = {
+const struct file_operations proc_cgroup_operations = {
 	.open		= cgroup_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -3046,7 +3046,7 @@ static int cgroupstats_open(struct inode
 	return single_open(file, proc_cgroupstats_show, NULL);
 }
 
-static struct file_operations proc_cgroupstats_operations = {
+static const struct file_operations proc_cgroupstats_operations = {
 	.open = cgroupstats_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff -u -p a/kernel/kprobes.c b/kernel/kprobes.c
--- a/kernel/kprobes.c 2009-08-11 22:10:22.000000000 +0200
+++ b/kernel/kprobes.c 2009-08-11 22:42:18.000000000 +0200
@@ -1333,7 +1333,7 @@ static int __kprobes kprobes_open(struct
 	return seq_open(filp, &kprobes_seq_ops);
 }
 
-static struct file_operations debugfs_kprobes_operations = {
+static const struct file_operations debugfs_kprobes_operations = {
 	.open           = kprobes_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
@@ -1515,7 +1515,7 @@ static ssize_t write_enabled_file_bool(s
 	return count;
 }
 
-static struct file_operations fops_kp = {
+static const struct file_operations fops_kp = {
 	.read =         read_enabled_file_bool,
 	.write =        write_enabled_file_bool,
 };
diff -u -p a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
--- a/kernel/rcupreempt_trace.c 2009-01-03 11:31:05.000000000 +0100
+++ b/kernel/rcupreempt_trace.c 2009-08-11 22:42:23.000000000 +0200
@@ -261,17 +261,17 @@ static ssize_t rcuctrs_read(struct file 
 	return bcount;
 }
 
-static struct file_operations rcustats_fops = {
+static const struct file_operations rcustats_fops = {
 	.owner = THIS_MODULE,
 	.read = rcustats_read,
 };
 
-static struct file_operations rcugp_fops = {
+static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.read = rcugp_read,
 };
 
-static struct file_operations rcuctrs_fops = {
+static const struct file_operations rcuctrs_fops = {
 	.owner = THIS_MODULE,
 	.read = rcuctrs_read,
 };
diff -u -p a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
--- a/kernel/rcutree_trace.c 2009-06-15 17:50:05.000000000 +0200
+++ b/kernel/rcutree_trace.c 2009-08-11 22:41:49.000000000 +0200
@@ -88,7 +88,7 @@ static int rcudata_open(struct inode *in
 	return single_open(file, show_rcudata, NULL);
 }
 
-static struct file_operations rcudata_fops = {
+static const struct file_operations rcudata_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_open,
 	.read = seq_read,
@@ -136,7 +136,7 @@ static int rcudata_csv_open(struct inode
 	return single_open(file, show_rcudata_csv, NULL);
 }
 
-static struct file_operations rcudata_csv_fops = {
+static const struct file_operations rcudata_csv_fops = {
 	.owner = THIS_MODULE,
 	.open = rcudata_csv_open,
 	.read = seq_read,
@@ -183,7 +183,7 @@ static int rcuhier_open(struct inode *in
 	return single_open(file, show_rcuhier, NULL);
 }
 
-static struct file_operations rcuhier_fops = {
+static const struct file_operations rcuhier_fops = {
 	.owner = THIS_MODULE,
 	.open = rcuhier_open,
 	.read = seq_read,
@@ -205,7 +205,7 @@ static int rcugp_open(struct inode *inod
 	return single_open(file, show_rcugp, NULL);
 }
 
-static struct file_operations rcugp_fops = {
+static const struct file_operations rcugp_fops = {
 	.owner = THIS_MODULE,
 	.open = rcugp_open,
 	.read = seq_read,
@@ -255,7 +255,7 @@ static int rcu_pending_open(struct inode
 	return single_open(file, show_rcu_pending, NULL);
 }
 
-static struct file_operations rcu_pending_fops = {
+static const struct file_operations rcu_pending_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_pending_open,
 	.read = seq_read,
diff -u -p a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c 2009-08-11 22:10:22.000000000 +0200
+++ b/kernel/sched.c 2009-08-11 22:42:06.000000000 +0200
@@ -822,7 +822,7 @@ static int sched_feat_open(struct inode 
 	return single_open(filp, sched_feat_show, NULL);
 }
 
-static struct file_operations sched_feat_fops = {
+static const struct file_operations sched_feat_fops = {
 	.open		= sched_feat_open,
 	.write		= sched_feat_write,
 	.read		= seq_read,
diff -u -p a/kernel/time/timer_list.c b/kernel/time/timer_list.c
--- a/kernel/time/timer_list.c 2008-12-07 19:29:06.000000000 +0100
+++ b/kernel/time/timer_list.c 2009-08-11 22:41:49.000000000 +0200
@@ -275,7 +275,7 @@ static int timer_list_open(struct inode 
 	return single_open(filp, timer_list_show, NULL);
 }
 
-static struct file_operations timer_list_fops = {
+static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff -u -p a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
--- a/kernel/time/timer_stats.c 2009-07-04 21:27:34.000000000 +0200
+++ b/kernel/time/timer_stats.c 2009-08-11 22:41:49.000000000 +0200
@@ -395,7 +395,7 @@ static int tstats_open(struct inode *ino
 	return single_open(filp, tstats_show, NULL);
 }
 
-static struct file_operations tstats_fops = {
+static const struct file_operations tstats_fops = {
 	.open		= tstats_open,
 	.read		= seq_read,
 	.write		= tstats_write,
diff -u -p a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
--- a/net/ipv6/ip6mr.c 2009-08-11 22:10:22.000000000 +0200
+++ b/net/ipv6/ip6mr.c 2009-08-11 22:41:43.000000000 +0200
@@ -217,7 +217,7 @@ static int ip6mr_vif_open(struct inode *
 			    sizeof(struct ipmr_vif_iter));
 }
 
-static struct file_operations ip6mr_vif_fops = {
+static const struct file_operations ip6mr_vif_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = ip6mr_vif_open,
 	.read    = seq_read,
@@ -341,7 +341,7 @@ static int ipmr_mfc_open(struct inode *i
 			    sizeof(struct ipmr_mfc_iter));
 }
 
-static struct file_operations ip6mr_mfc_fops = {
+static const struct file_operations ip6mr_mfc_fops = {
 	.owner	 = THIS_MODULE,
 	.open    = ipmr_mfc_open,
 	.read    = seq_read,
diff -u -p a/net/irda/irproc.c b/net/irda/irproc.c
--- a/net/irda/irproc.c 2009-04-13 16:04:31.000000000 +0200
+++ b/net/irda/irproc.c 2009-08-11 22:42:03.000000000 +0200
@@ -34,15 +34,15 @@
 #include <net/irda/irlap.h>
 #include <net/irda/irlmp.h>
 
-extern struct file_operations discovery_seq_fops;
-extern struct file_operations irlap_seq_fops;
-extern struct file_operations irlmp_seq_fops;
-extern struct file_operations irttp_seq_fops;
-extern struct file_operations irias_seq_fops;
+extern const struct file_operations discovery_seq_fops;
+extern const struct file_operations irlap_seq_fops;
+extern const struct file_operations irlmp_seq_fops;
+extern const struct file_operations irttp_seq_fops;
+extern const struct file_operations irias_seq_fops;
 
 struct irda_entry {
 	const char *name;
-	struct file_operations *fops;
+	const struct file_operations *fops;
 };
 
 struct proc_dir_entry *proc_irda;
diff -u -p a/net/key/af_key.c b/net/key/af_key.c
--- a/net/key/af_key.c 2009-06-24 21:18:51.000000000 +0200
+++ b/net/key/af_key.c 2009-08-11 22:42:07.000000000 +0200
@@ -3718,7 +3718,7 @@ static int pfkey_seq_open(struct inode *
 			    sizeof(struct seq_net_private));
 }
 
-static struct file_operations pfkey_proc_ops = {
+static const struct file_operations pfkey_proc_ops = {
 	.open	 = pfkey_seq_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
diff -u -p a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
--- a/net/mac80211/rc80211_minstrel_debugfs.c 2008-12-07 19:29:04.000000000 +0100
+++ b/net/mac80211/rc80211_minstrel_debugfs.c 2009-08-11 22:41:53.000000000 +0200
@@ -139,7 +139,7 @@ minstrel_stats_release(struct inode *ino
 	return 0;
 }
 
-static struct file_operations minstrel_stat_fops = {
+static const struct file_operations minstrel_stat_fops = {
 	.owner = THIS_MODULE,
 	.open = minstrel_stats_open,
 	.read = minstrel_stats_read,
diff -u -p a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
--- a/net/mac80211/rc80211_pid_debugfs.c 2009-01-03 11:31:05.000000000 +0100
+++ b/net/mac80211/rc80211_pid_debugfs.c 2009-08-11 22:41:54.000000000 +0200
@@ -198,7 +198,7 @@ static ssize_t rate_control_pid_events_r
 
 #undef RC_PID_PRINT_BUF_SIZE
 
-static struct file_operations rc_pid_fop_events = {
+static const struct file_operations rc_pid_fop_events = {
 	.owner = THIS_MODULE,
 	.read = rate_control_pid_events_read,
 	.poll = rate_control_pid_events_poll,
diff -u -p a/net/xfrm/xfrm_proc.c b/net/xfrm/xfrm_proc.c
--- a/net/xfrm/xfrm_proc.c 2009-01-03 11:31:05.000000000 +0100
+++ b/net/xfrm/xfrm_proc.c 2009-08-11 22:42:30.000000000 +0200
@@ -60,7 +60,7 @@ static int xfrm_statistics_seq_open(stru
 	return single_open_net(inode, file, xfrm_statistics_seq_show);
 }
 
-static struct file_operations xfrm_statistics_seq_fops = {
+static const struct file_operations xfrm_statistics_seq_fops = {
 	.owner	 = THIS_MODULE,
 	.open	 = xfrm_statistics_seq_open,
 	.read	 = seq_read,
diff -u -p a/samples/markers/marker-example.c b/samples/markers/marker-example.c
--- a/samples/markers/marker-example.c 2009-01-09 22:41:02.000000000 +0100
+++ b/samples/markers/marker-example.c 2009-08-11 22:42:14.000000000 +0200
@@ -26,7 +26,7 @@ static int my_open(struct inode *inode, 
 	return -EPERM;
 }
 
-static struct file_operations mark_ops = {
+static const struct file_operations mark_ops = {
 	.open = my_open,
 };
 
diff -u -p a/samples/tracepoints/tracepoint-sample.c b/samples/tracepoints/tracepoint-sample.c
--- a/samples/tracepoints/tracepoint-sample.c 2009-04-13 16:04:31.000000000 +0200
+++ b/samples/tracepoints/tracepoint-sample.c 2009-08-11 22:42:14.000000000 +0200
@@ -28,7 +28,7 @@ static int my_open(struct inode *inode, 
 	return -EPERM;
 }
 
-static struct file_operations mark_ops = {
+static const struct file_operations mark_ops = {
 	.open = my_open,
 };
 
diff -u -p a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c 2009-06-15 17:50:05.000000000 +0200
+++ b/scripts/mod/file2alias.c 2009-08-11 22:42:15.000000000 +0200
@@ -530,7 +530,7 @@ static void do_input(char *alias,
 }
 
 /* input:b0v0p0e0-eXkXrXaXmXlXsXfXwX where X is comma-separated %02X. */
-static int do_input_entry(const char *filename, struct input_device_id *id,
+static int do_input_entry(const char *filename, const struct input_device_id *id,
 			  char *alias)
 {
 	sprintf(alias, "input:");
diff -u -p a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
--- a/security/integrity/ima/ima_fs.c 2009-06-15 17:50:05.000000000 +0200
+++ b/security/integrity/ima/ima_fs.c 2009-08-11 22:42:15.000000000 +0200
@@ -43,7 +43,7 @@ static ssize_t ima_show_htable_violation
 	return ima_show_htable_value(buf, count, ppos, &ima_htable.violations);
 }
 
-static struct file_operations ima_htable_violations_ops = {
+static const struct file_operations ima_htable_violations_ops = {
 	.read = ima_show_htable_violations
 };
 
@@ -55,7 +55,7 @@ static ssize_t ima_show_measurements_cou
 
 }
 
-static struct file_operations ima_measurements_count_ops = {
+static const struct file_operations ima_measurements_count_ops = {
 	.read = ima_show_measurements_count
 };
 
@@ -158,7 +158,7 @@ static int ima_measurements_open(struct 
 	return seq_open(file, &ima_measurments_seqops);
 }
 
-static struct file_operations ima_measurements_ops = {
+static const struct file_operations ima_measurements_ops = {
 	.open = ima_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -233,7 +233,7 @@ static int ima_ascii_measurements_open(s
 	return seq_open(file, &ima_ascii_measurements_seqops);
 }
 
-static struct file_operations ima_ascii_measurements_ops = {
+static const struct file_operations ima_ascii_measurements_ops = {
 	.open = ima_ascii_measurements_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
@@ -313,7 +313,7 @@ static int ima_release_policy(struct ino
 	return 0;
 }
 
-static struct file_operations ima_measure_policy_ops = {
+static const struct file_operations ima_measure_policy_ops = {
 	.open = ima_open_policy,
 	.write = ima_write_policy,
 	.release = ima_release_policy
diff -u -p a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
--- a/sound/oss/au1550_ac97.c 2009-03-28 23:34:55.000000000 +0100
+++ b/sound/oss/au1550_ac97.c 2009-08-11 22:42:25.000000000 +0200
@@ -831,7 +831,7 @@ au1550_ioctl_mixdev(struct inode *inode,
 	return mixdev_ioctl(codec, cmd, arg);
 }
 
-static /*const */ struct file_operations au1550_mixer_fops = {
+static /*const */ const struct file_operations au1550_mixer_fops = {
 	owner:THIS_MODULE,
 	llseek:au1550_llseek,
 	ioctl:au1550_ioctl_mixdev,
@@ -1880,7 +1880,7 @@ au1550_release(struct inode *inode, stru
 	return 0;
 }
 
-static /*const */ struct file_operations au1550_audio_fops = {
+static /*const */ const struct file_operations au1550_audio_fops = {
 	owner:		THIS_MODULE,
 	llseek:		au1550_llseek,
 	read:		au1550_read,
