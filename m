Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXAXWrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXAXWrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932858AbXAXWrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:47:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:20059 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbXAXWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:47:08 -0500
Date: Wed, 24 Jan 2007 14:41:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/6] min and max kobjects
Message-Id: <20070124144148.8b164cc1.randy.dunlap@oracle.com>
In-Reply-To: <20070116063029.862885000@bull.net>
References: <20070116061516.899460000@bull.net>
	<20070116063029.862885000@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 07:15:20 +0100 Nadia.Derbey@bull.net wrote:

> [PATCH 04/06]
> 
> Introduces the kobjects associated to each tunable min and max value
> 
> Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
> ---
>  include/linux/akt.h         |   30 ++++
>  include/linux/akt_ops.h     |  311 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/autotune/akt.c       |  120 ++++++++++++++++
>  kernel/autotune/akt_sysfs.c |    8 +
>  4 files changed, 469 insertions(+)
> 
> Index: linux-2.6.20-rc4/include/linux/akt.h
> ===================================================================
> --- linux-2.6.20-rc4.orig/include/linux/akt.h	2007-01-15 15:08:41.000000000 +0100
> +++ linux-2.6.20-rc4/include/linux/akt.h	2007-01-15 15:21:47.000000000 +0100
> @@ -62,6 +62,13 @@ struct tunable_kobject {
>   * auto_tune structure.
>   * These values are type dependent and are used as high / low boundaries when
>   * tuning up or down.
> + * The show and store routines (thare are type dependent too) are here for

                                   they (or these ?)

> + * sysfs support (since the min and max can be updated through sysfs).
> + * The abs_value field is used to check that we are not:
> + *   . falling under the very 1st min value when updating the min value
> + *     through sysfs
> + *   . going over the very 1st max value when updating the max value
> + *     through sysfs
>   * The type is known when the tunable is defined (see DEFINE_TUNABLE macro).
>   */
>  struct typed_value {

> Index: linux-2.6.20-rc4/kernel/autotune/akt.c
> ===================================================================
> --- linux-2.6.20-rc4.orig/kernel/autotune/akt.c	2007-01-15 15:13:31.000000000 +0100
> +++ linux-2.6.20-rc4/kernel/autotune/akt.c	2007-01-15 15:25:35.000000000 +0100
> @@ -203,5 +207,121 @@ ssize_t store_tuning_mode(struct auto_tu
>  }
>  
>  
> +/*
> + * FUNCTION:    Get operation called by tunable_attr_show (i.e. when the file
> + *              /sys/tunables/<tunable>/min is displayed).
> + *              Outputs the current tunable minimum value
> + *
> + * RETURN VALUE: >0 : output string length (including the '\0')
> + *               <0 : failure
> + */

Since you are providing function comment header blocks, please use
the accepted kernel-doc format for (all of) these.

> +ssize_t show_tunable_min(struct auto_tune *tun_addr, char *buf)
> +{
> +	ssize_t rc;
> +
> +	if (tun_addr == NULL) {
> +		printk(KERN_ERR
> +			" show_tunable_min(): tunable address is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&tun_addr->tunable_lck);
> +
> +	rc = tun_addr->min.show(tun_addr, buf);
> +
> +	spin_unlock(&tun_addr->tunable_lck);
> +
> +	return rc;
> +}
> +
> +
> +/*
> + * FUNCTION:    Set operation called by tunable_attr_store (i.e. when a
> + *              string is stored into /sys/tunables/<tunable>/min).
> + *
> + * PARAMETERS:  count: input buffer size (including the '\0')
> + *
> + * RETURN VALUE: >0: number of characters used from the input buffer
> + *               <= 0: failure

I would expect a return value of 0 not to indicate failure;
only <0 should do that.  So is this a typo or a real case where
a return of 0 indicates failure?

> + */
> +ssize_t store_tunable_min(struct auto_tune *tun_addr, const char *buf,
> +			size_t count)
> +{
> +	ssize_t rc;
> +
> +	if (tun_addr == NULL) {
> +		printk(KERN_ERR
> +			" store_tunable_min(): tunable address is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&tun_addr->tunable_lck);
> +
> +	rc = tun_addr->min.store(tun_addr, buf, count);
> +
> +	spin_unlock(&tun_addr->tunable_lck);
> +
> +	return rc;
> +}
> +
> +
> +
> +
> +/*
> + * FUNCTION:    Set operation called by tunable_attr_store (i.e. when a
> + *              string is stored into /sys/tunables/<tunable>/max).
> + *
> + * PARAMETERS:  count: input buffer size (including the '\0')
> + *
> + * RETURN VALUE: >0: number of characters used from the input buffer
> + *               <= 0: failure

same question.

> + */
> +ssize_t store_tunable_max(struct auto_tune *tun_addr, const char *buf,
> +			size_t count)
> +{
> +	ssize_t rc;
> +
> +	if (tun_addr == NULL) {
> +		printk(KERN_ERR
> +			" store_tunable_max(): tunable address is invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&tun_addr->tunable_lck);
> +
> +	rc = tun_addr->max.store(tun_addr, buf, count);
> +
> +	spin_unlock(&tun_addr->tunable_lck);
> +
> +	return rc;
> +}
> +
> +
>  EXPORT_SYMBOL_GPL(register_tunable);
>  EXPORT_SYMBOL_GPL(unregister_tunable);

Thanks.

---
~Randy
