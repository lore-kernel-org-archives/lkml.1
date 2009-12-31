Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZLaDB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZLaDB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 22:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZLaDB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 22:01:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbZLaDB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 22:01:27 -0500
Message-ID: <4B3C1397.8040307@cn.fujitsu.com>
Date: Thu, 31 Dec 2009 10:59:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf tools: adjust symbol address
References: <4B3AC5CD.1000502@cn.fujitsu.com> <4B3AC69F.4070901@cn.fujitsu.com> <20091230131016.GC2956@ghostprotocols.net>
In-Reply-To: <20091230131016.GC2956@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 30, 2009 at 11:18:55AM +0800, Xiao Guangrong escreveu:
>> Using relocation offset adjust symbol address if we get
>> kernel symbol name form elf file
>>
>> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
>> index 79ca6a0..5b58d34 100644
>> --- a/tools/perf/util/symbol.c
>> +++ b/tools/perf/util/symbol.c
>> @@ -19,6 +19,18 @@
>>  #define NT_GNU_BUILD_ID 3
>>  #endif
>>  
>> +static s32 relocate_offset;
>> +void update_relocate_offset(s32 offset)
>> +{
>> +	relocate_offset = offset;
>> +}
>> +
>> +static inline void update_kernel_address(GElf_Sym *sym, bool kernel)
>> +{
>> +	if (kernel)
>> +		sym->st_value += relocate_offset;
>> +}
> 
> This should be done on the dso level, we may process multiple kernels,
> some with relocation, some without.
> 

Sorry, what does the 'multiple kernels' means?
vmlinux* not know it's relocation or not, and we just handle the _specific_
kernel at the time which match the current system. 

And i think adjust symbol address on the dso level is not a good idea since
we hardly know it's a module address or kernel address on dso level, i.e.
hardly to know whether the address need adjust.

> Humm, even at the _map_ level, because then we can just use the normal
> map_ip mechanism, this time the not using the identity map stuff, i.e.
> we have to get an IP from some event, then subtract the relocate_offset
> that will be in map->start.
> 

The 'inject' event is the first event in perf.data since we inject it at the
first counter file and inject 'relocation offset' before enable event, i.e.
before getting symbol address we have got the 'relocation offset' already.

Thanks,
Xiao
