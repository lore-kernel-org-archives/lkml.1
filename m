Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbXHVW5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbXHVW5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762384AbXHVW5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:57:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:57125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761777AbXHVW5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:57:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,295,1183359600"; 
   d="scan'208";a="120439175"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Date: Wed, 22 Aug 2007 15:56:57 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A023B2F6A@scsmsx411.amr.corp.intel.com>
In-Reply-To: <46CCB79E.7070109@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [BUG] 2.6.23-rc3-mm1 Kernel panic - not syncing: DMA: Memory would be corrupted
Thread-Index: AcflC02++1utvQzBTSeOiThkSwTf0AAAf3Gg
References: <46CC48FD.4000607@linux.vnet.ibm.com> <20070822091959.aa38fd3e.akpm@linux-foundation.org> <20070822172541.GA8058@bingen.suse.de> <46CC811C.9010600@linux.vnet.ibm.com> <617E1C2C70743745A92448908E030B2A023B2D39@scsmsx411.amr.corp.intel.com> <46CCB79E.7070109@linux.vnet.ibm.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       <linux-ia64@vger.kernel.org>
X-OriginalArrivalTime: 22 Aug 2007 22:56:58.0536 (UTC) FILETIME=[BE6BE280:01C7E50F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ 20.903201] [<a0000001003aaa50>] swiotlb_full+0x50/0x120
[ 20.903202] sp=e00000014322fac0 bsp=e000000143229120
[ 20.916902] [<a0000001003aac40>] swiotlb_map_single+0x120/0x1c0
[ 20.916904] sp=e00000014322fac0 bsp=e0000001432290d8
[ 20.931215] [<a0000001003ab630>] swiotlb_alloc_coherent+0x150/0x240
[ 20.931217] sp=e00000014322fac0 bsp=e000000143229090
[ 20.945923] [<a000000100550860>] PrimeIocFifos+0x4c0/0xb20
[ 20.945925] sp=e00000014322fac0 bsp=e000000143229010
[ 20.959812] [<a000000100556a80>] mpt_do_ioc_recovery+0xd60/0x28e0
[ 20.959814] sp=e00000014322faf0 bsp=e000000143228f30
[ 20.974310] [<a00000010055c8f0>] mpt_attach+0x830/0x20e0


Hmmm!  So you were in the mpt/fusion driver when you ran out
of SWIOTLB space.  That's an area where we both have the same
hardware ... and since it booted for me, it means that the
driver isn't totally broken.

I'm totally ignorant of what goes on inside this driver though.
You have more "ioc's" than I do.  I only see messages from mpt
bringing up ioc0 & ioc1.  Your boot_log also has ioc2 (which is
where you crash).  Here's the sdiff(1) output comparing the MPT
part of your boot log with my successful boot of the same kernel
and config (your log is the one on the left).  Maybe some MPT/Fusion
expert can spot something important in this bit?

-Tony

Fusion MPT base driver 3.04.05                                  Fusion MPT base driver 3.04.05
Copyright (c) 1999-2007 LSI Corporation                         Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.05                              Fusion MPT SPI Host driver 3.04.05
GSI 40 (level, low) -> CPU 3 (0x0600) vector 71               | GSI 28 (level, low) -> CPU 0 (0xc018) vector 48
ACPI: PCI Interrupt 0000:01:03.0[A] -> GSI 40 (level, low) -> | ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 28 (level, low) ->
mptbase: Initiating ioc0 bringup                                mptbase: Initiating ioc0 bringup
ioc0: LSI53C1030 C0: Capabilities={Initiator}                 | ioc0: LSI53C1030 B2: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=2 | scsi0 : ioc0: LSI53C1030 B2, FwRev=01030a00h, Ports=1, MaxQ=2
scsi 0:0:0:0: Direct-Access     IBM-ESXS DTN018C1UCDY10F  S25 | scsi 0:0:0:0: Direct-Access     QUANTUM  ATLAS IV 9 SCA   0B0
 target0:0:0: Beginning Domain Validation                        target0:0:0: Beginning Domain Validation
                                                              >  target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation                           target0:0:0: Ending Domain Validation
 target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offse |  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offse
