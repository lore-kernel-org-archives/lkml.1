Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZHIBaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZHIBaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 21:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbZHIBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 21:30:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZHIBaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 21:30:17 -0400
Message-ID: <4A7E262A.9020606@zytor.com>
Date: Sat, 08 Aug 2009 18:28:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ondrej Zary <linux@rainbow-software.org>, tglx@linutronix.de,
       mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OOPS in identify_cpu() on CPUs without CPUID
References: <200908081908.12240.linux@rainbow-software.org> <20090808175344.GA8099@elte.hu>
In-Reply-To: <20090808175344.GA8099@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2009 10:53 AM, Ingo Molnar wrote:
> 
> indeed ...
> 
>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>>
>> --- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10 05:05:27.000000000 +0200
>> +++ linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-08 18:00:21.000000000 +0200
>> @@ -699,6 +699,7 @@
>>  
>>  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>>  {
>> +	this_cpu = &default_cpu;
>>  	c->extended_cpuid_level = 0;
>>  
>>  	if (!have_cpuid_p())
> 
> How about initializing this_cpu instead, via:
> 
> static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
> 

The whole this_cpu hack is scary as all hell... although it's probably
OK on a technicality, it takes what is properly a per-cpu attribute and
turns it into a static global.

We *should* be able to initialize the APs (at least) in parallel, and
although there probably aren't any systems in the field which don't have
duplicate vendors, it is at least theoretically possible to have
combinations of CPUID and non-CPUID processors in the same systems.

As such, it really would be better if this_cpu was changed to be passed
as return values and on the stack (as appropriate).  However, that is
not 2.6.31 material, and as such doing the static initialization would
be okay.

Ondrej, would you be interested in doing a "fullblown" patch for this?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

