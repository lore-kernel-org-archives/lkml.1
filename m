Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYH1Ahj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYH1Ahj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbYH1Aha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:37:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418AbYH1AhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:37:21 -0400
Date: Wed, 27 Aug 2008 17:35:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <alpine.LFD.1.10.0808271611230.3419@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808271729410.3419@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <20080827230828.4285022b@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808271530350.3419@nehalem.linux-foundation.org>
 <20080827232803.2ba8dd96@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808271551380.3419@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808271611230.3419@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Linus Torvalds wrote:
> 
> Hmm. compat_ioctl() actually has exactly the same issue. Damn.
> 
> So you can't just add the new argument, you also have to _pass_ the 
> argument in the compat_ioctl handlers to the non-compat ones.

What the hell. Here's a test patch. A largish part of it was generated 
through a stupid script that basically did a number of grep + 'sed' on a 
lot of files, and then the rest was fixed up manually after running "make 
allmodconfig".

I'm not going to guarantee anything, but it gets close. A starting point 
for somebody else, and considering that it is

 208 files changed, 370 insertions(+), 376 deletions(-)

this is definitely linux-next material.

The extra deletions are mainly because the passing of "inode" as an 
argument means that some functions don't need to look it up manually any 
more.

And yeah, I changed the return type to "int". There's no way the kernel 
can validly return anything bigger than that anyway. And this way all the 
ioctl functions have the same type, no confusion.

TOTALLY UNTESTED apart from the fact that it compiles.

			Linus

---
 arch/mips/sibyte/common/sb_tbprof.c   |    2 +-
 arch/parisc/kernel/perf.c             |    4 +-
 arch/sparc/kernel/apc.c               |    2 +-
 arch/x86/kernel/apm_32.c              |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c   |    2 +-
 arch/x86/kernel/cpu/mtrr/if.c         |    3 +-
 block/bsg.c                           |    2 +-
 block/compat_ioctl.c                  |   18 +++++++++++-----
 block/ioctl.c                         |    3 +-
 drivers/block/DAC960.c                |    2 +-
 drivers/block/cciss.c                 |    4 +-
 drivers/block/loop.c                  |    3 +-
 drivers/block/paride/pt.c             |    4 +-
 drivers/char/agp/agp.h                |    2 +-
 drivers/char/agp/compat_ioctl.c       |    2 +-
 drivers/char/agp/frontend.c           |    2 +-
 drivers/char/ds1302.c                 |    2 +-
 drivers/char/dsp56k.c                 |    2 +-
 drivers/char/efirtc.c                 |    4 +-
 drivers/char/ip2/ip2main.c            |    6 ++--
 drivers/char/ip27-rtc.c               |    4 +-
 drivers/char/ipmi/ipmi_devintf.c      |    2 +-
 drivers/char/mmtimer.c                |    4 +-
 drivers/char/mwave/mwavedd.c          |    4 +-
 drivers/char/pcmcia/cm4000_cs.c       |    3 +-
 drivers/char/ppdev.c                  |    2 +-
 drivers/char/random.c                 |    2 +-
 drivers/char/rio/rio_linux.c          |    4 +-
 drivers/char/rtc.c                    |    4 +-
 drivers/char/sx.c                     |    4 +-
 drivers/char/tty_io.c                 |   14 +++++-------
 drivers/char/viotape.c                |    2 +-
 drivers/firewire/fw-cdev.c            |    8 +++---
 drivers/gpu/drm/i915/i915_drv.h       |    2 +-
 drivers/gpu/drm/i915/i915_ioc32.c     |    2 +-
 drivers/gpu/drm/mga/mga_drv.h         |    2 +-
 drivers/gpu/drm/mga/mga_ioc32.c       |    2 +-
 drivers/gpu/drm/r128/r128_drv.h       |    2 +-
 drivers/gpu/drm/r128/r128_ioc32.c     |    2 +-
 drivers/gpu/drm/radeon/radeon_drv.h   |    2 +-
 drivers/gpu/drm/radeon/radeon_ioc32.c |    2 +-
 drivers/hid/hidraw.c                  |    3 +-
 drivers/hid/usbhid/hiddev.c           |    6 ++--
 drivers/i2c/i2c-dev.c                 |    2 +-
 drivers/ieee1394/dv1394.c             |   20 +++++++++---------
 drivers/ieee1394/raw1394.c            |    4 +-
 drivers/ieee1394/video1394.c          |   34 ++++++++++++++++----------------
 drivers/infiniband/core/user_mad.c    |    4 +-
 drivers/input/evdev.c                 |    4 +-
 drivers/input/joydev.c                |    4 +-
 drivers/input/misc/uinput.c           |    2 +-
 drivers/md/dm-ioctl.c                 |    6 ++--
 drivers/media/video/compat_ioctl32.c  |   26 ++++++++++++------------
 drivers/message/fusion/mptctl.c       |    8 +++---
 drivers/message/i2o/i2o_config.c      |    2 +-
 drivers/misc/phantom.c                |    6 ++--
 drivers/misc/sgi-gru/grufile.c        |    2 +-
 drivers/net/ppp_generic.c             |    2 +-
 drivers/pci/proc.c                    |    2 +-
 drivers/rtc/rtc-dev.c                 |    2 +-
 drivers/s390/block/dasd_int.h         |    2 +-
 drivers/s390/char/tape_char.c         |    2 +-
 drivers/s390/char/vmcp.c              |    2 +-
 drivers/s390/cio/chsc_sch.c           |    2 +-
 drivers/s390/crypto/zcrypt_api.c      |    4 +-
 drivers/s390/scsi/zfcp_cfdc.c         |    2 +-
 drivers/sbus/char/cpwatchdog.c        |    2 +-
 drivers/sbus/char/display7seg.c       |    2 +-
 drivers/sbus/char/openprom.c          |    2 +-
 drivers/scsi/aacraid/linit.c          |    2 +-
 drivers/scsi/ch.c                     |    6 ++--
 drivers/scsi/dpt_i2o.c                |    7 +----
 drivers/scsi/megaraid/megaraid_mm.c   |   10 ++++----
 drivers/scsi/megaraid/megaraid_sas.c  |   10 ++++----
 drivers/scsi/osst.c                   |    2 +-
 drivers/scsi/sd.c                     |    2 +-
 drivers/scsi/sg.c                     |    2 +-
 drivers/scsi/st.c                     |    4 +-
 drivers/spi/spidev.c                  |    4 +-
 drivers/telephony/ixj.c               |    2 +-
 drivers/usb/class/usblp.c             |    2 +-
 drivers/usb/gadget/inode.c            |    6 ++--
 drivers/usb/gadget/printer.c          |    4 +-
 drivers/usb/misc/iowarrior.c          |    2 +-
 drivers/usb/misc/rio500.c             |    2 +-
 drivers/usb/misc/sisusbvga/sisusb.c   |   10 ++++----
 drivers/usb/misc/usblcd.c             |    2 +-
 drivers/video/fbmem.c                 |    4 +--
 drivers/watchdog/acquirewdt.c         |    2 +-
 drivers/watchdog/advantechwdt.c       |    2 +-
 drivers/watchdog/alim1535_wdt.c       |    2 +-
 drivers/watchdog/alim7101_wdt.c       |    2 +-
 drivers/watchdog/ar7_wdt.c            |    2 +-
 drivers/watchdog/at32ap700x_wdt.c     |    2 +-
 drivers/watchdog/at91rm9200_wdt.c     |    2 +-
 drivers/watchdog/bfin_wdt.c           |    2 +-
 drivers/watchdog/booke_wdt.c          |    2 +-
 drivers/watchdog/cpu5wdt.c            |    2 +-
 drivers/watchdog/davinci_wdt.c        |    2 +-
 drivers/watchdog/ep93xx_wdt.c         |    2 +-
 drivers/watchdog/eurotechwdt.c        |    2 +-
 drivers/watchdog/hpwdt.c              |    2 +-
 drivers/watchdog/i6300esb.c           |    2 +-
 drivers/watchdog/iTCO_wdt.c           |    2 +-
 drivers/watchdog/ib700wdt.c           |    2 +-
 drivers/watchdog/ibmasr.c             |    2 +-
 drivers/watchdog/indydog.c            |    2 +-
 drivers/watchdog/iop_wdt.c            |    2 +-
 drivers/watchdog/it8712f_wdt.c        |    2 +-
 drivers/watchdog/ixp2000_wdt.c        |    2 +-
 drivers/watchdog/ixp4xx_wdt.c         |    2 +-
 drivers/watchdog/ks8695_wdt.c         |    2 +-
 drivers/watchdog/machzwd.c            |    2 +-
 drivers/watchdog/mixcomwd.c           |    2 +-
 drivers/watchdog/mpc5200_wdt.c        |    2 +-
 drivers/watchdog/mpc8xxx_wdt.c        |    2 +-
 drivers/watchdog/mpcore_wdt.c         |    2 +-
 drivers/watchdog/mtx-1_wdt.c          |    2 +-
 drivers/watchdog/mv64x60_wdt.c        |    2 +-
 drivers/watchdog/omap_wdt.c           |    2 +-
 drivers/watchdog/pc87413_wdt.c        |    2 +-
 drivers/watchdog/pcwd.c               |    2 +-
 drivers/watchdog/pcwd_pci.c           |    2 +-
 drivers/watchdog/pcwd_usb.c           |    2 +-
 drivers/watchdog/pnx4008_wdt.c        |    2 +-
 drivers/watchdog/rm9k_wdt.c           |    4 +-
 drivers/watchdog/s3c2410_wdt.c        |    2 +-
 drivers/watchdog/sa1100_wdt.c         |    2 +-
 drivers/watchdog/sb_wdog.c            |    2 +-
 drivers/watchdog/sbc60xxwdt.c         |    2 +-
 drivers/watchdog/sbc7240_wdt.c        |    2 +-
 drivers/watchdog/sbc_epx_c3.c         |    2 +-
 drivers/watchdog/sc1200wdt.c          |    2 +-
 drivers/watchdog/sc520_wdt.c          |    2 +-
 drivers/watchdog/scx200_wdt.c         |    2 +-
 drivers/watchdog/shwdt.c              |    2 +-
 drivers/watchdog/smsc37b787_wdt.c     |    2 +-
 drivers/watchdog/softdog.c            |    2 +-
 drivers/watchdog/txx9wdt.c            |    2 +-
 drivers/watchdog/w83627hf_wdt.c       |    2 +-
 drivers/watchdog/w83697hf_wdt.c       |    2 +-
 drivers/watchdog/w83877f_wdt.c        |    2 +-
 drivers/watchdog/w83977f_wdt.c        |    2 +-
 drivers/watchdog/wafer5823wdt.c       |    2 +-
 drivers/watchdog/wdrtas.c             |    2 +-
 drivers/watchdog/wdt.c                |    2 +-
 drivers/watchdog/wdt285.c             |    2 +-
 drivers/watchdog/wdt977.c             |    2 +-
 drivers/watchdog/wdt_pci.c            |    2 +-
 fs/bad_inode.c                        |    4 +-
 fs/block_dev.c                        |    7 +++++-
 fs/cifs/cifsfs.h                      |    2 +-
 fs/cifs/ioctl.c                       |    3 +-
 fs/compat_ioctl.c                     |    3 +-
 fs/ext2/ext2.h                        |    4 +-
 fs/ext2/ioctl.c                       |    7 ++---
 fs/ext3/ioctl.c                       |    3 +-
 fs/ext4/ext4.h                        |    4 +-
 fs/ext4/ioctl.c                       |    7 ++---
 fs/fat/dir.c                          |    3 +-
 fs/gfs2/ops_file.c                    |    2 +-
 fs/inotify_user.c                     |    2 +-
 fs/ioctl.c                            |    8 +++---
 fs/jffs2/ioctl.c                      |    2 +-
 fs/jffs2/os-linux.h                   |    2 +-
 fs/jfs/ioctl.c                        |    7 ++---
 fs/jfs/jfs_inode.h                    |    4 +-
 fs/ncpfs/ioctl.c                      |    3 +-
 fs/ocfs2/ioctl.c                      |    7 ++---
 fs/ocfs2/ioctl.h                      |    4 +-
 fs/pipe.c                             |    3 +-
 fs/proc/inode.c                       |   14 ++++++------
 fs/reiserfs/ioctl.c                   |    3 +-
 fs/ubifs/ioctl.c                      |    7 ++---
 fs/ubifs/ubifs.h                      |    4 +-
 fs/xfs/linux-2.6/xfs_file.c           |    8 +++---
 fs/xfs/linux-2.6/xfs_ioctl32.c        |    6 +++-
 fs/xfs/linux-2.6/xfs_ioctl32.h        |    4 +-
 include/linux/ext3_fs.h               |    2 +-
 include/linux/fs.h                    |   10 ++++----
 include/linux/ncp_fs.h                |    2 +-
 include/linux/reiserfs_fs.h           |    2 +-
 include/linux/tty.h                   |    2 +-
 include/linux/wanrouter.h             |    2 +-
 include/media/v4l2-ioctl.h            |    2 +-
 kernel/power/user.c                   |    2 +-
 net/irda/irnet/irnet_ppp.c            |    3 +-
 net/irda/irnet/irnet_ppp.h            |    5 ++-
 net/socket.c                          |    8 +++---
 net/wanrouter/wanmain.c               |    3 +-
 sound/core/control.c                  |    2 +-
 sound/core/control_compat.c           |    4 +-
 sound/core/hwdep.c                    |    2 +-
 sound/core/hwdep_compat.c             |    4 +-
 sound/core/info.c                     |    2 +-
 sound/core/init.c                     |    2 +-
 sound/core/oss/mixer_oss.c            |    2 +-
 sound/core/oss/pcm_oss.c              |    2 +-
 sound/core/pcm_compat.c               |    2 +-
 sound/core/pcm_native.c               |    4 +-
 sound/core/rawmidi.c                  |    2 +-
 sound/core/rawmidi_compat.c           |    4 +-
 sound/core/seq/oss/seq_oss.c          |    6 ++--
 sound/core/seq/seq_clientmgr.c        |    2 +-
 sound/core/seq/seq_compat.c           |    2 +-
 sound/core/timer.c                    |    2 +-
 sound/core/timer_compat.c             |    4 +-
 virt/kvm/kvm_main.c                   |    8 +++---
 208 files changed, 370 insertions(+), 376 deletions(-)

diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index 66e3e3f..5419f85 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -507,7 +507,7 @@ static ssize_t sbprof_tb_read(struct file *filp, char *buf,
 	return count;
 }
 
