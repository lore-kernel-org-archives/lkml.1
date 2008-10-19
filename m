Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYJSXlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYJSXlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 19:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYJSXku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 19:40:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:45907 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbYJSXks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 19:40:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18683.50533.786782.474536@harpo.it.uu.se>
Date: Mon, 20 Oct 2008 01:40:21 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
In-Reply-To: <48F2D9A8.1030502@gmail.com>
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
	<48EBFE9B.9070503@gmail.com>
	<18674.4081.839329.116533@harpo.it.uu.se>
	<48F2D9A8.1030502@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 14:16:24 +0900, Tejun Heo wrote:
>Mikael Pettersson wrote:
>> - hardreset in sata_promise seems broken. I'll take a closer look
>>   at that in about a week's time (I'll be busy with other work the
>>   next couple of days).
>
>This looks like a rather serious problem, so please take a look at
>this.

I've done more tests now, and the problem is that errors detected
outside of sata_promise itself, typically timeouts, don't trigger
the pdc_reset_port() call needed to bring the ATA engine behind the
port back to sanity.

And the reason no Promise-specific reset is done on timeouts is
that libata-eh freezes the port before calling ->error_handler.
sata_promise's error_handler only does a reset if the port is
non-frozen, and I think that's because we don't want to destroy
error status bits needed by EH autopsy.

The solution I've been testing is the straightforward one of
overriding ->prereset with code which calls pdc_reset_port()
before calling the default prereset. (See patch below.)
(Promise's own driver issues resets whenever there's a sign
of a problem.)

One of my test disks will often trigger a timeout if smartctl
accesses it when it's spun down. Previously the port would not
recover from that, but now it's just a brief reset/detect and
then it's up again.

/Mikael

--- linux-2.6.27/drivers/ata/sata_promise.c.~1~	2008-07-14 10:22:36.000000000 +0200
+++ linux-2.6.27/drivers/ata/sata_promise.c	2008-10-20 00:20:58.000000000 +0200
@@ -153,6 +153,7 @@ static void pdc_freeze(struct ata_port *
 static void pdc_sata_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
 static void pdc_sata_thaw(struct ata_port *ap);
+static int pdc_prereset(struct ata_link *link, unsigned long deadline);
 static void pdc_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
 static int pdc_pata_cable_detect(struct ata_port *ap);
@@ -175,6 +176,7 @@ static const struct ata_port_operations 
 	.sff_irq_clear		= pdc_irq_clear,
 
 	.post_internal_cmd	= pdc_post_internal_cmd,
+	.prereset		= pdc_prereset,
 	.error_handler		= pdc_error_handler,
 };
 
@@ -691,6 +693,12 @@ static void pdc_sata_thaw(struct ata_por
 	readl(host_mmio + hotplug_offset); /* flush */
 }
 
+static int pdc_prereset(struct ata_link *link, unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return ata_sff_prereset(link, deadline);
+}
+
 static void pdc_error_handler(struct ata_port *ap)
 {
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
