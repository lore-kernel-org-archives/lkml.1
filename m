Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbXCZThN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbXCZThN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 15:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXCZThM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 15:37:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:30873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbXCZThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 15:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WYO3u7/2X/59Acb/epW8Hyy28/DcQbmG10DHVCUTVM07NeVHATOLlFb/Pk4Z7KRZn1NpierZsFvf4Slt/nEMRJmw6uEeKmv0YmjEPDEewh8+V2FYIjOIBRfP7GTxqO5eMHpgqoMe2GJJj7QPYBzU7WGUpJPTQgfu9pjuAGIX6Bc=
Date: Mon, 26 Mar 2007 23:33:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070326193312.GA10296@cvg>
References: <20070325072733.GA10257@cvg> <20070326154357.025e4faf@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326154357.025e4faf@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Luiz Fernando N. Capitulino - Mon, Mar 26, 2007 at 03:43:57PM -0300]
| 
|  Hi Cyrill,
| 
| Em Sun, 25 Mar 2007 11:27:33 +0400
| Cyrill Gorcunov <gorcunov@gmail.com> escreveu:
| 
| | This patch adds checking of driver registration status
| | and if it fails release allocated resources.
| | 
| | Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| | 
| | ---
| | 
| | Pete, please review the patch and Ack it then.
| | 
| |  drivers/usb/misc/ftdi-elan.c |   37 +++++++++++++++++++++++--------------
| |  1 files changed, 23 insertions(+), 14 deletions(-)
| | 
| | diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
| | index bc3327e..3cd9ae3 100644
| | --- a/drivers/usb/misc/ftdi-elan.c
| | +++ b/drivers/usb/misc/ftdi-elan.c
| | @@ -2909,27 +2909,36 @@ static int __init ftdi_elan_init(void)
| |          init_MUTEX(&ftdi_module_lock);
| |          INIT_LIST_HEAD(&ftdi_static_list);
| |          status_queue = create_singlethread_workqueue("ftdi-status-control");
| | -	if (!status_queue)
| | -		goto err1;
| |          command_queue = create_singlethread_workqueue("ftdi-command-engine");
| | -	if (!command_queue)
| | -		goto err2;
| |          respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
| | -	if (!respond_queue)
| | -		goto err3;
| | +	if (!status_queue || !command_queue || !respond_queue) {
| | +		printk(KERN_ERR "%s couldn't create workqueue\n",
| | +		       ftdi_elan_driver.name);
| | +		result = -ENOMEM;
| | +		goto err;
| | +	}
| 
|  The current version looks ok to me, why are you changing it?
| 
|  It's also smater, ie, if the first workqueue creation fails, it
| won't try to create the others.
| 
| |          result = usb_register(&ftdi_elan_driver);
| | -        if (result)
| | +        if (result) {
| |                  printk(KERN_ERR "usb_register failed. Error number %d\n",
| |  		       result);
| | +		goto err;
| | +	}
| |          return result;
| 
|  This could be:
| 
| """
| if (result) {
| 	printk(KERN_ERR "usb_register failed. Error number %d\n",
| 	    result);
| 	destroy_workqueue(respond_queue);
| 	goto err3;
| }
| """
| 
|  And you can change 'err1' to return 'result'.
| 
| -- 
| Luiz Fernando N. Capitulino
| 

Hi Luiz,

if usb registration failed we should release all worqueues we've
created and that is the reason why I've changed the code...

but anyway I have to find more elegant solution I think :)

		Cyrill

