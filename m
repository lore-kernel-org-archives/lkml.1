Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYA2UBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYA2UBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYA2UAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:00:50 -0500
Received: from speedy.student.utwente.nl ([130.89.163.131]:58539 "EHLO
	speedy.student.utwente.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYA2UAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:00:49 -0500
X-Greylist: delayed 3386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 15:00:49 EST
Date: Tue, 29 Jan 2008 20:04:17 +0100
From: Sytse Wielinga <s.b.wielinga@student.utwente.nl>
To: Markus Rechberger <markus.rechberger@amd.com>
Cc: Matt_Domsch@dell.com, Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       Douglas_Warzecha@dell.com, Abhay_Salunke@dell.com,
       linux-kernel@vger.kernel.org,
       Michael E Brown <Michael_E_Brown@dell.com>, Greg KH <gregkh@suse.de>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: FW: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080129190417.GA15410@speedy.student.utwente.nl>
Mail-Followup-To: Markus Rechberger <markus.rechberger@amd.com>,
	Matt_Domsch@dell.com,
	Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
	Douglas_Warzecha@dell.com, Abhay_Salunke@dell.com,
	linux-kernel@vger.kernel.org,
	Michael E Brown <Michael_E_Brown@dell.com>,
	Greg KH <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>
References: <20080129064415.GA8822@suse.de> <479F3F60.8050108@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479F3F60.8050108@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 03:59:44PM +0100, Markus Rechberger wrote:
(quote reformatted)
> On Mon, Jan 28, 2008 at 10:44:15PM -0800, Greg KH wrote:
> > On Tue, Jan 29, 2008 at 12:32:44AM -0600, Michael E Brown wrote:
> > > BIOS updates are broken on all Dell systems due to Commit
> > > 109f0e93b6b728f03c1eb4af02bc25d71b646c59, which is now in 2.6.24.
> > > 
> > >   static inline void fw_setup_device_id(struct device *f_dev, struct
> > > device *dev)
> > >   {
> > > -       /* XXX warning we should watch out for name collisions */
> > > -       strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
> > > +       snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s",
> > > dev->bus_id);
> > >  }
> > > 
> > > Two programs are broken by this change: 
> > >     1) dellBiosUpdate, which is part of libsmbios
> > >     2) All of the Dell Update Packages (DUPs) that are part of Dell
> > > OpenManage: each BIOS release for each of 3-4 dozen platforms.
> > > 
> > > These programs are broken due to the pathname change from
> > > /sys/class/firmware/dell_rbu/   to
> > > /sys/class/firmware/firmware-dell_rbu/loading. 
> > > 
> > > Realistically, I can fix libsmbios in a couple of weeks, but there is no
> > > way that we can go back and fix a couple hundred DUP packages for this
> > > change. If this stays, we are looking at over 6 months before we have an
> > > officially-available Dell OpenManage that can deal with it, and that
> > > would be for new BIOS releases only, I suspect.
> > > 
> > > Some of the relevant threads from when this was submitted and accepted:
> > > http://lkml.org/lkml/2005/5/23/73
> > > http://lkml.org/lkml/2005/5/23/62
> > > 
> > > Due to the extremely large and disruptive nature of this bug, it would
> > > be nice to get a 2.6.24.1 with this patch reverted.
> > > 
> > > I have copied the relevant developers at Dell who maintain this driver.
> > > Please preserve the cc: list when replying.
> > 
> > Fair enough, I have no problem reverting this.
> > 
> > Anyone want to keep it in?
>
> Hi Greg,
> 
> reverting this breaks support for several media (DVB/V4L) devices. I 
> would have to look up some bugreports the same name collision happened 
> with several different drivers.
> There was a comment in the fw code to watch out for name collisions 
> earlier already, so it needs a fix somewhere.
> 
> Here's some history:
> http://mcentral.de/wiki/index.php5/Bugtracker#i2c_dev_problem

What about creating symlinks with the old device names? That shouldn't give
rise to any collisions, as it only works in the /sys/class/firmware/ namespace
(correct me if I'm wrong, I haven't actually taken the time to investigate the
problem properly and have no experience with the firmware driver).

I've created the simple patch below. I have no idea if it actually works,
though, as I don't appear to have any hardware for which a linux driver
supports firmware loading. Please comment.

Oh, and I almost forgot to ask about __FUNCTION__, which is gcc-specific;
wouldn't it be a good idea to simply replace all occurrences in the kernel
source with __func__?

Sytse

---
 drivers/base/Kconfig          |   11 +++++++++++
 drivers/base/firmware_class.c |    7 +++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d7da109..d0a9cf6 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -34,6 +34,17 @@ config FW_LOADER
 	  require userspace firmware loading support, but a module built outside
 	  the kernel tree does.
 
+config FW_LOADER_SYSFS_COMPAT
+	bool "Deprecated /sys/class/firmware/ folders"
+	depends on FW_LOADER
+	default y
+	help
+	  Folders in /sys/class/firmware/ have been prefixed with 'firmware-'
+	  to prevent name collisions. Enable this option to create symlinks
+	  for backward compatibility.
+
+	  If unsure, say Y.
+
 config DEBUG_DRIVER
 	bool "Driver Core verbose debug messages"
 	depends on DEBUG_KERNEL
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 0295855..f8aba6c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -330,6 +330,13 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 		       __FUNCTION__);
 		goto error_kfree;
 	}
+
+#ifdef CONFIG_FW_LOADER_SYSFS_COMPAT
+	if (sysfs_create_link(&firmware_class.subsys.kobj, &f_dev->kobj, device->bus_id))
+		printk(KERN_WARNING "%s: sysfs_create_link failed for %s\n",
+			   __FUNCTION__, device->bus_id);
+#endif
+
 	*dev_p = f_dev;
 	return 0;
 
