Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZG1Pwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZG1Pwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbZG1Pwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:52:39 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54467 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZG1Pwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:52:38 -0400
Date: Tue, 28 Jul 2009 17:52:36 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/9] drivers/misc/c2port: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281752170.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

c2port_device_register returns an ERR_PTR value in an error case instead of
NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = eventfd_fget(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/misc/c2port/c2port-duramar2150.c       |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/c2port/c2port-duramar2150.c b/drivers/misc/c2port/c2port-duramar2150.c
index 338dcc1..585786b 100644
--- a/drivers/misc/c2port/c2port-duramar2150.c
+++ b/drivers/misc/c2port/c2port-duramar2150.c
@@ -128,7 +128,7 @@ static int __init duramar2150_c2port_init(void)
 
 	duramar2150_c2port_dev = c2port_device_register("uc",
 					&duramar2150_c2port_ops, NULL);
-	if (!duramar2150_c2port_dev) {
+	if (IS_ERR(duramar2150_c2port_dev)) {
 		ret = -ENODEV;
 		goto free_region;
 	}
