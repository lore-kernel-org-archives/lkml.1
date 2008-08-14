Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYHNPzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYHNPzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYHNPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:55:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46986 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYHNPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:55:31 -0400
Date: Thu, 14 Aug 2008 17:56:49 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       James.Bottomley@HansenPartnership.com, teheo@novell.com,
       oneukum@suse.de
Subject: Re: Power management for SCSI
Message-ID: <20080814155649.GA6046@elf.ucw.cz>
References: <20080813095055.GA475@elf.ucw.cz> <Pine.LNX.4.44L0.0808131026320.2455-100000@iolanthe.rowland.org> <20080814130812.GC2262@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814130812.GC2262@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Add support for autosuspend/autoresume. Lowlevel driver can use it to
> > > spin the disk down and power down its SATA link, to turn off the USB
> > > interface, etc.
> > > 
> > > Spinning down the disk is useful - saves ~0.5W here. Powering down
> > > SATA controller is even better -- should save ~1W.
> > > 
> > > Now, I guess the patch will need to be split to small pieces for
> > > merge... I tried to rearrange it so that the documentation and hooks
> > > go before stuff that needs the hooks, and before Kconfig enabler. If
> > > it looks reasonably good, I'll split it into smaller pieces.
> > 
> > James had a number of objections to my original patch; you can read 
> > them here:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2008-March/016849.html
> > 
> > I haven't had time yet to work on an improved version.
> 
> Ok, I see, "its done at the wrong level" sounds pretty serious.
> 
> First the general comments/questions:
...
> #2. As you say in the comment, the thing we're trying to power down is
> #the link.  In most SCSI implementations, the link has a rather complex
> #relationship to the target, what we want to do in
> #periodic_autosuspend_scan() is run over the devices on each link, and
> #if
> #they're not busy suspend the link?  What's probably needed is a set of
> #adjunct helpers for the transport classes to do this.
> 
> So the host suspend/resume stuff should go into struct
> scsi_transport_template?

Is this step in the right direction? Moved autosuspend from
scsi_host_template to scsi_transport_template...

							Pavel

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e4864d9..2b8cf09 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -320,14 +320,14 @@ static struct device_attribute *ahci_sde
 };
 
 struct pci_dev *my_pdev;
-int autosuspend_enabled = 0;	/* HERE */
+int autosuspend_enabled = 1;	/* HERE */
 
 struct sleep_disabled_reason ahci_active = {
         "ahci"
 };
 
 /* The host and its devices are all idle so we can autosuspend */
