Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbXC0R3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbXC0R3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934017AbXC0R3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:29:15 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:38083 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934013AbXC0R3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:29:14 -0400
Date: Tue, 27 Mar 2007 14:29:04 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       linux-kernel-list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070327142904.74af2456@localhost>
In-Reply-To: <20070327170125.GA11753@cvg>
References: <20070325072733.GA10257@cvg>
	<20070326151731.53cc080b.zaitcev@redhat.com>
	<20070327151405.GA11491@cvg>
	<20070327132839.71169aed@localhost>
	<20070327170125.GA11753@cvg>
Organization: Mandriva
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 27 Mar 2007 21:01:25 +0400
Cyrill Gorcunov <gorcunov@gmail.com> escreveu:

| [Luiz Fernando N. Capitulino - Tue, Mar 27, 2007 at 01:28:39PM -0300]
| | Em Tue, 27 Mar 2007 19:14:05 +0400
| | Cyrill Gorcunov <gorcunov@gmail.com> escreveu:
| | 
| | | Pete, Luiz
| | | 
| | | what about this one?
| | | 
| | | Actually there is just a check for where is error coming from.
| | | Maybe that is not the best solution but it allows us to reduce
| | | the calls to 'printk' :)
| | | 
| | | P.S. Pete your patch is good but the message about
| | | worqueue creation fail was to print even if we've
| | | been faltered on the usb_register procedure.
| | | 
| | | ---
| | | 
| | |  drivers/usb/misc/ftdi-elan.c |   15 +++++++++++----
| | |  1 files changed, 11 insertions(+), 4 deletions(-)
| | | 
| | | diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
| | | index bc3327e..3cd54af 100644
| | | --- a/drivers/usb/misc/ftdi-elan.c
| | | +++ b/drivers/usb/misc/ftdi-elan.c
| | | @@ -2903,7 +2903,7 @@ static struct usb_driver ftdi_elan_driver = {
| | |  };
| | |  static int __init ftdi_elan_init(void)
| | |  {
| | | -        int result;
| | | +        int result = 0;
| | |          printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
| | |  	       __TIME__, __DATE__);
| | |          init_MUTEX(&ftdi_module_lock);
| | | @@ -2918,18 +2918,25 @@ static int __init ftdi_elan_init(void)
| | |  	if (!respond_queue)
| | |  		goto err3;
| | |          result = usb_register(&ftdi_elan_driver);
| | | -        if (result)
| | | +        if (result) {
| | |                  printk(KERN_ERR "usb_register failed. Error number %d\n",
| | |  		       result);
| | | +		goto err4;
| | | +	}
| | |          return result;
| | |  
| | | + err4:
| | | +	destroy_workqueue(respond_queue);
| | |   err3:
| | |  	destroy_workqueue(command_queue);
| | |   err2:
| | |  	destroy_workqueue(status_queue);
| | |   err1:
| | | -	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
| | | -	return -ENOMEM;
| | | +	if (result == 0) {
| | | +		result = -ENOMEM;
| | | +		printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
| | | +	}
| | | +	return result;
| | |  }
| | 
| |  I still the prefer the version I sent you yesterday. :) It
| | changes the minimal amount of code.
| | 
| | -- 
| | Luiz Fernando N. Capitulino
| | 
| 
| Liuz,
| 
| but the patch you sent me does call
| 
| 	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
| 
| even if error occured in usb_register and that is not good I think.
| Fix me if I'm wrong.

 No, you're right. I missed it.

 Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

 But Greg is the right person to submit this.

-- 
Luiz Fernando N. Capitulino
