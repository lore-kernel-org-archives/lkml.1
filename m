Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939Ab0AUUCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0AUUCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566Ab0AUUCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:02:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:53412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab0AUUCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:02:41 -0500
Message-ID: <4B58B2AC.5050906@kernel.org>
Date: Thu, 21 Jan 2010 12:01:48 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 04/36] x86/pci: add cap_resource
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org> <1264055303-15123-5-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1001210745330.13231@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001210745330.13231@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2010 07:49 AM, Linus Torvalds wrote:
> 
> 
> On Wed, 20 Jan 2010, Yinghai Lu wrote:
>>
>> -v2: hpa said we should compare with (resource_size_t)~0
> 
> Hmm. Some of these look dubious.
> 
>> diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
>> index f939d60..b267919 100644
>> --- a/arch/x86/pci/bus_numa.c
>> +++ b/arch/x86/pci/bus_numa.c
>> @@ -60,6 +60,9 @@ void __devinit update_res(struct pci_root_info *info, size_t start,
>>  	if (start > end)
>>  		return;
>>  
>> +	if (start == (resource_size_t)~0)
>> +		return;
> 
> Here, 'start' isn't a resource_size_t. It's a regular size_t. And if 
> resource_size_t is u64, and size_t is u32, this test can never be true.
> 
> Maybe that is intentional, but if looks odd/wrong. Needs a comment if 
> right, needs fixing if wrong.

you are right, there are two patches about that already went into pci/linux-next

will ask Jesse to drop them from pci tree.

so could make them go via tip/x86

http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=f84fe8aef6e4b23ab58175a15dd12c197c993f81
http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commitdiff;h=693f084f82a38fc1b01e3b05664a6fe014a3488a

or later may have merge problem.


> 
>> +static inline resource_size_t cap_resource(u64 val)
>> +{
>> +	if (val > (resource_size_t)~0)
>> +		return (resource_size_t)~0;
>> +	else
>> +		return val;
>> +}
>>  #endif
> 
> And this just looks odd. I'd suggest just doing
> 
> 	#define MAX_RESOURCE ((resource_size_t)~0)
> 
> 	static inline resource_size_t cap_resource(u64 val)
> 	{
> 		if (val > MAX_RESOURCE)
> 			val = MAX_RESOURCE;
> 		return val;
> 	}
> 
> instead, which looks a whole lot more natural. No?

OK

Yinghai