-static int autosuspend(struct Scsi_Host *host)
+int ahci_autosuspend(struct Scsi_Host *host)
 {
 	if (my_pdev && autosuspend_enabled) {
 		printk("ahci: should autosuspend\n");
@@ -340,7 +340,7 @@ static int autosuspend(struct Scsi_Host 
 }
 
 /* The host needs to be autoresumed */
-static int autoresume(struct Scsi_Host *host)
+int ahci_autoresume(struct Scsi_Host *host)
 {
 	if (my_pdev && autosuspend_enabled) {
 		printk("ahci: should autoresume\n");
@@ -360,8 +360,8 @@ static struct scsi_host_template ahci_sh
 	.sg_tablesize		= AHCI_MAX_SG,
 	.dma_boundary		= AHCI_DMA_BOUNDARY,
 	.shost_attrs		= ahci_shost_attrs,
-	.autosuspend		= autosuspend,
-	.autoresume		= autoresume,
+//	.autosuspend		= autosuspend,
+//	.autoresume		= autoresume,
 	.sdev_attrs		= ahci_sdev_attrs,
 };
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9d3ba4..d3526a0 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -103,6 +103,9 @@ static const u8 def_control_mpage[CONTRO
 	0, 30	/* extended self test time, see 05-359r1 */
 };
 
+int ahci_autosuspend(struct Scsi_Host *host);
+int ahci_autoresume(struct Scsi_Host *host);
+
 /*
  * libata transport template.  libata doesn't do real transport stuff.
  * It just needs the eh_timed_out hook.
@@ -111,6 +114,8 @@ static struct scsi_transport_template at
 	.eh_strategy_handler	= ata_scsi_error,
 	.eh_timed_out		= ata_scsi_timed_out,
 	.user_scan		= ata_scsi_user_scan,
+	.autosuspend		= ahci_autosuspend,
+	.autoresume		= ahci_autoresume,
 };
 
 
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 5ef69c4..d2de371 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -10,6 +10,7 @@ #define DEBUG
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport.h>
 
 #include <linux/delay.h>
 
@@ -50,8 +51,8 @@ void scsi_autosuspend_host(struct Scsi_H
 	if (shost->pm_usage_cnt <= 0 && !shost->is_suspended &&
 			shost->shost_state == SHOST_RUNNING) {
 		WARN_ON(shost->host_busy);
-		if (!shost->hostt->autosuspend ||
-				shost->hostt->autosuspend(shost) == 0) {
+		if (!shost->transportt->autosuspend ||
+				shost->transportt->autosuspend(shost) == 0) {
 			shost->is_suspended = 1;
 			shost_dbg(shost, "suspended\n");
 		}
@@ -82,10 +83,10 @@ int scsi_autoresume_host(struct Scsi_Hos
 	mutex_lock(&shost->pm_mutex);
 	++shost->pm_usage_cnt;
 	if (shost->is_suspended) {
-		if (shost->hostt->autoresume &&
+		if (shost->transportt->autoresume &&
 				(shost->shost_state == SHOST_RUNNING ||
 				 shost->shost_state == SHOST_RECOVERY))
-			status = shost->hostt->autoresume(shost);
+			status = shost->transportt->autoresume(shost);
 		if (status == 0) {
 			shost->is_suspended = 0;
 			shost_dbg(shost, "resumed\n");
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index ef64fd8..c96f11f 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -499,10 +499,6 @@ struct scsi_host_template usb_stor_host_
 	.eh_device_reset_handler =	device_reset,
 	.eh_bus_reset_handler =		bus_reset,
 
-	/* dynamic power management */
-	.autosuspend =			autosuspend,
-	.autoresume =			autoresume,
-
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
 	.cmd_per_lun =			1,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b60445f..0f30451 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -176,21 +176,6 @@ #endif
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
 
-	/*
-	 * Power management routines.  These are optional; you should
-	 * implement them if you want your LLD to perform dynamic Power
-	 * Management.  The autosuspend method will be called whenever
-	 * all the devices below a host have been suspended (are in an
-	 * idle state), at which time the host adapter can safely be
-	 * autosuspended.  The autoresume method will be called whenever
-	 * a suspended host must be resumed for one of its devices to
-	 * carry out a command.  Both routines are always called in a
-	 * process context with interrupts enabled.
-	 *
-	 * Status: OPTIONAL
-	 */
-	int (* autosuspend)(struct Scsi_Host *);
-	int (* autoresume)(struct Scsi_Host *);
 
 	/*
 	 * Before the mid layer attempts to scan for a new device where none
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 490bd13..15c7886 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -77,6 +77,22 @@ struct scsi_transport_template {
 	 * request for target drivers.
 	 */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
+
+	/*
+	 * Power management routines.  These are optional; you should
+	 * implement them if you want your LLD to perform dynamic Power
+	 * Management.  The autosuspend method will be called whenever
+	 * all the devices below a host have been suspended (are in an
+	 * idle state), at which time the host adapter can safely be
+	 * autosuspended.  The autoresume method will be called whenever
+	 * a suspended host must be resumed for one of its devices to
+	 * carry out a command.  Both routines are always called in a
+	 * process context with interrupts enabled.
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (* autosuspend)(struct Scsi_Host *);
+	int (* autoresume)(struct Scsi_Host *);
 };
 
 #define transport_class_to_shost(tc) \


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
