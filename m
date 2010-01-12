Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768Ab0ALOaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0ALOaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986Ab0ALOaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:30:21 -0500
Received: from trinity.fluff.org ([89.16.178.74]:51270 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0ALOaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:30:20 -0500
Date: Tue, 12 Jan 2010 14:30:19 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC,PATCH 1/7 v2] Add a common struct clk
Message-ID: <20100112143019.GF18532@trinity.fluff.org>
References: <1263279511.160127.576969496193.0.gpush@pororo> <1263279511.160551.332624337260.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263279511.160551.332624337260.1.gpush@pororo>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 05:58:31PM +1100, Jeremy Kerr wrote:
> We currently have 21 definitions of struct clk in the ARM architecture,
> each defined on a per-platform basis. This makes it difficult to define
> platform- (or architecture-) independent clock sources without making
> assumptions about struct clk.
> 
> This change is an effort to unify struct clk where possible, by defining
> a common struct clk, containing a set of clock operations. Different
> clock implementations can set their own operations, and have a standard
> interface for generic code. The callback interface is exposed to the
> kernel proper, while the clock implementations only need to be seen by
> the platform internals.
> 
> This allows us to share clock code among platforms, and makes it
> possible to dynamically create clock devices in platform-independent
> code.
> 
> Platforms can enable the generic struct clock through
> CONFIG_USE_COMMON_STRUCT_CLK.
> 
> The common clock definitions are based on a development patch from Ben
> Herrenschmidt <benh@kernel.crashing.org>.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  arch/Kconfig        |    3 
>  include/linux/clk.h |  134 +++++++++++++++++++++++++++++++++++---------
>  2 files changed, 110 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 9d055b4..cefc026 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -140,4 +140,7 @@ config HAVE_HW_BREAKPOINT
>  config HAVE_USER_RETURN_NOTIFIER
>  	bool
>  
> +config USE_COMMON_STRUCT_CLK
> +	bool
> +
>  source "kernel/gcov/Kconfig"
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 1d37f42..1a6199e 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -11,36 +11,101 @@
>  #ifndef __LINUX_CLK_H
>  #define __LINUX_CLK_H
>  
> -struct device;
> +#include <linux/err.h>
>  
> -/*
> - * The base API.
> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
> +
> +/* If we're using the common struct clk, we define the base clk object here,
> + * which will be 'subclassed' by device-specific implementations. For example:
> + *
> + *  struct clk_foo {
> + *      struct clk;
> + *      [device specific fields]
> + *  };
> + *
> + * We define the common clock API through a set of static inlines that call the
> + * corresponding clk_operations. The API is exactly the same as that documented
> + * in the !CONFIG_USE_COMMON_STRUCT_CLK case.
>   */
>  
> +struct clk {
> +	const struct clk_operations *ops;
> +};
> +
> +struct clk_operations {
> +       int             (*enable)(struct clk *);

Personaly I'd leave the enable/disable as one call which takes
(struct clk *, bool on). these code paths tend to be pretty much the
same read/modify/write with only the modify changing depending on the
on parameter.

> +       void            (*disable)(struct clk *);
> +       unsigned long   (*get_rate)(struct clk *);
> +       void            (*put)(struct clk *);
> +       long            (*round_rate)(struct clk *, unsigned long);
> +       int             (*set_rate)(struct clk *, unsigned long);
> +       int             (*set_parent)(struct clk *, struct clk *);
> +       struct clk*     (*get_parent)(struct clk *);
> +};
> +
> +static inline int clk_enable(struct clk *clk)
> +{
> +	if (clk->ops->enable)
> +		return clk->ops->enable(clk);
> +	return 0;
> +}
> +
> +static inline void clk_disable(struct clk *clk)
> +{
> +	if (clk->ops->disable)
> +		clk->ops->disable(clk);
> +}
> +
> +static inline unsigned long clk_get_rate(struct clk *clk)
> +{
> +	if (clk->ops->get_rate)
> +		return clk->ops->get_rate(clk);
> +	return 0;
> +}
> +
> +static inline void clk_put(struct clk *clk)
> +{
> +	if (clk->ops->put)
> +		clk->ops->put(clk);
> +}
> +
> +static inline long clk_round_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->round_rate)
> +		return clk->ops->round_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +
> +static inline int clk_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	if (clk->ops->set_rate)
> +		return clk->ops->set_rate(clk, rate);
> +	return -ENOSYS;
> +}
> +
> +static inline int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	if (clk->ops->set_parent)
> +		return clk->ops->set_parent(clk, parent);
> +	return -ENOSYS;
> +}
> +
> +static inline struct clk *clk_get_parent(struct clk *clk)
> +{
> +	if (clk->ops->get_parent)
> +		return clk->ops->get_parent(clk);
> +	return ERR_PTR(-ENOSYS);
> +}

In the Samsung impelemtnations, the clk keeps a parent pointer and
we just return that as the esult of the clk_get_parent nless the clock
wants to override it.

> +
> +#else /* !CONFIG_USE_COMMON_STRUCT_CLK */
>  
>  /*
> - * struct clk - an machine class defined object / cookie.
> + * Global clock object, actual structure is declared per-machine
>   */
>  struct clk;
>  
>  /**
> - * clk_get - lookup and obtain a reference to a clock producer.
> - * @dev: device for clock "consumer"
> - * @id: clock comsumer ID
> - *
> - * Returns a struct clk corresponding to the clock producer, or
> - * valid IS_ERR() condition containing errno.  The implementation
> - * uses @dev and @id to determine the clock consumer, and thereby
> - * the clock producer.  (IOW, @id may be identical strings, but
> - * clk_get may return different clock producers depending on @dev.)
> - *
> - * Drivers must assume that the clock source is not enabled.
> - *
> - * clk_get should not be called from within interrupt context.
> - */
> -struct clk *clk_get(struct device *dev, const char *id);
> -
> -/**
>   * clk_enable - inform the system when the clock source should be running.
>   * @clk: clock source
>   *
> @@ -83,12 +148,6 @@ unsigned long clk_get_rate(struct clk *clk);
>   */
>  void clk_put(struct clk *clk);
>  
> -
> -/*
> - * The remaining APIs are optional for machine class support.
> - */
> -
> -
>  /**
>   * clk_round_rate - adjust a rate to the exact rate a clock can provide
>   * @clk: clock source
> @@ -125,6 +184,27 @@ int clk_set_parent(struct clk *clk, struct clk *parent);
>   */
>  struct clk *clk_get_parent(struct clk *clk);
>  
> +#endif /* !CONFIG_USE_COMMON_STRUCT_CLK */
> +
> +struct device;
> +
> +/**
> + * clk_get - lookup and obtain a reference to a clock producer.
> + * @dev: device for clock "consumer"
> + * @id: clock comsumer ID
> + *
> + * Returns a struct clk corresponding to the clock producer, or
> + * valid IS_ERR() condition containing errno.  The implementation
> + * uses @dev and @id to determine the clock consumer, and thereby
> + * the clock producer.  (IOW, @id may be identical strings, but
> + * clk_get may return different clock producers depending on @dev.)
> + *
> + * Drivers must assume that the clock source is not enabled.
> + *
> + * clk_get should not be called from within interrupt context.
> + */
> +struct clk *clk_get(struct device *dev, const char *id);
> +
>  /**
>   * clk_get_sys - get a clock based upon the device name
>   * @dev_id: device name
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

