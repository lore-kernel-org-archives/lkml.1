Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXLKMKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXLKMKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 07:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXLKMJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 07:09:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:1649 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbXLKMJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 07:09:54 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 07:09:54 EST
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 11 Dec 2007 04:04:53 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] sata_nv,adma: fix error when rmmod sata_nv
Date: Tue, 11 Dec 2007 20:04:29 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AAB@hkemmail01.nvidia.com>
In-Reply-To: <4735FFE6.6020705@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_nv,adma: fix error when rmmod sata_nv
Thread-Index: AcgjzAsyneLVsTKKScKpswOp4BuxCwYHjovw
References: <200709251323031982245@gmail.com> <470FE47B.5060505@garzik.org> <cfaab6210710160108x1328086cse991f668e23e569e@mail.gmail.com> <47181CE1.4000802@garzik.org> <cfaab6210710182358t4de355f9wd6d605a7b8076ace@mail.gmail.com> <47185BFD.2010909@garzik.org> <cfaab6210710211855q7a2de35co13d3017b2a07d4cc@mail.gmail.com> <47352DD8.6040607@garzik.org> <47353AE8.5050900@garzik.org> <4735FFE6.6020705@shaw.ca>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "peer chen" <peerchen@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "Robert Hancock" <hancockr@shaw.ca>
X-OriginalArrivalTime: 11 Dec 2007 12:04:30.0327 (UTC) FILETIME=[FC1F8070:01C83BED]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
The below error happens when i rmmod sata_nv in adma mode on ck804
chipset with 2.6.24 kernel.
I traced the code and found that the driver attempts to write device mem
that has been unmapped.

Only simply removing the code" writew(0, mmio + NV_ADMA_CTL);" in the
nv_adma_port_stop function or remove .port_stop field in nv_adma_ops,
rmmod is ok.

static void nv_adma_port_stop(struct ata_port *ap)
{
	struct nv_adma_port_priv *pp = ap->private_data;
	void __iomem *mmio = pp->ctl_block;

	VPRINTK("ENTER\n");
-	writew(0, mmio + NV_ADMA_CTL);
}

Or
 Place pcim_iomap_regions before ata_pci_prepare_native_host in
nv_init_one function.
This can guarantee that the code "writew(0, mmio + NV_ADMA_CTL) " write
device mem before the device mem is unmapped.

messages:
Dec 19 02:23:24 localhost kernel: ata16.00: disabled
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Synchronizing SCSI
cache
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Result:
hostbyte=0x04 driverbyte=0x00
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Stopping disk
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] START_STOP FAILED
Dec 19 02:23:24 localhost kernel: sd 15:0:0:0: [sda] Result:
hostbyte=0x04 driverbyte=0x00
Dec 19 02:23:24 localhost kernel: BUG: unable to handle kernel paging
request at virtual address e881a4c0
Dec 19 02:23:24 localhost kernel: printing eip: e88224e9 *pde = 0180c067
*pte = 00000000 
Dec 19 02:23:24 localhost kernel: Oops: 0002 [#1] SMP 
Dec 19 02:23:24 localhost kernel: Modules linked in: sata_nv libata
Dec 19 02:23:24 localhost kernel: 
Dec 19 02:23:24 localhost kernel: Pid: 4915, comm: rmmod Not tainted
(2.6.24-rc1-ge2e031eb #2)
Dec 19 02:23:24 localhost kernel: EIP: 0060:[<e88224e9>] EFLAGS:
00210292 CPU: 1
Dec 19 02:23:24 localhost kernel: EIP is at nv_adma_port_stop+0x3d/0x53
[sata_nv]
Dec 19 02:23:24 localhost kernel: EAX: 00000015 EBX: e881a480 ECX:
00200046 EDX: 00200046
Dec 19 02:23:24 localhost kernel: ESI: c220b50c EDI: c1979154 EBP:
c197904c ESP: c2429ecc
Dec 19 02:23:24 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033
SS: 0068
Dec 19 02:23:24 localhost kernel: Process rmmod (pid: 4915, ti=c2428000
task=c25e5a40 task.ti=c2428000)
Dec 19 02:23:24 localhost kernel: Stack: e8823e1b e881a480 00000000
e884398e c220b500 c18a3ec0 c1979154 00000000 
Dec 19 02:23:24 localhost kernel:        c02818be c1979154 c197904c
0000000d c18a3ec0 c18a3a40 c197904c e88259d0 
Dec 19 02:23:24 localhost kernel:        e88259d0 c2428000 c0281987
00200286 c197904c c027f8bb c1834600 c197904c 
Dec 19 02:23:24 localhost kernel: Call Trace:
Dec 19 02:23:24 localhost kernel:  [<e884398e>]
ata_host_release+0x2f/0x92 [libata]
Dec 19 02:23:24 localhost kernel:  [<c02818be>]
release_nodes+0x10f/0x12f
Dec 19 02:23:24 localhost kernel:  [<c0281987>]
devres_release_all+0x27/0x2a
Dec 19 02:23:24 localhost kernel:  [<c027f8bb>]
__device_release_driver+0x72/0x88
Dec 19 02:23:24 localhost kernel:  [<c027fccb>] driver_detach+0x76/0xb3
Dec 19 02:23:24 localhost kernel:  [<c027f49f>]
bus_remove_driver+0x63/0x81
Dec 19 02:23:24 localhost kernel:  [<c0228b5a>]
pci_unregister_driver+0xc/0x57
Dec 19 02:23:24 localhost kernel:  [<c0143792>]
sys_delete_module+0x197/0x1bd
Dec 19 02:23:24 localhost kernel:  [<c0417673>]
do_page_fault+0x202/0x581
Dec 19 02:23:24 localhost kernel:  [<c01570ec>] do_munmap+0x193/0x1ac
Dec 19 02:23:24 localhost kernel:  [<c0104e4e>]
sysenter_past_esp+0x5f/0x85
Dec 19 02:23:24 localhost kernel:  =======================
Dec 19 02:23:24 localhost kernel: Code: 3e 82 e8 e8 b8 30 90 d7 89 5c 24
04 c7 04 24 0f 3e 82 e8 e8 a8 30 90 d7 8b 5b 10 c7 04 24 1b 3e 82 e8 89
5c 24 04 e8 95 30 90 d7 <66> c7 43 40 00 00 c7 04 24 29 3e 82 e8 e8 83
30 90 d7 5b 58 5b 
Dec 19 02:23:24 localhost kernel: EIP: [<e88224e9>]
nv_adma_port_stop+0x3d/0x53 [sata_nv] SS:ESP 0068:c2429ecc
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
