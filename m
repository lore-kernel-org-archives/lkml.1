Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZKDJpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZKDJpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbZKDJpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:45:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:51208 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZKDJpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BH0sAtSOgIAZLG0NJX3AFzgefS7AS6l18qY/GAZav7UiMpeAXRQQJIzEkR0b0eNw44
         zyW8yk/Av1oSHtBVOXSY+eB27P3KWMHqQ/I6GeNjGQFkZxfBUv+gaDJ+zbNbeknKOZfD
         iho66xc8TQrTVJCjfN/jh9Mdncad4xitNBtkY=
Message-ID: <4AF14D45.4020804@tuffmail.co.uk>
Date: Wed, 04 Nov 2009 09:45:41 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] module: refactor symbol tables and try to reduce
 code size of each_symbol()
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-7-git-send-email-alan-jenkins@tuffmail.co.uk> <200911041858.28285.rusty@rustcorp.com.au>
In-Reply-To: <200911041858.28285.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> +typedef bool each_symbol_fn_t (enum export_type type,
>> +			       const struct kernel_symbol *sym,
>> +			       const unsigned long *crc,
>> +			       struct module *owner,
>> +			       void *data);
>> +
>>  /* Walk the exported symbol table */
>> -bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
>> -			    unsigned int symnum, void *data), void *data);
>> +bool each_symbol(each_symbol_fn_t *fn, void *data);
>>     
>
> I really hate throwaway typedefs like this.  But it's used in two other
> places, so I'll suppress my distaste :)
>   

"const struct kernel_symbol *sym" was pushing lines over 80 columns in 
those other two places.


>> +static struct ksymtab ksymtab[EXPORT_TYPE_MAX];
>> +
>> +static int __init init_ksymtab(void)
>> +{
>> +	struct ksymtab tmp[EXPORT_TYPE_MAX] = {
>> +		[EXPORT_TYPE_PLAIN] = {
>> +			__start___ksymtab, __start___kcrctab,
>> +			__stop___ksymtab - __start___ksymtab,
>> +		},
>>     

>> +	};
>> +
>> +	memcpy(ksymtab, tmp, sizeof(ksymtab));
>>     
>
> This works, but I'd prefer you to open-code the assignments.  Simpler and
> marginally more efficient.
>   

Ok.

>> @@ -322,9 +322,9 @@ static bool find_symbol_in_section(const struct symsearch *syms,
>>  	}
>>  #endif
>>  
>> +	fsa->sym = sym;
>> +	fsa->crc = crc;
>>  	fsa->owner = owner;
>> -	fsa->crc = symversion(syms->crcs, symnum);
>> -	fsa->sym = &syms->start[symnum];
>>  	return true;
>>     
>
> Strange gratuitous reorder here?
>
>   

I can't see why I did that either.  I'll put it back in the original order.

>> +static const char *export_section_names[EXPORT_TYPE_MAX] = {
>> +	[EXPORT_TYPE_PLAIN] = "__ksymtab",
>> +	[EXPORT_TYPE_GPL] = "__ksymtab_gpl",
>> +#ifdef CONFIG_UNUSED_SYMBOLS
>> +	[EXPORT_TYPE_UNUSED] = "__ksymtab_unused",
>> +	[EXPORT_TYPE_UNUSED_GPL] = "__ksymtab_unused_gpl",
>> +#endif
>> +	[EXPORT_TYPE_GPL_FUTURE] = "__ksymtab_gpl_future",
>> +};
>> +
>> +static const char *crc_section_names[EXPORT_TYPE_MAX] = {
>> +	[EXPORT_TYPE_PLAIN] = "__kcrctab",
>> +	[EXPORT_TYPE_GPL] = "__kcrctab_gpl",
>> +#ifdef CONFIG_UNUSED_SYMBOLS
>> +	[EXPORT_TYPE_UNUSED] = "__kcrctab_unused",
>> +	[EXPORT_TYPE_UNUSED_GPL] = "__kcrctab_unused_gpl",
>> +#endif
>> +	[EXPORT_TYPE_GPL_FUTURE] = "__kcrctab_gpl_future",
>> +};
>>     
>
> You can use [] here for size instead of explicit EXPORT_TYPE_MAX.  We should
> have named these sections better :(
>
>   
>> +	for (export_type = 0; export_type < EXPORT_TYPE_MAX; export_type++) {
>>     
>
> Then use ARRAY_SIZE(export_section_names) here.
>
>   
>> +	for (export_type = 0; export_type < EXPORT_TYPE_MAX; export_type++) {
>> +		if (mod->syms[export_type].syms &&
>>     
>
> Similar ARRAY_SIZE(mod->syms).  It's less indirect, IMHO.
>   

The idea was to highlight EXPORT_TYPE when the loop variable is 
shortened to the less obvious "type".  But that only affects two sites 
(in patch 9), and in both cases it's fairly easy to see the definition

enum export_type type;

so on balance I have to agree.  I'll switch to using ARRAY_SIZE() 
throughout.

> But all minor nitpicks; code is excellent!
>
> Thanks,
> Rusty.
>   

Thanks for the close review
Alan
