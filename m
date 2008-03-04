Return-Path: <linux-kernel-owner+w=401wt.eu-S1765212AbYCDQcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765212AbYCDQcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:32:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765436AbYCDQaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:35 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48596 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765027AbYCDQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:34 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 06/11] tifm: fix memorystick host initialization code
Date: Wed,  5 Mar 2008 03:02:23 +1100
Message-Id: <1204646548-27466-7-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-5-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Instead of assuming that host is powered on only once at card insertion,
allow for the possibility that memstick layer may need to cycle card's
power to get it out from some unhealthy states.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/host/tifm_ms.c |   40 ++++++++++++++------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/memstick/host/tifm_ms.c b/drivers/memstick/host/tifm_ms.c
index b88f5b3..2b5bf52 100644
--- a/drivers/memstick/host/tifm_ms.c
+++ b/drivers/memstick/host/tifm_ms.c
@@ -496,7 +496,18 @@ static void tifm_ms_set_param(struct memstick_host *msh,
 
 	switch (param) {
 	case MEMSTICK_POWER:
-		/* this is set by card detection mechanism */
+		/* also affected by media detection mechanism */
+		if (value == MEMSTICK_POWER_ON) {
+			host->mode_mask = TIFM_MS_SYS_SRAC | TIFM_MS_SYS_REI;
+			writel(TIFM_MS_SYS_RESET, sock->addr + SOCK_MS_SYSTEM);
+			writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
+			       sock->addr + SOCK_MS_SYSTEM);
+			writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
+		} else if (value == MEMSTICK_POWER_OFF) {
+			writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
+			       sock->addr + SOCK_MS_SYSTEM);
+			writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
+		}
 		break;
 	case MEMSTICK_INTERFACE:
 		if (value == MEMSTICK_SERIAL) {
@@ -531,22 +542,6 @@ static void tifm_ms_abort(unsigned long data)
 	tifm_eject(host->dev);
 }
 
-static int tifm_ms_initialize_host(struct tifm_ms *host)
-{
-	struct tifm_dev *sock = host->dev;
-	struct memstick_host *msh = tifm_get_drvdata(sock);
-
-	host->mode_mask = TIFM_MS_SYS_SRAC | TIFM_MS_SYS_REI;
-	writel(TIFM_MS_SYS_RESET, sock->addr + SOCK_MS_SYSTEM);
-	writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
-	       sock->addr + SOCK_MS_SYSTEM);
-	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
-	if (tifm_has_ms_pif(sock))
-		msh->caps |= MEMSTICK_CAP_PAR4;
-
-	return 0;
-}
-
 static int tifm_ms_probe(struct tifm_dev *sock)
 {
 	struct memstick_host *msh;
@@ -575,10 +570,10 @@ static int tifm_ms_probe(struct tifm_dev *sock)
 	msh->set_param = tifm_ms_set_param;
 	sock->card_event = tifm_ms_card_event;
 	sock->data_event = tifm_ms_data_event;
-	rc = tifm_ms_initialize_host(host);
+	if (tifm_has_ms_pif(sock))
+		msh->caps |= MEMSTICK_CAP_PAR4;
 
-	if (!rc)
-		rc = memstick_add_host(msh);
+	rc = memstick_add_host(msh);
 	if (!rc)
 		return 0;
 
@@ -616,11 +611,6 @@ static void tifm_ms_remove(struct tifm_dev *sock)
 	spin_unlock_irqrestore(&sock->lock, flags);
 
 	memstick_remove_host(msh);
-
-	writel(TIFM_MS_SYS_FCLR | TIFM_MS_SYS_INTCLR,
-	       sock->addr + SOCK_MS_SYSTEM);
-	writel(0xffffffff, sock->addr + SOCK_MS_STATUS);
-
 	memstick_free_host(msh);
 }
 
-- 
1.5.3.6

