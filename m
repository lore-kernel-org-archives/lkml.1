Return-Path: <linux-kernel-owner+w=401wt.eu-S1751232AbZHXB5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbZHXB5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZHXB53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:57:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbZHXB52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:57:28 -0400
Message-ID: <4A91F401.3010904@redhat.com>
Date: Mon, 24 Aug 2009 09:59:29 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, nhorman@redhat.com, ebiederm@xmission.com,
       andi@firstfloor.org, mingo@elte.hu, bernhard.walle@gmx.de,
       fenghua.yu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
       avorontsov@ru.mvista.com
Subject: Re: [Patch 5/8] ia64: implement crashkernel=auto
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>	<20090821065729.4855.47860.sendpatchset@localhost.localdomain> <20090821172407.d3a5cd2b.akpm@linux-foundation.org>
In-Reply-To: <20090821172407.d3a5cd2b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 21 Aug 2009 02:55:04 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> +#ifdef CONFIG_KEXEC_AUTO_RESERVE
>> +#define ARCH_HAS_DEFAULT_CRASH_SIZE
>> +static inline
>> +unsigned long long arch_default_crash_size(unsigned long long total_size)
>> +{
>> +	if (total_size >= 4ULL<<30 && total_size < 12ULL<<30)
>> +		return 1ULL<<28;
>> +	else if (total_size >= 12ULL<<30 && total_size < 128ULL<<30)
>> +		return 1ULL<<29;
>> +	else if (total_size >= 128ULL<<30 && total_size < 256ULL<<30)
>> +		return 3ULL<<28;
>> +	else if (total_size >= 256ULL<<30 && total_size < 378ULL<<30)
>> +		return 1ULL<<30;
>> +	else if (total_size >= 318ULL<<30 && total_size < 512ULL<<30)
>> +		return 3ULL<<29;
>> +	else if (total_size >= 512ULL<<30 && total_size < 768ULL<<30)
>> +		return 2ULL<<30;
>> +	else if (total_size >= 768ULL<<30)
>> +		return 3ULL<<30;
>> +}
>> +#include <asm-generic/kexec.h>
>> +#endif
>>     
>
> a) Why on earth is this inlined?
>
> b) Please consider making arch_default_crash_size() a __weak
>    function.  You'll probably find the result to be pleasing.
>   

Good idea!

> c) If we can't use __weak then please don't add
>    ARCH_HAS_DEFAULT_CRASH_SIZE.  Instead do this trick:
>
>
> 	#ifndef arch_default_crash_size
> 	static inline unsigned long long arch_default_crash_size(unsigned long long total_size)
> 	{
> 		...
> 	}
> 	#define arch_default_crash_size arch_default_crash_size
> 	#endif
>
> 	because i) it's good to standardise on something and ii) one less
> 	symbol gets added to the kernel.
>   

Yes, agree. I will try b) which seems to be better than c).

> d) why is asm-generic/kexec.h only included in asm/kexec.h if
>    CONFIG_KEXEC_AUTO_RESERVE happened to be defined?  That makes no
>    sense - there may be a multitude of reasons why asm/kexec.h wants
>    to include asm-generic/kexec.h.
>
>   
Hmm, yes? kernel/kexec.c includes linux/kexec.h which already includes 
asm/kexec.h....



