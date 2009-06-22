Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823AbZFVQpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbZFVQpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZFVQob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37499 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756231AbZFVQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:30 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/15] ppp: Fix throttling bugs
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:29 +0100
Message-ID: <20090622174228.25341.88309.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The ppp layer goes around calling the unthrottle method from non sleeping
paths. This isn't safe because the unthrottle methods in the tty layer need
to be able to sleep (consider a USB dongle).

Until now this didn't show up because the ppp layer never actually throttled
a port so the unthrottle was always a no-op. Currently it's a mutex taking
path so warnings are spewed if the unthrottle occurs via certain paths.

Fix this by removing the unneccessary unthrottle calls.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/ppp_async.c   |    1 -
 drivers/net/ppp_synctty.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index 6de8399..17c116b 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -356,7 +356,6 @@ ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	ap_put(ap);
-	tty_unthrottle(tty);
 }
 
 static void
diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index d2fa2db..aa3d39f 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -397,7 +397,6 @@ ppp_sync_receive(struct tty_struct *tty, const unsigned char *buf,
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	sp_put(ap);
-	tty_unthrottle(tty);
 }
 
 static void

