Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXBZVRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXBZVRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbXBZVRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:17:43 -0500
Received: from mail.gmx.net ([213.165.64.20]:46123 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932516AbXBZVRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:17:42 -0500
X-Provags-ID: V01U2FsdGVkX1/7xHJW48/7TGbZYdbM2dq/Q+Jyo9ksufY0ijDQPY
	jpBQ==
Date: Mon, 26 Feb 2007 22:17:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] pata_sil680 suspend/resume
In-Reply-To: <20061122172841.0b90f042@localhost.localdomain>
Message-ID: <Pine.LNX.4.60.0702262150460.5079@poirot.grange>
References: <20061122172841.0b90f042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I'm trying to suspend to RAM a KuroboxHG: powerpc MPC8241 based system 
with a sil680

00:0c.0 IDE interface: Silicon Image, Inc. PCI0680 Ultra ATA-133 Host Controller (rev 02)

PATA controller, using pata_sil680. This is not a real str, i.e., power is 
not switched off, just pull the whole system through suspend, and at the 
end put the peripheral controller and the CPU core to sleep.

To suspend I just use a script like:

hdparm -Y /dev/sda
echo -n "mem" > /sys/power/state
hdparm -y /dev/sda

where the last hdparm is meant to wake up the drive (ok, it doesn't:-)), 
tried without it too. 

With an approximately 2.6.20 kernel I could suspend, but on resume I got

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: tag 0 cmd 0xe0 Emask 0x4 stat 0x40 err 0x0 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: port failed to respond (30 secs, Status 0xd0)
ata1: soft resetting port
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 40020624 512-byte hdwr sectors (20491 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back

but then it worked - congratulations to all authors on a robust error 
handling! If I remove the "hdparm -y" I get a similar error on the first 
access.

With a post 2.6.20 kernel from powerpc.git I cannot suspend at all:

pata_sil680 0000:00:0c.0: suspend
ata1: suspend failed, device 0 still active
pci_device_suspend(): ata_pci_device_suspend+0x0/0x74() returns -16
suspend_device(): pci_device_suspend+0x0/0xac() returns -16
Could not suspend device 0000:00:0c.0: error -16

Same without "hdparm -Y". Should I use sdparm instead? but
"sdparm --command stop /dev/sda" doesn't spin the disk down.

Looking at drivers/ata/libata-eh.c it looks like ata_eh_suspend() should 
spin the disk down by itself and set the ATA_DFLAG_SUSPENDED flag, but it 
doesn't seem to happen. Or is it only for SATA?

Thanks
Guennadi
---
Guennadi Liakhovetski
