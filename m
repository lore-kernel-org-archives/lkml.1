Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZLGHaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZLGHaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZLGHaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:30:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56413 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZLGHaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:30:04 -0500
Message-ID: <4B1CAF01.8000103@cs.helsinki.fi>
Date: Mon, 07 Dec 2009 09:30:09 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemcheck: make bitfield annotations truly no-ops when
 disabled
References: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com>
In-Reply-To: <1260121333-19642-1-git-send-email-vegard.nossum@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum kirjoitti:
> It turns out that even zero-sized struct members (int foo[0];) will affect
> the struct layout, causing us in particular to lose 4 bytes in struct sock.
> 
> This patch fixes the regression in CONFIG_KMEMCHECK=n case.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  include/linux/kmemcheck.h |  110 ++++++++++++++++++++++++---------------------
>  1 files changed, 58 insertions(+), 52 deletions(-)
> 
> Andrew: Compile tested on x86_32 and x86_64, but because of my bad track
> record when it comes to brown paper bugs, can you please keep this in -mm
> for a little while? Thanks.
> 
> diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
> index e880d4c..08d7dc4 100644
> --- a/include/linux/kmemcheck.h
> +++ b/include/linux/kmemcheck.h
> @@ -36,6 +36,56 @@ int kmemcheck_hide_addr(unsigned long address);
>  
>  bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size);
>  
> +/*
> + * Bitfield annotations
> + *
> + * How to use: If you have a struct using bitfields, for example
> + *
> + *     struct a {
> + *             int x:8, y:8;
> + *     };
> + *
> + * then this should be rewritten as
> + *
> + *     struct a {
> + *             kmemcheck_bitfield_begin(flags);
> + *             int x:8, y:8;
> + *             kmemcheck_bitfield_end(flags);
> + *     };
> + *
> + * Now the "flags_begin" and "flags_end" members may be used to refer to the
> + * beginning and end, respectively, of the bitfield (and things like
> + * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
> + * fields should be annotated:
> + *
> + *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
> + *     kmemcheck_annotate_bitfield(a, flags);
> + */
> +#define kmemcheck_bitfield_begin(name)	\
> +	int name##_begin[0];
> +
> +#define kmemcheck_bitfield_end(name)	\
> +	int name##_end[0];
> +
> +#define kmemcheck_annotate_bitfield(ptr, name)				\
> +	do {								\
> +		int _n;							\
> +									\
> +		if (!ptr)						\
> +			break;						\
> +									\
> +		_n = (long) &((ptr)->name##_end)			\
> +			- (long) &((ptr)->name##_begin);		\
> +		MAYBE_BUILD_BUG_ON(_n < 0);				\
> +									\
> +		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
> +	} while (0)
> +
> +#define kmemcheck_annotate_variable(var)				\
> +	do {								\
> +		kmemcheck_mark_initialized(&(var), sizeof(var));	\
> +	} while (0)							\
> +
>  #else
>  #define kmemcheck_enabled 0
>  
> @@ -106,60 +156,16 @@ static inline bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
>  	return true;
>  }
>  
> -#endif /* CONFIG_KMEMCHECK */
> -
> -/*
> - * Bitfield annotations
> - *
> - * How to use: If you have a struct using bitfields, for example
> - *
> - *     struct a {
> - *             int x:8, y:8;
> - *     };
> - *
> - * then this should be rewritten as
> - *
> - *     struct a {
> - *             kmemcheck_bitfield_begin(flags);
> - *             int x:8, y:8;
> - *             kmemcheck_bitfield_end(flags);
> - *     };
> - *
> - * Now the "flags_begin" and "flags_end" members may be used to refer to the
> - * beginning and end, respectively, of the bitfield (and things like
> - * &x.flags_begin is allowed). As soon as the struct is allocated, the bit-
> - * fields should be annotated:
> - *
> - *     struct a *a = kmalloc(sizeof(struct a), GFP_KERNEL);
> - *     kmemcheck_annotate_bitfield(a, flags);
> - *
> - * Note: We provide the same definitions for both kmemcheck and non-
> - * kmemcheck kernels. This makes it harder to introduce accidental errors. It
> - * is also allowed to pass NULL pointers to kmemcheck_annotate_bitfield().
> - */
> -#define kmemcheck_bitfield_begin(name)	\
> -	int name##_begin[0];
> -
> -#define kmemcheck_bitfield_end(name)	\
> -	int name##_end[0];
> +#define kmemcheck_bitfield_begin(name)
> +#define kmemcheck_bitfield_end(name)
> +#define kmemcheck_annotate_bitfield(ptr, name)	\
> +	do {					\
> +	} while (0)
>  
> -#define kmemcheck_annotate_bitfield(ptr, name)				\
> -	do {								\
> -		int _n;							\
> -									\
> -		if (!ptr)						\
> -			break;						\
> -									\
> -		_n = (long) &((ptr)->name##_end)			\
> -			- (long) &((ptr)->name##_begin);		\
> -		MAYBE_BUILD_BUG_ON(_n < 0);				\
> -									\
> -		kmemcheck_mark_initialized(&((ptr)->name##_begin), _n);	\
> +#define kmemcheck_annotate_variable(var)	\
> +	do {					\
>  	} while (0)
>  
> -#define kmemcheck_annotate_variable(var)				\
> -	do {								\
> -		kmemcheck_mark_initialized(&(var), sizeof(var));	\
> -	} while (0)							\
> +#endif /* CONFIG_KMEMCHECK */
>  
>  #endif /* LINUX_KMEMCHECK_H */

