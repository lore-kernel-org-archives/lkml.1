Return-Path: <linux-kernel-owner+w=401wt.eu-S934547AbZLKX3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547AbZLKX3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934464AbZLKX3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:33 -0500
Received: from kroah.org ([198.145.64.141]:50464 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933876AbZLKX3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:01 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/58] opticon: Fix resume logic
Date: Fri, 11 Dec 2009 15:28:01 -0800
Message-Id: <1260574122-10676-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Opticon now takes the right mutex to check the port status but the status
check is done wrongly for the modern serial code, so fix it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/serial/opticon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index c03fdc0..4cdb975 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -502,7 +502,8 @@ static int opticon_resume(struct usb_interface *intf)
 	int result;
 
 	mutex_lock(&port->port.mutex);
-	if (port->port.count)
+	/* This is protected by the port mutex against close/open */
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);
 	else
 		result = 0;
-- 
1.6.5.5

