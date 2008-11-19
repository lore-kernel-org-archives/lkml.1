Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYKSTAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYKSTAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYKSTAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:00:33 -0500
Received: from relay.2ka.mipt.ru ([194.85.80.65]:39791 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYKSTAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:00:32 -0500
Date: Wed, 19 Nov 2008 21:56:36 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Stanley.Miao" <stanley.miao@windriver.com>
Subject: [PATCH] W1 OMAP: Fix OMAP LDP boot crash.
Message-ID: <20081119185634.GB9183@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Stanley.Miao" <stanley.miao@windriver.com>

OMAP LDP boot crash. This is because w1 subsystem changed the search interface,
so update omap_hdq's search interface to follow the change.

Signed-off-by: Stanley.Miao <stanley.miao@windriver.com>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/omap_hdq.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index e7fa6ab..b8d0f8b 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -89,8 +89,8 @@ static struct platform_driver omap_hdq_driver = {
 static u8 omap_w1_read_byte(void *_hdq);
 static void omap_w1_write_byte(void *_hdq, u8 byte);
 static u8 omap_w1_reset_bus(void *_hdq);
-static void omap_w1_search_bus(void *_hdq, u8 search_type,
-	w1_slave_found_callback slave_found);
+static void omap_w1_search_bus(void *_hdq, struct w1_master *master_dev,
+		u8 search_type,	w1_slave_found_callback slave_found);
 
 
 static struct w1_bus_master omap_w1_master = {
@@ -237,8 +237,8 @@ static u8 omap_w1_reset_bus(void *_hdq)
 }
 
 /* W1 search callback function */
-static void omap_w1_search_bus(void *_hdq, u8 search_type,
-	w1_slave_found_callback slave_found)
+static void omap_w1_search_bus(void *_hdq, struct w1_master *master_dev,
+		u8 search_type, w1_slave_found_callback slave_found)
 {
 	u64 module_id, rn_le, cs, id;
 
@@ -255,7 +255,7 @@ static void omap_w1_search_bus(void *_hdq, u8 search_type,
 	cs = w1_calc_crc8((u8 *)&rn_le, 7);
 	id = (cs << 56) | module_id;
 
-	slave_found(_hdq, id);
+	slave_found(master_dev, id);
 }
 
 static int _omap_hdq_reset(struct hdq_data *hdq_data)

-- 
	Evgeniy Polyakov
