Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZLWIwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZLWIwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 03:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZLWIwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 03:52:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:39348 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbZLWIwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 03:52:30 -0500
Message-ID: <4B31DB17.4050509@kernel.org>
Date: Wed, 23 Dec 2009 17:55:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: fengxiangjun <fengxiangjun@neusoft.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net> <4B30134C.1050609@gmail.com> <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net> <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com> <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
In-Reply-To: <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
X-Enigmail-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000006080607070707050005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000006080607070707050005
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 12/22/2009 11:02 AM, fengxiangjun wrote:
> You are right, it's definitely timing related.
> 
> I just tried capturing the failed booting message through a null modem 
> cable, but the problem goes away! It seems that I can't reproduce it 
> with serial console attached.

Hmmm... this is the second report of probing failure with SIDPR based
hardreset.  Can you please apply the attached patch and see whether
the problem is reproducible?  And if so, please attach full boot log.
Can you please also attach hdparm -I output of the occassionally
failing drive.

Thanks.

-- 
tejun

--------------000006080607070707050005
Content-Type: text/x-patch;
 name="piix-longer-debounce.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="piix-longer-debounce.patch"

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ac4e37..f50bba6 100644
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
index dc72690..c501e1e 100644
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
 

--------------000006080607070707050005--
