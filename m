Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZLZAeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZLZAeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZLZAef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:34:35 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53601 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZLZAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:34:34 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:34:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/5] firewire: cdev: fix another memory leak in an error path
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Clemens Ladisch <cladisch@fastmail.net>
In-Reply-To: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
Message-ID: <tkrat.22fe3865dde96d48@s5r6.in-berlin.de>
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If copy_from_user in an FW_CDEV_IOC_SEND_RESPONSE ioctl failed, the
fw_request pointed to by the inbound_transaction_resource is no
longer referenced and needs to be freed.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.33-rc2/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.33-rc2/drivers/firewire/core-cdev.c
@@ -723,6 +723,7 @@ static int ioctl_send_response(struct cl
 		if (copy_from_user(r->data, u64_to_uptr(request->data),
 				   r->length)) {
 			ret = -EFAULT;
+			kfree(r->request);
 			goto out;
 		}
 		fw_send_response(client->device->card, r->request,

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

