Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZHYUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZHYUgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZHYUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:36:44 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:47557 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbZHYUgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:36:43 -0400
Date: Tue, 25 Aug 2009 13:36:41 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825203640.GG6456@localdomain>
References: <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org> <alpine.LFD.2.01.0908251155570.3218@localhost.localdomain> <20090825191231.GA22821@elte.hu> <4A9438D1.4030608@kernel.org> <20090825192416.GA6974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825192416.GA6974@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 09:24:16PM +0200, Ingo Molnar wrote:
>> ...
>> > Furthermore, commit 2759c3287 did not declare any side-effects and 
>> > clearly causes a side-effect on vSMP which apparently has an 
>> > overlapping set of initial APIC ids.
>> > 
>> > Ravikiran, your patch does not do a clear revert of this bit though. 
>> > If you do a plain revert of the line above alone, does that fix the 
>> > problem too?
>> 
>> how about patch phys_pkg_id for vsmp?
>> 
>> diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
>> index f3b1037..65edc18 100644
>> --- a/arch/x86/kernel/apic/probe_64.c
>> +++ b/arch/x86/kernel/apic/probe_64.c
>> @@ -44,6 +44,11 @@ static struct apic *apic_probe[] __initdata = {
>>  	NULL,
>>  };
>>  
>> +static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
>> +{
>> +	return hard_smp_processor_id() >> index_msb;
>> +}
>> +
>>  /*
>>   * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
>>   */
>> @@ -69,6 +74,11 @@ void __init default_setup_apic_routing(void)
>>  		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
>>  	}
>>  
>> +	if (is_vsmp_box()) {
>> +		/* need to update phys_pkg_id */
>> +		apic->phys_pkg_id = apicid_phys_pkg_id;
>> +	}
>
>Hm, this is rather tempting simply because it only affects vSMP 
>systems and we are in late -rc's. Ravikiran, does Yinghai's patch 
>solve the crash for you too?
>

Yes it does.  Tested and confirmed.

Thanks,
Kiran
