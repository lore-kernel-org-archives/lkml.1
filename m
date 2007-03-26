Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbXCZSoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbXCZSoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbXCZSoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:44:11 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:42579 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbXCZSoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:44:10 -0400
Date: Mon, 26 Mar 2007 15:43:57 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070326154357.025e4faf@localhost>
In-Reply-To: <20070325072733.GA10257@cvg>
References: <20070325072733.GA10257@cvg>
Organization: Mandriva
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi Cyrill,

Em Sun, 25 Mar 2007 11:27:33 +0400
Cyrill Gorcunov <gorcunov@gmail.com> escreveu:

| This patch adds checking of driver registration status
| and if it fails release allocated resources.
| 
| Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| ---
| 
| Pete, please review the patch and Ack it then.
| 
|  drivers/usb/misc/ftdi-elan.c |   37 +++++++++++++++++++++++--------------
|  1 files changed, 23 insertions(+), 14 deletions(-)
| 
| diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
| index bc3327e..3cd9ae3 100644
| --- a/drivers/usb/misc/ftdi-elan.c
| +++ b/drivers/usb/misc/ftdi-elan.c
| @@ -2909,27 +2909,36 @@ static int __init ftdi_elan_init(void)
|          init_MUTEX(&ftdi_module_lock);
|          INIT_LIST_HEAD(&ftdi_static_list);
|          status_queue = create_singlethread_workqueue("ftdi-status-control");
| -	if (!status_queue)
| -		goto err1;
|          command_queue = create_singlethread_workqueue("ftdi-command-engine");
| -	if (!command_queue)
| -		goto err2;
|          respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
| -	if (!respond_queue)
| -		goto err3;
| +	if (!status_queue || !command_queue || !respond_queue) {
| +		printk(KERN_ERR "%s couldn't create workqueue\n",
| +		       ftdi_elan_driver.name);
| +		result = -ENOMEM;
| +		goto err;
| +	}

 The current version looks ok to me, why are you changing it?

 It's also smater, ie, if the first workqueue creation fails, it
won't try to create the others.

|          result = usb_register(&ftdi_elan_driver);
| -        if (result)
| +        if (result) {
|                  printk(KERN_ERR "usb_register failed. Error number %d\n",
|  		       result);
| +		goto err;
| +	}
|          return result;

 This could be:

"""
if (result) {
	printk(KERN_ERR "usb_register failed. Error number %d\n",
	    result);
	destroy_workqueue(respond_queue);
	goto err3;
}
"""

 And you can change 'err1' to return 'result'.

-- 
Luiz Fernando N. Capitulino
