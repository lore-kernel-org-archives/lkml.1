Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYESII3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYESII3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbYESIII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:08:08 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:40572 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232AbYESIIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:08:06 -0400
Date: Mon, 19 May 2008 10:08:04 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org, drzeus@drzeus.cx,
       sshtylyov@ru.mvista.com
Subject: [PATCH 8/9] au1xmmc: abort requests early if no card is present
Message-ID: <20080519080804.GI21985@roarinelk.homelinux.net>
References: <20080519080339.GA21985@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519080339.GA21985@roarinelk.homelinux.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ec41439903048bf98e301dbd03426c63156ebc0e Mon Sep 17 00:00:00 2001
From: Manuel Lauss <mlau@msc-ge.com>
Date: Sun, 18 May 2008 15:52:43 +0200
Subject: [PATCH] au1xmmc: abort requests early if no card is present

Don't process a request if no card is present.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
---
 drivers/mmc/host/au1xmmc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index be09a14..0b30582 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -689,6 +689,13 @@ static void au1xmmc_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	host->mrq = mrq;
 	host->status = HOST_S_CMD;
 
+	/* fail request immediately if no card is present */
+	if (0 == au1xmmc_card_inserted(host)) {
+		mrq->cmd->error = -ETIMEDOUT;
+		au1xmmc_finish_request(host);
+		return;
+	}
+
 	if (mrq->data) {
 		FLUSH_FIFO(host);
 		ret = au1xmmc_prepare_data(host, mrq->data);
-- 
1.5.5.1

