Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbXDFWMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbXDFWMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXDFWMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:12:25 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3204 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165AbXDFWMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:12:21 -0400
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: tg3: unable to handle null pointer dereference [Re: Linux
 2.6.21-rc6]
From: "Michael Chan" <mchan@broadcom.com>
To: "Nishanth Aravamudan" <nacc@us.ibm.com>, davem@davemloft.net
cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20070406214014.GF3346@us.ibm.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
 <20070406214014.GF3346@us.ibm.com>
Date: Fri, 06 Apr 2007 15:57:13 -0700
Message-ID: <1175900233.7911.87.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6A081A3138G13598993-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-06 at 14:40 -0700, Nishanth Aravamudan wrote:

> 2.6.21-rc5 is ok. 2.6.21-rc6 results in
> 
> [   14.241665] Unable to handle kernel NULL pointer dereference (address 0000000000000000)

Sorry, I think this should fix it:

[TG3]: Fix crash during tg3_init_one().

The driver will crash when the chip has been initialized by EFI before
tg3_init_one().  In this case, the driver will call tg3_chip_reset()
before allocating consistent memory.

The bug is fixed by checking for tp->hw_status before accessing it
during tg3_chip_reset().

Signed-off-by: Michael Chan <mchan@broadcom.com>

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 0acee9f..256969e 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -4834,8 +4834,10 @@ static int tg3_chip_reset(struct tg3 *tp)
 	 * sharing or irqpoll.
 	 */
 	tp->tg3_flags |= TG3_FLAG_CHIP_RESETTING;
-	tp->hw_status->status = 0;
-	tp->hw_status->status_tag = 0;
+	if (tp->hw_status) {
+		tp->hw_status->status = 0;
+		tp->hw_status->status_tag = 0;
+	}
 	tp->last_tag = 0;
 	smp_mb();
 	synchronize_irq(tp->pdev->irq);




