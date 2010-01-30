Return-Path: <linux-kernel-owner+w=401wt.eu-S1752351Ab0A3IXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0A3IXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 03:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790Ab0A3IXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 03:23:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42169 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0A3IXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 03:23:16 -0500
Message-ID: <4B63EC55.8030804@cs.helsinki.fi>
Date: Sat, 30 Jan 2010 10:22:45 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       vegard.nossum@gmail.com
Subject: Re: [PATCH] kmemleak: Do not enable KMEMCHECK_PARTIAL_OK	if	DEBUG_KMEMLEAK
References: <4B60573E.7080108@cs.helsinki.fi> <1264786856.4242.115.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1264786856.4242.115.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> On Wed, 2010-01-27 at 15:09 +0000, Pekka Enberg wrote:
>> Catalin Marinas wrote:
>>> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
>>> index 5b069e4..dfd39ba 100644
>>> --- a/mm/kmemleak.c
>>> +++ b/mm/kmemleak.c
>>> @@ -948,6 +948,25 @@ EXPORT_SYMBOL(kmemleak_no_scan);
>>>  /*
>>>   * Update an object's checksum and return true if it was modified.
>>>   */
>>> +#ifdef CONFIG_KMEMCHECK_PARTIAL_OK
>>> +static bool update_checksum(struct kmemleak_object *object)
>>> +{
>>> +     u32 crc = 0;
>>> +     unsigned long ptr;
>>> +
>>> +     for (ptr = ALIGN(object->pointer, 4);
>>> +          ptr < ((object->pointer + object->size) & ~3); ptr += 4) {
>>> +             if (!kmemcheck_is_obj_initialized(ptr, 4))
>>> +                     continue;
>>> +             crc = crc32(crc, (void *)ptr, 4);
>>> +     }
>>> +
>>> +     if (object->checksum == crc)
>>> +             return false;
>>> +     object->checksum = crc;
>>> +     return true;
>> I think it would be better to add a function to _kmemcheck_ that checks
>> the full object regardless of CONFIG_KMEMCHECK_PARTIAL_OK and use it here.
> 
> IIRC, it's only kmemleak using kmemcheck_is_obj_initialized(), we could
> convert this to check the full object. Something like below (again, not
> tested yet but if you are ok with the idea I'll test it a bit more and
> add a commit log):

Looks good to me!

> 
> diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> index 8cc1833..b3b531a 100644
> --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> @@ -337,7 +337,7 @@ bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
>  	if (!shadow)
>  		return true;
>  
> -	status = kmemcheck_shadow_test(shadow, size);
> +	status = kmemcheck_shadow_test_all(shadow, size);
>  
>  	return status == KMEMCHECK_SHADOW_INITIALIZED;
>  }
> diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
> index 3f66b82..16c6d9f 100644
> --- a/arch/x86/mm/kmemcheck/shadow.c
> +++ b/arch/x86/mm/kmemcheck/shadow.c
> @@ -139,13 +139,25 @@ enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size)
>  		if (x[i] == KMEMCHECK_SHADOW_INITIALIZED)
>  			return x[i];
>  	}
> +
> +	return x[0];
>  #else
> +	return kmemcheck_shadow_test_all(shadow, size);
> +#endif
> +}
> +
> +enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow, unsigned int size)
> +{
> +	uint8_t *x;
> +	unsigned int i;
> +
> +	x = shadow;
> +
>  	/* All bytes must be initialized. */
>  	for (i = 0; i < size; ++i) {
>  		if (x[i] != KMEMCHECK_SHADOW_INITIALIZED)
>  			return x[i];
>  	}
> -#endif
>  
>  	return x[0];
>  }
> diff --git a/arch/x86/mm/kmemcheck/shadow.h b/arch/x86/mm/kmemcheck/shadow.h
> index af46d9a..ff0b2f7 100644
> --- a/arch/x86/mm/kmemcheck/shadow.h
> +++ b/arch/x86/mm/kmemcheck/shadow.h
> @@ -11,6 +11,8 @@ enum kmemcheck_shadow {
>  void *kmemcheck_shadow_lookup(unsigned long address);
>  
>  enum kmemcheck_shadow kmemcheck_shadow_test(void *shadow, unsigned int size);
> +enum kmemcheck_shadow kmemcheck_shadow_test_all(void *shadow,
> +						unsigned int size);
>  void kmemcheck_shadow_set(void *shadow, unsigned int size);
>  
>  #endif
> 
> 

