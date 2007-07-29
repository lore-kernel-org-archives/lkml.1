Return-Path: <linux-kernel-owner+w=401wt.eu-S1764591AbXG2Qnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764591AbXG2Qnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763385AbXG2Qng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:43:36 -0400
Received: from h155.mvista.com ([63.81.120.155]:56842 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763122AbXG2Qnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:43:35 -0400
Message-ID: <46ACC42E.8040907@ru.mvista.com>
Date: Sun, 29 Jul 2007 20:45:34 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: niklaus.giger@member.fsf.org
Cc: linux-kernel@vger.kernel.org, linuxppc-embedded@ozlabs.org,
       kristen.c.accardi@intel.com
Subject: Re: [PATCH] Fix compilation for non CONFIG_HOTPLUG case
References: <200707291807.52042.niklaus.giger@member.fsf.org>
In-Reply-To: <200707291807.52042.niklaus.giger@member.fsf.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Niklaus Giger wrote:

> Fixes compilation issues for embedded boards which do not support HOTPLUG

> Signed-off-by: Niklaus Giger <niklaus.giger@member.fsf.org>

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 3599ab2..a09bfc8 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -24,7 +24,9 @@
>  #include "base.h"
>  #include "power/power.h"
> 
> +#ifdef CONFIG_HOTPLUG
>  extern const char *kobject_actions[];
> +#endif

    No need for #ifdef around extern declarations.

>  int (*platform_notify)(struct device * dev) = NULL;
>  int (*platform_notify_remove)(struct device * dev) = NULL;
> @@ -306,11 +308,13 @@ static ssize_t store_uevent(struct device *dev, struct 
> device_attribute *attr,
>  			    const char *buf, size_t count)
>  {
>  	size_t len = count;
> +#ifdef CONFIG_HOTPLUG
>  	enum kobject_action action;
> -
> +#endif

    Please don't remove newline between the declaration block and the code.

>  	if (len && buf[len-1] == '\n')
>  		len--;
> 
> +#ifdef CONFIG_HOTPLUG
>  	for (action = 0; action < KOBJ_MAX; action++) {
>  		if (strncmp(kobject_actions[action], buf, len) != 0)
>  			continue;
> @@ -319,11 +323,14 @@ static ssize_t store_uevent(struct device *dev, struct 
> device_attribute *attr,
>  		kobject_uevent(&dev->kobj, action);
>  		goto out;

    Grr... cleanup style abuse -- ISO a mere return they used goto. :-/

>  	}
> +#endif
> 
>  	dev_err(dev, "uevent: unsupported action-string; this will "
>  		     "be ignored in a future kernel version\n");
>  	kobject_uevent(&dev->kobj, KOBJ_ADD);
> +#ifdef CONFIG_HOTPLUG
>  out:
> +#endif

    Well, #ifdef'ing out label seems too much.

>  	return count;
>  }

WBR, Sergei
