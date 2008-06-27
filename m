Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYF0KwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYF0KwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 06:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYF0KwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 06:52:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:62152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbYF0Kv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 06:51:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,715,1204531200"; 
   d="scan'208";a="402723050"
Subject: Re: linux-next: Tree for June 26
From: David Woodhouse <david.woodhouse@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <200806270138.53895.rjw@sisk.pl>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <200806270138.53895.rjw@sisk.pl>
Organization: Intel Corporation
Date: Fri, 27 Jun 2008 11:51:53 +0100
Message-Id: <1214563913.10393.180.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-27 at 01:38 +0200, Rafael J. Wysocki wrote:
> commit 423c982fffb1cd95c8cdd654ce5ab59351ba41f5
> Author: Jaswinder Singh <jaswinder@infradead.org>
> Date:   Wed Jun 18 19:58:33 2008 +0530
> 
>     firmware: convert tg3 driver to request_firmware()
> 
> breaks my nx6325.
> 
> Apparently, with this patch applied the tg3 has a NULL pointer dereference
> somewhere, but I can only see the first line of the oops, afterwards the box
> hangs solid.

That's a 5705, isn't it? So using the 'tso5' firmware?

Is that firmware available (did you either build it into your kernel, or
run 'make INSTALL_FW_PATH=/lib/firmware firmware_install')? 

Not that it matters; I suspect the driver isn't trying to load it at
all. Can you test this patch, please?

(There are more cleanups I want to do to the error paths here, but those
should be harmless and irrelevant: http://david.woodhou.se/tg3.patch )

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index a70147d..bad784b 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -12234,11 +12234,6 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 
 	if (tp->tg3_flags2 & TG3_FLG2_HW_TSO) {
 		tp->tg3_flags2 |= TG3_FLG2_TSO_CAPABLE;
-
-		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705)
-			fw_name = "tigon/tg3_tso5.bin";
-		else
-			fw_name = "tigon/tg3_tso.bin";
 	}
 	else if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
 	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5701 ||
@@ -12248,6 +12243,13 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 		tp->tg3_flags2 &= ~TG3_FLG2_TSO_CAPABLE;
 	} else {
 		tp->tg3_flags2 |= TG3_FLG2_TSO_CAPABLE | TG3_FLG2_TSO_BUG;
+		printk("this code path would have forgotten to load the firmware\n");
+	}
+	if (tp->tg3_flags2 & TG3_FLG2_TSO_CAPABLE) {
+		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705)
+			fw_name = "tigon/tg3_tso5.bin";
+		else
+			fw_name = "tigon/tg3_tso.bin";
 	}
 
 	if (fw_name) {


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

