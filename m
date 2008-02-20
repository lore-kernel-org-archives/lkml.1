Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbYBTUMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbYBTUMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764936AbYBTUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:10:54 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51279 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764630AbYBTUKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:10:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 20 Feb 2008 21:10:06 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix NULL pointer deref. and resource leak
To: linux1394-devel@lists.sourceforge.net
cc: Anders Blomdell <anders.blomdell@control.lth.se>,
       David Moore <dcm@MIT.EDU>, linux-kernel@vger.kernel.org
In-Reply-To: <47BC8302.6040200@s5r6.in-berlin.de>
Message-ID: <tkrat.85fe1bb47a570eb7@s5r6.in-berlin.de>
References: <47BB0F99.3080101@control.lth.se> 
 <1203446333.28871.8.camel@aries.csail.mit.edu> 
 <47BC48A1.2010105@control.lth.se> <47BC51C9.6000102@control.lth.se> 
 <1203524791.21593.31.camel@pisces.mit.edu> 
 <47BC5753.9000306@control.lth.se> <1203528165.21593.47.camel@pisces.mit.edu>
 <47BC6E15.9000001@control.lth.se> <47BC7210.7040300@control.lth.se>
 <47BC8302.6040200@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By supplying ioctl()s in the wrong order, a userspace client was able to
trigger NULL pointer dereferences.  Furthermore, by calling
ioctl_create_iso_context more than once, new contexts could be created
without ever freeing the previously created contexts.

Thanks to Anders Blomdell for the report.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -646,6 +646,10 @@ static int ioctl_create_iso_context(stru
 	struct fw_cdev_create_iso_context *request = buffer;
 	struct fw_iso_context *context;
 
+	/* We only support one context at this time. */
+	if (client->iso_context != NULL)
+		return -EBUSY;
+
 	if (request->channel > 63)
 		return -EINVAL;
 
@@ -792,8 +796,9 @@ static int ioctl_start_iso(struct client
 {
 	struct fw_cdev_start_iso *request = buffer;
 
-	if (request->handle != 0)
+	if (client->iso_context == NULL || request->handle != 0)
 		return -EINVAL;
+
 	if (client->iso_context->type == FW_ISO_CONTEXT_RECEIVE) {
 		if (request->tags == 0 || request->tags > 15)
 			return -EINVAL;
@@ -810,7 +815,7 @@ static int ioctl_stop_iso(struct client 
 {
 	struct fw_cdev_stop_iso *request = buffer;
 
-	if (request->handle != 0)
+	if (client->iso_context == NULL || request->handle != 0)
 		return -EINVAL;
 
 	return fw_iso_context_stop(client->iso_context);

-- 
Stefan Richter
-=====-==--- --=- =-=--
http://arcgraph.de/sr/

