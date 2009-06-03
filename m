Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZFCJsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZFCJsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZFCJsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:48:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:27017 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZFCJsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:48:03 -0400
Subject: Re: [PATCH 1/1] MMC: core/core.c: mmc_rescan detects card change
	in one run
From: =?ISO-8859-1?Q?J=F6rg?= Schummer <ext-jorg.2.schummer@nokia.com>
To: ext Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090410183955.011c4d65@mjolnir.ossman.eu>
References: <20090303095530.65923117@mjolnir.ossman.eu>
	 <1238511081-24570-1-git-send-email-ext-jorg.2.schummer@nokia.com>
	 <20090410183955.011c4d65@mjolnir.ossman.eu>
Content-Type: multipart/mixed; boundary="=-XyVVsPNMlZ3R/AAyZyDP"
Date: Wed, 03 Jun 2009 12:47:48 +0300
Message-Id: <1244022468.20907.5.camel@jorg-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 03 Jun 2009 09:47:49.0047 (UTC) FILETIME=[5AD87C70:01C9E430]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XyVVsPNMlZ3R/AAyZyDP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 2009-04-10 at 18:39 +0200, ext Pierre Ossman wrote:
> On Tue, 31 Mar 2009 17:51:21 +0300
> Jorg Schummer <ext-jorg.2.schummer@nokia.com> wrote:
> 
> > With this patch, mmc_rescan can detect the removal of an mmc card and
> > the insertion of (possibly another) card in the same run. This means
> > that a card change can be detected without having to call
> > mmc_detect_change multiple times.
> > 
> > This change generalises the core such that it can be easily used by
> > hosts which provide a mechanism to detect only the presence of a card
> > reader cover, which has to be taken off in order to insert a card. Other
> > hosts ("card detect" or "MMC_CAP_NEEDS_POLL") each receive an event when
> > a card is removed and when a card is inserted, so it is sufficient for
> > them if mmc_rescan handles only one event at a time. "Cover detect"
> > hosts, however, only receive events about the cover status. This means
> > that between 2 subsequent events, both a card removal and a card
> > insertion can occur. In this case, the pre-patch version of mmc_rescan
> > would only detect the removal of the previous card but not the insertion
> > of the new card.
> > 
> > Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
> > ---
> 
> Queued, thanks.

Hi Pierre,

is there any news about this patch?

Regards,
Jörg


--=-XyVVsPNMlZ3R/AAyZyDP
Content-Disposition: attachment; filename=mmc_rescan.patch
Content-Type: message/rfc822; name=mmc_rescan.patch

From: ext-jorg.2.schummer@nokia.com
Subject: [PATCH 1/1] MMC: core/core.c: mmc_rescan detects card change in
	one run
Date: Wed, 03 Jun 2009 12:47:48 +0300
Message-Id: <1244022468.20907.6.camel@jorg-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

With this patch, mmc_rescan can detect the removal of an mmc card and
the insertion of (possibly another) card in the same run. This means
that a card change can be detected without having to call
mmc_detect_change multiple times.

This change generalises the core such that it can be easily used by
hosts which provide a mechanism to detect only the presence of a card
reader cover, which has to be taken off in order to insert a card. Other
hosts ("card detect" or "MMC_CAP_NEEDS_POLL") each receive an event when
a card is removed and when a card is inserted, so it is sufficient for
them if mmc_rescan handles only one event at a time. "Cover detect"
hosts, however, only receive events about the cover status. This means
that between 2 subsequent events, both a card removal and a card
insertion can occur. In this case, the pre-patch version of mmc_rescan
would only detect the removal of the previous card but not the insertion
of the new card.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 drivers/mmc/core/core.c |   99 ++++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 44 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df6ce4a..5970719 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -740,61 +740,72 @@ void mmc_rescan(struct work_struct *work)
 
 	mmc_bus_get(host);
 
-	if (host->bus_ops == NULL) {
-		/*
-		 * Only we can add a new handler, so it's safe to
-		 * release the lock here.
-		 */
+	/* if there is a card registered, check whether it is still present */
+	if ((host->bus_ops != NULL) && host->bus_ops->detect && !host->bus_dead)
+		host->bus_ops->detect(host);
+
+	mmc_bus_put(host);
+
+
+	mmc_bus_get(host);
+
+	/* if there still is a card present, stop here */
+	if (host->bus_ops != NULL) {
 		mmc_bus_put(host);
+		goto out;
+	}
 
-		if (host->ops->get_cd && host->ops->get_cd(host) == 0)
-			goto out;
+	/* detect a newly inserted card */
 
-		mmc_claim_host(host);
+	/*
+	 * Only we can add a new handler, so it's safe to
+	 * release the lock here.
+	 */
+	mmc_bus_put(host);
 
-		mmc_power_up(host);
-		mmc_go_idle(host);
+	if (host->ops->get_cd && host->ops->get_cd(host) == 0)
+		goto out;
 
-		mmc_send_if_cond(host, host->ocr_avail);
+	mmc_claim_host(host);
 
-		/*
-		 * First we search for SDIO...
-		 */
-		err = mmc_send_io_op_cond(host, 0, &ocr);
-		if (!err) {
-			if (mmc_attach_sdio(host, ocr))
-				mmc_power_off(host);
-			goto out;
-		}
+	mmc_power_up(host);
+	mmc_go_idle(host);
 
-		/*
-		 * ...then normal SD...
-		 */
-		err = mmc_send_app_op_cond(host, 0, &ocr);
-		if (!err) {
-			if (mmc_attach_sd(host, ocr))
-				mmc_power_off(host);
-			goto out;
-		}
+	mmc_send_if_cond(host, host->ocr_avail);
 
-		/*
-		 * ...and finally MMC.
-		 */
-		err = mmc_send_op_cond(host, 0, &ocr);
-		if (!err) {
-			if (mmc_attach_mmc(host, ocr))
-				mmc_power_off(host);
-			goto out;
-		}
+	/*
+	 * First we search for SDIO...
+	 */
+	err = mmc_send_io_op_cond(host, 0, &ocr);
+	if (!err) {
+		if (mmc_attach_sdio(host, ocr))
+			mmc_power_off(host);
+		goto out;
+	}
 
-		mmc_release_host(host);
-		mmc_power_off(host);
-	} else {
-		if (host->bus_ops->detect && !host->bus_dead)
-			host->bus_ops->detect(host);
+	/*
+	 * ...then normal SD...
+	 */
+	err = mmc_send_app_op_cond(host, 0, &ocr);
+	if (!err) {
+		if (mmc_attach_sd(host, ocr))
+			mmc_power_off(host);
+		goto out;
+	}
 
-		mmc_bus_put(host);
+	/*
+	 * ...and finally MMC.
+	 */
+	err = mmc_send_op_cond(host, 0, &ocr);
+	if (!err) {
+		if (mmc_attach_mmc(host, ocr))
+			mmc_power_off(host);
+		goto out;
 	}
+
+	mmc_release_host(host);
+	mmc_power_off(host);
+
 out:
 	if (host->caps & MMC_CAP_NEEDS_POLL)
 		mmc_schedule_delayed_work(&host->detect, HZ);
-- 
1.5.4.3


--=-XyVVsPNMlZ3R/AAyZyDP--

