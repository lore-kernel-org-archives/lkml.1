Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbYJQRMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbYJQRMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYJQRMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:12:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYJQRMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:12:23 -0400
Date: Fri, 17 Oct 2008 19:11:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081017171139.GA1792@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'd like to announce a new upstream -git based tree i started working on 
some time ago, the "remove all compiler warnings on x86, on any .config" 
tree.

This tree adds the CONFIG_ALLOW_WARNINGS config option - which, if 
disabled, adds -Werror to the build flags and results in a failed build 
if any compiler warning is emitted by the kernel build. I started the 
tree based on David Howells's CONFIG_ENABLE_WERROR patchset.

Right now the results are pretty good already: x86 builds with zero 
warnings both allyesconfig, allnoconfig and allmodconfig, 32-bit and 
64-bit as well - and most randconfig kernels will build fine as well. I 
continue fixing randconfig triggered warnings as i trigger them.

The main purpose of this tree is to use it in the -tip auto-testing 
randconfig based kernel testing machinery, and to fix all new warnings 
that trigger via that patch influx vector - and to help other 
maintainers fix warnings that reach the upstream kernel.

The tip/warnings tree consists of 5 topic branches comprising 83 commits 
at the moment:

 earth4:~/tip> tip-pending warnings/

   topic                              #commits
   -------------------------------------------
   warnings/bug                       :     19
   warnings/complex                   :     27
   warnings/infrastructure            :      5
   warnings/simple                    :     23
   warnings/ugly                      :      9
   ---------------------
   total topics:       5
   pending topics:     5
   pending commits:   83

tip/warnings/infrastructure:

  this topic contains the basic patches that enable this mode of 
  building.

tip/warnings/simple:

  this topic is for simple, obvious (looking) fixes. 

tip/warnings/complex:

  this topic is for fixes that i categorized as more complex - 
  they need review and more testing.

tip/warnings/ugly:

  these are workarounds for gcc bugs that i did not consider upstream 
  worthy in any way. They also contain patches that fell through my 
  review and need further improvements.

tip/warnings/bug:

  this is a special topic for a certain type of warning: BUG() turning 
  into a NOP on CONFIG_EMBEDDED + !CONFIG_BUG. In this case gcc is 
  completely right in warning us in various places that we are 
  triggering undefined behavior. This topic is fairly complete in that 
  it fixes all these warnings i could trigger on 
  allyesconfig+!CONFIG_BUG - but i'm on two minds what we should do. A 
  simple solution would be to not allow the turning off of BUG() - but 
  to turn it into something really simple, such as an infinite loop. 
  Unfortunately that increases the size of the kernel by +0.2% so i did 
  not want t do it without consideration. I kept these commits filtered 
  out.

Note that deprecated API and unused-return-value warnings 
(ENABLE_WARN_DEPRECATED and ENABLE_MUST_CHECK) are not included right 
now, there's way too many of them. If this effort works out fine the we 
could start covering those warnings too.

It is also not clear to me how i should annotate variables for gcc false 
positives. The current upstream kernel method is:

        uninitialized_var(i);

But Alan suggested that we should use __attribute__((used)) instead:

        #define __used __attribute__((used))

and that he would not accept uninitialized_var() annotations. A central 
policy decision is needed on that. I wouldnt mind to convert all 
uninitialized_var() annotations over into __used annotations - but the 
question is: is this really an equivalent transformation? Can gcc be 
fooled into not initializing an incorrect __used annotation? With 
uninitialized_var() we at least have a specific initialization to zero.

The integrated tree is available at tip/auto-warnings-next. Obviously 
the warnings/ugly and warnings/complex topics are still work in 
progress. The coordinates of the tip/warnings/simple topic can be found 
below.

Comments, suggestions are welcome.

	Ingo

-------------->
the latest warnings/simple git tree is available at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git warnings/simple

	Ingo

