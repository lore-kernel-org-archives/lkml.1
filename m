Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYIZAoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYIZAoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 20:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYIZAo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 20:44:29 -0400
Received: from mga12.intel.com ([143.182.124.36]:45411 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbYIZAo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 20:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,309,1220252400"; 
   d="scan'208";a="51551522"
Message-ID: <48DC3077.1080905@linux.intel.com>
Date: Thu, 25 Sep 2008 17:44:39 -0700
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net
Subject: Re: [PATCH] oprofile: Implement Intel architectural perfmon support
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org> <1219250433-25516-2-git-send-email-andi@firstfloor.org> <1219250433-25516-3-git-send-email-andi@firstfloor.org> <20080925200048.GI23557@erda.amd.com>
In-Reply-To: <20080925200048.GI23557@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> On 20.08.08 18:40:31, Andi Kleen wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> Newer Intel CPUs (Core1+) have support for architectural
>> events described in CPUID 0xA. See the IA32 SDM Vol3b.18 for details.
>>
>> The advantage of this is that it can be done without knowing about
>> the specific CPU, because the CPU describes by itself what
>> performance events are supported. This is only a fallback
>> because only a limited set of 6 events are supported.
>> This allows to do profiling on Nehalem and on Atom systems
>> (later not tested)
>>
>> This patch implements support for that in oprofile's Intel
>> Family 6 profiling module. It also has the advantage of supporting
>> an arbitary number of events now as reported by the CPU.
>> Also allow arbitary counter widths >32bit while we're at it.
>>
>> Requires a patched oprofile userland to support the new
>> architecture.
>>
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>> ---
>>  Documentation/kernel-parameters.txt |    5 ++
>>  arch/x86/oprofile/nmi_int.c         |   32 +++++++++--
>>  arch/x86/oprofile/op_model_ppro.c   |  104 +++++++++++++++++++++++++++-------
>>  arch/x86/oprofile/op_x86_model.h    |    3 +
>>  4 files changed, 116 insertions(+), 28 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index 056742c..10c8b1b 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1486,6 +1486,11 @@ and is between 256 and 4096 characters. It is defined in the file
>>  	oprofile.timer=	[HW]
>>  			Use timer interrupt instead of performance counters
>>  
>> +	oprofile.force_arch_perfmon=1 [X86]
>> +			Force use of architectural perfmon performance counters
>> +			in oprofile on Intel CPUs.  The kernel selects the
>> +			correct default on its own.
>> +
> 
> Could you create a separate patch that introduces this new kernel
> parameter? 

The parameter only makes sense together with something which uses it.
So an additional one liner patch ( + docs) would be a patch depending on
the earlier arch perfmon patch. If you want that really I can do it, but
frankly it doesn't make sense to me.

It's only really a debugging feature, I can also just take it out
if it's a problem.

> This would make it easier to send all other changes
> upstream. We already discussed the need of this parameter.

I thought the result of the discussion was that it was not useful
because there's no equivalent on arch perfmon on any other x86 CPUs?
IBS is still not architectural, but family/model specific.

> Maybe it
> would fit better to have a more generalized paramater for this that
> could be reused then by other archs/models as well. Something like
> force_pmu_detection that could be used for all new CPUs (also other
> models) that do not yet have a specific kernel implementation.

You mean something like pmu=<oprofile arch string> to force
use of that?

> Even better would a sysfs entry instead with that we can specify which
> cpu type to use:

module param is already in sysfs.

>  echo "i386/arch_perfmon" > /sys/module/oprofile/parameters/cpu_type
> 
> That would allow us to switch the pmu at runtime and also from the
> userland.

Switching at runtime would be complicated changes I think

Also

