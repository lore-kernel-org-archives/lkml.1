Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYCNQfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYCNQfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYCNQfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:35:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30278 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYCNQfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:35:40 -0400
Date: Fri, 14 Mar 2008 09:34:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] Add macros similar to min/max/min_t/max_t.
Message-Id: <20080314093451.cd3e644c.randy.dunlap@oracle.com>
In-Reply-To: <1205471926.19712.12.camel@brick>
References: <1205471926.19712.12.camel@brick>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 22:18:45 -0700 Harvey Harrison wrote:

> Also, change the variable names used in the min/max macros to avoid shadowed
> variable warnings when min/max min_t/max_t are nested.
> 
> Small formatting changes to make all the macros have a similar form.
> 
> 
>  drivers/media/video/bt8xx/bttvp.h    |    2 -
>  drivers/media/video/usbvideo/vicam.c |    6 ---
>  include/linux/kernel.h               |   63 ++++++++++++++++++++++++----------
>  3 files changed, 45 insertions(+), 26 deletions(-)

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2df44e7..c74460c 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -335,33 +335,60 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
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

Where is some blurb/comment about what "clamp" means/does?
min/max are well understood, but clamp?  Is that a shop tool?
I think I have a few out in my garage.

So can we have some blurb here to explain clamp(), clamp_t(),
and clamp_val()?

(kernel-doc preferred, but not required) e.g:


/**
 * clamp - returns a value that is restricted between min & max inclusive
 * @val: current value
 * @min: minimum value of the clamping region
 * @max: maximum value of the clamping region
 */

and explain the differences in clamp/clamp_t/clamp_val...


/*
> +#define clamp(val, min, max) ({			\
> +	typeof(val) __val = (val);		\
> +	typeof(min) __min = (min);		\
> +	typeof(max) __max = (max);		\
> +	(void) (&__val == &__min);		\
> +	(void) (&__val == &__max);		\
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
> +
> +#define clamp_val(val, min, max) ({		\
> +	typeof(val) __val = (val);		\
> +	typeof(val) __min = (min);		\
> +	typeof(val) __max = (max);		\
> +	__val = __val < __min ? __min: __val;	\
> +	__val > __max ? __max: __val; })
>  
>  /**
>   * container_of - cast a member of a structure out to the containing structure


---
~Randy