------------------>
Ingo Molnar (24):
      [vfs] fs.h - fix warning in drivers/infiniband/core/uverbs_main.c
      fix warning in fs/ext4/extents.c
      work around warning in fs/xfs/xfs_rtalloc.c
      fix warning in drivers/net/mlx4/mcg.c
      fix warning in drivers/net/mlx4/profile.c
      fix warning in arch/x86/kernel/io_apic_32.c
      fix warning in arch/x86/kernel/setup.c
      fix warning in sound/soc/codecs/tlv320aic23.c
      fix warning in drivers/ide/pci/hpt366.c
      fix warning in net/mac80211/rc80211_minstrel_debugfs.c
      fix warning in drivers/media/dvb/frontends/cx24116.c
      fix warning in drivers/video/cirrusfb.c
      fix warning in drivers/isdn/i4l/isdn_ppp.c
      fix warning in fs/afs/dir.c
      fix warning in net/netlabel/netlabel_addrlist.c
      fix warning in drivers/net/wireless/b43/phy_g.c
      fix warning in arch/x86/kernel/early-quirks.c
      include/linux/fs.h: fix warning in fs/gfs2/ops_file.c
      fix warning in drivers/base/platform.c
      fix warning in drivers/pci/pci-driver.c
      fix warning in drivers/acpi/sleep/main.c
      fix warning in net/ax25/sysctl_net_ax25.c
      fix warning in arch/x86/kernel/paravirt-spinlocks.c
      fix warnings in drivers/acpi/sbs.c


 arch/x86/kernel/early-quirks.c          |    4 +++-
 arch/x86/kernel/io_apic_32.c            |    4 ++--
 arch/x86/kernel/paravirt-spinlocks.c    |    3 ++-
 arch/x86/kernel/setup.c                 |    2 ++
 drivers/acpi/sbs.c                      |    7 +++++++
 drivers/acpi/sleep/main.c               |   10 +++++-----
 drivers/base/platform.c                 |   10 ++++++----
 drivers/ide/pci/hpt366.c                |    1 -
 drivers/isdn/i4l/isdn_ppp.c             |    2 ++
 drivers/media/dvb/frontends/cx24116.c   |    3 ++-
 drivers/net/mlx4/mcg.c                  |    2 +-
 drivers/net/mlx4/profile.c              |    2 ++
 drivers/net/wireless/b43/b43.h          |    3 ++-
 drivers/pci/pci-driver.c                |    9 +++++----
 drivers/video/cirrusfb.c                |    3 +--
 fs/afs/dir.c                            |    2 +-
 fs/ext4/extents.c                       |    1 +
 fs/xfs/xfs_rtalloc.c                    |    2 +-
 include/linux/audit.h                   |    3 ++-
 include/linux/fs.h                      |    6 +++---
 net/ax25/sysctl_net_ax25.c              |    2 ++
 net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
 sound/soc/codecs/tlv320aic23.c          |    2 --
 23 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 733c4f8..e587947 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -95,6 +95,7 @@ static void __init nvidia_bugs(int num, int slot, int func)
 
 }
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -112,10 +113,11 @@ static u32 ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
+#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
-#if defined(CONFIG_ACPI) && defined (CONFIG_X86_IO_APIC)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 	u32 d;
 	u8  b;
 
diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
index e710289..64f0953 100644
--- a/arch/x86/kernel/io_apic_32.c
+++ b/arch/x86/kernel/io_apic_32.c
@@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	}
 
 	icr = apic_icr_read();
-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
+	printk(KERN_DEBUG "... APIC ICR: %08x\n", (u32)icr);
+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (u32)(icr >> 32));
 
 	v = apic_read(APIC_LVTT);
 	printk(KERN_DEBUG "... APIC LVTT: %08x\n", v);
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 0e9f198..95777b0 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,7 +7,8 @@
 
 #include <asm/paravirt.h>
 
-static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+static inline void
+default_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2255782..44c2315 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -732,6 +732,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -743,6 +744,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 10a3651..2657182 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -389,6 +389,8 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 	return result;
 }
 
+#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
+
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -425,6 +427,8 @@ static int acpi_battery_set_alarm(struct acpi_battery *battery)
 	return ret;
 }
 
