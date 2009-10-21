Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbZJUEf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbZJUEf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 00:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbZJUEfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 00:35:55 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:33638 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZJUEfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 00:35:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=goosnByfGUR7TV9yH3s5mYFU20K4rYWG+VOOaqgLZvTcQyDMFqKdTgBfUWIq+n3Fny
         JSj2aZtzG6UCOXcpXpvhbZAvhaQkJ/hdIE2KfhGwcflUEZphBYYe4OUrD6p+4nhfivHP
         ZkzXaKH+xTTA10aUUlGRx51dcvV1eCamst17Q=
Date: Tue, 20 Oct 2009 21:35:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Constantin Baranov <const@mimas.ru>
Subject: Re: [PATCH] leds-alix2: add support for button connected to J15
Message-ID: <20091021043553.GA378@core.coreip.homeip.net>
References: <20091016130315.GT28832@buzzloop.caiaq.de> <20091018072738.GF3935@core.coreip.homeip.net> <20091019073728.GC28832@buzzloop.caiaq.de> <20091020013852.GC24370@core.coreip.homeip.net> <20091020101357.GR28832@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020101357.GR28832@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Oct 20, 2009 at 12:13:57PM +0200, Daniel Mack wrote:
> +
> +	ret = input_register_polled_device(ipdev);
> +	
> +	if (ret) {
> +		input_free_polled_device(ipdev);
> +		ipdev = NULL;
> +	}
> +
> +	return ret;
> +}

Ah, don't be lazy ;)

static void alix_button_unregister(void)
{
	if (ipdev) {
		input_unregister_polled_device(ipdev);
		/* Yes, polled devices need to be freed */
		input_free_polled_device(ipdev);
		ipdev = NULL;
	}
}

> +#else
> +#define alix_button_register() (0)

static inline int alix_button_register(void) { return 0; }
static inline void alix_button_unregister(void) { }

So you get typechecking (if any).

> +#endif
> +
>  static int __init alix_led_probe(struct platform_device *pdev)
>  {
>  	int i;
> @@ -89,6 +139,11 @@ static int __init alix_led_probe(struct platform_device *pdev)
>  		if (ret < 0)
>  			goto fail;
>  	}
> +
> +	ret = alix_button_register();
> +	if (ret) 
> +		goto fail;
> +
>  	return 0;
>  
>  fail:
> @@ -103,6 +158,12 @@ static int alix_led_remove(struct platform_device *pdev)
>  
>  	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
>  		led_classdev_unregister(&alix_leds[i].cdev);
> +
> +#ifdef CONFIG_LEDS_ALIX2_BUTTON
> +	if (ipdev)
> +		input_unregister_polled_device(ipdev);
> +#endif

	alix_button_unregister();

> +
>  	return 0;
>  }
>  

-- 
Dmitry
