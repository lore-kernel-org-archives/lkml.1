Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZBKPMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZBKPMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZBKPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:11:56 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:19953 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZBKPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=KGXkffA42ZGwvVnV5J9u8gKV1gP2Hp71ChIudYnXBhw0+KHzQTniMqALhzsucAm/Ot
         1pObOP4g4FLrZ0BjliBhEvvW626C4rhPOch5zqwlTGTc06rfcdnbiOtShDfW3DLV+BX0
         3+vqMK5cNIC2iNpOAaALqdXRS+KPPepibmKjk=
Message-ID: <4992EAAB.3010809@gmail.com>
Date: Thu, 12 Feb 2009 00:11:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [bug] sata detection problem
References: <20090208063516.GA2318@elte.hu>
In-Reply-To: <20090208063516.GA2318@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------010208070302000203040509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010208070302000203040509
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

Ingo Molnar wrote:
> Hm, in a boot test i had this boot failure:
> 
> [   15.504053] calling  piix_init+0x0/0x30 @ 1
> [   15.508050] ata_piix 0000:00:1f.1: version 2.12
> [   15.516193] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
> [   15.520029] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKG] -> GSI 11 (level, low) -> IRQ 11
> [   15.524072] ata_piix 0000:00:1f.1: setting latency timer to 64
> [   15.528115] scsi0 : ata_piix
> [   15.531526] scsi1 : ata_piix
> [   15.544044] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
> [   15.548028] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
> [   15.716358] ata1.00: ATAPI: ýVýVýVýVýVýýýýýýýýýýýýýýýýýýýýýýýýýýýýýý, ýýVýVýV, max UDMA7
> [   15.720044] ata1.00: limited to UDMA/33 due to 40-wire cable
> [   15.740296] ata1.00: configured for UDMA/33

That's one strange ghost device detection.  Because PATA doesn't have
a reliable way of determining device presence, libata uses combination
of tests along the probing sequence to determine device presence.
Each test is intentionally made somewhat relaxed to avoid missing a
present device (and those condition often do trigger).  It seems
somehow it is passing all the existing tests.  The hardest part
probably is the IDENTIFY command sequence but for SFF controllers it's
done via polling instead of IRQ and thus by having the right (or
wrong) status register value a port with floating pins may be able to
pass it.

How reproducible is the problem?  It can probably be worked around by
making the NODEV_HINT checking a tad bit tighter in SFF host state
machine.  PATA device presence detection is an art not an exact
science.  :-)

Can you please apply the attached patch and report the log after the
problem happens?

Thanks.

-- 
tejun


--------------010208070302000203040509
Content-Type: text/x-patch;
 name="probe-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="probe-debug.patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9fbf059..e783f7a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5380,7 +5380,7 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	 */
 	ata_lpm_enable(host);
 
-	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
+	rc = ata_host_request_pm(host, mesg, 0, 0/*ATA_EHI_QUIET*/, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
 	return rc;
@@ -5400,7 +5400,7 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 void ata_host_resume(struct ata_host *host)
 {
 	ata_host_request_pm(host, PMSG_ON, ATA_EH_RESET,
-			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
+			    ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/, 0);
 	host->dev->power.power_state = PMSG_ON;
 
 	/* reenable link pm */
@@ -5993,7 +5993,7 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 
 		ehi->probe_mask |= ATA_ALL_DEVICES;
 		ehi->action |= ATA_EH_RESET | ATA_EH_LPM;
-		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+		ehi->flags |= ATA_EHI_NO_AUTOPSY/* | ATA_EHI_QUIET*/;
 
 		ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 		ap->pflags |= ATA_PFLAG_LOADING;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 0b299b0..ff18440 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1302,6 +1302,11 @@ fsm_start:
 
 		} else {
 			/* ATA PIO protocol */
+			if (qc->tf.command == ATA_CMD_ID_ATA ||
+			    qc->tf.command == ATA_CMD_ID_ATAPI)
+				ata_dev_printk(qc->dev, KERN_INFO,
+					       "XXX cmd=%02x status=%02x\n",
+					       qc->tf.command, status);
 			if (unlikely((status & ATA_DRQ) == 0)) {
 				/* handle BSY=0, DRQ=0 as error */
 				if (likely(status & (ATA_ERR | ATA_DF))) {
@@ -1943,6 +1948,9 @@ unsigned int ata_sff_dev_classify(struct ata_device *dev, int present,
 	/* determine if device is ATA or ATAPI */
 	class = ata_dev_classify(&tf);
 
+	ata_dev_printk(dev, KERN_INFO, "XXX signature %02x/%02x:%02x:%02x class=%d horkage=0x%x\n",
+		       tf.feature, tf.lbal, tf.lbam, tf.lbah, class, dev->horkage);
+
 	if (class == ATA_DEV_UNKNOWN) {
 		/* If the device failed diagnostic, it's likely to
 		 * have reported incorrect device signature too.
@@ -2087,6 +2095,7 @@ int ata_sff_softreset(struct ata_link *link, unsigned int *classes,
 		devmask |= (1 << 0);
 	if (slave_possible && ata_devchk(ap, 1))
 		devmask |= (1 << 1);
+	ata_link_printk(link, KERN_INFO, "XXX devmask 0x%x\n", devmask);
 
 	/* select device 0 again */
 	ap->ops->sff_dev_select(ap, 0);

--------------010208070302000203040509--