+#endif
+
 static int acpi_ac_get_present(struct acpi_sbs *sbs)
 {
 	int result;
@@ -816,7 +820,10 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 
 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
+#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
 	struct acpi_battery *battery = &sbs->battery[id];
+#endif
+
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	if (battery->bat.dev) {
 		if (battery->have_sysfs_alarm)
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index d13194a..2276d75 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -63,7 +63,7 @@ void __init acpi_old_suspend_ordering(void)
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
-static int acpi_pm_disable_gpes(void)
+static inline int acpi_pm_disable_gpes(void)
 {
 	acpi_hw_disable_all_gpes();
 	return 0;
@@ -75,7 +75,7 @@ static int acpi_pm_disable_gpes(void)
  *	If necessary, set the firmware waking vector and do arch-specific
  *	nastiness to get the wakeup code to the waking vector.
  */
-static int __acpi_pm_prepare(void)
+static inline int __acpi_pm_prepare(void)
 {
 	int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
@@ -88,7 +88,7 @@ static int __acpi_pm_prepare(void)
  *	acpi_pm_prepare - Prepare the platform to enter the target sleep
  *		state and disable the GPEs.
  */
-static int acpi_pm_prepare(void)
+static inline int acpi_pm_prepare(void)
 {
 	int error = __acpi_pm_prepare();
 
@@ -103,7 +103,7 @@ static int acpi_pm_prepare(void)
  *	This is called after we wake back up (or if entering the sleep state
  *	failed).
  */
-static void acpi_pm_finish(void)
+static inline void acpi_pm_finish(void)
 {
 	u32 acpi_state = acpi_target_sleep_state;
 
@@ -124,7 +124,7 @@ static void acpi_pm_finish(void)
 /**
  *	acpi_pm_end - Finish up suspend sequence.
  */
-static void acpi_pm_end(void)
+static inline void acpi_pm_end(void)
 {
 	/*
 	 * This is necessary in case acpi_pm_finish() is not called during a
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..e0bcd6b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -614,7 +614,8 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 
 #ifdef CONFIG_PM_SLEEP
 
-static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
+static inline int
+platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 {
 	int ret = 0;
 
@@ -624,7 +625,8 @@ static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 	return ret;
 }
 
-static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
+static inline int
+platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -637,7 +639,7 @@ static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 	return ret;
 }
 
-static int platform_legacy_resume_early(struct device *dev)
+static inline int platform_legacy_resume_early(struct device *dev)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -650,7 +652,7 @@ static int platform_legacy_resume_early(struct device *dev)
 	return ret;
 }
 
-static int platform_legacy_resume(struct device *dev)
+static inline int platform_legacy_resume(struct device *dev)
 {
 	int ret = 0;
 
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 9cf171c..ca0acb5 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1289,7 +1289,6 @@ static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;
diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 77c280e..c179360 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -431,6 +431,7 @@ set_arg(void __user *b, void *val,int len)
 	return 0;
 }
 
+#ifdef CONFIG_IPPP_FILTER
 static int get_filter(void __user *arg, struct sock_filter **p)
 {
 	struct sock_fprog uprog;
@@ -465,6 +466,7 @@ static int get_filter(void __user *arg, struct sock_filter **p)
 	*p = code;
 	return uprog.len;
 }
+#endif
 
 /*
  * ippp device ioctl
diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index deb36f4..eb5febc 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -200,7 +200,8 @@ static int cx24116_writereg(struct cx24116_state* state, int reg, int data)
 }
 
 /* Bulk byte writes to a single I2C address, for 32k firmware load */
-static int cx24116_writeregN(struct cx24116_state* state, int reg, u8 *data, u16 len)
+static int
+cx24116_writeregN(struct cx24116_state* state, int reg, const u8 *data, u16 len)
 {
 	int ret = -EREMOTEIO;
 	struct i2c_msg msg;
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index c83f88c..d1230a8 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	if (block_mcast_loopback)
 		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
-						       (1 << MGM_BLCK_LB_BIT));
+						       (1U << MGM_BLCK_LB_BIT));
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 
diff --git a/drivers/net/mlx4/profile.c b/drivers/net/mlx4/profile.c
index 9ca42b2..ec9383d 100644
--- a/drivers/net/mlx4/profile.c
+++ b/drivers/net/mlx4/profile.c
@@ -52,6 +52,7 @@ enum {
 	MLX4_RES_NUM
 };
 
+#ifdef CONFIG_MLX4_DEBUG
 static const char *res_name[] = {
 	[MLX4_RES_QP]		= "QP",
 	[MLX4_RES_RDMARC]	= "RDMARC",
@@ -65,6 +66,7 @@ static const char *res_name[] = {
 	[MLX4_RES_MTT]		= "MTT",
 	[MLX4_RES_MCG]		= "MCG",
 };
+#endif
 
 u64 mlx4_make_profile(struct mlx4_dev *dev,
 		      struct mlx4_profile *request,
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 427b820..ac55b62 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -853,7 +853,8 @@ void b43warn(struct b43_wl *wl, const char *fmt, ...)
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 #else /* DEBUG */
-# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+b43dbg(struct b43_wl *wl, const char *fmt, ...) { }
 #endif /* DEBUG */
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a13f534..b062868 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -324,7 +324,7 @@ static int pci_default_pm_resume(struct pci_dev *pci_dev)
 	return retval;
 }
 
-static int pci_legacy_suspend(struct device *dev, pm_message_t state)
+static inline int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -339,7 +339,8 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 	return i;
 }
 
-static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
+static inline int
+pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -352,7 +353,7 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 	return i;
 }
 
-static int pci_legacy_resume(struct device *dev)
+static inline int pci_legacy_resume(struct device *dev)
 {
 	int error;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -365,7 +366,7 @@ static int pci_legacy_resume(struct device *dev)
 	return error;
 }
 
-static int pci_legacy_resume_early(struct device *dev)
+static inline int pci_legacy_resume_early(struct device *dev)
 {
 	int error = 0;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 048b139..ace4001 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
 
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options) {
-	char *this_opt, s[32];
-	int i;
+	char *this_opt;
 
 	DPRINTK("ENTER\n");
 
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index dfda03d..254c567 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -563,7 +563,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid fid;
+	struct afs_fid fid = { 0, };
 	struct dentry *parent;
 	struct key *key;
 	void *dir_version;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..9a34682 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1156,6 +1156,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		return 0;
 	}
 
+	ix = NULL; /* avoid gcc false positive warning */
 	/* go up and search for index to the right */
 	while (--depth >= 0) {
 		ix = path[depth].p_idx;
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e2f68de..fe5de08 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1872,7 +1872,7 @@ xfs_growfs_rt(
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
-	xfs_trans_t	*tp;		/* transaction pointer */
+	xfs_trans_t	*uninitialized_var(tp);	/* transaction pointer */
 
 	sbp = &mp->m_sb;
 	cancelflags = 0;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6272a39..a3f78d0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -580,7 +580,8 @@ extern int audit_enabled;
 #define audit_log(c,g,t,f,...) do { ; } while (0)
 #define audit_log_start(c,g,t) ({ NULL; })
 #define audit_log_vformat(b,f,a) do { ; } while (0)
-#define audit_log_format(b,f,...) do { ; } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+audit_log_format(struct audit_buffer *ab, const char *fmt, ...) { }
 #define audit_log_end(b) do { ; } while (0)
 #define audit_log_n_hex(a,b,l) do { ; } while (0)
 #define audit_log_n_string(a,c,l) do { ; } while (0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6a625b..114f469 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1597,9 +1597,9 @@ void unnamed_dev_init(void);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
-	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
+	(((fops != NULL) && try_module_get((fops)->owner) ? (fops) : NULL))
 #define fops_put(fops) \
-	do { if (fops) module_put((fops)->owner); } while(0)
+	do { if (fops != NULL) module_put((fops)->owner); } while(0)
 
 extern int register_filesystem(struct file_system_type *);
 extern int unregister_filesystem(struct file_system_type *);
@@ -1675,7 +1675,7 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 #else /* !CONFIG_FILE_LOCKING */
 #define locks_mandatory_locked(a) ({ 0; })
 #define locks_mandatory_area(a, b, c, d, e) ({ 0; })
-#define __mandatory_lock(a) ({ 0; })
+static inline int __mandatory_lock(struct inode *ino) { return 0; }
 #define mandatory_lock(a) ({ 0; })
 #define locks_verify_locked(a) ({ 0; })
 #define locks_verify_truncate(a, b, c) ({ 0; })
diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
index f288fc4..735ceef 100644
--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -24,7 +24,9 @@ static int min_idle[1],			max_idle[] = {65535000};
 static int min_n2[] = {1},		max_n2[] = {31};
 static int min_paclen[] = {1},		max_paclen[] = {512};
 static int min_proto[1],		max_proto[] = { AX25_PROTO_MAX };
+#ifdef CONFIG_AX25_DAMA_SLAVE
 static int min_ds_timeout[1],		max_ds_timeout[] = {65535000};
+#endif
 
 static struct ctl_table_header *ax25_table_header;
 
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 0b024cd..26f8ffc 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -106,7 +106,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int
+static ssize_t
 minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *o)
 {
 	struct minstrel_stats_info *ms;
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 44308da..45395d0 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -421,8 +421,6 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int tlv320aic23_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 				      int clk_id, unsigned int freq, int dir)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
-
 	switch (freq) {
 	case 12000000:
 		return 0;
