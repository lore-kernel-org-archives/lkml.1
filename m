Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967941Ab0B0IHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 03:07:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39733 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967911Ab0B0IHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 03:07:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K0avKlRpNA7eYtiZP0At4D0HL6nf3hhMlIIc7gZwbBynKtyYThXOZEFR2tKDpj9TEx
         tLI5T2wVUOuQuRWRg/mUyvKG2G0KEHYYMnW7cFu319OKbCS2GTc94bntSkYxjCE9vwbV
         C1SWyeIDq/0dqv/KpvTGuTy4lWotnQq2qFXpw=
Date: Sat, 27 Feb 2010 00:06:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/14] dell-laptop: Update rfkill state on kill switch
Message-ID: <20100227080656.GD793@core.coreip.homeip.net>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
 <1267197527-18062-5-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267197527-18062-5-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Fri, Feb 26, 2010 at 10:18:37AM -0500, Matthew Garrett wrote:
> +
>  static int __init dell_init(void)
>  {
>  	struct calling_interface_buffer buffer;
> @@ -373,6 +410,13 @@ static int __init dell_init(void)
>  		goto fail_rfkill;
>  	}
>  
> +	ret = i8042_install_filter(dell_laptop_i8042_filter);
> +	if (ret) {
> +		printk(KERN_WARNING
> +		       "dell-laptop: Unable to install key filter\n");
> +		goto fail_filter;
> +	}
> +
>  #ifdef CONFIG_ACPI
>  	/* In the event of an ACPI backlight being available, don't
>  	 * register the platform controller.
> @@ -410,6 +454,8 @@ static int __init dell_init(void)
>  	return 0;
>  
>  fail_backlight:
> +	i8042_remove_filter(dell_laptop_i8042_filter);

cancel_delayed_work_sync() is missing.

> +fail_filter:
>  	dell_cleanup_rfkill();
>  fail_rfkill:
>  	platform_device_del(platform_device);
> @@ -424,6 +470,8 @@ fail_platform_driver:
>  
>  static void __exit dell_exit(void)
>  {
> +	cancel_delayed_work_sync(&dell_rfkill_work);
> +	i8042_remove_filter(dell_laptop_i8042_filter);

Wrong order, you need to unregister filter first.

>  	backlight_device_unregister(dell_backlight_device);
>  	dell_cleanup_rfkill();

Thanks.

-- 
Dmitry
