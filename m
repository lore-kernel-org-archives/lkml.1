Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbZB0Ujp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbZB0Ujp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbZB0Uho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:37:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760225AbZB0Uhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:37:42 -0500
Date: Fri, 27 Feb 2009 12:36:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Felipe Balbi <me@felipebalbi.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, sameo@openedhand.com,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2/2] mfd: twl4030: add twl4030-pwrbutton as our child
Message-Id: <20090227123649.d2d6408c.akpm@linux-foundation.org>
In-Reply-To: <1235762883-20870-2-git-send-email-me@felipebalbi.com>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	<1235762883-20870-2-git-send-email-me@felipebalbi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 21:28:03 +0200
Felipe Balbi <me@felipebalbi.com> wrote:

> From: Felipe Balbi <felipe.balbi@nokia.com>
> 
> Make that twl4030-pwrbutton.c driver probe with current
> child creation api for twl4030.
> 
> Cc: Samuel Ortiz <sameo@openedhand.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
> ---
> This part is better off going via mfd.
> 
>  drivers/mfd/twl4030-core.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
> index 68826f1..c86bc3b 100644
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -101,6 +101,12 @@
>  #define twl_has_usb()	false
>  #endif
>  
> +#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
> +	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)

OK, this is "wrong".  The core shouldn't need to know about specific
clients.

> +#define twl_has_pwrbutton()	true
> +#else
> +#define twl_has_pwrbutton()	false
> +#endif
>  
>  /* Triton Core internal information (BEGIN) */
>  
> @@ -526,6 +532,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>  		usb_transceiver = child;
>  	}
>  
> +	if (twl_has_pwrbutton()) {
> +		child = add_child(1, "twl4030_pwrbutton",
> +				NULL, 0, true, pdata->irq_base + 8 + 0, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
>  	if (twl_has_regulator()) {
>  		/*
>  		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);

The client module should register itself with the core, rather than the core
registering the client.

What has gone wrong here?
