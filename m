Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXHBO1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXHBO1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXHBO1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:27:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:3717 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbXHBO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ox9tEM6ivpLLpowwTRB7Li+TYNJMES6rNmAOeCt2+pQkKByvYr2b6gGE4p4Bi5Ijqd0JcKdPe9ZupXc816BK/Tlm2D8+voI82x5Zz3sRYoZ4jyo1jNgD8TaGVYVd4AWccprRbmb0COTBVuqfed45/9N4iSYipZbdvIuqb1IA8zQ=
Message-ID: <46B1E9D6.80006@googlemail.com>
Date: Thu, 02 Aug 2007 16:27:34 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch warnings
References: <46AE2459.7080905@googlemail.com> <20070730185124.GA29116@uranus.ravnborg.org> <46AE3C80.7010307@googlemail.com> <46AF9152.2050707@googlemail.com> <20070731204846.GA9985@uranus.ravnborg.org> <46AFB06E.2020401@googlemail.com>
In-Reply-To: <46AFB06E.2020401@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>> WARNING: vmlinux.o(.init.text+0x29d40): Section mismatch: reference to .exit.text:wbsd_release_resources (between 'wbsd_init' and 'wbsd_probe')
>>> WARNING: vmlinux.o(.init.text+0x29d49): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
>>> WARNING: vmlinux.o(.init.text+0x29f28): Section mismatch: reference to .exit.text:wbsd_free_mmc (between 'wbsd_init' and 'wbsd_probe')
>> When a function is marked __exit and used from an init function then the safe choice
>> is to just remove the __exit marking. Usually this is small functions used
>> only in error situations.
>> Should be trivial too.
> 
> I'll look at those too
> 
>> Sorry - no patch this time. Could you try to look at it yorself then I will review.
> 
> Ok I'll try.
> 

The warnings gone with this patch but I'm not really sure it is correct.


 drivers/mmc/host/wbsd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index e0c9808..9bf2a87 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -1266,7 +1266,7 @@ static int __devinit wbsd_alloc_mmc(struct device *dev)
 	return 0;
 }
 
-static void __devexit wbsd_free_mmc(struct device *dev)
+static void wbsd_free_mmc(struct device *dev)
 {
 	struct mmc_host *mmc;
 	struct wbsd_host *host;
@@ -1358,7 +1358,7 @@ static int __devinit wbsd_request_region(struct wbsd_host *host, int base)
 	return 0;
 }
 
-static void __devexit wbsd_release_regions(struct wbsd_host *host)
+static void wbsd_release_regions(struct wbsd_host *host)
 {
 	if (host->base)
 		release_region(host->base, 8);
@@ -1434,7 +1434,7 @@ err:
 		"Falling back on FIFO.\n", dma);
 }
 
-static void __devexit wbsd_release_dma(struct wbsd_host *host)
+static void wbsd_release_dma(struct wbsd_host *host)
 {
 	if (host->dma_addr) {
 		dma_unmap_single(mmc_dev(host->mmc), host->dma_addr,
@@ -1484,7 +1484,7 @@ static int __devinit wbsd_request_irq(struct wbsd_host *host, int irq)
 	return 0;
 }
 
-static void __devexit wbsd_release_irq(struct wbsd_host *host)
+static void  wbsd_release_irq(struct wbsd_host *host)
 {
 	if (!host->irq)
 		return;
@@ -1535,7 +1535,7 @@ static int __devinit wbsd_request_resources(struct wbsd_host *host,
  * Release all resources for the host.
  */
 
-static void __devexit wbsd_release_resources(struct wbsd_host *host)
+static void wbsd_release_resources(struct wbsd_host *host)
 {
 	wbsd_release_dma(host);
 	wbsd_release_irq(host);
