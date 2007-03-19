Return-Path: <linux-kernel-owner+w=401wt.eu-S965427AbXCSXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965427AbXCSXLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXCSXLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:11:43 -0400
Received: from waste.org ([66.93.16.53]:46890 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbXCSXLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:11:42 -0400
Date: Mon, 19 Mar 2007 17:58:59 -0500
From: Matt Mackall <mpm@selenic.com>
To: Tasos Parisinos <t.parisinos@sciensis.com>
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Message-ID: <20070319225858.GK10459@waste.org>
References: <45FEB8B7.7020200@sciensis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FEB8B7.7020200@sciensis.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 06:22:15PM +0200, Tasos Parisinos wrote:
> +static inline _i32 rsa_max(_i32 x, _i32 y)
> +{
> +    return (x > y)? x: y;
> +}

We've got a max() already. Use tabs.

> +
> +/*
> + * Module loading callback function
> + *
> + * Returns 0 on success or a negative value indicating error
> + */

This comment is not very useful.

> +static _err __init rsa_load(void)
> +{
> +    _u32 i;

Can we use int and u32 instead of _err and _u32, please?

> +    _err retval = RSA_NO_ERR;

And 0.

> +    /* Pre-allocate some auxilliary mpis */
> +    rsa_echo("Preallocating %lu bytes for auxilliary operands\n",
> +         RSA_AUX_SIZE * RSA_AUX_COUNT * sizeof(_u32));

And printk.

> +    memset(&aux, 0, sizeof(aux));
> +    for(i = 0; i < RSA_AUX_COUNT; i++) {
> +        retval = rsa_mpi_alloc(&aux[i], RSA_AUX_SIZE);

kmalloc, please? RSA_AUX_SIZE appears to be in bytes.

> +        if(retval < 0)

We use "for (" and "if (" so they don't look like function calls.

> +            goto rollback;
> +    }
> +           
> +    rsa_echo("RSA cipher algorithm module initialized\n");
> +    return RSA_NO_ERR;
> +
> +/* Free all allocated resources if any errors occur */
> +rollback:
> +    for(i = 0; i < RSA_AUX_COUNT; i++)
> +        rsa_mpi_free(aux[i]);

kfree()

> +/*
> + * Preallocate an mpi. The allocated mpi will be all-zeroed and not
> + * canonicalized.
> + *
> + * Returns 0 on success or a negative value indicating error
> + *
> + * @n:       pointer pointer to the allocated mpi
> + * @limbs: number of allocated limbs (32 bit digits)
> + */
> +static _err rsa_mpi_alloc(mpi ** n, _i32 limbs)

Kerneldoc style is "function_name - short description". We write
pointers as "mpi **n". These things probably all want to be named
mpi_* rather than rsa_mpi_*, as they're not specific to the RSA algorithm.

> +{
> +    mpi * handle;

And here.

> +        rsa_debug("%s: kzalloc failed\n", __FUNCTION__);

printk.

> +static _err rsa_mpi_init(mpi **    n, _u8 * str, _u32 size, _u32 xtra)

If str is an actual string, use char *str.

> +    /* Allocate space for the mpi and its data */
> +    s = (size / 4) + ((size % 4)? 1: 0);

Uhhh.. (size + 1) / 4?

> +    retval = rsa_mpi_alloc(n, s + xtra);

Is this not in bytes?

> +    /* Copy the data */
> +    for(i = size - 1, j = 0; i >= 0; i--, j++)
> +        buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));

Ew.

> +        /* Zero the xtra limbs */
> +        else if(size < handle->size)
> +            for(i = size; i < s; i++)
> +                buf[i] = 0;

memset?

> +        return RSA_ERR_INVARG;

-EINVAL

> +    buf = (*n)->data;
> +    for(i = size - 1, j = 0; i >= 0; i--, j++)
> +        buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));

That mess looks familiar.

> +#define RSA_AUX_COUNT         CONFIG_RSA_AUXCOUNT
> +#define RSA_AUX_SIZE         CONFIG_RSA_AUXSIZE

Just use the config value.

> +#define RSA_MAX_U32        0xFFFFFFFF

I'm sure we've got this somewhere.

> +#define RSA_NO_ERR        0
> +#define RSA_ERR_INVARG        -1
> +#define RSA_ERR_NOMEM        -2

0, -EINVAL, -ENOMEM.

> +#define true            0x01
> +#define false            0x00

Ew.

> +/* Mpi utility functions */
> +static _err        rsa_mpi_alloc(mpi **, _i32);
> +static void         rsa_mpi_free(mpi *);
> +static _err         rsa_mpi_init(mpi **, _u8 *, _u32, _u32);
> +static _err         rsa_mpi_resize(mpi **, _i32, _u8);
> +static _err         rsa_mpi_set(mpi **, _u8 *, _u32);
> +static inline _err     rsa_mpi_copy(mpi **, mpi *);
> +static void         rsa_mpi_print(mpi *, _u8);

Why are you declaring a bunch of static functions in a header file?

-- 
Mathematics is the supreme nostalgia of our time.