sd 0:0:0:0: [sda] 35548320 512-byte hardware sectors (18201 M | sd 0:0:0:0: [sda] 17942584 512-byte hardware sectors (9187 MB
sd 0:0:0:0: [sda] Write Protect is off                          sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, | sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
sd 0:0:0:0: [sda] 35548320 512-byte hardware sectors (18201 M | sd 0:0:0:0: [sda] 17942584 512-byte hardware sectors (9187 MB
sd 0:0:0:0: [sda] Write Protect is off                          sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, | sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
 sda: sda1 sda2                                               |  sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk                            sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0                    sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:8:0: Processor         IBM      25P3495a S320  1 1   | scsi 0:0:1:0: Direct-Access     SEAGATE  ST318406LC       010
 target0:0:8: Beginning Domain Validation                     |  target0:0:1: Beginning Domain Validation
 target0:0:8: Ending Domain Validation                        |  target0:0:1: Ending Domain Validation
 target0:0:8: asynchronous                                    |  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offse
scsi 0:0:8:0: Attached scsi generic sg1 type 3                | sd 0:0:1:0: [sdb] 35843670 512-byte hardware sectors (18352 M
GSI 41 (level, low) -> CPU 4 (0x1000) vector 72               | sd 0:0:1:0: [sdb] Write Protect is off
ACPI: PCI Interrupt 0000:01:03.1[B] -> GSI 41 (level, low) -> | sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
                                                              > sd 0:0:1:0: [sdb] 35843670 512-byte hardware sectors (18352 M
                                                              > sd 0:0:1:0: [sdb] Write Protect is off
                                                              > sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
                                                              >  sdb: sdb1 sdb2 sdb3
                                                              > sd 0:0:1:0: [sdb] Attached SCSI disk
                                                              > sd 0:0:1:0: Attached scsi generic sg1 type 0
                                                              > scsi 0:0:6:0: Processor         ESG-SHV  SCA HSBP M17     1.0
                                                              >  target0:0:6: Beginning Domain Validation
                                                              >  target0:0:6: Ending Domain Validation
                                                              >  target0:0:6: asynchronous
                                                              > scsi 0:0:6:0: Attached scsi generic sg2 type 3
                                                              > GSI 29 (level, low) -> CPU 1 (0xc218) vector 49
                                                              > ACPI: PCI Interrupt 0000:06:02.1[B] -> GSI 29 (level, low) ->
mptbase: Initiating ioc1 bringup                                mptbase: Initiating ioc1 bringup
ioc1: LSI53C1030 C0: Capabilities={Initiator}                 | ioc1: LSI53C1030 B2: Capabilities={Initiator}
scsi1 : ioc1: LSI53C1030 C0, FwRev=01032821h, Ports=1, MaxQ=2 | scsi1 : ioc1: LSI53C1030 B2, FwRev=01030a00h, Ports=1, MaxQ=2
GSI 142 (level, low) -> CPU 5 (0x1200) vector 73              | Fusion MPT SAS Host driver 3.04.05
ACPI: PCI Interrupt 0000:41:03.0[A] -> GSI 142 (level, low) - | USB Universal Host Controller Interface driver v3.0
mptbase: Initiating ioc2 bringup                              | GSI 16 (level, low) -> CPU 2 (0xc418) vector 50
ioc2: LSI53C1030 C0: Capabilities={Initiator}                 | ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) ->
DMA: Out of SW-IOMMU space for 263200 bytes at device ?       | uhci_hcd 0000:00:1d.0: UHCI Host Controller
Kernel panic - not syncing: DMA: Memory would be corrupted    | uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus n
