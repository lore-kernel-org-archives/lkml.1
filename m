Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXC1TSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXC1TSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXC1TSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:18:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:29120 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbXC1TSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qDEUbhQe1OURWlkOawf7OrffvKgoIyZVGFev+J0HI75XFCIsMd++Jd0T/PpvdnaCrQymKuPLgFKlVLDdz1u2Ix+zwZw5yYxVGnKvgZTLCQbo4w67/Nq6tXJJrq1zjasnCSNwpqON9IufvBudvsBBK7rAee9nQURWbLWTTnoWv+8=
Date: Wed, 28 Mar 2007 23:14:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] USB Elan FTDI: check for driver registration status v2
Message-ID: <20070328191428.GB10233@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking of driver registration status
and release allocated resources if it failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

Pete, Ack it please

 drivers/usb/misc/ftdi-elan.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index bc3327e..d9cbdb8 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2910,24 +2910,28 @@ static int __init ftdi_elan_init(void)
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
 	if (!status_queue)
-		goto err1;
+		goto err_status_queue;
         command_queue = create_singlethread_workqueue("ftdi-command-engine");
 	if (!command_queue)
-		goto err2;
+		goto err_command_queue;
         respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
 	if (!respond_queue)
-		goto err3;
+		goto err_respond_queue;
         result = usb_register(&ftdi_elan_driver);
-        if (result)
+        if (result) {
+		destroy_workqueue(status_queue);
+		destroy_workqueue(command_queue);
+		destroy_workqueue(respond_queue);
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
 		       result);
+	}
         return result;
 
- err3:
+ err_respond_queue:
 	destroy_workqueue(command_queue);
- err2:
+ err_command_queue:
 	destroy_workqueue(status_queue);
- err1:
+ err_status_queue:
 	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
 	return -ENOMEM;
 }
