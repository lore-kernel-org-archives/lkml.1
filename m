Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYCJNFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYCJNFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCJNF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:05:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:12365 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYCJNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=XgFnqKvdNBTlwTaWIEFoIG0oXFa7PchJFXjXbMofY7Yq/oG8V2JCFFyflX7/UAphWR/yAQ7OPe8ULLG82HB45KF/jc7nCHEiMKMohvsKdJAiFBcw8Xzh9h+HWLCj+1QLh3404D/cKlho/AeWsPFqJl8+WMOgos4LRJQSi38OlXc=
Message-ID: <47D5320E.8020107@gmail.com>
Date: Mon, 10 Mar 2008 22:05:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay.
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------090001030106080805010901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090001030106080805010901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Volker Armin Hemmann wrote:
> Hi,
> 
> I have an Alive -NF5-esata2+. AM2 board with dual core AMD64 cpu.
> 
> Problem exists with latest bios 1.90 and its predecessor 1.80.
> 
> This board with nforce 520 chipset (MCP65) has three possible settings for the 
> sata controller:
> non-raid
> raid
> ahci.
> 
> My default is non-raid.
> 
> With 2.6.24 based kernels I get this on cold boot:
> 
> [   50.808824] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [   80.743754] ata1.00: qc timeout (cmd 0xec)
> [   80.743792] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)

Does "irqpoll" make any difference?  Also, does the attached patch help?

> and this on reboots:
> 
> [   36.619135] ata1: port is slow to respond, please be patient (Status 0xd0)
> [   40.982984] ata1: softreset failed (device not ready)

Is this consistent?  Do you always get IDENTIFY timeout on cold boots
and softreset failure on reboots?

> with 2.6.23.11 it looks like this:

Hmmm...

> I removed the pata-disk and the drivers some days ago - but that has had no 
> influence on the problem. The delay was there with the pata-drive and drivers 
> too. There are some changes in the config - but even with the 2.6.3.11 config 
> on a 2.6.24 and make oldconfig showed the delays.
> 
> If I change from 'non raid' to AHCI (because the handbook says that is the way 
> to get NCQ working) boot hangs for looong time and no harddisks are found:
> (dmesg from systemrescuecd 1.0)
> ahci 0000:00:0a.0: version 3.0
> ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low) -> 
> IRQ 18
> ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
> ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio 
> PCI: Setting latency timer of device 0000:00:0a.0 to 64
> scsi3 : ahci
> scsi4 : ahci
> scsi5 : ahci
> scsi6 : ahci
> ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 218
> ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 218
> ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 218
> ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 218
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> APIC error on CPU0: 00(40)
> scsi_scan_2 used greatest stack depth: 2868 bytes left
> ata1.00: qc timeout (cmd 0xec)
> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata1: failed to recover some devices, retrying in 5 secs

This one definitely looks like a misrouted IRQ.  irqpoll should help.
This failure is the same for 2.6.23 and 24, right?

-- 
tejun

--------------090001030106080805010901
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug"

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

Index: tree2/drivers/ata/ahci.c
===================================================================
--- tree2.orig/drivers/ata/ahci.c
+++ tree2/drivers/ata/ahci.c
@@ -397,6 +397,7 @@ static const struct ata_port_operations 
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */

--------------090001030106080805010901--
