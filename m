Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbZHYB0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbZHYB0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZHYB0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:26:35 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:58961 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbZHYB0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:26:34 -0400
Date: Mon, 24 Aug 2009 18:26:32 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825012632.GB6842@localdomain>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A932809.1000103@kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 04:53:45PM -0700, Yinghai Lu wrote:
>Ravikiran G Thirumalai wrote:
>> 
>> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> 
>> Index: linux-2.6.31-rc6/arch/x86/kernel/apic/apic_flat_64.c
>> ===================================================================
>> --- linux-2.6.31-rc6.orig/arch/x86/kernel/apic/apic_flat_64.c	2009-08-21 12:42:16.000000000 -0700
>> +++ linux-2.6.31-rc6/arch/x86/kernel/apic/apic_flat_64.c	2009-08-21 14:12:21.654837472 -0700
>> @@ -161,7 +161,8 @@ static int flat_apic_id_registered(void)
>>  
>>  static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
>>  {
>> -	return initial_apic_id >> index_msb;
>> +	return cpu_has_apic ? hard_smp_processor_id() >> index_msb :
>> +	    initial_apic_id >> index_msb;
>>  }
>
>it seems we should use initial apic id here.
>

Why?  The specs seem to indicate otherwise unless I am mistaken --
Intel  systems programming guide, Vol 3A Part1, chapter 7 section
7.5.5 - Identifying Logical Processors in a MP system:
<quote>
After the BIOS has completed the MP initialization protocol, each logical
processor can be uniquely identified by its local APIC ID. Software can
access these APIC IDs in either of the following ways
</quote>
phys_pkg_id() indicates that the logical package id is being looked up,
so local apic id should be used here no?
What am I missing?


>can you check which calling for vsmp cause the problem?
>arch/x86/kernel/cpu/addon_cpuid_features.c:     c->cpu_core_id = apic->phys_pkg_id(c->initial_apicid, ht_mask_width)
>arch/x86/kernel/cpu/addon_cpuid_features.c:     c->phys_proc_id = apic->phys_pkg_id(c->initial_apicid, core_plus_mask_width
>);
>arch/x86/kernel/cpu/addon_cpuid_features.c:     c->apicid = apic->phys_pkg_id(c->initial_apicid, 0);

The above are definitely problematic.  Anyplace that uses phys_pkg_id to get
the unique pkg id of a logical processor will have problems.
