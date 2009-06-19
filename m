Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbZFSGyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbZFSGyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZFSGyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:54:44 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44149 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbZFSGyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:54:43 -0400
Message-ID: <4A3B3633.3000507@snapgear.com>
Date: Fri, 19 Jun 2009 16:54:43 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, gerg@uclinux.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] m68k: merge the mmu and non-mmu versions of checksum.h
References: <200906170711.n5H7BFw9009030@localhost.localdomain> <20090618194521.GA7464@infradead.org>
In-Reply-To: <20090618194521.GA7464@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Hellwig wrote:
> On Wed, Jun 17, 2009 at 05:11:15PM +1000, Greg Ungerer wrote:
>> +#ifdef CONFIG_MMU
>>  /*
>>   *	This is a version of ip_compute_csum() optimized for IP headers,
>>   *	which always checksum on 4 octet boundaries.
>> @@ -59,6 +61,9 @@ static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
>>  		 : "memory");
>>  	return (__force __sum16)~sum;
>>  }
>> +#else
>> +__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
>> +#endif
> 
> Any good reason this is inline for all mmu processors and out of line
> for nommu, independent of the actual cpu variant?

I don't recall of the simple (and thus non-mmu) m68k variants
support all the instructions used in this optimized version.
I will check that. It might be that this is mis-placed and
is actually conditional on the CPU type.

The C code version is significantly bigger, I think that is why
it was not inlined here (see arch/m68knommu/lib/checksum.c)


>>  static inline __sum16 csum_fold(__wsum sum)
>>  {
>>  	unsigned int tmp = (__force u32)sum;
>> +#ifdef CONFIG_COLDFIRE
>> +	tmp = (tmp & 0xffff) + (tmp >> 16);
>> +	tmp = (tmp & 0xffff) + (tmp >> 16);
>> +	return (__force __sum16)~tmp;
>> +#else
>>  	__asm__("swap %1\n\t"
>>  		"addw %1, %0\n\t"
>>  		"clrw %1\n\t"
>> @@ -74,6 +84,7 @@ static inline __sum16 csum_fold(__wsum sum)
>>  		: "=&d" (sum), "=&d" (tmp)
>>  		: "0" (sum), "1" (tmp));
>>  	return (__force __sum16)~sum;
>> +#endif
>>  }
> 
> I think this would be cleaner by having totally separate functions
> for both cases, e.g.
> 
> #ifdef CONFIG_COLDFIRE
> static inline __sum16 csum_fold(__wsum sum)
> {
> 	unsigned int tmp = (__force u32)sum;
> 
> 	tmp = (tmp & 0xffff) + (tmp >> 16);
> 	tmp = (tmp & 0xffff) + (tmp >> 16);
> 
> 	return (__force __sum16)~tmp;
> }
> #else
> ...
> #endif

Ok, I will change that.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
