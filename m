Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZHYFNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZHYFNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 01:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZHYFNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 01:13:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:37096 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZHYFNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 01:13:07 -0400
Message-ID: <4A9372A1.9090905@kernel.org>
Date: Mon, 24 Aug 2009 22:12:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain>
In-Reply-To: <20090825012632.GB6842@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Mon, Aug 24, 2009 at 04:53:45PM -0700, Yinghai Lu wrote:
>> Ravikiran G Thirumalai wrote:
>>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>>
>>> Index: linux-2.6.31-rc6/arch/x86/kernel/apic/apic_flat_64.c
>>> ===================================================================
>>> --- linux-2.6.31-rc6.orig/arch/x86/kernel/apic/apic_flat_64.c	2009-08-21 12:42:16.000000000 -0700
>>> +++ linux-2.6.31-rc6/arch/x86/kernel/apic/apic_flat_64.c	2009-08-21 14:12:21.654837472 -0700
>>> @@ -161,7 +161,8 @@ static int flat_apic_id_registered(void)
>>>  
>>>  static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
>>>  {
>>> -	return initial_apic_id >> index_msb;
>>> +	return cpu_has_apic ? hard_smp_processor_id() >> index_msb :
>>> +	    initial_apic_id >> index_msb;
>>>  }
>> it seems we should use initial apic id here.
>>
> 
> Why?  The specs seem to indicate otherwise unless I am mistaken --
> Intel  systems programming guide, Vol 3A Part1, chapter 7 section
> 7.5.5 - Identifying Logical Processors in a MP system:
> <quote>
> After the BIOS has completed the MP initialization protocol, each logical
> processor can be uniquely identified by its local APIC ID. Software can
> access these APIC IDs in either of the following ways
> </quote>
> phys_pkg_id() indicates that the logical package id is being looked up,
> so local apic id should be used here no?
> What am I missing?

initial apic id : it can not changed, there is fixed mapping from that to physical processor id aka socket id / node id.

apic id: could be changed by BIOS to any value. there is no good way to get phys_pkg_id from that.

> 
> 
>> can you check which calling for vsmp cause the problem?
>> arch/x86/kernel/cpu/addon_cpuid_features.c:     c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
>> arch/x86/kernel/cpu/addon_cpuid_features.c:     c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width
>> );
>> arch/x86/kernel/cpu/addon_cpuid_features.c:     c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);
> 
> The above are definitely problematic.  Anyplace that uses phys_pkg_id to get
> the unique pkg id of a logical processor will have problems.

that is from intel new cpuid(0x0b) leaf, that is with initial_apicid according to intel EDS.

we need to figure out your initial apic id. and find out good way for phys_pkg_id.
and may need to modify apic->phys_pkg_id member according to dmi info.

YH
