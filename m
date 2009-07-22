Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZGVGQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZGVGQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 02:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZGVGQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 02:16:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60829 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbZGVGQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 02:16:18 -0400
Message-ID: <4A66AE53.2050209@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 14:14:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       bblum@google.com, linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
Subject: Re: [RFCv2][PATCH] flexible array implementation
References: <20090721220017.60A219D3@kernel>	 <4A66868F.4010001@cn.fujitsu.com> <1248237292.24021.2.camel@nimitz>
In-Reply-To: <1248237292.24021.2.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12:34, Dave Hansen wrote:
> On Wed, 2009-07-22 at 11:25 +0800, Li Zefan wrote:
>>> +/**
>>> + * flex_array_put - copy data into the array at @element_nr
>>> + * @src:	address of data to copy into the array
>>> + * @element_nr:	index of the position in which to insert
>>> + * 		the new element.
>> @fa and @flags are not documented.
> 
> True...  But one of my pet peeves are kerneldocs like this:
> 
> 	@fa: the flex array
> 	@flags: GFP flags
> 
> It's so trivially obvious from looking at the types and the variable
> names that I'm not sure it's worth the cost of the lines.  
> 

I'm not kernel-doc expert, but ./scripts/kernel-doc will warn
on this. And from time to time, we receive patches to fix
kernel-doc.

>>> + *
>>> + * Note that this *copies* the contents of @src into
>>> + * the array.  If you are trying to store an array of
>>> + * pointers, make sure to pass in &ptr instead of ptr.
>>> + *
>>> + * Locking must be provided by the caller.
>>> + */
>>> +int flex_array_put(struct flex_array *fa, int element_nr, void *src, gfp_t flags)
>>> +{
>>> +	int part_nr = fa_element_to_part_nr(fa, element_nr);
>>> +	struct flex_array_part *part;
>>> +	void *dst;
>>> +
>>> +	part = __fa_get_part(fa, part_nr, flags);
>>> +	if (!part)
>>> +		return -ENOMEM;
>> So this may allocate memory, and has disavantages:
>>
>> - If flex_array_put() is called in atomic context, flags has to be GFP_ATOMIC.
>> - and thus it may fail.
>>
>> Since we pass the total_elem to flex_array_alloc(), how about add a flag,
>> and if the flag is set, the alloc() will also allocate all fa_parts?
>>
>> And add __flex_array_put(), which assumes fa_parts has been allocated.
> 
> How about flex_array_prealloc()?  It seems to work for all the radix
> tree users.
> 

I have no strong opinion. I just want a non-fail version of
flex_array_put() (I mean "void __flex_array_put()").

