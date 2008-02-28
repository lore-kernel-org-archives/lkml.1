Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYB1D6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYB1D6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 22:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYB1D6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 22:58:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:1601 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYB1D6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 22:58:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Wed, 27 Feb 2008 19:58:19 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma.
Date: Thu, 28 Feb 2008 11:57:43 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE8@hkemmail01.nvidia.com>
In-Reply-To: <47C5FF3B.2000000@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma.
Thread-Index: Ach5oBGzbFELxopSTdSo5UbJjkwVGgAECyUA
References: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE5@hkemmail01.nvidia.com> <47C42534.1090107@shaw.ca> <47C43E27.5070700@garzik.org> <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE7@hkemmail01.nvidia.com> <47C5FF3B.2000000@shaw.ca>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, "Peer Chen" <pchen@nvidia.com>,
       "Allen Martin" <AMartin@nvidia.com>
X-OriginalArrivalTime: 28 Feb 2008 03:57:43.0563 (UTC) FILETIME=[122B3DB0:01C879BE]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rober wrote:
> Kuan Luo wrote:
> > Jeff wrote:
> >> robert worte:
> >>> This is basically avoiding switching into register mode, 
> >> right? I don't 
> >>> think this is a very good solution as the point of the 
> >> tf_read function 
> >>> is that it's supposed to read the taskfile provided by 
> the drive to 
> >>> diagnose the error, so not doing this isn't a good thing.
> >> Agree with this analysis -- if ->tf_read() is being called, then 
> >> obviously the core wants a current copy of the device's 
> ATA registers.
> >>
> >> It is not a good solution to simply avoiding returning 
> >> meaningful data, 
> >> because -- as Robert notes -- we need tf_read for analysis.
> >>
> >> 	Jeff
> >>
> > 
> > The driver got one error : "nv_adma_check_cpb: CPB 0, 
> flags=0x11". The
> > code entered ata_port_abort -> ata_qc_complete
> > -> fill_result_tf->nv_adma_tf_read.
> > 
> > Firstly, nv_adma_register_mode failed, showing the below messages:
> > timeout waiting for ADMA IDLE, stat=0x440
> > timeout waiting for ADMA LEGACY, stat=0x440
> > 
> > Then enter ata_tf_read function. 
> > I found the system hung at tf->hob_nsect = 
> ioread8(ioaddr->nsect_addr);
> > Sometimes the screen showed "
> > CPU0: Machin check Exception 0000000000000004
> > Bank 4:b200000000070f0f
> > kernel panic -not syncing: CPU Context corrupt.
> > "
> > If nv_adma_register_mode failed, the reg result should be not
> > meaningful. 
> > I don't know why the systm hung.
> 
> By the way, this MCE indicates that the CPU integrated 
> northbridge got a 
> watchdog error indicating that a bus transaction timed out 
> (presumably 
> on the HyperTransport link). This likely indicates that the chipset 
> failed to respond to a CPU read of that register. Obviously this is 
> something we want to avoid causing..
> 
In the process of debugging this issue, i found hardware sometimes
entered another wrong stat.
 nv_adma_interrupt: adma status 0x1540 notifier 0xffffffff notifer_err
0x0 sactive 0x1.

As the status has no NV_ADMA_STAT_CPBERR, the check_commands =
0xffffffff.
Actually,  there is only one command(sactive 0x1).

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ed5473b..7c24e71 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1052,19 +1052,18 @@ static irqreturn_t nv_adma_interrupt(int irq,
void *dev_instance)
 			if (status & (NV_ADMA_STAT_DONE |
 				      NV_ADMA_STAT_CPBERR |
 				      NV_ADMA_STAT_CMD_COMPLETE)) {
-				u32 check_commands = notifier_clears[i];
+				u32 check_commands = 0;
 				int pos, error = 0;
 
-				if (status & NV_ADMA_STAT_CPBERR) {
-					/* Check all active commands */
-					if
(ata_tag_valid(ap->link.active_tag))
-						check_commands = 1 <<
-
ap->link.active_tag;
-					else
-						check_commands = ap->
-							link.sactive;
-				}
+				/* Check all active commands */
+				if (ata_tag_valid(ap->link.active_tag))
+					check_commands = 1 <<
+						ap->link.active_tag;
+				else
+					check_commands = ap->
+						link.sactive;
 
+				check_commands &= notifier_clears[i];
 				/** Check CPBs for completed commands */
 				while ((pos = ffs(check_commands)) &&
!error) {
 					pos--;

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
