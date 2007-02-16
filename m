Return-Path: <linux-kernel-owner+w=401wt.eu-S1423226AbXBPEww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423226AbXBPEww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423218AbXBPEww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:52:52 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:60676 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423219AbXBPEwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:52:50 -0500
Date: Thu, 15 Feb 2007 22:52:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv ADMA controller lockup investigation
In-reply-to: <45D439F7.3030604@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Allen Martin <AMartin@nvidia.com>, nas@arctrix.com, B.Steinbrink@gmx.de
Message-id: <45D5389E.70300@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45D3E1FF.3080606@shaw.ca> <45D439F7.3030604@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> It's curious that only the post-cache-flush command is having issues,
>> and normal NCQ operation seems fine. Maybe it's related to that tag 0
>> being reused repeatedly?
> 
> 
> If you take cache flush out of the equation, what happens when NCQ is 
> enabled with a queue depth of 1 (to reproduce tag-0-used-repeatedly 
> condition)?
> 
>     Jeff

I was able to reproduce it in my same test case with NCQ depth set to 1.
Of course, there were still some cache flushes going on there, so I'm not
certain that test really told us anything new. I'm rather doutbful that it's
related to reusing the same tag now, though, based on the tests I've been
doing. It may be something to do with switching between NCQ and non-NCQ
commands, maybe the controller isn't able to handle doing that too rapidly.
This patch seems to fix the problem - or at least it hasn't failed the tests that
I've run so far. It's not really ideal though, so I'd like to do some more
investigation/testing before proclaiming it as a fix. Experimentally, it
appears that 10 microseconds is not enough delay, but 20 seems to work better.

Hints from the peanut gallery remain welcome.

--- linux-2.6.20-git6edit/drivers/ata/sata_nv.c.before_hacking	2007-02-15 18:19:13.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_nv.c	2007-02-15 22:36:02.000000000 -0600
@@ -219,6 +219,7 @@
 	void __iomem *		gen_block;
 	void __iomem *		notifier_clear_block;
 	u8			flags;
+	int			last_issue_ncq;
 };
 
 struct nv_host_priv {
@@ -1260,6 +1261,7 @@
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
+	int curr_ncq = (qc->tf.protocol == ATA_PROT_NCQ);
 
 	VPRINTK("ENTER\n");
 
@@ -1274,6 +1276,14 @@
 	/* write append register, command tag in lower 8 bits
 	   and (number of cpbs to append -1) in top 8 bits */
 	wmb();
+
+	if(curr_ncq != pp->last_issue_ncq) {
+	   	/* Seems to need some delay before switching between NCQ and non-NCQ
+		   commands, else we get command timeouts and such. */
+		udelay(20);
+		pp->last_issue_ncq = curr_ncq;
+	}
+
 	writew(qc->tag, mmio + NV_ADMA_APPEND);
 
 	DPRINTK("Issued tag %u\n",qc->tag);
