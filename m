Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYCLPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYCLPNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYCLPNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:13:40 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:45936 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYCLPNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:13:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/6] kernel: add clamp(), clamp_t() and clamp_val() macros
Date: Wed, 12 Mar 2008 16:13:08 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1205269894.22317.32.camel@brick>
In-Reply-To: <1205269894.22317.32.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121613.09172.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 22:11:34 Harvey Harrison wrote:
> Adds macros similar to min/max/min_t/max_t.
> 
> Also, change the variable names used in the min/max macros to
> avoid shadowed variable warnings when min/max min_t/max_t are
> nested.
> 
> clamp_val is useful when clamping to constants so all types are
> taken from typeof() the first arg.
> 
> Small formatting changes to make all the macros have a similar
> form.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Andrew, this is a rollup of my original patch already in -mm with
> checkpatch warnings fixed up and one additional macro based on
> limit_value found in the b43 driver, called clamp_val.
> 
> clamp_t is no longer used, but I introduce it anyway as some future
> user may want to force the return type similar to how min_t/max_t
> operate.
> 
>  include/linux/kernel.h |   66 ++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 48 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2df44e7..b9331ac 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -335,33 +335,63 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
>  #endif /* __LITTLE_ENDIAN */
>  
>  /*
> - * min()/max() macros that also do
> + * min()/max()/clamp() macros that also do
>   * strict type-checking.. See the
>   * "unnecessary" pointer comparison.
>   */
> -#define min(x,y) ({ \
> -	typeof(x) _x = (x);	\
> -	typeof(y) _y = (y);	\
> -	(void) (&_x == &_y);		\
> -	_x < _y ? _x : _y; })
> -
> -#define max(x,y) ({ \
> -	typeof(x) _x = (x);	\
> -	typeof(y) _y = (y);	\
> -	(void) (&_x == &_y);		\
> -	_x > _y ? _x : _y; })
> +#define min(x, y) ({				\
> +	typeof(x) _min1 = (x);			\
> +	typeof(y) _min2 = (y);			\
> +	(void) (&_min1 == &_min2);		\
> +	_min1 < _min2 ? _min1 : _min2; })
> +
> +#define max(x, y) ({				\
> +	typeof(x) _max1 = (x);			\
> +	typeof(y) _max2 = (y);			\
> +	(void) (&_max1 == &_max2);		\
> +	_max1 > _max2 ? _max1 : _max2; })
> +
> +#define clamp(val, min, max) ({			\
> +	typeof(val) __val = (val);		\
> +	typeof(min) __min = (min);		\
> +	typeof(max) __max = (max);		\
> +	(void) (&__val == &__min);		\
> +	(void) (&__val == &__max);		\
> +	__val = __val < __min ? __min: __val;	\
> +	__val > __max ? __max: __val; })
> +
> +/*
> + * Useful when min and max are constants.
> + */
> +#define clamp_val(val, min, max) ({		\

So why not call it clamp_const()?
One could even use __builtin_constant_p() and make clamp() use
either clamp_const() or clamp_nonconst() from above automagically.
I'd prefer that.

> +	typeof(val) __val = (val);		\
> +	typeof(val) __min = (min);		\
> +	typeof(val) __max = (max);		\
> +	__val = __val < __min ? __min: __val;	\
> +	__val > __max ? __max: __val; })
>  
>  /*
>   * ..and if you can't take the strict
>   * types, you can specify one yourself.
>   *
> - * Or not use min/max at all, of course.
> + * Or not use min/max/clamp at all, of course.
>   */
> -#define min_t(type,x,y) \
> -	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
> -#define max_t(type,x,y) \
> -	({ type __x = (x); type __y = (y); __x > __y ? __x: __y; })
> -
> +#define min_t(type, x, y) ({			\
> +	type __min1 = (x);			\
> +	type __min2 = (y);			\
> +	__min1 < __min2 ? __min1: __min2; })
> +
> +#define max_t(type, x, y) ({			\
> +	type __max1 = (x);			\
> +	type __max2 = (y);			\
> +	__max1 > __max2 ? __max1: __max2; })
> +
> +#define clamp_t(type, val, min, max) ({		\
> +	type __val = (val);			\
> +	type __min = (min);			\
> +	type __max = (max);			\
> +	__val = __val < __min ? __min: __val;	\
> +	__val > __max ? __max: __val; })
>  
>  /**
>   * container_of - cast a member of a structure out to the containing structure



-- 
Greetings Michael.
