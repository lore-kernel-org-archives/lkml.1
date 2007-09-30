Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbXI3Vmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbXI3Vmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 17:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXI3Vmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 17:42:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40063 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752325AbXI3Vmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:42:42 -0400
Date: Sun, 30 Sep 2007 22:47:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Scott Simpson <simps05192@yahoo.com>
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org,
       james.bottomley@HansenPartnership.com
Subject: Re: Conflict when loading initio driver
Message-ID: <20070930224755.6a4cf1c6@the-village.bc.nu>
In-Reply-To: <786233.43251.qm@web56808.mail.re3.yahoo.com>
References: <786233.43251.qm@web56808.mail.re3.yahoo.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>    I have a scanner connected to a Initio INI-950 SCSI card and I recently upgraded from SuSE 10.2 to 10.3. The new kernel doesn't see any of my devices. I get the following in /var/log/messages:
> 
> 
> 
>    
> 
>    Sep 30 09:05:13 r2d2 kernel: ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 17 (level, low) -> IRQ 16
> 
>    Sep 30 09:05:13 r2d2 kernel: initio: I/O port range 0x0 is busy.
> 
>    Sep 30 09:05:13 r2d2 kernel: ACPI: PCI interrupt for device 0000:00:0a.0 disabled

Humm not a collision - thats a bug in the driver updating. Looks like the
changes I made and combined with Christoph's lost a line somewhere when I
was merging it all. Try the following

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/drivers/scsi/initio.c linux-2.6.23rc8-mm1/drivers/scsi/initio.c
--- linux.vanilla-2.6.23rc8-mm1/drivers/scsi/initio.c	2007-09-26 16:46:54.000000000 +0100
+++ linux-2.6.23rc8-mm1/drivers/scsi/initio.c	2007-09-30 22:22:03.839113616 +0100
@@ -2867,6 +2867,7 @@
 	}
 	host = (struct initio_host *)shost->hostdata;
 	memset(host, 0, sizeof(struct initio_host));
+	host->addr = pci_resource_start(pdev, 0);
 
 	if (!request_region(host->addr, 256, "i91u")) {
 		printk(KERN_WARNING "initio: I/O port range 0x%x is busy.\n", host->addr);
