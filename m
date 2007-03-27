Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbXC0Rx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbXC0Rx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbXC0Rx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:53:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934072AbXC0Rx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:53:57 -0400
Date: Tue, 27 Mar 2007 10:51:16 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       zaitcev@redhat.com
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-Id: <20070327105116.d3eea47a.zaitcev@redhat.com>
In-Reply-To: <20070327151405.GA11491@cvg>
References: <20070325072733.GA10257@cvg>
	<20070326151731.53cc080b.zaitcev@redhat.com>
	<20070327151405.GA11491@cvg>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 19:14:05 +0400, Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> --- a/drivers/usb/misc/ftdi-elan.c
> @@ -2903,7 +2903,7 @@ static struct usb_driver ftdi_elan_driver = {
>  };
>  static int __init ftdi_elan_init(void)
>  {
> -        int result;
> +        int result = 0;

Why do you need this?

> @@ -2918,18 +2918,25 @@ static int __init ftdi_elan_init(void)
>  	if (!respond_queue)
>  		goto err3;
>          result = usb_register(&ftdi_elan_driver);
> -        if (result)
> +        if (result) {
>                  printk(KERN_ERR "usb_register failed. Error number %d\n",
>  		       result);
> +		goto err4;
> +	}
>          return result;
>  
> + err4:
> +	destroy_workqueue(respond_queue);
>   err3:

This is fine, although I do wish you wouldn't number the exception labels.
If anything is changed, someone might try to rearrange and renumber them
and that leads to bugs.

>   err1:
> -	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
> -	return -ENOMEM;
> +	if (result == 0) {
> +		result = -ENOMEM;
> +		printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
> +	}
> +	return result;

What in the world is this supposed to do? Under what conditions can
result be zero here?

Personally, I would get rid of the printk. If your modprobe fails,
it's a good enough indication. Or at least, change the text to
something more neutral, like "unable to initialize (%d)" and print
the error code. It's not just about workqueues now.

-- Pete
