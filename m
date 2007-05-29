Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbXE2VSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbXE2VSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXE2VRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:17:52 -0400
Received: from smtp.osdl.org ([207.189.120.12]:41813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXE2VRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:17:50 -0400
Date: Tue, 29 May 2007 14:01:55 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Gary Zambrano" <zambrano@broadcom.com>,
       "Maximilian Engelhardt" <maxi@daemonizer.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Jeff Garzik" <jgarzik@pobox.com>, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: b44: regression in 2.6.22 (resend)
Message-ID: <20070529140155.07693380@freepuppy>
In-Reply-To: <200705292245.22940.mb@bu3sch.de>
References: <20070525172431.60affaca@freepuppy>
	<200705281655.15105.mb@bu3sch.de>
	<1180448075.17146.12.camel@dhcp-10-12-136-115.broadcom.com>
	<200705292245.22940.mb@bu3sch.de>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am busy bisecting the real cause. Unfortunately, oprofile doesn't work
on the laptop, and build time sucks...

This how I think the IRQ should work:

--- a/drivers/net/b44.c	2007-05-29 09:47:53.000000000 -0700
+++ b/drivers/net/b44.c	2007-05-29 09:49:50.000000000 -0700
@@ -908,9 +908,11 @@ static irqreturn_t b44_interrupt(int irq
 	u32 istat, imask;
 	int handled = 0;
 
-	spin_lock(&bp->lock);
-
 	istat = br32(bp, B44_ISTAT);
+	if (istat == 0 || istat == ~0)
+		return IRQ_NONE;
+
+	spin_lock(&bp->lock);
 	imask = br32(bp, B44_IMASK);
 
 	/* The interrupt mask register controls which interrupt bits
