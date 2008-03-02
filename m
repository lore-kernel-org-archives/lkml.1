Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbYCBVJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbYCBVJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYCBVJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:09:26 -0500
Received: from orion.ambsoft.pl ([212.109.144.130]:41840 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbYCBVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:09:25 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: problem with starting 2.6.25-rc1 and latest git
Date: Sun, 2 Mar 2008 22:09:21 +0100
User-Agent: KMail/1.9.7
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200802132316.03155.m.kozlowski@tuxland.pl> <200802261704.46848.m.kozlowski@tuxland.pl> <20080226230532.76f63db3@hyperion.delvare>
In-Reply-To: <20080226230532.76f63db3@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803022209.22227.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

> On Tue, 26 Feb 2008 17:04:46 +0100, Mariusz Kozlowski wrote:
> > I can reproduce this here on rc3 as well. Weird - on git tree before
> > rc3 was released this didn't happen. rc2 and rc1 are broken. I also
> > don't know why nobody else see this but us :) And not sure how
> > to debug it some more or provide more accurate information.
> 
> Here's a quick and dirty debugging patch I wrote in an attempt to find
> out what was going on. Unfortunately, the problem never happened to me
> when this debug patch was applied. Maybe you'll have more "luck"?

Sorry for the late response. I tried your patch and it seems we share this 'luck'.
I couldn't reproduce that. I have a few other ideas to try. I'll see what I can do. 
Unfortunately my time got limited recently so I'm lagging behind LKML and
kernel stuff :-/

	Mariusz

>  kernel/module.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- linux-2.6.25-rc1.orig/kernel/module.c	2008-02-14 09:16:15.000000000 +0100
> +++ linux-2.6.25-rc1/kernel/module.c	2008-02-14 23:20:22.000000000 +0100
> @@ -2153,8 +2153,10 @@ sys_init_module(void __user *umod,
>  		return PTR_ERR(mod);
>  	}
>  
> +	printk(KERN_WARNING "loading module %s, checkpoint 1\n", mod->name);
>  	/* Drop lock so they can recurse */
>  	mutex_unlock(&module_mutex);
> +	printk(KERN_WARNING "loading module %s, checkpoint 2\n", mod->name);
>  
>  	blocking_notifier_call_chain(&module_notify_list,
>  			MODULE_STATE_COMING, mod);
> @@ -2177,6 +2179,7 @@ sys_init_module(void __user *umod,
>  
>  	/* Now it's a first class citizen! */
>  	mutex_lock(&module_mutex);
> +	printk(KERN_WARNING "loading module %s, checkpoint 3\n", mod->name);
>  	mod->state = MODULE_STATE_LIVE;
>  	/* Drop initial reference. */
>  	module_put(mod);
> @@ -2186,6 +2189,7 @@ sys_init_module(void __user *umod,
>  	mod->init_size = 0;
>  	mod->init_text_size = 0;
>  	mutex_unlock(&module_mutex);
> +	printk(KERN_WARNING "loading module %s, checkpoint 4\n", mod->name);
>  	wake_up(&module_wq);
>  
>  	return 0;
> 
> 


