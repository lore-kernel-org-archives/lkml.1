Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbZHDRU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbZHDRU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 13:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932811AbZHDRU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 13:20:56 -0400
Received: from ru.mvista.com ([213.79.90.228]:46806 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932832AbZHDRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 13:20:55 -0400
Date: Tue, 4 Aug 2009 21:20:55 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: akpm@linux-foundation.org, drzeus@drzeus.cx, ian@mnementh.co.uk,
       matt@console-pimps.org, roberto.foglietta@gmail.com,
       linux-kernel@vger.kernel.org, sdhci-devel@lists.ossman.eu
Subject: [PATCH] sdhci: Be more strict with get_min_clock() usage
Message-ID: <20090804172055.GA9271@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <200907292204.n6TM4GGQ019192@imap1.linux-foundation.org>
 <20090801100443.7a5c2f86@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090801100443.7a5c2f86@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_min_clock() makes sense only with NONSTANDARD_CLOCK quirk and when
set_clock() callback is specified.

The patch should cause no functional changes, it just makes the code
self-documented and avoids any possible misuse of get_min_clock().

Suggested-by: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

On Sat, Aug 01, 2009 at 10:04:43AM +0200, Pierre Ossman wrote:
[...]
> Hmm... I don't think this is quite right. Right now you kill the
> warning without verifying that there is a mechanism to go lower.
[...]
> > -	mmc->f_min = host->max_clk / 256;
> > +	if (host->ops->get_min_clock)
> > +		mmc->f_min = host->ops->get_min_clock(host);
> > +	else
> > +		mmc->f_min = host->max_clk / 256;
> >  	mmc->f_max = host->max_clk;
> >  	mmc->caps = MMC_CAP_SDIO_IRQ;
> 
> You should be checking ops->set_clock and SDHCI_QUIRK_NONSTANDARD_CLOCK
> here.

Well, it makes no sense to specify .get_min_clock() w/o .set_clock().

But okay, to make things self documented and to avoid misuses, we'd
better add these checks.

Thanks Pierre!

 drivers/mmc/host/sdhci.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index fc96f8c..7f7f45b 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1772,7 +1772,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	 * Set host parameters.
 	 */
 	mmc->ops = &sdhci_ops;
-	if (host->ops->get_min_clock)
+	if (host->quirks & SDHCI_QUIRK_NONSTANDARD_CLOCK &&
+			host->ops->set_clock && host->ops->get_min_clock)
 		mmc->f_min = host->ops->get_min_clock(host);
 	else
 		mmc->f_min = host->max_clk / 256;
-- 
1.6.3.3

