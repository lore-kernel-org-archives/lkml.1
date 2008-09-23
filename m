Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbYIWJQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbYIWJQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYIWJQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:16:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbYIWJQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:16:03 -0400
Date: Tue, 23 Sep 2008 11:15:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] raid: make RAID autodetect default a KConfig option
Message-ID: <20080923091547.GF31189@elte.hu>
References: <20080921154541.371f2ebe@infradead.org> <20080922082728.GB6601@elte.hu> <18648.26191.479291.883160@notabene.brown> <20080922205808.033436f7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922205808.033436f7@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Tue, 23 Sep 2008 13:45:19 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Monday September 22, mingo@elte.hu wrote:
> > > 
> > > * Arjan van de Ven <arjan@infradead.org> wrote:
> > > 
> > > > From 812bf9a448d96375a3aec5c51764d74cace85abb Mon Sep 17 00:00:00
> > > > 2001 From: Arjan van de Ven <arjan@linux.intel.com>
> > > > Date: Sun, 21 Sep 2008 15:44:32 -0700
> > > > Subject: [PATCH] raid: make RAID autodetect default a KConfig
> > > > option
> > > > 
> > > > RAID autodetect has the side effect of requiring synchronisation
> > > > of all device drivers, which can make the boot several seconds
> > > > longer (I've measured 7 on one of my laptops).... even for
> > > > systems that don't have RAID setup for the root filesystem (the
> > > > only FS where this matters).
> > > > 
> > > > This patch makes the default for autodetect a config option;
> > > > either way the user can always override via the kernel command
> > > > line.
> > > 
> > > Neil, if you agree with this patch, could you please send your
> > > Acked-by line? This patch depends on a clean-up in
> > > init/do_mounts_md.c that is in the fastboot tree so it would be
> > > logistically easier/better if we could queue this up towards
> > > upstream via tip/fastboot.
> > 
> > Yes,
> >  Acked-by: NeilBrown <neilb@suse.de>
> > 
> > I'm not a big fan of autodetect in any case, and this patch seems to
> > cover all the bases I can think of.
> > 
> 
> thanks
> pushed to
> git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git
> master
> 
> Ingo, please pull

pulled the commit below into tip/fastboot, thanks Arjan and Neil!

	Ingo

---------------->
>From da827bea62d62cabfe913e05fc05879faa614af8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 21 Sep 2008 15:44:32 -0700
Subject: [PATCH] raid: make RAID autodetect default a KConfig option

RAID autodetect has the side effect of requiring synchronisation
of all device drivers, which can make the boot several seconds longer
(I've measured 7 on one of my laptops).... even for systems that don't
have RAID setup for the root filesystem (the only FS where this matters).

This patch makes the default for autodetect a config option; either way
the user can always override via the kernel command line.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: NeilBrown <neilb@suse.de>
---
 drivers/md/Kconfig  |   14 ++++++++++++++
 init/do_mounts_md.c |   11 +++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 07d92c1..8e72c91 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -30,6 +30,20 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_AUTODETECT
+	bool "Autodetect RAID arrays during kernel boot"
+	depends on BLK_DEV_MD
+	default y
+	---help---
+	  If you say Y here, then the kernel will try to autodetect raid
+	  arrays as part of its boot process. 
+
+	  If you don't use raid and say Y, this autodetection can cause 
+	  a several-second delay in the boot time due to various
+	  synchronisation steps that are part of this step.
+
+	  If unsure, say Y.
+
 config MD_LINEAR
 	tristate "Linear (append) mode"
 	depends on BLK_DEV_MD
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index c0dfd3c..48b3fad 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -12,7 +12,12 @@
  * The code for that is here.
  */
 
-static int __initdata raid_noautodetect, raid_autopart;
+#ifdef CONFIG_MD_AUTODETECT
+static int __initdata raid_noautodetect;
+#else
+static int __initdata raid_noautodetect=1;
+#endif
+static int __initdata raid_autopart;
 
 static struct {
 	int minor;
@@ -252,6 +257,8 @@ static int __init raid_setup(char *str)
 
 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
+		if (!strncmp(str, "autodetect", wlen))
+			raid_noautodetect = 0;
 		if (strncmp(str, "partitionable", wlen)==0)
 			raid_autopart = 1;
 		if (strncmp(str, "part", wlen)==0)
@@ -288,7 +295,7 @@ void __init md_run_setup(void)
 	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
 
 	if (raid_noautodetect)
-		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=noautodetect)\n");
+		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
 	else
 		autodetect_raid();
 	md_setup_drive();
