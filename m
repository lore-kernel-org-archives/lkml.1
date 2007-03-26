Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbXCZT4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbXCZT4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbXCZT4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:56:46 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:51631 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbXCZT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:56:45 -0400
Date: Mon, 26 Mar 2007 16:56:30 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070326165630.34cb09af@localhost>
In-Reply-To: <20070326193312.GA10296@cvg>
References: <20070325072733.GA10257@cvg>
	<20070326154357.025e4faf@localhost>
	<20070326193312.GA10296@cvg>
Organization: Mandriva
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 26 Mar 2007 23:33:12 +0400
Cyrill Gorcunov <gorcunov@gmail.com> escreveu:

| if usb registration failed we should release all worqueues we've
| created and that is the reason why I've changed the code...

 I see, maybe something like the following (not tested):

diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index bc3327e..cf95ae8 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -2903,7 +2903,8 @@ static struct usb_driver ftdi_elan_drive
 };
 static int __init ftdi_elan_init(void)
 {
-        int result;
+        int result = -ENOMEM;
+
         printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
 	       __TIME__, __DATE__);
         init_MUTEX(&ftdi_module_lock);
@@ -2918,9 +2919,13 @@ static int __init ftdi_elan_init(void)
 	if (!respond_queue)
 		goto err3;
         result = usb_register(&ftdi_elan_driver);
-        if (result)
+        if (result) {
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
 		       result);
+		destroy_workqueue(respond_queue);
+		goto err3;
+	}
+
         return result;
 
  err3:
@@ -2929,7 +2934,7 @@ static int __init ftdi_elan_init(void)
 	destroy_workqueue(status_queue);
  err1:
 	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
-	return -ENOMEM;
+	return result;
 }
 
 static void __exit ftdi_elan_exit(void)

PS: Please, don't remove people from the CC list (wait for them
to ask for that).

-- 
Luiz Fernando N. Capitulino
