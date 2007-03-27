Return-Path: <linux-kernel-owner+w=401wt.eu-S934146AbXC0SUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146AbXC0SUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934148AbXC0SUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:20:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:24503 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146AbXC0SUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=X5MY/Cykbw3xLD7lMKlNDtWXdIAsR+Qw24Vf47Uaro2RqwrZlbNFSWh69+4ht+2ScLFr2NFHU5lE12kk8uI7SdniP7aYEkgSENJAtPka9Kvu98W44GsJILYJbDpnvaooTNnIadtT0uAzzxxgJgYlxDhegVDFy8jH9sMmG2CwLA4=
Date: Tue, 27 Mar 2007 22:16:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: [PATCH] USB Elan FTDI: check for driver registration status
Message-ID: <20070327181608.GC11753@cvg>
References: <20070325072733.GA10257@cvg> <20070326151731.53cc080b.zaitcev@redhat.com> <20070327151405.GA11491@cvg> <20070327105116.d3eea47a.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327105116.d3eea47a.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Pete Zaitcev - Tue, Mar 27, 2007 at 10:51:16AM -0700]
| On Tue, 27 Mar 2007 19:14:05 +0400, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > --- a/drivers/usb/misc/ftdi-elan.c
| > @@ -2903,7 +2903,7 @@ static struct usb_driver ftdi_elan_driver = {
| >  };
| >  static int __init ftdi_elan_init(void)
| >  {
| > -        int result;
| > +        int result = 0;
| 
| Why do you need this?

Setting result to 0 indicate that there is no errors. Pete, look
this init code does the following - 

	1) creates 3 workqueues
	2) register usb driver

So we have:
	- at each step of creating worqueue we have to check if it was
	  succsessfull
	- if all workqeues were successfully created we need to check if
	  usb registration failed

So we can get error on any step and there is a question how to properly
and eleganly handle them... the solution I proposed maybe is not ideal
but you may help me supposing your own patch :)

And as result I set 'results=0' to prevent from printing message about
worqueue fails if the error _really_ occured in usb_register. Just
review the function at whole and you will find the reason.

| > @@ -2918,18 +2918,25 @@ static int __init ftdi_elan_init(void)
| >  	if (!respond_queue)
| >  		goto err3;
| >          result = usb_register(&ftdi_elan_driver);
| > -        if (result)
| > +        if (result) {
| >                  printk(KERN_ERR "usb_register failed. Error number %d\n",
| >  		       result);
| > +		goto err4;
| > +	}
| >          return result;
| >  
| > + err4:
| > +	destroy_workqueue(respond_queue);
| >   err3:
| 
| This is fine, although I do wish you wouldn't number the exception labels.
| If anything is changed, someone might try to rearrange and renumber them
| and that leads to bugs.

Agree, may be the labels could be like:

	err_respond_queue:

and so on?

| 
| >   err1:
| > -	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
| > -	return -ENOMEM;
| > +	if (result == 0) {
| > +		result = -ENOMEM;
| > +		printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
| > +	}
| > +	return result;
| 
| What in the world is this supposed to do? Under what conditions can
| result be zero here?

If error was in worqueue creation then there will be 0.

| 
| Personally, I would get rid of the printk. If your modprobe fails,
| it's a good enough indication. Or at least, change the text to
| something more neutral, like "unable to initialize (%d)" and print
| the error code. It's not just about workqueues now.
| 
| -- Pete
| 

Can't agree... if modprobe failed I wonna know _where_ it happens and
why :) Or maybe I misunderstood you...

		Cyrill

