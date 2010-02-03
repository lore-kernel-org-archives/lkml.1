Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab0BCKiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:38:06 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24190 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0BCKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:38:03 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 03 Feb 2010 11:37:17 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: g_mass_storage: min(...) warning fixed
In-reply-to: <20100203165726.e258ad58.sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1265193437-25663-1-git-send-email-m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.6.5
References: <20100203165726.e258ad58.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <m.nazarewicz@samsung.com>

This patch fixes warning caused by calling min() macro
with arguments of different types:

  drivers/usb/gadget/f_mass_storage.c:623: warning: \
  comparison of distinct pointer types lacks a cast

This fixes commit a736e2758c6390b854219e6f6bb4f9a0e3be66df.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Hello,

On Wed, 03 Feb 2010 06:57:26 +0100, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> today's linux-next build produced these warnings:
> 
> drivers/usb/gadget/f_mass_storage.c: In function 'fsg_setup':
> drivers/usb/gadget/f_mass_storage.c:623: warning: comparison of distinct pointer types lacks a cast
> 
> Introduced by commit a736e2758c6390b854219e6f6bb4f9a0e3be66df ("USB:
> g_mass_storage: superfluous and missing packets fixed").

Sorry about that.  Attached is patch fixing that.  I've overlooked the
fact that w_length is u16 not int.

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b5a8902..b5cad39 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -620,7 +620,7 @@ static int fsg_setup(struct usb_function *f,
 		*(u8 *) req->buf = fsg->common->nluns - 1;
 
 		/* Respond with data/status */
-		req->length = min(1, w_length);
+		req->length = min((u16)1, w_length);
 		fsg->common->ep0req_name =
 			ctrl->bRequestType & USB_DIR_IN ? "ep0-in" : "ep0-out";
 		return ep0_queue(fsg->common);
-- 
1.6.5

