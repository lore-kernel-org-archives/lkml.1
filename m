Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbZH1UIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbZH1UIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZH1UId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:08:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:52224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbZH1UIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,292,1249282800"; 
   d="scan'208";a="443639958"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Amerigo Wang'" <amwang@redhat.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'Anton Vorontsov'" <avorontsov@ru.mvista.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'Neil Horman'" <nhorman@redhat.com>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'kamezawa.hiroyu@jp.fujitsu.com'" <kamezawa.hiroyu@jp.fujitsu.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'Michael Ellerman'" <michael@ellerman.id.au>,
       "'M. Mohan Kumar'" <mohan@in.ibm.com>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'bernhard.walle@gmx.de'" <bernhard.walle@gmx.de>,
       "'Ingo Molnar'" <mingo@elte.hu>
Date: Fri, 28 Aug 2009 13:08:30 -0700
Subject: RE: [Patch 4/8] ia64: implement crashkernel=auto
Thread-Topic: [Patch 4/8] ia64: implement crashkernel=auto
Thread-Index: AconxqhuCDJGDS2gTyGijKY6fQMfrgAU54Cw
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B954B3BB@orsmsx505.amr.corp.intel.com>
References: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
 <20090827031848.4534.40440.sendpatchset@localhost.localdomain>
 <A6AD88C3F2289247BE726C37303E1EB8B949E358@orsmsx505.amr.corp.intel.com>
 <4A965F3A.5070007@redhat.com>
 <A6AD88C3F2289247BE726C37303E1EB8B949E7A3@orsmsx505.amr.corp.intel.com>
 <4A97ABA9.8030604@redhat.com>
In-Reply-To: <4A97ABA9.8030604@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> +	unsigned long long ret;
>>>>> +
>>>>> +	if (total_size >= GBYTES(4) && total_size < GBYTES(12))
>>>>> +		ret = MBYTES(256);
>>>>> +	else if (total_size >= GBYTES(12) && total_size < GBYTES(128))
>>>>> +		ret = MBYTES(512);
>>>>> +	else if (total_size >= GBYTES(128) && total_size < GBYTES(256))
>>>>> +		ret = MBYTES(768);
>>>>> +	else if (total_size >= GBYTES(256) && total_size < GBYTES(378))
>>>>> +		ret = MBYTES(1024);
>>>>> +	else if (total_size >= GBYTES(318) && total_size < GBYTES(512))
>>>>> +		ret = MBYTES(1536);
>>>>> +	else if (total_size >= GBYTES(512) && total_size < GBYTES(768))
>>>>> +		ret = MBYTES(2048);
>>>>> +	else
>>>>> +		ret = MBYTES(3072);
>>>>> +	if (!ia64_platform_is("sn2") && !ia64_platform_is("uv"))
>>>>> +		if (ret > GBYTES(4))
>>>>> +			ret = ret / GBYTES(4) * MBYTES(256);
>>>>>
>>>>>
>>>> This code doesn't make sense to me. What you really want is following
>>>>
>>> code, right?
>>>
>>>> +		if (total_size > GBYTES(4))
>>>> +			ret = total_size / GBYTES(4) * MBYTEST(256)
>>>>
>>>>
>>>>
>>> Nope. Check check_crashkernel_memory().
>>>
>>
>> This statement will be ALWAYS false:
>> +		if (ret > GBYTES(4))
>> since ret's max value is 3GB after the above total_size checks.
>>
>> So the code doesn't make sense. Did I miss something?
>>
>
>Oops, in fact it was supposed to be:
>
>  if (ret + base > GBYTES(4))
>    //blah blah
>
>Hmm, but is it possible for ia64 to choose a base address above 1G? If
>no, that code can be removed.

I think you don't need to consider the base here. This arch_default_crash_size() only returns size. Later on, ia64 setup_crashkernel() will find a base value in reserved region and check if the base value is under 4GB etc.

Thanks.

-Fenghua
