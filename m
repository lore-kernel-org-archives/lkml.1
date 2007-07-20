Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXGTRWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXGTRWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXGTRWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:22:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbXGTRWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:22:37 -0400
Message-ID: <46A0EF4D.6030308@zytor.com>
Date: Fri, 20 Jul 2007 10:22:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH] Use wbinvd() macro instead of raw inline assembly in
 .c files
References: <1184885740.16311.19.camel@t60> <200707201343.59962.ak@suse.de>
In-Reply-To: <200707201343.59962.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Friday 20 July 2007 00:55:40 Glauber de Oliveira Costa wrote:
>> This patch uses the already-existant wbinvd() macro to replace
>> raw assembly to perform this very same task in some .c files
>>     
>> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>>
>> diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
>> index f61fb8e..afbb951 100644
>> --- a/arch/x86_64/kernel/tce.c
>> +++ b/arch/x86_64/kernel/tce.c
>> @@ -42,7 +42,7 @@ static inline void flush_tce(void* tceaddr)
>>  	if (cpu_has_clflush)
>>  		asm volatile("clflush (%0)" :: "r" (tceaddr));
>>  	else
>> -		asm volatile("wbinvd":::"memory");
>> +		wbinvd();
> 
> I guess it can be just removed there. I don' think there are any calgary 
> machines without clflush
> 

That seems like an unsafe thing to do (unless we err out somewhere);
lest there is, say, a microcode update disabling clflush due to an erratum.

It also seems to me we should have a macro for clflush(), especially
since it is "clflush (%0)" :: "r" in a number of places, which really
isn't correct; it should be "clflush %0" : "+m", both to allow
addressing modes to be used and to give gcc a modicum of a hint that
something is going on with a specific memory location.

	-hpa
