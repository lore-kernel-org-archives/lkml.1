Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbXE1Kvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbXE1Kvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750700AbXE1Kvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:51:32 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55569
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXE1Kvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:51:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 12:49:55 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705280224.40506.mb@bu3sch.de> <200705280240.17910.maxi@daemonizer.de>
In-Reply-To: <200705280240.17910.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281249.56106.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you also test the following patch?
I think there's a bug in b44 that is doesn't properly discard
shared IRQs, so it might possibly generate a NAPI storm, dunno.
Worth a try.

Index: linux-2.6.22-rc3/drivers/net/b44.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/net/b44.c	2007-05-27 23:01:44.000000000 +0200
+++ linux-2.6.22-rc3/drivers/net/b44.c	2007-05-28 12:48:27.000000000 +0200
@@ -911,6 +911,8 @@ static irqreturn_t b44_interrupt(int irq
 	spin_lock(&bp->lock);
 
 	istat = br32(bp, B44_ISTAT);
+	if (istat == 0xFFFFFFFF)
+		goto out; /* Shared IRQ not for us */
 	imask = br32(bp, B44_IMASK);
 
 	/* The interrupt mask register controls which interrupt bits
@@ -942,6 +944,7 @@ irq_ack:
 		bw32(bp, B44_ISTAT, istat);
 		br32(bp, B44_ISTAT);
 	}
+out:
 	spin_unlock(&bp->lock);
 	return IRQ_RETVAL(handled);
 }


-- 
Greetings Michael.
