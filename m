Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYCMXBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYCMXBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYCMXBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:01:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbYCMXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:01:02 -0400
Date: Thu, 13 Mar 2008 16:00:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, avorontsov@ru.mvista.com
Subject: Re: [patch 2.6.25-rc5 1/2] gpiolib:  dynamic gpio number allocation
Message-Id: <20080313160039.b69a5d24.akpm@linux-foundation.org>
In-Reply-To: <200803131549.54632.david-b@pacbell.net>
References: <200803131549.54632.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 14:49:53 -0800
David Brownell <david-b@pacbell.net> wrote:

> From: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> If gpio_chip->base is negative during registration, gpiolib performs
> dynamic base allocation. This is useful for devices that aren't always
> present, such as GPIOs on hotplugged devices rather than mainboards.
> (This behavior was previously specified but not implemented.)
> 
> To avoid using any numbers that may have been explicitly assigned but
> not yet registered, this dynamic allocation assigns GPIO numbers from
> the biggest number on down, instead of from the smallest on up.
>
> ..
>
> +/* dynamic allocation of GPIOs, e.g. on a hotplugged device */
> +static int gpiochip_find_base(int ngpio)
> +{
> +	int i;
> +	int spare = 0;
> +	int base = -ENOSPC;
> +
> +	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
> +		struct gpio_chip *chip = gpio_desc[i].chip;
> +
> +		if (!chip) {
> +			spare++;
> +			if (spare == ngpio) {
> +				base = i;
> +				break;
> +			}
> +		} else {
> +			spare = 0;
> +			i -= chip->ngpio - 1;
> +		}
> +	}
> +
> +	if (gpio_is_valid(base))
> +		pr_debug("%s: found new base at %d\n", __func__, base);
> +	return base;
> +}

hm.  I suppose that if someone want a huge number of GPIOs then we can
convert this to a bitmap or an IDR tree easily enough.

Shouldn't ARCH_NR_GPIOS be CONFIG_NR_GPIOS?


