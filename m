Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbXCTOoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbXCTOoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933543AbXCTOoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:44:38 -0400
Received: from mailout20.yourhostingaccount.com ([65.254.253.166]:60800 "EHLO
	mailout20.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933158AbXCTOoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:44:37 -0400
Message-ID: <003501c76afe$3c797a20$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "Matt Mackall" <mpm@selenic.com>
Cc: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>
References: <45FEB8B7.7020200@sciensis.com> <20070319225858.GK10459@waste.org>
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Date: Tue, 20 Mar 2007 16:44:01 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.52.108
X-EN-OrigHost: dsl-88-218-52-108.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments

> On Mon, Mar 19, 2007 at 06:22:15PM +0200, Tasos Parisinos wrote:
>> +static inline _i32 rsa_max(_i32 x, _i32 y)
>> +{
>> +    return (x > y)? x: y;
>> +}
> 
> We've got a max() already. Use tabs.
> 

This is right, will be fixed, just hate discipline

>> +
>> +/*
>> + * Module loading callback function
>> + *
>> + * Returns 0 on success or a negative value indicating error
>> + */
> 
> This comment is not very useful.
> 

Some of them are just bookmarks for me, i can get rid of them

>> +static _err __init rsa_load(void)
>> +{
>> +    _u32 i;
> 
> Can we use int and u32 instead of _err and _u32, please?
> 
>> +    _err retval = RSA_NO_ERR;
> 
> And 0.

right

> 
>> +    /* Pre-allocate some auxilliary mpis */
>> +    rsa_echo("Preallocating %lu bytes for auxilliary operands\n",
>> +         RSA_AUX_SIZE * RSA_AUX_COUNT * sizeof(_u32));
> 
> And printk.

i made such a printk wrapper not to mess with all the printk instances when i needed to
does this hurt, to be left as is?

> 
>> +    memset(&aux, 0, sizeof(aux));
>> +    for(i = 0; i < RSA_AUX_COUNT; i++) {
>> +        retval = rsa_mpi_alloc(&aux[i], RSA_AUX_SIZE);
> 
> kmalloc, please? RSA_AUX_SIZE appears to be in bytes.
> 

I need such a wrapper because there are other things done in rsa_mpi_alloc
than kmalloc

>> +        if(retval < 0)
> 
> We use "for (" and "if (" so they don't look like function calls.
> 

right, will fix

>> +            goto rollback;
>> +    }
>> +           
>> +    rsa_echo("RSA cipher algorithm module initialized\n");
>> +    return RSA_NO_ERR;
>> +
>> +/* Free all allocated resources if any errors occur */
>> +rollback:
>> +    for(i = 0; i < RSA_AUX_COUNT; i++)
>> +        rsa_mpi_free(aux[i]);
> 
> kfree()
> 

same as above, i need this wrapper


>> +/*
>> + * Preallocate an mpi. The allocated mpi will be all-zeroed and not
>> + * canonicalized.
>> + *
>> + * Returns 0 on success or a negative value indicating error
>> + *
>> + * @n:       pointer pointer to the allocated mpi
>> + * @limbs: number of allocated limbs (32 bit digits)
>> + */
>> +static _err rsa_mpi_alloc(mpi ** n, _i32 limbs)
> 
> Kerneldoc style is "function_name - short description". We write
> pointers as "mpi **n". These things probably all want to be named
> mpi_* rather than rsa_mpi_*, as they're not specific to the RSA algorithm.
> 
>> +{
>> +    mpi * handle;
> 
> And here.
> 
>> +        rsa_debug("%s: kzalloc failed\n", __FUNCTION__);
> 
> printk.
> 
>> +static _err rsa_mpi_init(mpi **    n, _u8 * str, _u32 size, _u32 xtra)
> 
> If str is an actual string, use char *str.
> 
>> +    /* Allocate space for the mpi and its data */
>> +    s = (size / 4) + ((size % 4)? 1: 0);
> 
> Uhhh.. (size + 1) / 4?
> 

i think (size + 3)/4 


>> +    retval = rsa_mpi_alloc(n, s + xtra);
> 
> Is this not in bytes?
> 
>> +    /* Copy the data */
>> +    for(i = size - 1, j = 0; i >= 0; i--, j++)
>> +        buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
> 
> Ew.

not obvious eh? ok will break it apart

> 
>> +        /* Zero the xtra limbs */
>> +        else if(size < handle->size)
>> +            for(i = size; i < s; i++)
>> +                buf[i] = 0;
> 
> memset?

in the first case it broke my results, so i left it for later

> 
>> +        return RSA_ERR_INVARG;
> 
> -EINVAL
> 
>> +    buf = (*n)->data;
>> +    for(i = size - 1, j = 0; i >= 0; i--, j++)
>> +        buf[j / 4] |= ((_u32)str[i] << ((j % 4) * 8));
> 
> That mess looks familiar.
> 

not obvious as well, will break it apart

>> +#define RSA_AUX_COUNT         CONFIG_RSA_AUXCOUNT
>> +#define RSA_AUX_SIZE         CONFIG_RSA_AUXSIZE
> 
> Just use the config value.
> 
>> +#define RSA_MAX_U32        0xFFFFFFFF
> 
> I'm sure we've got this somewhere.
> 

if you could tell me i will fix it

>> +#define RSA_NO_ERR        0
>> +#define RSA_ERR_INVARG        -1
>> +#define RSA_ERR_NOMEM        -2
> 
> 0, -EINVAL, -ENOMEM.
> 
>> +#define true            0x01
>> +#define false            0x00
> 
> Ew.
> 

development leftovers, will fix


>> +/* Mpi utility functions */
>> +static _err        rsa_mpi_alloc(mpi **, _i32);
>> +static void         rsa_mpi_free(mpi *);
>> +static _err         rsa_mpi_init(mpi **, _u8 *, _u32, _u32);
>> +static _err         rsa_mpi_resize(mpi **, _i32, _u8);
>> +static _err         rsa_mpi_set(mpi **, _u8 *, _u32);
>> +static inline _err     rsa_mpi_copy(mpi **, mpi *);
>> +static void         rsa_mpi_print(mpi *, _u8);
> 
> Why are you declaring a bunch of static functions in a header file?
> 

i think the compiler will disagree if i dont, but i will give it a try

> -- 
> Mathematics is the supreme nostalgia of our time.
