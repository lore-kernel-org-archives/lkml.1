Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbYB0Ez6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbYB0Ez6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759662AbYB0Ezq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:55:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:7869 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbYB0EzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:55:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 26 Feb 2008 20:55:11 -0800
MIME-Version: 1.0
Subject: RE: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 27 Feb 2008 12:55:08 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE7@hkemmail01.nvidia.com>
In-Reply-To: <47C43E27.5070700@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma.
Thread-Index: Ach4lKNSNUMFfONEQ/6e3kuickAn9AAXfr7A
References: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE5@hkemmail01.nvidia.com> <47C42534.1090107@shaw.ca> <47C43E27.5070700@garzik.org>
From: "Kuan Luo" <kluo@nvidia.com>
To: "Jeff Garzik" <jeff@garzik.org>, "Robert Hancock" <hancockr@shaw.ca>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, "Peer Chen" <pchen@nvidia.com>
X-OriginalArrivalTime: 27 Feb 2008 04:55:09.0009 (UTC) FILETIME=[ED66D410:01C878FC]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff wrote:
>robert worte:
> > 
> > This is basically avoiding switching into register mode, 
> right? I don't 
> > think this is a very good solution as the point of the 
> tf_read function 
> > is that it's supposed to read the taskfile provided by the drive to 
> > diagnose the error, so not doing this isn't a good thing.
> 
> Agree with this analysis -- if ->tf_read() is being called, then 
> obviously the core wants a current copy of the device's ATA registers.
> 
> It is not a good solution to simply avoiding returning 
> meaningful data, 
> because -- as Robert notes -- we need tf_read for analysis.
> 
> 	Jeff
>

The driver got one error : "nv_adma_check_cpb: CPB 0, flags=0x11". The
code entered ata_port_abort -> ata_qc_complete
-> fill_result_tf->nv_adma_tf_read.

Firstly, nv_adma_register_mode failed, showing the below messages:
timeout waiting for ADMA IDLE, stat=0x440
timeout waiting for ADMA LEGACY, stat=0x440

Then enter ata_tf_read function. 
I found the system hung at tf->hob_nsect = ioread8(ioaddr->nsect_addr);
Sometimes the screen showed "
CPU0: Machin check Exception 0000000000000004
Bank 4:b200000000070f0f
kernel panic -not syncing: CPU Context corrupt.
"
If nv_adma_register_mode failed, the reg result should be not
meaningful. 
I don't know why the systm hung.
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
