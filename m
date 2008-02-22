Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYBWAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYBWAQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbYBWAQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:16:35 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:5909 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYBWAQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bkVEA7D6vPgN101uSu1AvaOQ1hFuYkmOifyPNM67uXPVQqTFCMVKKdqCCQqIuUyj1x1pv1hb+z+/XMBPJzlZ6d0JgxBiHmLFqg2yxJbdXYv0qCkr8voTPoGbumWvsNvvf5NKDKg79qhK/vq94maRp/CGSM+ZVj4ecVlEPzo4Qdw=
Date: Sat, 23 Feb 2008 02:56:28 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/4 resend] [x86] Add generic GPIO support to x86
Message-ID: <20080222235628.GA31683@zarina>
Reply-To: cbouatmailru@gmail.com
References: <200710181551.24912.florian.fainelli@telecomint.eu> <20080213140258.78380f5d.akpm@linux-foundation.org> <200802131755.30921.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <200802131755.30921.david-b@pacbell.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 05:55:30PM -0800, David Brownell wrote:
> On Wednesday 13 February 2008, Andrew Morton wrote:
> > It would be more modern to have a <linux/gpio.h> which takes care of
> > cruddy details, but it's getting too late for that.
> 
> Sort of like this?  For drivers that don't want to list themselves
> in Kconfig as depending on GENERIC_GPIO (e.g. one NAND driver I heard
> about), this lets them use <linux/gpio.h> ... existing code can't
> break, and it won't hurt if new code uses this.
> 
> - Dave
> 
> 
> ============== CUT HERE
> Add a <linux/gpio.h> defining fail/warn stubs for GPIO calls on
> platforms that don't support the GPIO programming interface.  It
> includes the arch-specific interface glue otherwise.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  include/linux/gpio.h |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 93 insertions(+)
> 
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ g26/include/linux/gpio.h	2008-02-13 17:40:06.000000000 -0800
> @@ -0,0 +1,93 @@
> +#ifndef __LINUX_GPIO_H
> +#define __LINUX_GPIO_H
> +
> +#ifdef CONFIG_GENERIC_GPIO
> +#include <asm/gpio.h>
> +
> +#else
> +
> +/*
> + * Some platforms don't support the GPIO programming interface.
> + *
> + * In case some driver uses it anyway (it should normally have
> + * depended on GENERIC_GPIO), these routines help the compiler
> + * optimize out much GPIO-related code ... or trigger a runtime
> + * warning when something is wrongly called.
> + */
> +
> +static inline int gpio_is_valid(int number)
> +{
> +	return 0;
> +}
> +
> +static inline int gpio_request(unsigned gpio, const char *label)
> +{
> +	return -EINVAL;

Could we return -ENOSYS instead, so drivers will able to distinguish
between "something really failed" and "there is no gpio support,
fallback to other methods"? Without this, the notorious NAND driver
will hardly benefit from this change. ;-)

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
