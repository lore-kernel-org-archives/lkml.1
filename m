Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYFIGjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYFIGjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYFIGjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:39:14 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:59478 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbYFIGjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:39:13 -0400
Date: Mon, 9 Jun 2008 08:39:11 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] au1xmmc: abort requests early if no card is present.
Message-ID: <20080609063911.GG8724@roarinelk.homelinux.net>
References: <20080609063521.GA8724@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609063521.GA8724@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a478fbe20735b832696ba4cc0d3d21eb7371e689 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Sun, 18 May 2008 15:52:43 +0200
Subject: [PATCH] au1xmmc: abort requests early if no card is present

Don't process an MMC request if no card is present.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index fcbaf40..718eb87 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -697,6 +697,13 @@ static void au1xmmc_request(struct mmc_host* mmc, struct mmc_request* mrq)
 	host->mrq = mrq;
 	host->status = HOST_S_CMD;
 
+	/* fail request immediately if no card is present */
+	if (0 == au1xmmc_card_inserted(host)) {
+		mrq->cmd->error = -ENOMEDIUM;
+		au1xmmc_finish_request(host);
+		return;
+	}
+
 	if (mrq->data) {
 		FLUSH_FIFO(host);
 		ret = au1xmmc_prepare_data(host, mrq->data);
-- 
1.5.5.3

