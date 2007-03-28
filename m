Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbXC1QE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbXC1QE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbXC1QE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:04:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:13972 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbXC1QE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BJY7GG94CKqCy+THBr7C6CahWwFN4UaivvEl1GXmC7uSF42Uir7Tl7hl4iadI/9yLrqeaxeyjWjuxgoX1ySR1paAekQvzR9ATi5O+rQO+ZIf0vx8+5NDSP3id/gHsPI89BD8bYbStHdh8Mv6fLO+BpmjEJq4L1Jyfs4Ibf9Tey0=
Date: Wed, 28 Mar 2007 20:00:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070328160032.GA10233@cvg>
References: <20070325072733.GA10257@cvg> <20070326154357.025e4faf@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326154357.025e4faf@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete, Luiz

check this one please.

I've inspected ftdi-elan.c for style and as result
the solution I propose is just to add explicit
destroying of worqueues if usb_register failed.

And Pete, take a look - whoa! - I've renamed error labels :)


		Cyrill

---

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
