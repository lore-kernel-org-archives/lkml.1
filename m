Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZHUNky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZHUNky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbZHUNky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204AbZHUNkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:40:53 -0400
Date: Fri, 21 Aug 2009 15:44:07 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] xenfb: connect to backend before registering fb
Message-ID: <20090821154407.6337421b@leela>
In-Reply-To: <20090821151352.1676de18@leela>
References: <20090821124059.17ab93fa@leela>
	<20090821150922.72e12d9a@leela>
	<20090821151352.1676de18@leela>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As soon as the framebuffer is registered, our methods may be called by the
kernel. This leads to a crash as xenfb_refresh() gets called before we have
the irq.

Connect to the backend before registering our framebuffer with the kernel.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

--
Index: linux-git/drivers/video/xen-fbfront.c
===================================================================
--- linux-git.orig/drivers/video/xen-fbfront.c
+++ linux-git/drivers/video/xen-fbfront.c
@@ -454,6 +454,10 @@ static int __devinit xenfb_probe(struct 
 
 	xenfb_init_shared_page(info, fb_info);
 
+	ret = xenfb_connect_backend(dev, info);
+	if (ret < 0)
+		goto error;
+
 	ret = register_framebuffer(fb_info);
 	if (ret) {
 		fb_deferred_io_cleanup(fb_info);
@@ -464,10 +468,6 @@ static int __devinit xenfb_probe(struct 
 	}
 	info->fb_info = fb_info;
 
-	ret = xenfb_connect_backend(dev, info);
-	if (ret < 0)
-		goto error;
-
 	xenfb_make_preferred_console();
 	return 0;
 
