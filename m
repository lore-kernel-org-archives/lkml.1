Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbZLXMhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbZLXMhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZLXMhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:37:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:48798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZLXMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:37:30 -0500
Message-ID: <4B336153.8090206@kernel.org>
Date: Thu, 24 Dec 2009 21:40:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: fengxiangjun <fengxiangjun@neusoft.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net> <4B30134C.1050609@gmail.com> <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net> <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com> <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net> <4B31DB17.4050509@kernel.org> <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net> <4B331957.7030906@kernel.org> <alpine.LNX.2.00.0912241535340.1682@darkstar.example.net> <4B331D93.2010000@kernel.org> <alpine.LNX.2.00.0912241557170.1682@darkstar.example.net> <alpine.LNX.2.00.0912242010350.1691@darkstar.example.net>
In-Reply-To: <alpine.LNX.2.00.0912242010350.1691@darkstar.example.net>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010701060309050902010107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010701060309050902010107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

On 12/24/2009 09:15 PM, fengxiangjun wrote:
> Here is it, and I hope it help. And merry xmas, ;)
> 
> ata1.00: SATA link down (SStatus 0 SControl 301)

Hmmm... SControl DET hasn't been cleared.  Does the attached patch
make any difference?

-- 
tejun

--------------010701060309050902010107
Content-Type: text/x-patch;
 name="retry-link-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="retry-link-resume.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 19136a7..5bc31d2 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -173,6 +173,8 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
 static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val);
+static int piix_sidpr_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -334,9 +336,9 @@ static struct ata_port_operations piix_sata_ops = {
 
 static struct ata_port_operations piix_sidpr_sata_ops = {
 	.inherits		= &piix_sata_ops,
-	.hardreset		= sata_std_hardreset,
 	.scr_read		= piix_sidpr_scr_read,
 	.scr_write		= piix_sidpr_scr_write,
+	.hardreset		= piix_sidpr_hardreset,
 };
 
 static const struct piix_map_db ich5_map_db = {
@@ -962,6 +964,18 @@ static int piix_sidpr_scr_write(struct ata_link *link,
 	return 0;
 }
 
+static int piix_sidpr_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	const unsigned long *timing = sata_deb_timing_hotplug;
+	bool online;
+	int rc;
+
+	/* do hardreset */
+	rc = sata_link_hardreset(link, timing, deadline, &online, NULL);
+	return online ? -EAGAIN : rc;
+}
+
 #ifdef CONFIG_PM
 static int piix_broken_suspend(void)
 {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 22ff51b..bb19319 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3731,7 +3731,7 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 	unsigned long interval = params[0];
 	unsigned long duration = params[1];
 	unsigned long last_jiffies, t;
-	u32 last, cur;
+	u32 last, cur, xxx;
 	int rc;
 
 	t = ata_deadline(jiffies, params[2]);
@@ -3740,7 +3740,9 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 
 	if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
 		return rc;
+	xxx = cur;
 	cur &= 0xf;
+	ata_link_printk(link, KERN_INFO, "XXX debounce start, SStatus=%x\n", xxx);
 
 	last = cur;
 	last_jiffies = jiffies;
@@ -3749,6 +3751,7 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 		msleep(interval);
 		if ((rc = sata_scr_read(link, SCR_STATUS, &cur)))
 			return rc;
+		xxx = cur;
 		cur &= 0xf;
 
 		/* DET stable? */
@@ -3756,8 +3759,12 @@ int sata_link_debounce(struct ata_link *link, const unsigned long *params,
 			if (cur == 1 && time_before(jiffies, deadline))
 				continue;
 			if (time_after(jiffies,
-				       ata_deadline(last_jiffies, duration)))
+				       ata_deadline(last_jiffies, duration))) {
+				ata_link_printk(link, KERN_INFO,
+						"XXX debounce done, SStatus=%x, DET stable for %u msecs\n",
+						xxx, jiffies_to_msecs(jiffies - last_jiffies));
 				return 0;
+			}
 			continue;
 		}
 
@@ -3791,15 +3798,30 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		     unsigned long deadline)
 {
 	u32 scontrol, serror;
-	int rc;
+	int tries = 3, rc;
 
 	if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
 		return rc;
 
-	scontrol = (scontrol & 0x0f0) | 0x300;
+	do {
+		scontrol = (scontrol & 0x0f0) | 0x300;
 
-	if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
-		return rc;
+		if ((rc = sata_scr_write(link, SCR_CONTROL, scontrol)))
+			return rc;
+
+		if ((rc = sata_scr_read(link, SCR_CONTROL, &scontrol)))
+			return rc;
+
+		/* is SControl restored correctly? */
+		if ((scontrol & 0xf0f) != 0x300)
+			break;
+
+		msleep(100);
+
+		ata_link_printk(link, KERN_WARNING,
+				"failed to restore SControl=%x%s\n",
+				scontrol, tries > 1 ? ", retrying" : "");
+	} while (--tries);
 
 	/* Some PHYs react badly if SStatus is pounded immediately
 	 * after resuming.  Delay 200ms before debouncing.

--------------010701060309050902010107--
