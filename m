Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZALG5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZALG5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZALG4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:56:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:5170 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZALG4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:56:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,251,1231142400"; 
   d="scan'208";a="480829204"
Subject: [PATCH 2/3]async serio shutdown
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:56:43 +0800
Message-Id: <1231743403.5867.51.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serio shutdown is quite slow. It sometimes will take 0.2s for each port.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/input/serio/serio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/input/serio/serio.c
===================================================================
--- linux.orig/drivers/input/serio/serio.c	2009-01-12 14:38:06.000000000 +0800
+++ linux/drivers/input/serio/serio.c	2009-01-12 14:41:24.000000000 +0800
@@ -36,6 +36,7 @@
 #include <linux/kthread.h>
 #include <linux/mutex.h>
 #include <linux/freezer.h>
+#include <linux/async.h>
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Serio abstraction core");
@@ -798,11 +799,17 @@ static void serio_cleanup(struct serio *
 	mutex_unlock(&serio->drv_mutex);
 }
 
+static void serio_async_shutdown(void *data, async_cookie_t cookie)
+{
+	struct serio *serio = data;
+	serio_cleanup(serio);
+}
+
 static void serio_shutdown(struct device *dev)
 {
 	struct serio *serio = to_serio_port(dev);
 
-	serio_cleanup(serio);
+	async_schedule(serio_async_shutdown, serio);
 }
 
 static void serio_attach_driver(struct serio_driver *drv)


