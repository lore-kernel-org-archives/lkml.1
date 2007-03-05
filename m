Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXCEPT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXCEPT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXCEPT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:19:59 -0500
Received: from rtr.ca ([64.26.128.89]:3957 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXCEPT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:19:58 -0500
Message-ID: <45EC351B.2020206@rtr.ca>
Date: Mon, 05 Mar 2007 10:19:55 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca> <45EBAC73.7010600@drzeus.cx> <45EC2851.7020905@rtr.ca>
In-Reply-To: <45EC2851.7020905@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Pierre Ossman wrote:
>> Mark Lord wrote:
>>> Another regression, for Pierre Ossman this time.
>>>
>>> My syslog gets spammed like this (below) on suspend/resume (to RAM) 
>>> cycles.
>>> Worked fine, without all of the noise, in all previous kernels up to
>>> 2.6.20+.
>>>
>>
>> This looks like a PCI configuration issue.
> 
> To me, it looks like a buggy driver "resume" sequence.
> The low-level SDHCI driver is trying to use the device
> before the PM/PCI stuff has restored the pre-suspend state.
...

I've dug a bit deeper, instrumenting the driver,
and found/fixed the problem.

The interrupt is shared with another device, which resumes
earlier than the sdhci controller, and generates an interrupt.

The sdhci interrupt handler runs, sees 0xffffffff in its own
device's interrupt status, and tries to handle it..
The reason for the 0xffffffff is that the device is still
suspended, and *all* regs are reading back 0xffffffff.

So.. the suspend routine should de-register the irq handler,
and the resume routine should re-register it again.

Or perhaps a simpler kludge like this one, which fixes it for me:

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- linux/drivers/mmc/sdhci.c.orig	2007-03-02 15:06:31.000000000 -0500
+++ linux/drivers/mmc/sdhci.c	2007-03-05 10:13:51.000000000 -0500
@@ -994,7 +994,7 @@
 
 	intmask = readl(host->ioaddr + SDHCI_INT_STATUS);
 
-	if (!intmask) {
+	if (!intmask || intmask == 0xffffffff) {
 		result = IRQ_NONE;
 		goto out;
 	}
