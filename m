Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZJFPRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZJFPRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbZJFPRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:17:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35838 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757589AbZJFPRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:17:36 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/5] opticon: Fix resume logic
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Date: Tue, 06 Oct 2009 16:06:57 +0100
Message-ID: <20091006150651.9431.16939.stgit@localhost.localdomain>
In-Reply-To: <20091006145413.9431.47083.stgit@localhost.localdomain>
References: <20091006145413.9431.47083.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opticon now takes the right mutex to check the port status but the status
check is done wrongly for the modern serial code, so fix it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/opticon.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index c3a9ce2..4ff9e7a 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -499,7 +499,8 @@ static int opticon_resume(struct usb_interface *intf)
 	int result;
 
 	mutex_lock(&port->port.mutex);
-	if (port->port.count)
+	/* This is protected by the port mutex against close/open */
+	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);
 	else
 		result = 0;

