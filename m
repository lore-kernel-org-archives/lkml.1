Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZE1Kxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZE1Kxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZE1Kx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:53:27 -0400
Received: from mx1.emlix.com ([193.175.82.87]:38579 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZE1Kx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:53:26 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [PATCH] g_serial: append zlp when tx buffer becomes empty
Date: Thu, 28 May 2009 12:53:24 +0200
Message-Id: <1243508004-17898-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some usb serial host drivers expect a short packet before they forward
the data to the application. This is caused by them trying to read more
than one packet at a time. So when the gadget sends an exact multiple
of the maximum packet size, it should append a zero-length packet.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/usb/gadget/u_serial.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 3df70e5..f121030 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -372,6 +372,7 @@ __acquires(&port->port_lock)
 
 		req->length = len;
 		list_del(&req->list);
+		req->zero = (gs_buf_data_avail(&port->port_write_buf) == 0);
 
 		pr_vdebug(PREFIX "%d: tx len=%d, 0x%02x 0x%02x 0x%02x ...\n",
 				port->port_num, len, *((u8 *)req->buf),
-- 
1.6.1.3

