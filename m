Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbXG1WUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbXG1WUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbXG1WU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:20:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:52277 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbXG1WU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=J71znTD8jMlHo/6Cn5cA5Ae0/cU5FbrOg18UlfyJgGAWcyg+xElyZ1fix3+s5jLHdYdZtHJNTYObt6m7liDwSPakWPnB6U4PrnKCblB4UV727TNB8EsRxRX8nu5hiNrIgq6i7Gl5elX4gLVrhGVFN6G3jSbbENfpg2yfnOkclVA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Petko Manolov <petkan@users.sourceforge.net>
Subject: [PATCH] USB Pegasus driver - avoid a potential NULL pointer dereference.
Date: Sun, 29 Jul 2007 00:19:02 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707290019.02591.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch makes sure we don't dereference a NULL pointer in 
drivers/net/usb/pegasus.c::write_bulk_callback() in the initial 
struct net_device *net = pegasus->net; assignment.
The existing code checks if 'pegasus' is NULL and bails out if 
it is, so we better not touch that pointer until after that check.

Please consider merging.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/net/usb/pegasus.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index a05fd97..04cba6b 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -768,11 +768,13 @@ done:
 static void write_bulk_callback(struct urb *urb)
 {
 	pegasus_t *pegasus = urb->context;
-	struct net_device *net = pegasus->net;
+	struct net_device *net;
 
 	if (!pegasus)
 		return;
 
+	net = pegasus->net;
+
 	if (!netif_device_present(net) || !netif_running(net))
 		return;
 

