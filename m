Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYDGW7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYDGW7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758363AbYDGW7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:59:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323AbYDGW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:59:29 -0400
Date: Mon, 7 Apr 2008 15:59:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       pavel@ucw.cz, tony@atomide.com, paul@pwsan.com,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/6] Clocklib: debugfs support
Message-Id: <20080407155901.c7431c3e.akpm@linux-foundation.org>
In-Reply-To: <20080403132337.GA26981@doriath.ww600.siemens.net>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	<20080403132337.GA26981@doriath.ww600.siemens.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008 17:23:37 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Provide /sys/kernel/debug/clock to ease debugging.
> 

Plese fully document the proposed kernel->userspace interface in the
changelog so that we can review it design.

> diff --git a/include/linux/clklib.h b/include/linux/clklib.h
> index 3d0ffaf..77514cc 100644
> --- a/include/linux/clklib.h
> +++ b/include/linux/clklib.h
> @@ -19,6 +19,7 @@ struct seq_file;
>   * @get_rate: obtain the current clock rate of a specified clock
>   * @set_rate: set the clock rate for a specified clock
>   * @round_rate: adjust a reate to the exact rate a clock can provide
> + * @format: output any additional information for a clock
>   *
>   * This structure specifies clock operations that are used to configure
>   * specific clock.
> @@ -30,6 +31,7 @@ struct clk_ops {
>  	unsigned long (*get_rate) (struct clk *clk);
>  	int (*set_rate)  (struct clk *, unsigned long);
>  	long (*round_rate) (struct clk *, unsigned long);
> +	int (*format)	(struct clk *, struct seq_file *);

It's conventional to leave no space between the ) and the ( here.  Using a
tab is quite unconventional.

>  };
>  
>  /**
> diff --git a/kernel/clklib.c b/kernel/clklib.c
> index 012f845..8d872e1 100644
> --- a/kernel/clklib.c
> +++ b/kernel/clklib.c
> @@ -324,3 +324,77 @@ out:
>  	return rc;
>  }
>  EXPORT_SYMBOL(clk_alloc_function);
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +
> +#define NAME_FIELD_LEN	20
> +
> +static void dump_clocks(struct seq_file *s, struct clk *parent, int nest)
> +{
> +	struct clk *clk;
> +	int i;
> +
> +	list_for_each_entry(clk, &clocks, node) {
> +		if (clk->parent == parent) {
> +			for (i = 0; i < nest; i++) {
> +				seq_putc(s, ' ');
> +				seq_putc(s, ' ');
> +			}
> +			seq_puts(s, clk->name);
> +
> +			i = 2 * nest + strlen(clk->name);
> +			if (i >= NAME_FIELD_LEN)
> +				i = NAME_FIELD_LEN - 1;
> +			for (; i < NAME_FIELD_LEN; i++) {
> +				seq_putc(s, ' ');
> +			}
> +			seq_printf(s, "%c use=%d rate=%10lu Hz",
> +				clk->ops && clk->ops->set_parent ? '*' : ' ',
> +				clk->users,
> +				__clk_get_rate(clk));
> +			if (clk->ops && clk->ops->format)
> +				clk->ops->format(clk, s);
> +			seq_putc(s, '\n');
> +
> +			dump_clocks(s, clk, nest + 1);
> +		}
> +	}
> +}

hm, this would break the one-value-per-file rule, except that applies to
sysfs, but this interface is implemented via debug fs, but it is proposed
that it appear under /sys.  Tricky.


