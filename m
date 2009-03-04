Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZCDJjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZCDJjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 04:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZCDJjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 04:39:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:37693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbZCDJjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 04:39:09 -0500
Message-ID: <49AE4C26.4040104@kernel.org>
Date: Wed, 04 Mar 2009 18:38:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-tip: cpufreq breakage - bisection	fingers	89c9215165ca609096e845926d9a18f1306176a4
References: <1236085632.5958.8.camel@marge.simson.net>	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>	 <49ADE077.1060606@kernel.org>  <1236138205.6119.12.camel@marge.simson.net> <1236147277.6049.3.camel@marge.simson.net> <49AE2028.8040402@kernel.org>
In-Reply-To: <49AE2028.8040402@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 09:38:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, Mike.
> 
> Mike Galbraith wrote:
>> On Wed, 2009-03-04 at 04:43 +0100, Mike Galbraith wrote:
>>> On Wed, 2009-03-04 at 10:59 +0900, Tejun Heo wrote:
>>>
>>>> I can't reproduce the problem here.
>>> Guess I'll have to sharpen a stick or two then.
>> With monkey-see-monkey-do-stick, box becomes happy camper again.
>>
>> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
>> index c29f301..bc9972a 100644
>> --- a/arch/x86/kernel/setup_percpu.c
>> +++ b/arch/x86/kernel/setup_percpu.c
>> @@ -256,6 +256,11 @@ static struct page * __init pcpue_get_page(unsigned int cpu, int pageno)
>>  			    + ((size_t)pageno << PAGE_SHIFT));
>>  }
>>  
>> +static void __init embed_populate_pte(unsigned long addr)
>> +{
>> +	populate_extra_pte(addr);
>> +}
>> +
>>  static ssize_t __init setup_pcpu_embed(size_t static_size)
>>  {
>>  	unsigned int cpu;
>> @@ -284,10 +289,15 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
>>  	pr_info("PERCPU: Embedded %zu pages at %p, static data %zu bytes\n",
>>  		pcpue_unit_size >> PAGE_SHIFT, pcpue_ptr, static_size);
>>  
>> +#if 0
>>  	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
>>  				      pcpue_unit_size,
>>  				      pcpue_unit_size - static_size, pcpue_ptr,
>>  				      NULL);
>> +#else
>> +	return pcpu_setup_first_chunk(pcpue_get_page, static_size,
>> +				      0, 0, NULL, embed_populate_pte);
>> +#endif
>>  }
> 
> That isn't quite correct but is still very interesting that it fixes
> the build issue.  Super weird.  I'm almost done setting up 11.0 system.
> I'll dig into it as soon as I'm done with sata_nv -stable issue.

Hmm... on my openSUSE 11.0 it builds just fine.

  $ gcc --version
  gcc (SUSE Linux) 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036]
  Copyright (C) 2008 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  $ ld --version
  GNU ld (GNU Binutils; openSUSE 11.0) 2.18.50.20080409-11.1
  Copyright 2007 Free Software Foundation, Inc.
  This program is free software; you may redistribute it under the terms of
  the GNU General Public License version 3 or (at your option) a later version.
  This program has absolutely no warranty.

I've used the config file you attached and the commit ID I used is
d0c4f570276cb4d2dc4215b90eb7cb6e2bdd4a15.

I wonder what is going on.  I'll try again with
89c9215165ca609096e845926d9a18f1306176a4.  Argh... weird.

Thanks.

--
tejun
