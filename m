Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXHAWNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXHAWNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXHAWNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:13:44 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:40599 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbXHAWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:13:43 -0400
Date: Wed, 1 Aug 2007 15:13:40 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       Andrew Patterson <andrew.patterson@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] qla2xxx: allocate enough space for the full PCI descriptor.
Message-ID: <20070801221340.GA4370@plap.qlogic.org>
References: <46A8BF75.161.5C8424A@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de> <1185487419.7134.485.camel@bluto.andrew> <20070727062343.GC15408@plap.qlogic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727062343.GC15408@plap.qlogic.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 01 Aug 2007 22:12:48.0128 (UTC) FILETIME=[17FAF800:01C7D489]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

	On Thu, 26 Jul 2007, Andrew Vasquez wrote:

	> On Thu, 26 Jul 2007, Andrew Patterson wrote:
	> 
	> > On Thu, 2007-07-26 at 15:36 +0200, Ulrich Windl wrote:
	> > > Hi,
	> > > 
	> > > <6>QLogic Fibre Channel HBA Driver
	> > > <6>GSI 49 (level, low) -> CPU 3 (0x0300) vector 51
	> > > <6>ACPI: PCI Interrupt 0000:0f:01.0[A] -> GSI 49 (level, low) -> IRQ 51
	> > > <6>qla2xxx 0000:0f:01.0: Found an ISP2422, irq 51, iobase 0xc0000000b0040000
	> > > [...]
	> > > <6>qla2xxx 0000:0f:01.0: LOOP UP detected (4 Gbps).
	> > > <6>qla2xxx 0000:0f:01.0: Topology - (F_Port), Host Loop address 0x0
	> > > <6>scsi0 : qla2xxx
	> > > <6>qla2xxx 0000:0f:01.0:
	> > > <4> QLogic Fibre Channel HBA Driver: 8.01.07-k3
	> > > <4>  QLogic HP AB378-60001 -
	> > > <4>  ISP2422: PCI-X Mode 2 (133 MH4.00.26 [IP]  @ 0000:0f:01.0 hdma+, host#=0, 
	> > > fw=4.00.26 [IP]
	> 
	> The 33/66/100/133 values refer to the bus-clock speed at which the
	> card is operating.  As is seen here (although a bit truncated --
	> separate issue, I'll try to see if I can reproduce this on one of my
	> HPQ rigs),

	Ok, so what's happening here is the buffer passed in (pci_info)
	does not have bytes allocated (off by 3).

	James, please apply...

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 93c0c7e..acca898 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1564,7 +1564,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
-	char pci_info[20];
+	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
 