-static long sbprof_tb_ioctl(struct file *filp,
+static int sbprof_tb_ioctl(struct inode *inode, struct file *filp,
 			    unsigned int command,
 			    unsigned long arg)
 {
diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
index f696f57..6d98acc 100644
--- a/arch/parisc/kernel/perf.c
+++ b/arch/parisc/kernel/perf.c
@@ -198,7 +198,7 @@ static int perf_open(struct inode *inode, struct file *file);
 static ssize_t perf_read(struct file *file, char __user *buf, size_t cnt, loff_t *ppos);
 static ssize_t perf_write(struct file *file, const char __user *buf, size_t count, 
 	loff_t *ppos);
-static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static int perf_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 static void perf_start_counters(void);
 static int perf_stop_counters(uint32_t *raddr);
 static const struct rdr_tbl_ent * perf_rdr_get_entry(uint32_t rdr_num);
@@ -442,7 +442,7 @@ static void perf_patch_images(void)
  * must be running on the processor that you wish to change.
  */
 
-static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int perf_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long error_start;
 	uint32_t raddr[4];
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 5267d48..d49a35a 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -85,7 +85,7 @@ static int apc_release(struct inode *inode, struct file *f)
 	return 0;
 }
 
-static long apc_ioctl(struct file *f, unsigned int cmd, unsigned long __arg)
+static int apc_ioctl(struct inode *inode, struct file *f, unsigned int cmd, unsigned long __arg)
 {
 	__u8 inarg, __user *arg;
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 9ee24e6..329e4c5 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1460,7 +1460,7 @@ static unsigned int do_poll(struct file *fp, poll_table *wait)
 	return 0;
 }
 
-static long do_ioctl(struct file *filp, u_int cmd, u_long arg)
+static int do_ioctl(struct inode *inode, struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as;
 	int ret;
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 726a5fc..91f970f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -645,7 +645,7 @@ static unsigned int mce_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
-static long mce_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static int mce_ioctl(struct inode *inode, struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int __user *p = (int __user *)arg;
 
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index 84c480b..d6b053b 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -145,8 +145,7 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	return -EINVAL;
 }
 
-static long
-mtrr_ioctl(struct file *file, unsigned int cmd, unsigned long __arg)
+static int mtrr_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long __arg)
 {
 	int err = 0;
 	mtrr_type type;
diff --git a/block/bsg.c b/block/bsg.c
index 0aae8d7..1ec2e02 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -872,7 +872,7 @@ static unsigned int bsg_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct bsg_device *bd = file->private_data;
 	int __user *uarg = (int __user *) arg;
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index c23177e..2c32818 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -709,7 +709,7 @@ static int compat_blkdev_driver_ioctl(struct inode *inode, struct file *file,
 	}
 
 	if (disk->fops->unlocked_ioctl)
-		return disk->fops->unlocked_ioctl(file, cmd, arg);
+		return disk->fops->unlocked_ioctl(inode, file, cmd, arg);
 
 	if (disk->fops->ioctl) {
 		lock_kernel();
@@ -773,10 +773,16 @@ static int compat_blkdev_locked_ioctl(struct inode *inode, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-/* Most of the generic ioctls are handled in the normal fallback path.
-   This assumes the blkdev's low level compat_ioctl always returns
-   ENOIOCTLCMD for unknown ioctls. */
-long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+/*
+ * Most of the generic ioctls are handled in the normal fallback path.
+ * This assumes the blkdev's low level compat_ioctl always returns
+ * ENOIOCTLCMD for unknown ioctls.
+ *
+ * NOTE! We ignore the on-disk inode that was passed as
+ * an argument, and use the "f_mapping->host" inode for
+ * all block ioctls!
+ */
+int compat_blkdev_ioctl(struct inode *unused, struct file *file, unsigned cmd, unsigned long arg)
 {
 	int ret = -ENOIOCTLCMD;
 	struct inode *inode = file->f_mapping->host;
@@ -806,7 +812,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	ret = compat_blkdev_locked_ioctl(inode, file, bdev, cmd, arg);
 	/* FIXME: why do we assume -> compat_ioctl needs the BKL? */
 	if (ret == -ENOIOCTLCMD && disk->fops->compat_ioctl)
-		ret = disk->fops->compat_ioctl(file, cmd, arg);
+		ret = disk->fops->compat_ioctl(inode, file, cmd, arg);
 	unlock_kernel();
 
 	if (ret != -ENOIOCTLCMD)
diff --git a/block/ioctl.c b/block/ioctl.c
index 77185e5..a85824e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -204,8 +204,9 @@ int blkdev_driver_ioctl(struct inode *inode, struct file *file,
 			struct gendisk *disk, unsigned cmd, unsigned long arg)
 {
 	int ret;
+
 	if (disk->fops->unlocked_ioctl)
-		return disk->fops->unlocked_ioctl(file, cmd, arg);
+		return disk->fops->unlocked_ioctl(inode, file, cmd, arg);
 
 	if (disk->fops->ioctl) {
 		lock_kernel();
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index a002a38..972539d 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6628,7 +6628,7 @@ static void DAC960_DestroyProcEntries(DAC960_Controller_T *Controller)
  * DAC960_gam_ioctl is the ioctl function for performing RAID operations.
 */
 
-static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
+static int DAC960_gam_ioctl(struct inode *inode, struct file *file, unsigned int Request,
 						unsigned long Argument)
 {
   long ErrorCode = 0;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b73116e..67404dd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -192,7 +192,7 @@ static void cciss_procinit(int i)
 #endif				/* CONFIG_PROC_FS */
 
 #ifdef CONFIG_COMPAT
-static long cciss_compat_ioctl(struct file *f, unsigned cmd, unsigned long arg);
+static int cciss_compat_ioctl(struct inode *inode, struct file *f, unsigned cmd, unsigned long arg);
 #endif
 
 static struct block_device_operations cciss_fops = {
@@ -618,7 +618,7 @@ static int cciss_ioctl32_passthru(struct file *f, unsigned cmd,
 static int cciss_ioctl32_big_passthru(struct file *f, unsigned cmd,
 				      unsigned long arg);
 
-static long cciss_compat_ioctl(struct file *f, unsigned cmd, unsigned long arg)
+static int cciss_compat_ioctl(struct inode *inode, struct file *f, unsigned cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case CCISS_GETPCIINFO:
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d3a25b0..bfa4f44 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1292,9 +1292,8 @@ loop_get_status_compat(struct loop_device *lo,
 	return err;
 }
 
-static long lo_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int lo_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 	int err;
 
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 673b8b2..5a6fe4a 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -190,7 +190,7 @@ module_param_array(drive3, int, NULL, 0);
 #define ATAPI_LOG_SENSE		0x4d
 
 static int pt_open(struct inode *inode, struct file *file);
-static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static int pt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 static int pt_release(struct inode *inode, struct file *file);
 static ssize_t pt_read(struct file *filp, char __user *buf,
 		       size_t count, loff_t * ppos);
@@ -690,7 +690,7 @@ out:
 	return err;
 }
 
-static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int pt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct pt_unit *tape = file->private_data;
 	struct mtop __user *p = (void __user *)arg;
diff --git a/drivers/char/agp/agp.h b/drivers/char/agp/agp.h
index 4bada0e..acdeee0 100644
--- a/drivers/char/agp/agp.h
+++ b/drivers/char/agp/agp.h
@@ -313,7 +313,7 @@ extern const struct aper_size_info_16 agp3_generic_sizes[];
 extern int agp_off;
 extern int agp_try_unsupported_boot;
 
-long compat_agp_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int compat_agp_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 
 /* Chipset independant registers (from AGP Spec) */
 #define AGP_APBASE	0x10
diff --git a/drivers/char/agp/compat_ioctl.c b/drivers/char/agp/compat_ioctl.c
index 58c57cb..abd8974 100644
--- a/drivers/char/agp/compat_ioctl.c
+++ b/drivers/char/agp/compat_ioctl.c
@@ -202,7 +202,7 @@ static int compat_agpioc_unbind_wrap(struct agp_file_private *priv, void __user
 	return agp_unbind_memory(memory);
 }
 
-long compat_agp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int compat_agp_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct agp_file_private *curr_priv = file->private_data;
 	int ret_val = -ENOTTY;
diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index a96f319..0a2d134 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -971,7 +971,7 @@ int agpioc_chipset_flush_wrap(struct agp_file_private *priv)
 	return 0;
 }
 
-static long agp_ioctl(struct file *file,
+static int agp_ioctl(struct inode *inode, struct file *file,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct agp_file_private *curr_priv = file->private_data;
diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index c5e67a6..95aac80 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -154,7 +154,7 @@ static unsigned char days_in_mo[] =
 
 /* ioctl that supports RTC_RD_TIME and RTC_SET_TIME (read and set time/date). */
 
-static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
 
diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index ca7c72a..e4866bc 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -303,7 +303,7 @@ static ssize_t dsp56k_write(struct file *file, const char __user *buf, size_t co
 	}
 }
 
-static long dsp56k_ioctl(struct file *file, unsigned int cmd,
+static int dsp56k_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			 unsigned long arg)
 {
 	int dev = iminor(file->f_path.dentry->d_inode) & 0x0f;
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 34d15d5..3131dc0 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -51,7 +51,7 @@
 
 static DEFINE_SPINLOCK(efi_rtc_lock);
 
-static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
+static int efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg);
 
 #define is_leap(year) \
@@ -146,7 +146,7 @@ convert_from_efi_time(efi_time_t *eft, struct rtc_time *wtime)
 	}
 }
 
-static long efi_rtc_ioctl(struct file *file, unsigned int cmd,
+static int efi_rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 689f9dc..5ac4c8d 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -203,7 +203,7 @@ static int set_serial_info(i2ChanStrPtr, struct serial_struct __user *);
 
 static ssize_t ip2_ipl_read(struct file *, char __user *, size_t, loff_t *);
 static ssize_t ip2_ipl_write(struct file *, const char __user *, size_t, loff_t *);
-static long ip2_ipl_ioctl(struct file *, UINT, ULONG);
+static int ip2_ipl_ioctl(struct inode *inode, struct file *, UINT, ULONG);
 static int ip2_ipl_open(struct inode *, struct file *);
 
 static int DumpTraceBuffer(char __user *, int);
@@ -2845,8 +2845,8 @@ ip2_ipl_write(struct file *pFile, const char __user *pData, size_t count, loff_t
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-static long
-ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
+static int
+ip2_ipl_ioctl(struct inode *inode, struct file *pFile, UINT cmd, ULONG arg )
 {
 	unsigned int iplminor = iminor(pFile->f_path.dentry->d_inode);
 	int rc = 0;
diff --git a/drivers/char/ip27-rtc.c b/drivers/char/ip27-rtc.c
index ec9d044..f85a353 100644
--- a/drivers/char/ip27-rtc.c
+++ b/drivers/char/ip27-rtc.c
@@ -47,7 +47,7 @@
 #include <asm/sn/sn0/hub.h>
 #include <asm/sn/sn_private.h>
 
-static long rtc_ioctl(struct file *filp, unsigned int cmd,
+static int rtc_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			unsigned long arg);
 
 static int rtc_read_proc(char *page, char **start, off_t off,
@@ -76,7 +76,7 @@ static unsigned long epoch = 1970;	/* year corresponding to 0x00	*/
 static const unsigned char days_in_mo[] =
 {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
 
-static long rtc_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int rtc_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 
 	struct rtc_time wtime;
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 64e1c16..02a8511 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -762,7 +762,7 @@ static long put_compat_ipmi_recv(struct ipmi_recv *p64,
 /*
  * Handle compatibility ioctls
  */
-static long compat_ipmi_ioctl(struct file *filep, unsigned int cmd,
+static int compat_ipmi_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
 			      unsigned long arg)
 {
 	int rc;
diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 918711a..e2b2463 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -58,7 +58,7 @@ extern unsigned long sn_rtc_cycles_per_second;
 
 #define rtc_time()              (*RTC_COUNTER_ADDR)
 
-static long mmtimer_ioctl(struct file *file, unsigned int cmd,
+static int mmtimer_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg);
 static int mmtimer_mmap(struct file *file, struct vm_area_struct *vma);
 
@@ -365,7 +365,7 @@ restart:
  * %MMTIMER_GETCOUNTER - Gets the current value in the counter and places it
  * in the address specified by @arg.
  */
-static long mmtimer_ioctl(struct file *file, unsigned int cmd,
+static int mmtimer_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int ret = 0;
diff --git a/drivers/char/mwave/mwavedd.c b/drivers/char/mwave/mwavedd.c
index 4f8d67f..41a3af0 100644
--- a/drivers/char/mwave/mwavedd.c
+++ b/drivers/char/mwave/mwavedd.c
@@ -86,7 +86,7 @@ module_param(mwave_uart_io, int, 0);
 
 static int mwave_open(struct inode *inode, struct file *file);
 static int mwave_close(struct inode *inode, struct file *file);
-static long mwave_ioctl(struct file *filp, unsigned int iocmd,
+static int mwave_ioctl(struct inode *inode, struct file *filp, unsigned int iocmd,
 							unsigned long ioarg);
 
 MWAVE_DEVICE_DATA mwave_s_mdd;
@@ -119,7 +119,7 @@ static int mwave_close(struct inode *inode, struct file *file)
 	return retval;
 }
 
-static long mwave_ioctl(struct file *file, unsigned int iocmd,
+static int mwave_ioctl(struct inode *inode, struct file *file, unsigned int iocmd,
 							unsigned long ioarg)
 {
 	unsigned int retval = 0;
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index f070ae7..f556c56 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1406,11 +1406,10 @@ static void stop_monitor(struct cm4000_dev *dev)
 	DEBUGP(3, dev, "<- stop_monitor\n");
 }
 
-static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int cmm_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct cm4000_dev *dev = filp->private_data;
 	unsigned int iobase = dev->p_dev->io.BasePort1;
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pcmcia_device *link;
 	int size;
 	int rc;
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index bee39fd..fafcc15 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -633,7 +633,7 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return 0;
 }
 
-static long pp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int pp_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	lock_kernel();
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1838aa3..93e26d0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1061,7 +1061,7 @@ static ssize_t random_write(struct file *file, const char __user *buffer,
 	return (ssize_t)count;
 }
 
-static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static int random_ioctl(struct inode *inode, struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index a8f68a3..1fad0e4 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -179,7 +179,7 @@ static int rio_set_real_termios(void *ptr);
 static void rio_hungup(void *ptr);
 static void rio_close(void *ptr);
 static int rio_chars_in_buffer(void *ptr);
-static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
 static int rio_init_drivers(void);
 
 static void my_hd(void *addr, int len);
@@ -560,7 +560,7 @@ static void rio_close(void *ptr)
 
 
 
-static long rio_fw_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int rio_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int rc = 0;
 	func_enter();
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index f53d4d0..3bb7b51 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -142,7 +142,7 @@ static DEFINE_TIMER(rtc_irq_timer, rtc_dropped_irq, 0, 0);
 static ssize_t rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos);
 
-static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 static void rtc_get_rtc_time(struct rtc_time *rtc_tm);
 
 #ifdef RTC_IRQ
@@ -717,7 +717,7 @@ static int rtc_do_ioctl(unsigned int cmd, unsigned long arg, int kernel)
 			    &wtime, sizeof wtime) ? -EFAULT : 0;
 }
 
-static long rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	lock_kernel();
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index c385206..54d0c48 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -286,7 +286,7 @@ static void sx_close(void *ptr);
 static int sx_chars_in_buffer(void *ptr);
 static int sx_init_board(struct sx_board *board);
 static int sx_init_portstructs(int nboards, int nports);
-static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+static int sx_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 						unsigned long arg);
 static int sx_init_drivers(void);
 
@@ -1686,7 +1686,7 @@ static int do_memtest_w(struct sx_board *board, int min, int max)
 }
 #endif
 
-static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
+static int sx_fw_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 							unsigned long arg)
 {
 	long rc = 0;
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index daeb8f7..835658b 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -150,9 +150,9 @@ ssize_t redirected_tty_write(struct file *, const char __user *,
 static unsigned int tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 static int tty_release(struct inode *, struct file *);
-long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
-static long tty_compat_ioctl(struct file *file, unsigned int cmd,
+static int tty_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				unsigned long arg);
 #else
 #define tty_compat_ioctl NULL
@@ -785,13 +785,13 @@ static unsigned int hung_up_tty_poll(struct file *filp, poll_table *wait)
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct file *file, unsigned int cmd,
+static int hung_up_tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
 
-static long hung_up_tty_compat_ioctl(struct file *file,
+static int hung_up_tty_compat_ioctl(struct inode *inode, struct file *file,
 				     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
@@ -2941,13 +2941,12 @@ static int tty_tiocmset(struct tty_struct *tty, struct file *file, unsigned int
 /*
  * Split this up, as gcc can choke on it otherwise..
  */
-long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct *tty, *real_tty;
 	void __user *p = (void __user *)arg;
 	int retval;
 	struct tty_ldisc *ld;
-	struct inode *inode = file->f_dentry->d_inode;
 
 	tty = (struct tty_struct *)file->private_data;
 	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
@@ -3075,10 +3074,9 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-static long tty_compat_ioctl(struct file *file, unsigned int cmd,
+static int tty_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
 	struct tty_struct *tty = file->private_data;
 	struct tty_ldisc *ld;
 	int retval = -ENOIOCTLCMD;
diff --git a/drivers/char/viotape.c b/drivers/char/viotape.c
index 7a70a40..649b50e 100644
--- a/drivers/char/viotape.c
+++ b/drivers/char/viotape.c
@@ -678,7 +678,7 @@ free_op:
 	return ret;
 }
 
-static long viotap_unlocked_ioctl(struct file *file,
+static int viotap_unlocked_ioctl(struct inode *inode, struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	long rc;
diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 2e6d584..c7b1e3d 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -916,8 +916,8 @@ dispatch_ioctl(struct client *client, unsigned int cmd, void __user *arg)
 	return 0;
 }
 
-static long
-fw_device_op_ioctl(struct file *file,
+static int
+fw_device_op_ioctl(struct inode *inode, struct file *file,
 		   unsigned int cmd, unsigned long arg)
 {
 	struct client *client = file->private_data;
@@ -929,8 +929,8 @@ fw_device_op_ioctl(struct file *file,
 }
 
 #ifdef CONFIG_COMPAT
-static long
-fw_device_op_compat_ioctl(struct file *file,
+static int
+fw_device_op_compat_ioctl(struct inode *inode, struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
 	struct client *client = file->private_data;
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index d7326d9..ecc9ce6 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -216,7 +216,7 @@ extern void i915_driver_lastclose(struct drm_device * dev);
 extern void i915_driver_preclose(struct drm_device *dev,
 				 struct drm_file *file_priv);
 extern int i915_driver_device_is_agp(struct drm_device * dev);
-extern long i915_compat_ioctl(struct file *filp, unsigned int cmd,
+extern int i915_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      unsigned long arg);
 
 /* i915_irq.c */
diff --git a/drivers/gpu/drm/i915/i915_ioc32.c b/drivers/gpu/drm/i915/i915_ioc32.c
index 1fe68a2..f8f623e 100644
--- a/drivers/gpu/drm/i915/i915_ioc32.c
+++ b/drivers/gpu/drm/i915/i915_ioc32.c
@@ -199,7 +199,7 @@ drm_ioctl_compat_t *i915_compat_ioctls[] = {
  * \param arg user argument.
  * \return zero on success or negative number on failure.
  */
-long i915_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int i915_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int nr = DRM_IOCTL_NR(cmd);
 	drm_ioctl_compat_t *fn = NULL;
diff --git a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
index f6ebd24..dfe6cd7 100644
--- a/drivers/gpu/drm/mga/mga_drv.h
+++ b/drivers/gpu/drm/mga/mga_drv.h
@@ -187,7 +187,7 @@ extern irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS);
 extern void mga_driver_irq_preinstall(struct drm_device * dev);
 extern void mga_driver_irq_postinstall(struct drm_device * dev);
 extern void mga_driver_irq_uninstall(struct drm_device * dev);
-extern long mga_compat_ioctl(struct file *filp, unsigned int cmd,
+extern int mga_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			     unsigned long arg);
 
 #define mga_flush_write_combine()	DRM_WRITEMEMORYBARRIER()
diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
index 30d0047..b5d0826 100644
--- a/drivers/gpu/drm/mga/mga_ioc32.c
+++ b/drivers/gpu/drm/mga/mga_ioc32.c
@@ -208,7 +208,7 @@ drm_ioctl_compat_t *mga_compat_ioctls[] = {
  * \param arg user argument.
  * \return zero on success or negative number on failure.
  */
-long mga_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int mga_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int nr = DRM_IOCTL_NR(cmd);
 	drm_ioctl_compat_t *fn = NULL;
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 011105e..e145952 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -159,7 +159,7 @@ extern void r128_driver_lastclose(struct drm_device * dev);
 extern void r128_driver_preclose(struct drm_device * dev,
 				 struct drm_file *file_priv);
 
-extern long r128_compat_ioctl(struct file *filp, unsigned int cmd,
+extern int r128_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			      unsigned long arg);
 
 /* Register definitions, register access macros and drmAddMap constants
diff --git a/drivers/gpu/drm/r128/r128_ioc32.c b/drivers/gpu/drm/r128/r128_ioc32.c
index d3cb676..f242fdb 100644
--- a/drivers/gpu/drm/r128/r128_ioc32.c
+++ b/drivers/gpu/drm/r128/r128_ioc32.c
@@ -198,7 +198,7 @@ drm_ioctl_compat_t *r128_compat_ioctls[] = {
  * \param arg user argument.
  * \return zero on success or negative number on failure.
  */
-long r128_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int r128_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int nr = DRM_IOCTL_NR(cmd);
 	drm_ioctl_compat_t *fn = NULL;
diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index 0993816..4b55abd 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -401,7 +401,7 @@ extern void radeon_driver_preclose(struct drm_device * dev, struct drm_file *fil
 extern void radeon_driver_postclose(struct drm_device * dev, struct drm_file * filp);
 extern void radeon_driver_lastclose(struct drm_device * dev);
 extern int radeon_driver_open(struct drm_device * dev, struct drm_file * filp_priv);
-extern long radeon_compat_ioctl(struct file *filp, unsigned int cmd,
+extern int radeon_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 				unsigned long arg);
 
 /* r300_cmdbuf.c */
diff --git a/drivers/gpu/drm/radeon/radeon_ioc32.c b/drivers/gpu/drm/radeon/radeon_ioc32.c
index 56decda..6b518cb 100644
--- a/drivers/gpu/drm/radeon/radeon_ioc32.c
+++ b/drivers/gpu/drm/radeon/radeon_ioc32.c
@@ -401,7 +401,7 @@ drm_ioctl_compat_t *radeon_compat_ioctls[] = {
  * \param arg user argument.
  * \return zero on success or negative number on failure.
  */
-long radeon_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int radeon_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int nr = DRM_IOCTL_NR(cmd);
 	drm_ioctl_compat_t *fn = NULL;
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index c40f040..0a15260 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -217,10 +217,9 @@ static int hidraw_release(struct inode * inode, struct file * file)
 	return 0;
 }
 
-static long hidraw_ioctl(struct file *file, unsigned int cmd,
+static int hidraw_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	unsigned int minor = iminor(inode);
 	long ret = 0;
 	/* FIXME: What stops hidraw_table going NULL */
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 842e9ed..0b08caf 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -544,7 +544,7 @@ static noinline int hiddev_ioctl_string(struct hiddev *hiddev, unsigned int cmd,
 	return len;
 }
 
-static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int hiddev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct hiddev_list *list = file->private_data;
 	struct hiddev *hiddev = list->hiddev;
@@ -761,9 +761,9 @@ static long hiddev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-static long hiddev_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int hiddev_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	return hiddev_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+	return hiddev_ioctl(inode, file, cmd, (unsigned long)compat_ptr(arg));
 }
 #endif
 
diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index af4491f..98ec3d2 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -367,7 +367,7 @@ static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
 	return res;
 }
 
-static long i2cdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int i2cdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct i2c_client *client = (struct i2c_client *)file->private_data;
 	unsigned long funcs;
diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index b6eb2cf..a8bdc2c 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -158,7 +158,7 @@ static void it_tasklet_func(unsigned long data);
 static void ir_tasklet_func(unsigned long data);
 
 #ifdef CONFIG_COMPAT
-static long dv1394_compat_ioctl(struct file *file, unsigned int cmd,
+static int dv1394_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			       unsigned long arg);
 #endif
 
@@ -1533,7 +1533,7 @@ static ssize_t dv1394_read(struct file *file,  char __user *buffer, size_t count
 
 /*** DEVICE IOCTL INTERFACE ************************************************/
 
-static long dv1394_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int dv1394_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct video_card *video = file_to_video_card(file);
 	unsigned long flags;
@@ -2457,7 +2457,7 @@ struct dv1394_status32 {
 
 /* RED-PEN: this should use compat_alloc_userspace instead */
 
-static int handle_dv1394_init(struct file *file, unsigned int cmd, unsigned long arg)
+static int handle_dv1394_init(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct dv1394_init32 dv32;
 	struct dv1394_init dv;
@@ -2480,13 +2480,13 @@ static int handle_dv1394_init(struct file *file, unsigned int cmd, unsigned long
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	ret = dv1394_ioctl(file, DV1394_IOC_INIT, (unsigned long)&dv);
+	ret = dv1394_ioctl(inode, file, DV1394_IOC_INIT, (unsigned long)&dv);
 	set_fs(old_fs);
 
 	return ret;
 }
 
-static int handle_dv1394_get_status(struct file *file, unsigned int cmd, unsigned long arg)
+static int handle_dv1394_get_status(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct dv1394_status32 dv32;
 	struct dv1394_status dv;
@@ -2498,7 +2498,7 @@ static int handle_dv1394_get_status(struct file *file, unsigned int cmd, unsigne
 
 	old_fs = get_fs();
 	set_fs(KERNEL_DS);
-	ret = dv1394_ioctl(file, DV1394_IOC_GET_STATUS, (unsigned long)&dv);
+	ret = dv1394_ioctl(inode, file, DV1394_IOC_GET_STATUS, (unsigned long)&dv);
 	set_fs(old_fs);
 
 	if (!ret) {
@@ -2523,7 +2523,7 @@ static int handle_dv1394_get_status(struct file *file, unsigned int cmd, unsigne
 
 
 
-static long dv1394_compat_ioctl(struct file *file, unsigned int cmd,
+static int dv1394_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			       unsigned long arg)
 {
 	switch (cmd) {
@@ -2532,12 +2532,12 @@ static long dv1394_compat_ioctl(struct file *file, unsigned int cmd,
 	case DV1394_IOC_WAIT_FRAMES:
 	case DV1394_IOC_RECEIVE_FRAMES:
 	case DV1394_IOC_START_RECEIVE:
-		return dv1394_ioctl(file, cmd, arg);
+		return dv1394_ioctl(inode, file, cmd, arg);
 
 	case DV1394_IOC32_INIT:
-		return handle_dv1394_init(file, cmd, arg);
+		return handle_dv1394_init(inode, file, cmd, arg);
 	case DV1394_IOC32_GET_STATUS:
-		return handle_dv1394_get_status(file, cmd, arg);
+		return handle_dv1394_get_status(inode, file, cmd, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 6fa9e4a..6cf46fa 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -2656,7 +2656,7 @@ static long do_raw1394_ioctl(struct file *file, unsigned int cmd,
 	return -EINVAL;
 }
 
-static long raw1394_ioctl(struct file *file, unsigned int cmd,
+static int raw1394_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	long ret;
@@ -2717,7 +2717,7 @@ static long raw1394_read_cycle_timer32(struct file_info *fi, void __user * uaddr
 	return err;
 }
 
-static long raw1394_compat_ioctl(struct file *file,
+static int raw1394_compat_ioctl(struct inode *inode, struct file *file,
 				 unsigned int cmd, unsigned long arg)
 {
 	struct file_info *fi = file->private_data;
diff --git a/drivers/ieee1394/video1394.c b/drivers/ieee1394/video1394.c
index 25db6e6..ed4eb78 100644
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -716,7 +716,7 @@ static inline unsigned video1394_buffer_state(struct dma_iso_ctx *d,
 	return ret;
 }
 
-static long video1394_ioctl(struct file *file,
+static int video1394_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
 	struct file_ctx *ctx = (struct file_ctx *)file->private_data;
@@ -1272,7 +1272,7 @@ static int video1394_release(struct inode *inode, struct file *file)
 }
 
 #ifdef CONFIG_COMPAT
-static long video1394_compat_ioctl(struct file *f, unsigned cmd, unsigned long arg);
+static int video1394_compat_ioctl(struct inode *inode, struct file *f, unsigned cmd, unsigned long arg);
 #endif
 
 static struct cdev video1394_cdev;
@@ -1386,7 +1386,7 @@ struct video1394_wait32 {
 	struct compat_timeval filltime;
 };
 
-static int video1394_wr_wait32(struct file *file, unsigned int cmd, unsigned long arg)
+static int video1394_wr_wait32(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
         struct video1394_wait32 __user *argp = (void __user *)arg;
         struct video1394_wait32 wait32;
@@ -1405,11 +1405,11 @@ static int video1394_wr_wait32(struct file *file, unsigned int cmd, unsigned lon
         old_fs = get_fs();
         set_fs(KERNEL_DS);
         if (cmd == VIDEO1394_IOC32_LISTEN_WAIT_BUFFER)
-		ret = video1394_ioctl(file,
+		ret = video1394_ioctl(inode, file,
 				      VIDEO1394_IOC_LISTEN_WAIT_BUFFER,
 				      (unsigned long) &wait);
         else
-		ret = video1394_ioctl(file,
+		ret = video1394_ioctl(inode, file,
 				      VIDEO1394_IOC_LISTEN_POLL_BUFFER,
 				      (unsigned long) &wait);
         set_fs(old_fs);
@@ -1427,7 +1427,7 @@ static int video1394_wr_wait32(struct file *file, unsigned int cmd, unsigned lon
         return ret;
 }
 
-static int video1394_w_wait32(struct file *file, unsigned int cmd, unsigned long arg)
+static int video1394_w_wait32(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
         struct video1394_wait32 wait32;
         struct video1394_wait wait;
@@ -1445,11 +1445,11 @@ static int video1394_w_wait32(struct file *file, unsigned int cmd, unsigned long
         old_fs = get_fs();
         set_fs(KERNEL_DS);
         if (cmd == VIDEO1394_IOC32_LISTEN_QUEUE_BUFFER)
-		ret = video1394_ioctl(file,
+		ret = video1394_ioctl(inode, file,
 				      VIDEO1394_IOC_LISTEN_QUEUE_BUFFER,
 				      (unsigned long) &wait);
         else
-		ret = video1394_ioctl(file,
+		ret = video1394_ioctl(inode, file,
 				      VIDEO1394_IOC_TALK_WAIT_BUFFER,
 				      (unsigned long) &wait);
         set_fs(old_fs);
@@ -1457,33 +1457,33 @@ static int video1394_w_wait32(struct file *file, unsigned int cmd, unsigned long
         return ret;
 }
 
-static int video1394_queue_buf32(struct file *file, unsigned int cmd, unsigned long arg)
+static int video1394_queue_buf32(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
         return -EFAULT;   /* ??? was there before. */
 
-	return video1394_ioctl(file,
+	return video1394_ioctl(inode, file,
 				VIDEO1394_IOC_TALK_QUEUE_BUFFER, arg);
 }
 
-static long video1394_compat_ioctl(struct file *f, unsigned cmd, unsigned long arg)
+static int video1394_compat_ioctl(struct inode *inode, struct file *f, unsigned cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case VIDEO1394_IOC_LISTEN_CHANNEL:
 	case VIDEO1394_IOC_UNLISTEN_CHANNEL:
 	case VIDEO1394_IOC_TALK_CHANNEL:
 	case VIDEO1394_IOC_UNTALK_CHANNEL:
-		return video1394_ioctl(f, cmd, arg);
+		return video1394_ioctl(inode, f, cmd, arg);
 
 	case VIDEO1394_IOC32_LISTEN_QUEUE_BUFFER:
-		return video1394_w_wait32(f, cmd, arg);
+		return video1394_w_wait32(inode, f, cmd, arg);
 	case VIDEO1394_IOC32_LISTEN_WAIT_BUFFER:
-		return video1394_wr_wait32(f, cmd, arg);
+		return video1394_wr_wait32(inode, f, cmd, arg);
 	case VIDEO1394_IOC_TALK_QUEUE_BUFFER:
-		return video1394_queue_buf32(f, cmd, arg);
+		return video1394_queue_buf32(inode, f, cmd, arg);
 	case VIDEO1394_IOC32_TALK_WAIT_BUFFER:
-		return video1394_w_wait32(f, cmd, arg);
+		return video1394_w_wait32(inode, f, cmd, arg);
 	case VIDEO1394_IOC32_LISTEN_POLL_BUFFER:
-		return video1394_wr_wait32(f, cmd, arg);
+		return video1394_wr_wait32(inode, f, cmd, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 268a2d2..6cd0bc3 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -743,7 +743,7 @@ static long ib_umad_enable_pkey(struct ib_umad_file *file)
 	return ret;
 }
 
-static long ib_umad_ioctl(struct file *filp, unsigned int cmd,
+static int ib_umad_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			  unsigned long arg)
 {
 	switch (cmd) {
@@ -759,7 +759,7 @@ static long ib_umad_ioctl(struct file *filp, unsigned int cmd,
 }
 
 #ifdef CONFIG_COMPAT
-static long ib_umad_compat_ioctl(struct file *filp, unsigned int cmd,
+static int ib_umad_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 				 unsigned long arg)
 {
 	switch (cmd) {
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 3524bef..9fd8fa9 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -888,13 +888,13 @@ static long evdev_ioctl_handler(struct file *file, unsigned int cmd,
 	return retval;
 }
 
-static long evdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int evdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return evdev_ioctl_handler(file, cmd, (void __user *)arg, 0);
 }
 
 #ifdef CONFIG_COMPAT
-static long evdev_ioctl_compat(struct file *file,
+static int evdev_ioctl_compat(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	return evdev_ioctl_handler(file, cmd, compat_ptr(arg), 1);
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 65d7077..d4db145 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -555,7 +555,7 @@ static int joydev_ioctl_common(struct joydev *joydev,
 }
 
 #ifdef CONFIG_COMPAT
-static long joydev_compat_ioctl(struct file *file,
+static int joydev_compat_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	struct joydev_client *client = file->private_data;
@@ -622,7 +622,7 @@ static long joydev_compat_ioctl(struct file *file,
 }
 #endif /* CONFIG_COMPAT */
 
-static long joydev_ioctl(struct file *file,
+static int joydev_ioctl(struct inode *inode, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct joydev_client *client = file->private_data;
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 223d56d..a37877e 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -455,7 +455,7 @@ static int uinput_release(struct inode *inode, struct file *file)
 	__ret;						\
 })
 
-static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int uinput_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int			retval;
 	struct uinput_device	*udev;
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b262c00..c21cbdc 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1470,15 +1470,15 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 	return r;
 }
 
-static long dm_ctl_ioctl(struct file *file, uint command, ulong u)
+static int dm_ctl_ioctl(struct inode *inode, struct file *file, uint command, ulong u)
 {
 	return (long)ctl_ioctl(command, (struct dm_ioctl __user *)u);
 }
 
 #ifdef CONFIG_COMPAT
-static long dm_compat_ctl_ioctl(struct file *file, uint command, ulong u)
+static int dm_compat_ctl_ioctl(struct inode *inode, struct file *file, uint command, ulong u)
 {
-	return (long)dm_ctl_ioctl(file, command, (ulong) compat_ptr(u));
+	return dm_ctl_ioctl(inode, file, command, (ulong) compat_ptr(u));
 }
 #else
 #define dm_compat_ctl_ioctl NULL
diff --git a/drivers/media/video/compat_ioctl32.c b/drivers/media/video/compat_ioctl32.c
index bd5d9de..7eacc2d 100644
--- a/drivers/media/video/compat_ioctl32.c
+++ b/drivers/media/video/compat_ioctl32.c
@@ -110,15 +110,15 @@ struct video_window32 {
 };
 #endif
 
-static int native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int native_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOIOCTLCMD;
 
 	if (file->f_op->unlocked_ioctl)
-		ret = file->f_op->unlocked_ioctl(file, cmd, arg);
+		ret = file->f_op->unlocked_ioctl(inode, file, cmd, arg);
 	else if (file->f_op->ioctl) {
 		lock_kernel();
-		ret = file->f_op->ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		ret = file->f_op->ioctl(inode, file, cmd, arg);
 		unlock_kernel();
 	}
 
@@ -549,7 +549,7 @@ enum {
 	MaxClips = (~0U-sizeof(struct video_window))/sizeof(struct video_clip)
 };
 
-static int do_set_window(struct file *file, unsigned int cmd, unsigned long arg)
+static int do_set_window(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct video_window32 __user *up = compat_ptr(arg);
 	struct video_window __user *vw;
@@ -607,11 +607,11 @@ static int do_set_window(struct file *file, unsigned int cmd, unsigned long arg)
 		}
 	}
 
-	return native_ioctl(file, VIDIOCSWIN, (unsigned long)vw);
+	return native_ioctl(inode, file, VIDIOCSWIN, (unsigned long)vw);
 }
 #endif
 
-static int do_video_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int do_video_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	union {
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -754,12 +754,12 @@ static int do_video_ioctl(struct file *file, unsigned int cmd, unsigned long arg
 		goto out;
 
 	if(compatible_arg)
-		err = native_ioctl(file, realcmd, (unsigned long)up);
+		err = native_ioctl(inode, file, realcmd, (unsigned long)up);
 	else {
 		mm_segment_t old_fs = get_fs();
 
 		set_fs(KERNEL_DS);
-		err = native_ioctl(file, realcmd, (unsigned long) &karg);
+		err = native_ioctl(inode, file, realcmd, (unsigned long) &karg);
 		set_fs(old_fs);
 	}
 	if(err == 0) {
@@ -827,7 +827,7 @@ out:
 	return err;
 }
 
-long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
+int v4l_compat_ioctl32(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOIOCTLCMD;
 
@@ -837,7 +837,7 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	case VIDIOCSWIN32:
-		ret = do_set_window(file, cmd, arg);
+		ret = do_set_window(inode, file, cmd, arg);
 		break;
 	case VIDIOCGTUNER32:
 	case VIDIOCSTUNER32:
@@ -885,7 +885,7 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_S_INPUT32:
 	case VIDIOC_TRY_FMT32:
 	case VIDIOC_S_HW_FREQ_SEEK:
-		ret = do_video_ioctl(file, cmd, arg);
+		ret = do_video_ioctl(inode, file, cmd, arg);
 		break;
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
@@ -913,7 +913,7 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case _IOR('v' , BASE_VIDIOCPRIVATE+5, int):
 	case _IOR('v' , BASE_VIDIOCPRIVATE+6, int):
 	case _IOR('v' , BASE_VIDIOCPRIVATE+7, int):
-		ret = native_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+		ret = native_ioctl(inode, file, cmd, (unsigned long)compat_ptr(arg));
 		break;
 #endif
 	default:
@@ -922,7 +922,7 @@ long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 #else
-long v4l_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
+int v4l_compat_ioctl32(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index f5233f3..3d20a3c 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -116,7 +116,7 @@ static int  mptctl_probe(struct pci_dev *, const struct pci_device_id *);
 static void mptctl_remove(struct pci_dev *);
 
 #ifdef CONFIG_COMPAT
-static long compat_mpctl_ioctl(struct file *f, unsigned cmd, unsigned long arg);
+static int compat_mpctl_ioctl(struct inode *inode, struct file *f, unsigned cmd, unsigned long arg);
 #endif
 /*
  * Private function calls.
@@ -652,8 +652,8 @@ __mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static long
-mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int
+mptctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	lock_kernel();
@@ -2818,7 +2818,7 @@ compat_mpt_command(struct file *filp, unsigned int cmd,
 	return ret;
 }
 
-static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static int compat_mpctl_ioctl(struct inode *inode, struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	lock_kernel();
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index 4238de9..442cdb3 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -746,7 +746,7 @@ out:
 	return rcode;
 }
 
-static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
+static int i2o_cfg_compat_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 				 unsigned long arg)
 {
 	int ret;
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index daf5856..4902f28 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -83,7 +83,7 @@ static int phantom_status(struct phantom_device *dev, unsigned long newstat)
  * File ops
  */
 
-static long phantom_ioctl(struct file *file, unsigned int cmd,
+static int phantom_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
 	struct phantom_device *dev = file->private_data;
@@ -195,14 +195,14 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 }
 
 #ifdef CONFIG_COMPAT
-static long phantom_compat_ioctl(struct file *filp, unsigned int cmd,
+static int phantom_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
 	if (_IOC_NR(cmd) <= 3 && _IOC_SIZE(cmd) == sizeof(compat_uptr_t)) {
 		cmd &= ~(_IOC_SIZEMASK << _IOC_SIZESHIFT);
 		cmd |= sizeof(void *) << _IOC_SIZESHIFT;
 	}
-	return phantom_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
+	return phantom_ioctl(inode, filp, cmd, (unsigned long)compat_ptr(arg));
 }
 #else
 #define phantom_compat_ioctl NULL
diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 23c91f5..fb6d7ad 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -233,7 +233,7 @@ static long gru_get_chiplet_status(unsigned long arg)
  *
  * Called to update file attributes via IOCTL calls.
  */
-static long gru_file_unlocked_ioctl(struct file *file, unsigned int req,
+static int gru_file_unlocked_ioctl(struct inode *inode, struct file *file, unsigned int req,
 				    unsigned long arg)
 {
 	int err = -EBADRQC;
diff --git a/drivers/net/ppp_generic.c b/drivers/net/ppp_generic.c
index ddccc07..3ec394d 100644
--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -547,7 +547,7 @@ static int get_filter(void __user *arg, struct sock_filter **p)
 }
 #endif /* CONFIG_PPP_FILTER */
 
-static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int ppp_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ppp_file *pf = file->private_data;
 	struct ppp *ppp;
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index e1098c3..db5903f 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -201,7 +201,7 @@ struct pci_filp_private {
 	int write_combine;
 };
 
-static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
+static int proc_bus_pci_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			       unsigned long arg)
 {
 	const struct proc_dir_entry *dp = PDE(file->f_dentry->d_inode);
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index f118252..ac41969 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -203,7 +203,7 @@ static unsigned int rtc_dev_poll(struct file *file, poll_table *wait)
 	return (data != 0) ? (POLLIN | POLLRDNORM) : 0;
 }
 
-static long rtc_dev_ioctl(struct file *file,
+static int rtc_dev_ioctl(struct inode *inode, struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	int err = 0;
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 31ecaa4..ab20e29 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -611,7 +611,7 @@ void dasd_destroy_partitions(struct dasd_block *);
 
 /* externals in dasd_ioctl.c */
 int  dasd_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
-long dasd_compat_ioctl(struct file *, unsigned int, unsigned long);
+int dasd_compat_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 
 /* externals in dasd_proc.c */
 int dasd_proc_init(void);
diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index be0ce22..5b42a1f 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -37,7 +37,7 @@ static int tapechar_open(struct inode *,struct file *);
 static int tapechar_release(struct inode *,struct file *);
 static int tapechar_ioctl(struct inode *, struct file *, unsigned int,
 			  unsigned long);
-static long tapechar_compat_ioctl(struct file *, unsigned int,
+static int tapechar_compat_ioctl(struct inode *inode, struct file *, unsigned int,
 			  unsigned long);
 
 static const struct file_operations tape_fops =
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 09e7d9b..3de2abe 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -138,7 +138,7 @@ vmcp_write(struct file *file, const char __user *buff, size_t count,
  * let userspace to change the response size, if userspace expects a bigger
  * response
  */
-static long vmcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int vmcp_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct vmcp_session *session;
 	int temp;
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 91ca87a..6a0904e 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -737,7 +737,7 @@ out_free:
 	return ret;
 }
 
-static long chsc_ioctl(struct file *filp, unsigned int cmd,
+static int chsc_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 		       unsigned long arg)
 {
 	CHSC_MSG(2, "chsc_ioctl called, cmd=%x\n", cmd);
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index cb22b97..6e82f85 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -621,7 +621,7 @@ static long zcrypt_ica_status(struct file *filp, unsigned long arg)
 	return ret;
 }
 
-static long zcrypt_unlocked_ioctl(struct file *filp, unsigned int cmd,
+static int zcrypt_unlocked_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 				  unsigned long arg)
 {
 	int rc;
@@ -872,7 +872,7 @@ static long trans_xcRB32(struct file *filp, unsigned int cmd,
 	return rc;
 }
 
-static long zcrypt_compat_ioctl(struct file *filp, unsigned int cmd,
+static int zcrypt_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 			 unsigned long arg)
 {
 	if (cmd == ICARSAMODEXPO)
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index ec2abce..de0380f 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -160,7 +160,7 @@ static void zfcp_cfdc_req_to_sense(struct zfcp_cfdc_data *data,
 	       sizeof(req->qtcb->bottom.support.els));
 }
 
-static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
+static int zfcp_cfdc_dev_ioctl(struct inode *inode, struct file *file, unsigned int command,
 				unsigned long buffer)
 {
 	struct zfcp_cfdc_data *data;
diff --git a/drivers/sbus/char/cpwatchdog.c b/drivers/sbus/char/cpwatchdog.c
index 23abfdf..1d272b6 100644
--- a/drivers/sbus/char/cpwatchdog.c
+++ b/drivers/sbus/char/cpwatchdog.c
@@ -397,7 +397,7 @@ static int wd_ioctl(struct inode *inode, struct file *file,
 	return(0);
 }
 
-static long wd_compat_ioctl(struct file *file, unsigned int cmd,
+static int wd_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
 	int rval = -ENOIOCTLCMD;
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index d8f5c0c..74842f3 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -117,7 +117,7 @@ static int d7s_release(struct inode *inode, struct file *f)
 	return 0;
 }
 
-static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int d7s_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	__u8 regs = readb(d7s_regs);
 	__u8 ireg = 0;
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 29dc735..9a37df0 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -650,7 +650,7 @@ static int openprom_ioctl(struct inode * inode, struct file * file,
 	};
 }
 
-static long openprom_compat_ioctl(struct file *file, unsigned int cmd,
+static int openprom_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		unsigned long arg)
 {
 	long rval = -ENOTTY;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9aa301c..ff0ec51 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -751,7 +751,7 @@ static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
 }
 
-static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+static int aac_compat_cfg_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg)
 {
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 3c257fe..a9ac914 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -596,7 +596,7 @@ ch_checkrange(scsi_changer *ch, unsigned int type, unsigned int unit)
 	return 0;
 }
 
-static long ch_ioctl(struct file *file,
+static int ch_ioctl(struct inode *inode, struct file *file,
 		    unsigned int cmd, unsigned long arg)
 {
 	scsi_changer *ch = file->private_data;
@@ -843,7 +843,7 @@ struct changer_element_status32 {
 };
 #define CHIOGSTATUS32  _IOW('c', 8,struct changer_element_status32)
 
-static long ch_ioctl_compat(struct file * file,
+static int ch_ioctl_compat(struct inode *inode, struct file * file,
 			    unsigned int cmd, unsigned long arg)
 {
 	scsi_changer *ch = file->private_data;
@@ -858,7 +858,7 @@ static long ch_ioctl_compat(struct file * file,
 	case CHIOINITELEM:
 	case CHIOSVOLTAG:
 		/* compatible */
-		return ch_ioctl(file, cmd, arg);
+		return ch_ioctl(inode, file, cmd, arg);
 	case CHIOGSTATUS32:
 	{
 		struct changer_element_status32 ces32;
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 1fe0901..0c4e821 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -115,7 +115,7 @@ static int hba_count = 0;
 static struct class *adpt_sysfs_class;
 
 #ifdef CONFIG_COMPAT
-static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
+static int compat_adpt_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 #endif
 
 static const struct file_operations adpt_fops = {
@@ -2147,14 +2147,11 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 }
 
 #ifdef CONFIG_COMPAT
-static long compat_adpt_ioctl(struct file *file,
+static int compat_adpt_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode;
 	long ret;
  
-	inode = file->f_dentry->d_inode;
- 
 	lock_kernel();
  
 	switch(cmd) {
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index f680561..e3d9a55 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -44,7 +44,7 @@ static void mraid_mm_free_adp_resources(mraid_mmadp_t *);
 static void mraid_mm_teardown_dma_pools(mraid_mmadp_t *);
 
 #ifdef CONFIG_COMPAT
-static long mraid_mm_compat_ioctl(struct file *, unsigned int, unsigned long);
+static int mraid_mm_compat_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 #endif
 
 MODULE_AUTHOR("LSI Logic Corporation");
@@ -1218,13 +1218,13 @@ mraid_mm_init(void)
  * @cmd		: ioctl command
  * @arg		: user ioctl packet
  */
-static long
-mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
-		      unsigned long arg)
+static int
+mraid_mm_compat_ioctl(struct inode *inode, struct file *filep,
+		      unsigned int cmd, unsigned long arg)
 {
 	int err;
 
-	err = mraid_mm_ioctl(NULL, filep, cmd, arg);
+	err = mraid_mm_ioctl(inode, filep, cmd, arg);
 
 	return err;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 97b7633..8bcd1bd 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3269,8 +3269,8 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 /**
  * megasas_mgmt_ioctl -	char node ioctl entry point
  */
-static long
-megasas_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int
+megasas_mgmt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case MEGASAS_IOC_FIRMWARE:
@@ -3324,9 +3324,9 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	return error;
 }
 
-static long
-megasas_mgmt_compat_ioctl(struct file *file, unsigned int cmd,
-			  unsigned long arg)
+static int
+megasas_mgmt_compat_ioctl(struct inode *inode, struct file *file,
+			  unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case MEGASAS_IOC_FIRMWARE32:
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 1c79f97..4d6867f 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5191,7 +5191,7 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-static long osst_compat_ioctl(struct file * file, unsigned int cmd_in, unsigned long arg)
+static int osst_compat_ioctl(struct inode *inode, struct file * file, unsigned int cmd_in, unsigned long arg)
 {
 	struct osst_tape *STp = file->private_data;
 	struct scsi_device *sdev = STp->device;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..e283650 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -921,7 +921,7 @@ static void sd_rescan(struct device *dev)
  * This gets directly called from VFS. When the ioctl 
  * is not recognized we go back to the other translation paths. 
  */
-static long sd_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int sd_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct block_device *bdev = file->f_path.dentry->d_inode->i_bdev;
 	struct gendisk *disk = bdev->bd_disk;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 661f9f2..5d4e1aa 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1113,7 +1113,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 }
 
 #ifdef CONFIG_COMPAT
-static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+static int sg_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c2bb53e..245c8ba 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3233,7 +3233,7 @@ static int partition_tape(struct scsi_tape *STp, int size)
 
 
 /* The ioctl command */
-static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
+static int st_ioctl(struct inode *inode, struct file *file, unsigned int cmd_in, unsigned long arg)
 {
 	int i, cmd_nr, cmd_type, bt;
 	int retval = 0;
@@ -3586,7 +3586,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-static long st_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int st_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct scsi_tape *STp = file->private_data;
 	struct scsi_device *sdev = STp->device;
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index e5e0cfe..70b3a16 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -299,8 +299,8 @@ done:
 	return status;
 }
 
-static long
-spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int
+spidev_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int			err = 0;
 	int			retval = 0;
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index ec7aeb5..afea51d 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -6661,7 +6661,7 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 	return retval;
 }
 
-static long ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
+static int ixj_ioctl(struct inode *inode, struct file *file_p, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	lock_kernel();
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 0647164..0fdca42 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -487,7 +487,7 @@ static unsigned int usblp_poll(struct file *file, struct poll_table_struct *wait
 	return ret;
 }
 
-static long usblp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int usblp_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct usblp *usblp = file->private_data;
 	int length, err, i;
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index f4585d3..c772d34 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -482,7 +482,7 @@ ep_release (struct inode *inode, struct file *fd)
 	return 0;
 }
 
-static long ep_ioctl(struct file *fd, unsigned code, unsigned long value)
+static int ep_ioctl(struct inode *inode, struct file *fd, unsigned code, unsigned long value)
 {
 	struct ep_data		*data = fd->private_data;
 	int			status;
@@ -1292,7 +1292,7 @@ out:
        return mask;
 }
 
-static long dev_ioctl (struct file *fd, unsigned code, unsigned long value)
+static int dev_ioctl(struct inode *inode, struct file *fd, unsigned code, unsigned long value)
 {
 	struct dev_data		*dev = fd->private_data;
 	struct usb_gadget	*gadget = dev->gadget;
@@ -1300,7 +1300,7 @@ static long dev_ioctl (struct file *fd, unsigned code, unsigned long value)
 
 	if (gadget->ops->ioctl) {
 		lock_kernel();
-		ret = gadget->ops->ioctl (gadget, code, value);
+		ret = gadget->ops->ioctl(gadget, code, value);
 		unlock_kernel();
 	}
 	return ret;
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index e009008..d02ce89 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -828,8 +828,8 @@ printer_poll(struct file *fd, poll_table *wait)
 	return status;
 }
 
-static long
-printer_ioctl(struct file *fd, unsigned int code, unsigned long arg)
+static int
+printer_ioctl(struct inode *inode, struct file *fd, unsigned int code, unsigned long arg)
 {
 	struct printer_dev	*dev = fd->private_data;
 	unsigned long		flags;
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index a4ef77e..5e3411a 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -473,7 +473,7 @@ exit:
 /**
  *	iowarrior_ioctl
  */
-static long iowarrior_ioctl(struct file *file, unsigned int cmd,
+static int iowarrior_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	struct iowarrior *dev = NULL;
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 248a12a..3ba8ef2 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -104,7 +104,7 @@ static int close_rio(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long ioctl_rio(struct file *file, unsigned int cmd, unsigned long arg)
+static int ioctl_rio(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct RioCommand rio_cmd;
 	struct rio_usb_data *rio = &rio_instance;
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 69c34a5..26142aa 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2982,8 +2982,8 @@ sisusb_handle_command(struct sisusb_usb_data *sisusb, struct sisusb_command *y,
 	return retval;
 }
 
-static long
-sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int
+sisusb_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct sisusb_usb_data *sisusb;
 	struct sisusb_info x;
@@ -3058,8 +3058,8 @@ err_out:
 }
 
 #ifdef SISUSB_NEW_CONFIG_COMPAT
-static long
-sisusb_compat_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static int
+sisusb_compat_ioctl(struct inode *inode, struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long retval;
 
@@ -3067,7 +3067,7 @@ sisusb_compat_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		case SISUSB_GET_CONFIG_SIZE:
 		case SISUSB_GET_CONFIG:
 		case SISUSB_COMMAND:
-			retval = sisusb_ioctl(f, cmd, arg);
+			retval = sisusb_ioctl(inode, f, cmd, arg);
 			return retval;
 
 		default:
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 2db4228..3f46226 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -146,7 +146,7 @@ static ssize_t lcd_read(struct file *file, char __user * buffer, size_t count, l
 	return retval;
 }
 
-static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int lcd_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct usb_lcd *dev;
 	u16 bcdDevice;
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 98843c2..aebf6f0 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1223,10 +1223,8 @@ static int fb_get_fscreeninfo(struct inode *inode, struct file *file,
 	return err;
 }
 
-static long
-fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int fb_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
 	struct fb_ops *fb = info->fbops;
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 6e46a55..7579e79 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -145,7 +145,7 @@ static ssize_t acq_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int acq_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index a5110f9..518c159 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -132,7 +132,7 @@ static ssize_t advwdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int advwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2a7690e..bde5fbc 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -176,7 +176,7 @@ static ssize_t ali_write(struct file *file, const char __user *data,
  *	we want an extension to enable irq ack monitoring and the like
  */
 
-static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int ali_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index a045ef8..4c0ef21 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -234,7 +234,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 55dcbfe..2dcd13e 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -240,7 +240,7 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 	return len;
 }
 
-static long ar7_wdt_ioctl(struct file *file,
+static int ar7_wdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	static struct watchdog_info ident = {
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index e8ae638..aafa445 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -212,7 +212,7 @@ static struct watchdog_info at32_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static long at32_wdt_ioctl(struct file *file,
+static int at32_wdt_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 993e5f5..8658fc7 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -128,7 +128,7 @@ static struct watchdog_info at91_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static long at91_wdt_ioctl(struct file *file,
+static int at91_wdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 31b4225..e82f2ed 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -248,7 +248,7 @@ static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
  *	Query basic information from the device or ping it, as outlined by the
  *	watchdog API.
  */
-static long bfin_wdt_ioctl(struct file *file,
+static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index c3b78a7..c5a7ce1 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -82,7 +82,7 @@ static struct watchdog_info ident = {
 	.identity = "PowerPC Book-E Watchdog",
 };
 
-static long booke_wdt_ioctl(struct file *file,
+static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 71f6d7e..feb30cd 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -148,7 +148,7 @@ static int cpu5wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
+static int cpu5wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 2e13602..81f676a 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -142,7 +142,7 @@ static struct watchdog_info ident = {
 	.identity = "DaVinci Watchdog",
 };
 
-static long davinci_wdt_ioctl(struct file *file,
+static int davinci_wdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index e9f950f..496a5fa 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -135,7 +135,7 @@ static struct watchdog_info ident = {
 	.identity = "EP93xx Watchdog",
 };
 
-static long ep93xx_wdt_ioctl(struct file *file,
+static int ep93xx_wdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index bbd14e3..ecb704d 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -233,7 +233,7 @@ size_t count, loff_t *ppos)
  * according to their available features.
  */
 
-static long eurwdt_ioctl(struct file *file,
+static int eurwdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a3765e0..de4a065 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -556,7 +556,7 @@ static struct watchdog_info ident = {
 	.identity = "HP iLO2 HW Watchdog Timer",
 };
 
-static long hpwdt_ioctl(struct file *file, unsigned int cmd,
+static int hpwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index c13383f..013eb0d 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -256,7 +256,7 @@ static ssize_t esb_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int esb_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
 	int new_heartbeat;
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index bfb93bc..4d1015a 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -510,7 +510,7 @@ static ssize_t iTCO_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
+static int iTCO_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 05a2810..53bf64d 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -187,7 +187,7 @@ static ssize_t ibwdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int ibwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin;
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index b82405c..14a32af 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -270,7 +270,7 @@ static ssize_t asr_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long asr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int asr_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	static const struct watchdog_info ident = {
 		.options =	WDIOF_KEEPALIVEPING |
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 73c9e79..97e8619 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -108,7 +108,7 @@ static ssize_t indydog_write(struct file *file, const char *data,
 	return len;
 }
 
-static long indydog_ioctl(struct file *file, unsigned int cmd,
+static int indydog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int options, retval = -EINVAL;
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index 96eb2cb..91070a7 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -130,7 +130,7 @@ static const struct watchdog_info ident = {
 	.identity = "iop watchdog",
 };
 
-static long iop_wdt_ioctl(struct file *file,
+static int iop_wdt_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	int options;
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 2270ee0..a2851a6 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -231,7 +231,7 @@ static ssize_t it8712f_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
+static int it8712f_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 4f4b35a..4e8c501 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -105,7 +105,7 @@ static struct watchdog_info ident = {
 	.identity	= "IXP2000 Watchdog",
 };
 
-static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
+static int ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 8302ef0..0933442 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -96,7 +96,7 @@ static struct watchdog_info ident = {
 };
 
 
-static long ixp4xx_wdt_ioctl(struct file *file, unsigned int cmd,
+static int ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 0b798fd..76b310f 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -152,7 +152,7 @@ static struct watchdog_info ks8695_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static long ks8695_wdt_ioctl(struct file *file, unsigned int cmd,
+static int ks8695_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 2dfc275..fb840c5 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -303,7 +303,7 @@ static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
 	return count;
 }
 
-static long zf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 407b025..cc1d238 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -195,7 +195,7 @@ static ssize_t mixcomwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long mixcomwd_ioctl(struct file *file,
+static int mixcomwd_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/mpc5200_wdt.c b/drivers/watchdog/mpc5200_wdt.c
index db91892..614bc2c 100644
--- a/drivers/watchdog/mpc5200_wdt.c
+++ b/drivers/watchdog/mpc5200_wdt.c
@@ -94,7 +94,7 @@ static struct watchdog_info mpc5200_wdt_info = {
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "mpc5200 watchdog on GPT0",
 };
-static long mpc5200_wdt_ioctl(struct file *file, unsigned int cmd,
+static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	struct mpc5200_wdt *wdt = file->private_data;
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 38c588e..243bce7 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -143,7 +143,7 @@ static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
+static int mpc8xxx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 2a9bfa8..91db86e 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -218,7 +218,7 @@ static struct watchdog_info ident = {
 	.identity		= "MPcore Watchdog",
 };
 
-static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
+static int mpcore_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	struct mpcore_wdt *wdt = file->private_data;
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index b4b7b0a..fd7f85d 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -136,7 +136,7 @@ static int mtx1_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long mtx1_wdt_ioctl(struct file *file, unsigned int cmd,
+static int mtx1_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index acf589d..b3dea2d 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -173,7 +173,7 @@ static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long mv64x60_wdt_ioctl(struct file *file,
+static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3a11dad..8bbc9bf 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -185,7 +185,7 @@ static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
+static int omap_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int new_margin;
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 484c215..9417f9c 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -397,7 +397,7 @@ static ssize_t pc87413_write(struct file *file, const char __user *data,
  *	querying capabilities and current status.
  */
 
-static long pc87413_ioctl(struct file *file, unsigned int cmd,
+static int pc87413_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int new_timeout;
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 9e1331a..0f6f9a6 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -594,7 +594,7 @@ static int pcwd_get_temperature(int *temperature)
  *	/dev/watchdog handling
  */
 
-static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int pcwd_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int rv;
 	int status;
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 90eb1d4..dae0372 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -453,7 +453,7 @@ static ssize_t pcipcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
+static int pcipcwd_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index c1685c9..68419ee 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -368,7 +368,7 @@ static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
+static int usb_pcwd_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 0ed8416..44ab680 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -173,7 +173,7 @@ static const struct watchdog_info ident = {
 	.identity = "PNX4008 Watchdog",
 };
 
-static long pnx4008_wdt_ioctl(struct inode *inode, struct file *file,
+static int pnx4008_wdt_ioctl(struct inode *inode, struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index f1ae372..384738c 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -55,7 +55,7 @@ static int wdt_gpi_open(struct inode *, struct file *);
 static int wdt_gpi_release(struct inode *, struct file *);
 static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t,
 								loff_t *);
-static long wdt_gpi_ioctl(struct file *, unsigned int, unsigned long);
+static int wdt_gpi_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 static int wdt_gpi_notify(struct notifier_block *, unsigned long, void *);
 static const struct resource *wdt_gpi_get_resource(struct platform_device *,
 						const char *, unsigned int);
@@ -244,7 +244,7 @@ static ssize_t wdt_gpi_write(struct file *f, const char __user *d, size_t s,
 	return s ? 1 : 0;
 }
 
-static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static int wdt_gpi_ioctl(struct inode *inode, struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long res = -ENOTTY;
 	const long size = _IOC_SIZE(cmd);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 86d4280..28e9488 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -272,7 +272,7 @@ static const struct watchdog_info s3c2410_wdt_ident = {
 };
 
 
-static long s3c2410wdt_ioctl(struct file *file,	unsigned int cmd,
+static int s3c2410wdt_ioctl(struct inode *inode, struct file *file,	unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 31a4843..30d2bda 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -86,7 +86,7 @@ static const struct watchdog_info ident = {
 	.identity	= "SA1100/PXA255 Watchdog",
 };
 
-static long sa1100dog_ioctl(struct file *file, unsigned int cmd,
+static int sa1100dog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 27e526a..55aa97b 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -164,7 +164,7 @@ static ssize_t sbwdog_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long sbwdog_ioctl(struct file *file, unsigned int cmd,
+static int sbwdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int ret = -ENOTTY;
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 3266daa..9507175 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -225,7 +225,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 67ddeb1..74d648c 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -168,7 +168,7 @@ static const struct watchdog_info ident = {
 };
 
 
-static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index e5e470c..a367d9f 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -100,7 +100,7 @@ static ssize_t epx_c3_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long epx_c3_ioctl(struct file *file, unsigned int cmd,
+static int epx_c3_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int options, retval = -EINVAL;
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 23da3cc..0f57878 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -182,7 +182,7 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 }
 
 
-static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
+static int sc1200wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 						unsigned long arg)
 {
 	int new_timeout;
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index a2b6c10..d2851bf 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -279,7 +279,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index 9e19a10..8203518 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -155,7 +155,7 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 	return 0;
 }
 
-static long scx200_wdt_ioctl(struct file *file, unsigned int cmd,
+static int scx200_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index cdc7138..8eebcb3 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -338,7 +338,7 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
  * 	Query basic information from the device or ping it, as outlined by the
  * 	watchdog API.
  */
-static long sh_wdt_ioctl(struct file *file, unsigned int cmd,
+static int sh_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int new_heartbeat;
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 988ff1d..09828f1 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -423,7 +423,7 @@ static ssize_t wb_smsc_wdt_write(struct file *file, const char __user *data,
 
 /* ioctl => control interface */
 
-static long wb_smsc_wdt_ioctl(struct file *file,
+static int wb_smsc_wdt_ioctl(struct inode *inode, struct file *file,
 					unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index c650464..9a2d3fa 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -192,7 +192,7 @@ static ssize_t softdog_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long softdog_ioctl(struct file *file, unsigned int cmd,
+static int softdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 6adab77..8184c55 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -127,7 +127,7 @@ static ssize_t txx9wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
+static int txx9wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 69396ad..9ec4bed 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -191,7 +191,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 445d30a..b969baa 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -229,7 +229,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 24587d2..36ed0b2 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -242,7 +242,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 2525da5..ab029dd 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -377,7 +377,7 @@ static struct watchdog_info ident = {
 	.identity = WATCHDOG_NAME,
 };
 
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int status;
 	int new_options, retval = -EINVAL;
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 68377ae..06e6cae 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -121,7 +121,7 @@ static ssize_t wafwdt_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static long wafwdt_ioctl(struct file *file, unsigned int cmd,
+static int wafwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int new_timeout;
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 5d3b1a8..823ed73 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -305,7 +305,7 @@ out:
  * wdrtas_ioctl implements the watchdog API ioctls
  */
 
-static long wdrtas_ioctl(struct file *file, unsigned int cmd,
+static int wdrtas_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int __user *argp = (void __user *)arg;
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index deeebb2..cfbba80 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -349,7 +349,7 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
  *	querying capabilities and current status.
  */
 
-static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index db362c3..e799311 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -132,7 +132,7 @@ static const struct watchdog_info ident = {
 	.identity	= "Footbridge Watchdog",
 };
 
-static long watchdog_ioctl(struct file *file, unsigned int cmd,
+static int watchdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	unsigned int new_margin;
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 60e28d4..348674f 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -351,7 +351,7 @@ static const struct watchdog_info ident = {
  *      according to their available features.
  */
 
-static long wdt977_ioctl(struct file *file, unsigned int cmd,
+static int wdt977_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int status;
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index ed02bdb..2d6a3e5 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -403,7 +403,7 @@ static ssize_t wdtpci_write(struct file *file, const char __user *buf,
  *	querying capabilities and current status.
  */
 
-static long wdtpci_ioctl(struct file *file, unsigned int cmd,
+static int wdtpci_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 							unsigned long arg)
 {
 	int new_heartbeat;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 5f1538c..acb7af1 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -61,13 +61,13 @@ static int bad_file_ioctl (struct inode *inode, struct file *filp,
 	return -EIO;
 }
 
-static long bad_file_unlocked_ioctl(struct file *file, unsigned cmd,
+static int bad_file_unlocked_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 			unsigned long arg)
 {
 	return -EIO;
 }
 
-static long bad_file_compat_ioctl(struct file *file, unsigned int cmd,
+static int bad_file_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			unsigned long arg)
 {
 	return -EIO;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index aff5421..d1384f0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1150,8 +1150,13 @@ static int blkdev_close(struct inode * inode, struct file * filp)
 	return blkdev_put(bdev);
 }
 
-static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+static int block_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg)
 {
+	/*
+	 * NOTE! We ignore the on-disk inode that was passed as
+	 * an argument, and use the "f_mapping->host" inode for
+	 * all block ioctls!
+	 */
 	return blkdev_ioctl(file->f_mapping->host, file, cmd, arg);
 }
 
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 135c965..f46a281 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -95,7 +95,7 @@ extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
-extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
+extern int cifs_ioctl(struct inode *inode, struct file *filep, unsigned int cmd, unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 0088a5b..c6b9fa4 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -30,9 +30,8 @@
 
 #define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
 
-long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
+int cifs_ioctl(struct inode *inode, struct file *filep, unsigned int command, unsigned long arg)
 {
-	struct inode *inode = filep->f_dentry->d_inode;
 	int rc = -ENOTTY; /* strange error - but the precedent */
 	int xid;
 	struct cifs_sb_info *cifs_sb;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..d3a3093 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2804,7 +2804,8 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 
 	default:
 		if (filp->f_op && filp->f_op->compat_ioctl) {
-			error = filp->f_op->compat_ioctl(filp, cmd, arg);
+			struct inode *inode = filp->f_dentry->d_inode;
+			error = filp->f_op->compat_ioctl(inode, filp, cmd, arg);
 			if (error != -ENOIOCTLCMD)
 				goto out_fput;
 		}
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 47d88da..6924f85 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -138,8 +138,8 @@ int __ext2_write_begin(struct file *file, struct address_space *mapping,
 		struct page **pagep, void **fsdata);
 
 /* ioctl.c */
-extern long ext2_ioctl(struct file *, unsigned int, unsigned long);
-extern long ext2_compat_ioctl(struct file *, unsigned int, unsigned long);
+extern int ext2_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
+extern int ext2_compat_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 
 /* namei.c */
 struct dentry *ext2_get_parent(struct dentry *child);
diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index de876fa..ba84585 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -18,9 +18,8 @@
 #include <asm/uaccess.h>
 
 
-long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int ext2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -156,7 +155,7 @@ setflags_out:
 }
 
 #ifdef CONFIG_COMPAT
-long ext2_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int ext2_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
@@ -175,6 +174,6 @@ long ext2_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		return -ENOIOCTLCMD;
 	}
-	return ext2_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
+	return ext2_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index 0d0c701..7cf4617 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -294,9 +294,8 @@ group_add_out:
 }
 
 #ifdef CONFIG_COMPAT
-long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int ext3_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	/* These are just misnamed, they actually get/put from/to user an int */
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2950032..4bee000 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1079,8 +1079,8 @@ extern int ext4_block_truncate_page(handle_t *handle,
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
 /* ioctl.c */
-extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
-extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
+extern int ext4_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
+extern int ext4_compat_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 
 /* migrate.c */
 extern int ext4_ext_migrate(struct inode *, struct file *, unsigned int,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 7a6c2f1..f72db70 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -18,9 +18,8 @@
 #include "ext4_jbd2.h"
 #include "ext4.h"
 
-long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int ext4_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
@@ -275,7 +274,7 @@ setversion_out:
 }
 
 #ifdef CONFIG_COMPAT
-long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int ext4_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
@@ -316,6 +315,6 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		return -ENOIOCTLCMD;
 	}
-	return ext4_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
+	return ext4_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
 }
 #endif
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index cd4a016..32c94b1 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -796,10 +796,9 @@ static int fat_dir_ioctl(struct inode *inode, struct file *filp,
 
 FAT_IOCTL_FILLDIR_FUNC(fat_compat_ioctl_filldir, compat_dirent)
 
-static long fat_compat_dir_ioctl(struct file *filp, unsigned cmd,
+static int fat_compat_dir_ioctl(struct inode *inode, struct file *filp, unsigned cmd,
 				 unsigned long arg)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct compat_dirent __user *d1 = compat_ptr(arg);
 	int short_only, both;
 
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index e9a366d..b7bf87c 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -289,7 +289,7 @@ static int gfs2_set_flags(struct file *filp, u32 __user *ptr)
 	return do_gfs2_set_flags(filp, gfsflags, ~GFS2_DIF_JDATA);
 }
 
-static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int gfs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	switch(cmd) {
 	case FS_IOC_GETFLAGS:
diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 6024942..9cfde4e 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -533,7 +533,7 @@ static int inotify_release(struct inode *ignored, struct file *file)
 	return 0;
 }
 
-static long inotify_ioctl(struct file *file, unsigned int cmd,
+static int inotify_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			  unsigned long arg)
 {
 	struct inotify_device *dev;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 7db32b3..2adb993 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -31,20 +31,20 @@
 static long vfs_ioctl(struct file *filp, unsigned int cmd,
 		      unsigned long arg)
 {
+	struct inode *inode;
 	int error = -ENOTTY;
 
 	if (!filp->f_op)
 		goto out;
 
+	inode = filp->f_path.dentry->d_inode;
 	if (filp->f_op->unlocked_ioctl) {
-		error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
+		error = filp->f_op->unlocked_ioctl(inode, filp, cmd, arg);
 		if (error == -ENOIOCTLCMD)
 			error = -EINVAL;
-		goto out;
 	} else if (filp->f_op->ioctl) {
 		lock_kernel();
-		error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
-					  filp, cmd, arg);
+		error = filp->f_op->ioctl(inode, filp, cmd, arg);
 		unlock_kernel();
 	}
 
diff --git a/fs/jffs2/ioctl.c b/fs/jffs2/ioctl.c
index 9d41f43..80aa967 100644
--- a/fs/jffs2/ioctl.c
+++ b/fs/jffs2/ioctl.c
@@ -12,7 +12,7 @@
 #include <linux/fs.h>
 #include "nodelist.h"
 
-long jffs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
 	   will include compression support etc. */
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 5e194a5..7ef2c62 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -167,7 +167,7 @@ int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
 
 /* ioctl.c */
-long jffs2_ioctl(struct file *, unsigned int, unsigned long);
+int jffs2_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 
 /* symlink.c */
 extern const struct inode_operations jffs2_symlink_inode_operations;
diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
index afe222b..0fdf047 100644
--- a/fs/jfs/ioctl.c
+++ b/fs/jfs/ioctl.c
@@ -52,9 +52,8 @@ static long jfs_map_ext2(unsigned long flags, int from)
 }
 
 
-long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int jfs_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
 	struct jfs_inode_info *jfs_inode = JFS_IP(inode);
 	unsigned int flags;
 
@@ -129,7 +128,7 @@ setflags_out:
 }
 
 #ifdef CONFIG_COMPAT
-long jfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int jfs_compat_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	/* While these ioctl numbers defined with 'long' and have different
 	 * numbers than the 64bit ABI,
@@ -143,6 +142,6 @@ long jfs_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		cmd = JFS_IOC_SETFLAGS;
 		break;
 	}
-	return jfs_ioctl(filp, cmd, arg);
+	return jfs_ioctl(inode, filp, cmd, arg);
 }
 #endif
diff --git a/fs/jfs/jfs_inode.h b/fs/jfs/jfs_inode.h
index adb2faf..a94ca32 100644
--- a/fs/jfs/jfs_inode.h
+++ b/fs/jfs/jfs_inode.h
@@ -22,8 +22,8 @@ struct fid;
 
 extern struct inode *ialloc(struct inode *, umode_t);
 extern int jfs_fsync(struct file *, struct dentry *, int);
-extern long jfs_ioctl(struct file *, unsigned int, unsigned long);
-extern long jfs_compat_ioctl(struct file *, unsigned int, unsigned long);
+extern int jfs_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
+extern int jfs_compat_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 extern struct inode *jfs_iget(struct super_block *, unsigned long);
 extern int jfs_commit_inode(struct inode *, int);
 extern int jfs_write_inode(struct inode*, int);
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 3a97c95..75c3c29 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -874,9 +874,8 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 }
 
 #ifdef CONFIG_COMPAT
-long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int ncp_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	lock_kernel();
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 7b142f0..bf5c6a2 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -109,9 +109,8 @@ bail:
 	return status;
 }
 
-long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+int ocfs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	unsigned int flags;
 	int new_clusters;
 	int status;
@@ -168,7 +167,7 @@ long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+int ocfs2_compat_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case OCFS2_IOC32_GETFLAGS:
@@ -189,6 +188,6 @@ long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return -ENOIOCTLCMD;
 	}
 
-	return ocfs2_ioctl(file, cmd, arg);
+	return ocfs2_ioctl(inode, file, cmd, arg);
 }
 #endif
diff --git a/fs/ocfs2/ioctl.h b/fs/ocfs2/ioctl.h
index cf9a5ee..0632b05 100644
--- a/fs/ocfs2/ioctl.h
+++ b/fs/ocfs2/ioctl.h
@@ -10,7 +10,7 @@
 #ifndef OCFS2_IOCTL_H
 #define OCFS2_IOCTL_H
 
-long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
-long ocfs2_compat_ioctl(struct file *file, unsigned cmd, unsigned long arg);
+int ocfs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
+int ocfs2_compat_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg);
 
 #endif /* OCFS2_IOCTL_H */
diff --git a/fs/pipe.c b/fs/pipe.c
index fcba654..8765108 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -577,9 +577,8 @@ bad_pipe_w(struct file *filp, const char __user *buf, size_t count,
 	return -EBADF;
 }
 
-static long pipe_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int pipe_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct pipe_inode_info *pipe;
 	int count, buf, nrbufs;
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 8bb03f0..711bb4f 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -239,11 +239,11 @@ static unsigned int proc_reg_poll(struct file *file, struct poll_table_struct *p
 	return rv;
 }
 
-static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int proc_reg_unlocked_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
-	long (*unlocked_ioctl)(struct file *, unsigned int, unsigned long);
+	int (*unlocked_ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
 	int (*ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
 
 	spin_lock(&pde->pde_unload_lock);
@@ -257,12 +257,12 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (unlocked_ioctl) {
-		rv = unlocked_ioctl(file, cmd, arg);
+		rv = unlocked_ioctl(inode, file, cmd, arg);
 		if (rv == -ENOIOCTLCMD)
 			rv = -EINVAL;
 	} else if (ioctl) {
 		lock_kernel();
-		rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+		rv = ioctl(inode, file, cmd, arg);
 		unlock_kernel();
 	}
 
@@ -271,11 +271,11 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
 }
 
 #ifdef CONFIG_COMPAT
-static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int proc_reg_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	long rv = -ENOTTY;
-	long (*compat_ioctl)(struct file *, unsigned int, unsigned long);
+	int (*compat_ioctl)(struct inode *, struct file *, unsigned int, unsigned long);
 
 	spin_lock(&pde->pde_unload_lock);
 	if (!pde->proc_fops) {
@@ -287,7 +287,7 @@ static long proc_reg_compat_ioctl(struct file *file, unsigned int cmd, unsigned
 	spin_unlock(&pde->pde_unload_lock);
 
 	if (compat_ioctl)
-		rv = compat_ioctl(file, cmd, arg);
+		rv = compat_ioctl(inode, file, cmd, arg);
 
 	pde_users_dec(pde);
 	return rv;
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 8303320..d85fe0d 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -115,10 +115,9 @@ setversion_out:
 }
 
 #ifdef CONFIG_COMPAT
-long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
+int reiserfs_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	/* These are just misnamed, they actually get/put from/to user an int */
diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index 5e82cff..08cf595 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -145,10 +145,9 @@ out_unlock:
 	return err;
 }
 
-long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int ubifs_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int flags, err;
-	struct inode *inode = file->f_path.dentry->d_inode;
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
@@ -187,7 +186,7 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
-long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int ubifs_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case FS_IOC32_GETFLAGS:
@@ -199,6 +198,6 @@ long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		return -ENOIOCTLCMD;
 	}
-	return ubifs_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+	return ubifs_ioctl(inode, file, cmd, (unsigned long)compat_ptr(arg));
 }
 #endif
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index d7f706f..d82737e 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1639,10 +1639,10 @@ int ubifs_recover_size(struct ubifs_info *c);
 void ubifs_destroy_size_tree(struct ubifs_info *c);
 
 /* ioctl.c */
-long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int ubifs_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 void ubifs_set_inode_flags(struct inode *inode);
 #ifdef CONFIG_COMPAT
-long ubifs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+int ubifs_compat_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 #endif
 
 /* compressor.c */
diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 5311c1a..a4c1d10 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -376,14 +376,14 @@ xfs_file_mmap(
 	return 0;
 }
 
-STATIC long
+STATIC int
 xfs_file_ioctl(
+	struct inode	*inode,
 	struct file	*filp,
 	unsigned int	cmd,
 	unsigned long	p)
 {
 	int		error;
-	struct inode	*inode = filp->f_path.dentry->d_inode;
 
 	error = xfs_ioctl(XFS_I(inode), filp, 0, cmd, (void __user *)p);
 	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
@@ -397,14 +397,14 @@ xfs_file_ioctl(
 	return error;
 }
 
-STATIC long
+STATIC int
 xfs_file_ioctl_invis(
+	struct inode	*inode,
 	struct file	*filp,
 	unsigned int	cmd,
 	unsigned long	p)
 {
 	int		error;
-	struct inode	*inode = filp->f_path.dentry->d_inode;
 
 	error = xfs_ioctl(XFS_I(inode), filp, IO_INVIS, cmd, (void __user *)p);
 	xfs_iflags_set(XFS_I(inode), XFS_IMODIFIED);
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
index a4b254e..dfe42ab 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -469,8 +469,9 @@ xfs_compat_ioctl(
 	return error;
 }
 
-long
+int
 xfs_file_compat_ioctl(
+	struct inode		*inode,
 	struct file		*file,
 	unsigned		cmd,
 	unsigned long		arg)
@@ -478,8 +479,9 @@ xfs_file_compat_ioctl(
 	return xfs_compat_ioctl(0, file, cmd, arg);
 }
 
-long
+int
 xfs_file_compat_invis_ioctl(
+	struct inode		*inode,
 	struct file		*file,
 	unsigned		cmd,
 	unsigned long		arg)
diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.h b/fs/xfs/linux-2.6/xfs_ioctl32.h
index 02de6e6..7e64783 100644
--- a/fs/xfs/linux-2.6/xfs_ioctl32.h
+++ b/fs/xfs/linux-2.6/xfs_ioctl32.h
@@ -18,7 +18,7 @@
 #ifndef __XFS_IOCTL32_H__
 #define __XFS_IOCTL32_H__
 
-extern long xfs_file_compat_ioctl(struct file *, unsigned, unsigned long);
-extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
+extern int xfs_file_compat_ioctl(struct inode *inode, struct file *, unsigned, unsigned long);
+extern int xfs_file_compat_invis_ioctl(struct inode *inode, struct file *, unsigned, unsigned long);
 
 #endif /* __XFS_IOCTL32_H__ */
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 80171ee..c30e0ab 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -841,7 +841,7 @@ extern void ext3_set_aops(struct inode *inode);
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
 		       unsigned long);
-extern long ext3_compat_ioctl (struct file *, unsigned int, unsigned long);
+extern int ext3_compat_ioctl (struct inode *, struct file *, unsigned int, unsigned long);
 
 /* namei.c */
 extern int ext3_orphan_add(handle_t *, struct inode *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..9bcfbcd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1211,8 +1211,8 @@ struct block_device_operations {
 	int (*open) (struct inode *, struct file *);
 	int (*release) (struct inode *, struct file *);
 	int (*ioctl) (struct inode *, struct file *, unsigned, unsigned long);
-	long (*unlocked_ioctl) (struct file *, unsigned, unsigned long);
-	long (*compat_ioctl) (struct file *, unsigned, unsigned long);
+	int (*unlocked_ioctl) (struct inode *, struct file *, unsigned, unsigned long);
+	int (*compat_ioctl) (struct inode *, struct file *, unsigned, unsigned long);
 	int (*direct_access) (struct block_device *, sector_t,
 						void **, unsigned long *);
 	int (*media_changed) (struct gendisk *);
@@ -1242,8 +1242,8 @@ struct file_operations {
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
-	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
-	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*unlocked_ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
+	int (*compat_ioctl) (struct inode *,struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
@@ -1656,7 +1656,7 @@ extern int blkdev_ioctl(struct inode *, struct file *, unsigned, unsigned long);
 extern int blkdev_driver_ioctl(struct inode *inode, struct file *file,
 			       struct gendisk *disk, unsigned cmd,
 			       unsigned long arg);
-extern long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
+extern int compat_blkdev_ioctl(struct inode *inode, struct file *, unsigned, unsigned long);
 extern int blkdev_get(struct block_device *, mode_t, unsigned);
 extern int blkdev_put(struct block_device *);
 extern int bd_claim(struct block_device *, void *);
diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 9f2d763..af7d026 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -211,7 +211,7 @@ void ncp_date_unix2dos(int unix_date, __le16 * time, __le16 * date);
 
 /* linux/fs/ncpfs/ioctl.c */
 int ncp_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
-long ncp_compat_ioctl(struct file *, unsigned int, unsigned long);
+int ncp_compat_ioctl(struct inode *inode, struct file *, unsigned int, unsigned long);
 
 /* linux/fs/ncpfs/sock.c */
 int ncp_request2(struct ncp_server *server, int function,
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index e9963af..3422037 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -2174,7 +2174,7 @@ __u32 r5_hash(const signed char *msg, int len);
 /* prototypes from ioctl.c */
 int reiserfs_ioctl(struct inode *inode, struct file *filp,
 		   unsigned int cmd, unsigned long arg);
-long reiserfs_compat_ioctl(struct file *filp,
+int reiserfs_compat_ioctl(struct inode *inode, struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 int reiserfs_unpack(struct inode *inode, struct file *filp);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 0cbec74..bdb65a2 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -365,7 +365,7 @@ extern const struct file_operations tty_ldiscs_proc_fops;
 extern void tty_wakeup(struct tty_struct *tty);
 extern void tty_ldisc_flush(struct tty_struct *tty);
 
-extern long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
diff --git a/include/linux/wanrouter.h b/include/linux/wanrouter.h
index e0aa396..82d2547 100644
--- a/include/linux/wanrouter.h
+++ b/include/linux/wanrouter.h
@@ -522,7 +522,7 @@ extern int wanrouter_proc_init(void);
 extern void wanrouter_proc_cleanup(void);
 extern int wanrouter_proc_add(struct wan_device *wandev);
 extern int wanrouter_proc_delete(struct wan_device *wandev);
-extern long wanrouter_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+extern int wanrouter_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 
 /* Public Data */
 /* list of registered devices */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index dc64046..9ab9474 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -286,7 +286,7 @@ int v4l_compat_translate_ioctl(struct inode *inode, struct file *file,
 #endif
 
 /* 32 Bits compatibility layer for 64 bits processors */
-extern long v4l_compat_ioctl32(struct file *file, unsigned int cmd,
+extern int v4l_compat_ioctl32(struct inode *inode, struct file *file, unsigned int cmd,
 				unsigned long arg);
 
 extern int video_ioctl2(struct inode *inode, struct file *file,
diff --git a/kernel/power/user.c b/kernel/power/user.c
index a6332a3..6f8b19d 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -187,7 +187,7 @@ static ssize_t snapshot_write(struct file *filp, const char __user *buf,
 	return res;
 }
 
-static long snapshot_ioctl(struct file *filp, unsigned int cmd,
+static int snapshot_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 							unsigned long arg)
 {
 	int error = 0;
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 6d8ae03..ae45f37 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -631,8 +631,9 @@ dev_irnet_poll(struct file *	file,
  * This is the way pppd configure us and control us while the PPP
  * instance is active.
  */
-static long
+static int
 dev_irnet_ioctl(
+		struct inode *	inode,
 		struct file *	file,
 		unsigned int	cmd,
 		unsigned long	arg)
diff --git a/net/irda/irnet/irnet_ppp.h b/net/irda/irnet/irnet_ppp.h
index d9f8bd4..44bd8ec 100644
--- a/net/irda/irnet/irnet_ppp.h
+++ b/net/irda/irnet/irnet_ppp.h
@@ -76,8 +76,9 @@ static ssize_t
 static unsigned int
 	dev_irnet_poll(struct file *,
 		       poll_table *);
-static long
-	dev_irnet_ioctl(struct file *,
+static int
+	dev_irnet_ioctl(struct inode *,
+			struct file *,
 			unsigned int,
 			unsigned long);
 /* ------------------------ PPP INTERFACE ------------------------ */
diff --git a/net/socket.c b/net/socket.c
index 8ef8ba8..5d6824b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -107,9 +107,9 @@ static int sock_mmap(struct file *file, struct vm_area_struct *vma);
 static int sock_close(struct inode *inode, struct file *file);
 static unsigned int sock_poll(struct file *file,
 			      struct poll_table_struct *wait);
-static long sock_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static int sock_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
-static long compat_sock_ioctl(struct file *file,
+static int compat_sock_ioctl(struct inode *inode, struct file *file,
 			      unsigned int cmd, unsigned long arg);
 #endif
 static int sock_fasync(int fd, struct file *filp, int on);
@@ -850,7 +850,7 @@ EXPORT_SYMBOL(dlci_ioctl_set);
  *	what to do with it - that's up to the protocol still.
  */
 
-static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
+static int sock_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg)
 {
 	struct socket *sock;
 	struct sock *sk;
@@ -2316,7 +2316,7 @@ void socket_seq_show(struct seq_file *seq)
 #endif				/* CONFIG_PROC_FS */
 
 #ifdef CONFIG_COMPAT
-static long compat_sock_ioctl(struct file *file, unsigned cmd,
+static int compat_sock_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 			      unsigned long arg)
 {
 	struct socket *sock = file->private_data;
diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 7f07152..2974428 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -349,9 +349,8 @@ __be16 wanrouter_type_trans(struct sk_buff *skb, struct net_device *dev)
  *	o execute requested action or pass command to the device driver
  */
 
-long wanrouter_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+int wanrouter_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int err = 0;
 	struct proc_dir_entry *dent;
 	struct wan_device *wandev;
diff --git a/sound/core/control.c b/sound/core/control.c
index 281b2e2..f10a3f0 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1149,7 +1149,7 @@ static int snd_ctl_tlv_ioctl(struct snd_ctl_file *file,
 	return err;
 }
 
-static long snd_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_ctl_file *ctl;
 	struct snd_card *card;
diff --git a/sound/core/control_compat.c b/sound/core/control_compat.c
index 6101259..0af5c5b 100644
--- a/sound/core/control_compat.c
+++ b/sound/core/control_compat.c
@@ -390,7 +390,7 @@ enum {
 	SNDRV_CTL_IOCTL_ELEM_REPLACE32 = _IOWR('U', 0x18, struct snd_ctl_elem_info32),
 };
 
-static inline long snd_ctl_ioctl_compat(struct file *file, unsigned int cmd, unsigned long arg)
+static inline int snd_ctl_ioctl_compat(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_ctl_file *ctl;
 	struct snd_kctl_ioctl *p;
@@ -412,7 +412,7 @@ static inline long snd_ctl_ioctl_compat(struct file *file, unsigned int cmd, uns
 	case SNDRV_CTL_IOCTL_TLV_READ:
 	case SNDRV_CTL_IOCTL_TLV_WRITE:
 	case SNDRV_CTL_IOCTL_TLV_COMMAND:
-		return snd_ctl_ioctl(file, cmd, (unsigned long)argp);
+		return snd_ctl_ioctl(inode, file, cmd, (unsigned long)argp);
 	case SNDRV_CTL_IOCTL_ELEM_LIST32:
 		return snd_ctl_elem_list_compat(ctl->card, argp);
 	case SNDRV_CTL_IOCTL_ELEM_INFO32:
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 6d6589f..7518eaa 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -231,7 +231,7 @@ static int snd_hwdep_dsp_load(struct snd_hwdep *hw,
 	return 0;
 }
 
-static long snd_hwdep_ioctl(struct file * file, unsigned int cmd,
+static int snd_hwdep_ioctl(struct inode *inode, struct file * file, unsigned int cmd,
 			    unsigned long arg)
 {
 	struct snd_hwdep *hw = file->private_data;
diff --git a/sound/core/hwdep_compat.c b/sound/core/hwdep_compat.c
index 3827c0c..3c7cc2a 100644
--- a/sound/core/hwdep_compat.c
+++ b/sound/core/hwdep_compat.c
@@ -59,7 +59,7 @@ enum {
 	SNDRV_HWDEP_IOCTL_DSP_LOAD32   = _IOW('H', 0x03, struct snd_hwdep_dsp_image32)
 };
 
-static long snd_hwdep_ioctl_compat(struct file * file, unsigned int cmd,
+static int snd_hwdep_ioctl_compat(struct inode *inode, struct file * file, unsigned int cmd,
 				   unsigned long arg)
 {
 	struct snd_hwdep *hw = file->private_data;
@@ -68,7 +68,7 @@ static long snd_hwdep_ioctl_compat(struct file * file, unsigned int cmd,
 	case SNDRV_HWDEP_IOCTL_PVERSION:
 	case SNDRV_HWDEP_IOCTL_INFO:
 	case SNDRV_HWDEP_IOCTL_DSP_STATUS:
-		return snd_hwdep_ioctl(file, cmd, (unsigned long)argp);
+		return snd_hwdep_ioctl(inode, file, cmd, (unsigned long)argp);
 	case SNDRV_HWDEP_IOCTL_DSP_LOAD32:
 		return snd_hwdep_dsp_load_compat(hw, argp);
 	}
diff --git a/sound/core/info.c b/sound/core/info.c
index c67773a..5f8e1e9 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -465,7 +465,7 @@ static unsigned int snd_info_entry_poll(struct file *file, poll_table * wait)
 	return mask;
 }
 
-static long snd_info_entry_ioctl(struct file *file, unsigned int cmd,
+static int snd_info_entry_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
 	struct snd_info_private_data *data;
diff --git a/sound/core/init.c b/sound/core/init.c
index df46bbc..82323a2 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -275,7 +275,7 @@ static unsigned int snd_disconnect_poll(struct file * file, poll_table * wait)
 	return POLLERR | POLLNVAL;
 }
 
-static long snd_disconnect_ioctl(struct file *file,
+static int snd_disconnect_ioctl(struct inode *inode, struct file *file,
 				 unsigned int cmd, unsigned long arg)
 {
 	return -ENODEV;
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 581aa2c..273f177 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -359,7 +359,7 @@ static int snd_mixer_oss_ioctl1(struct snd_mixer_oss_file *fmixer, unsigned int
 	return -ENXIO;
 }
 
-static long snd_mixer_oss_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_mixer_oss_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return snd_mixer_oss_ioctl1((struct snd_mixer_oss_file *) file->private_data, cmd, arg);
 }
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 4c601b1..229513c 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2428,7 +2428,7 @@ static int snd_pcm_oss_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long snd_pcm_oss_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_pcm_oss_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_pcm_oss_file *pcm_oss_file;
 	int __user *p = (int __user *)arg;
diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 49aa693..f480fda 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -460,7 +460,7 @@ enum {
 
 };
 
-static long snd_pcm_ioctl_compat(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_pcm_ioctl_compat(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_pcm_file *pcm_file;
 	struct snd_pcm_substream *substream;
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index c49b9d9..4c703aa 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2726,7 +2726,7 @@ static int snd_pcm_capture_ioctl1(struct file *file,
 	return snd_pcm_common_ioctl1(file, substream, cmd, arg);
 }
 
-static long snd_pcm_playback_ioctl(struct file *file, unsigned int cmd,
+static int snd_pcm_playback_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				   unsigned long arg)
 {
 	struct snd_pcm_file *pcm_file;
@@ -2740,7 +2740,7 @@ static long snd_pcm_playback_ioctl(struct file *file, unsigned int cmd,
 				       (void __user *)arg);
 }
 
-static long snd_pcm_capture_ioctl(struct file *file, unsigned int cmd,
+static int snd_pcm_capture_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
 	struct snd_pcm_file *pcm_file;
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index f7ea728..8c103ca 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -687,7 +687,7 @@ static int snd_rawmidi_input_status(struct snd_rawmidi_substream *substream,
 	return 0;
 }
 
-static long snd_rawmidi_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_rawmidi_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_rawmidi_file *rfile;
 	void __user *argp = (void __user *)arg;
diff --git a/sound/core/rawmidi_compat.c b/sound/core/rawmidi_compat.c
index 5268c1f..2764275 100644
--- a/sound/core/rawmidi_compat.c
+++ b/sound/core/rawmidi_compat.c
@@ -99,7 +99,7 @@ enum {
 	SNDRV_RAWMIDI_IOCTL_STATUS32 = _IOWR('W', 0x20, struct snd_rawmidi_status32),
 };
 
-static long snd_rawmidi_ioctl_compat(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_rawmidi_ioctl_compat(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_rawmidi_file *rfile;
 	void __user *argp = compat_ptr(arg);
@@ -110,7 +110,7 @@ static long snd_rawmidi_ioctl_compat(struct file *file, unsigned int cmd, unsign
 	case SNDRV_RAWMIDI_IOCTL_INFO:
 	case SNDRV_RAWMIDI_IOCTL_DROP:
 	case SNDRV_RAWMIDI_IOCTL_DRAIN:
-		return snd_rawmidi_ioctl(file, cmd, (unsigned long)argp);
+		return snd_rawmidi_ioctl(inode, file, cmd, (unsigned long)argp);
 	case SNDRV_RAWMIDI_IOCTL_PARAMS32:
 		return snd_rawmidi_ioctl_params_compat(rfile, argp);
 	case SNDRV_RAWMIDI_IOCTL_STATUS32:
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index 777796e..b1fd18e 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -63,7 +63,7 @@ static int odev_open(struct inode *inode, struct file *file);
 static int odev_release(struct inode *inode, struct file *file);
 static ssize_t odev_read(struct file *file, char __user *buf, size_t count, loff_t *offset);
 static ssize_t odev_write(struct file *file, const char __user *buf, size_t count, loff_t *offset);
-static long odev_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+static int odev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 static unsigned int odev_poll(struct file *file, poll_table * wait);
 
 
@@ -178,8 +178,8 @@ odev_write(struct file *file, const char __user *buf, size_t count, loff_t *offs
 	return snd_seq_oss_write(dp, buf, count, file);
 }
 
-static long
-odev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int
+odev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct seq_oss_devinfo *dp;
 	dp = file->private_data;
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 7a1545d..d9ebb9d 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2191,7 +2191,7 @@ static int snd_seq_do_ioctl(struct snd_seq_client *client, unsigned int cmd,
 }
 
 
-static long snd_seq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_seq_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_seq_client *client = file->private_data;
 
diff --git a/sound/core/seq/seq_compat.c b/sound/core/seq/seq_compat.c
index 9628c06..f1a7060 100644
--- a/sound/core/seq/seq_compat.c
+++ b/sound/core/seq/seq_compat.c
@@ -87,7 +87,7 @@ enum {
 	SNDRV_SEQ_IOCTL_QUERY_NEXT_PORT32 = _IOWR('S', 0x52, struct snd_seq_port_info32),
 };
 
-static long snd_seq_ioctl_compat(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_seq_ioctl_compat(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct snd_seq_client *client = file->private_data;
 	void __user *argp = compat_ptr(arg);
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 0af337e..f505d69 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1756,7 +1756,7 @@ enum {
 	SNDRV_TIMER_IOCTL_PAUSE_OLD = _IO('T', 0x23),
 };
 
-static long snd_timer_user_ioctl(struct file *file, unsigned int cmd,
+static int snd_timer_user_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
 	struct snd_timer_user *tu;
diff --git a/sound/core/timer_compat.c b/sound/core/timer_compat.c
index 5512f53..2dc4785 100644
--- a/sound/core/timer_compat.c
+++ b/sound/core/timer_compat.c
@@ -93,7 +93,7 @@ enum {
 	SNDRV_TIMER_IOCTL_STATUS32 = _IOW('T', 0x14, struct snd_timer_status32),
 };
 
-static long snd_timer_user_ioctl_compat(struct file *file, unsigned int cmd, unsigned long arg)
+static int snd_timer_user_ioctl_compat(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = compat_ptr(arg);
 
@@ -114,7 +114,7 @@ static long snd_timer_user_ioctl_compat(struct file *file, unsigned int cmd, uns
 	case SNDRV_TIMER_IOCTL_PAUSE:
 	case SNDRV_TIMER_IOCTL_PAUSE_OLD:
 	case SNDRV_TIMER_IOCTL_NEXT_DEVICE:
-		return snd_timer_user_ioctl(file, cmd, (unsigned long)argp);
+		return snd_timer_user_ioctl(inode, file, cmd, (unsigned long)argp);
 	case SNDRV_TIMER_IOCTL_INFO32:
 		return snd_timer_user_info_compat(file, argp);
 	case SNDRV_TIMER_IOCTL_STATUS32:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7dd9b0b..51368d7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -66,7 +66,7 @@ static __read_mostly struct preempt_ops kvm_preempt_ops;
 
 struct dentry *kvm_debugfs_dir;
 
-static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
+static int kvm_vcpu_ioctl(struct inode *inode, struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
 bool kvm_rebooting;
@@ -1112,7 +1112,7 @@ static int kvm_vcpu_ioctl_set_sigmask(struct kvm_vcpu *vcpu, sigset_t *sigset)
 	return 0;
 }
 
-static long kvm_vcpu_ioctl(struct file *filp,
+static int kvm_vcpu_ioctl(struct inode *inode, struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
@@ -1295,7 +1295,7 @@ out:
 	return r;
 }
 
-static long kvm_vm_ioctl(struct file *filp,
+static int kvm_vm_ioctl(struct inode *inode, struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
 	struct kvm *kvm = filp->private_data;
@@ -1415,7 +1415,7 @@ static int kvm_dev_ioctl_create_vm(void)
 	return fd;
 }
 
-static long kvm_dev_ioctl(struct file *filp,
+static int kvm_dev_ioctl(struct inode *inode, struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
 	long r = -EINVAL;
