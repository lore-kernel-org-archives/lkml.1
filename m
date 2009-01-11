Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZAKMp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZAKMp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 07:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZAKMpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 07:45:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42195 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbZAKMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 07:45:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 11 Jan 2009 13:44:46 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: cdev: simplify a schedule_delayed_work wrapper
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, David Moore <dcm@acm.org>
In-Reply-To: <4969CE1A.8010800@s5r6.in-berlin.de>
Message-ID: <tkrat.2ab2f7113c10a9d4@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
 <tkrat.f364570373ba8da5@s5r6.in-berlin.de>
 <1231643968.3538.59.camel@localhost.localdomain>
 <1231656885.3538.67.camel@localhost.localdomain>
 <4969CE1A.8010800@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel API documentation says that queue_delayed_work() returns 0
(only) if the work was already queued.  The return codes of
schedule_delayed_work() are not documented but the same.

In init_iso_resource(), the work has never been queued yet, hence we
can assume schedule_delayed_work() to be a guaranteed success there.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -129,7 +129,7 @@ struct iso_resource {
 	struct iso_resource_event *e_alloc, *e_dealloc;
 };
 
-static int schedule_iso_resource(struct iso_resource *);
+static void schedule_iso_resource(struct iso_resource *);
 static void release_iso_resource(struct client *, struct client_resource *);
 
 /*
@@ -1111,17 +1111,11 @@ static void iso_resource_work(struct wor
 	client_put(client);
 }
 
-static int schedule_iso_resource(struct iso_resource *r)
+static void schedule_iso_resource(struct iso_resource *r)
 {
-	int scheduled;
-
 	client_get(r->client);
-
-	scheduled = schedule_delayed_work(&r->work, 0);
-	if (!scheduled)
+	if (!schedule_delayed_work(&r->work, 0))
 		client_put(r->client);
-
-	return scheduled;
 }
 
 static void release_iso_resource(struct client *client,
@@ -1173,13 +1167,13 @@ static int init_iso_resource(struct clie
 	if (todo == ISO_RES_ALLOC) {
 		r->resource.release = release_iso_resource;
 		ret = add_client_resource(client, &r->resource, GFP_KERNEL);
+		if (ret < 0)
+			goto fail;
 	} else {
 		r->resource.release = NULL;
 		r->resource.handle = -1;
-		ret = schedule_iso_resource(r) ? 0 : -ENOMEM;
+		schedule_iso_resource(r);
 	}
-	if (ret < 0)
-		goto fail;
 	request->handle = r->resource.handle;
 
 	return 0;

-- 
Stefan Richter
-=====-==--= ---= -=-==
http://arcgraph.de/sr/

