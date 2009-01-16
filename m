Return-Path: <linux-kernel-owner+w=401wt.eu-S1765848AbZAPXWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765848AbZAPXWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZAPXWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:22:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:35793 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761563AbZAPXWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:22:18 -0500
Message-ID: <497116A8.5080900@sgi.com>
Date: Fri, 16 Jan 2009 15:22:16 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: put trigger in to detect mismatched apic versions.
References: <49704DF6.8040205@sgi.com> <20090116092540.GC4305@elte.hu> <4970C984.30202@sgi.com> <20090116223011.GB3899@elte.hu>
In-Reply-To: <20090116223011.GB3899@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Hi Ingo,
>>
>> I did notice that the versions all came up the same, and that the checks 
>> were very specific.  I was trying to be as transparent and unintrusive 
>> as possible.  Since there's so few calls, I though this was a good 
>> approach but apparently I was wrong.
>>
>> I like the idea of collapsing the array down to one and checking to see 
>> if all apic's have the same version, but is this really the case? Must 
>> all apics be the same?
> 
> Could you please send a patch that doesnt change the code, only adds a 
> 'boot APIC version' kind of variable as an apic_version __read_mostly 
> variable and does a WARN_ONCE() if that mismatches? We can then stick that 
> into -tip and see whether it triggers.
> 
> The max array size is ~128K, right? So if the WARN_ONCE() does not 
> trigger, we can just drop the array and use the central apic_version 
> variable ...
> 
> And even if it _does_ trigger, the version incompatibilities between APIC 
> protocols are very rare. They only happen across wildly different CPU 
> architectures like when going from very old external apics to integrated 
> apics, or going from apics to x-apics. We wont see any mixing across those 
> boundaries.
> 
> 	Ingo

Btw, I checked with our UV architect and the problem is that we need a
16 bit apic id which is what caused the MAX_APICS to be bumped to 32k.
The lower 8 bits are the normal apic id, and the upper bit relate to
the node.  This means cpu 0 on node 0 has the same apic id as cpu 0 on
node 1, etc.  I also asked about whether we could rely on always having
the same apic version, and the answer was yes, though it's really only
relevant between the cpus on a node.

Thanks,
Mike
--- 
Subject: x86: put trigger in to detect mismatched apic versions.

Fire off one message if two apic's discovered with different
apic versions.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic.c |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/apic.c
@@ -1833,6 +1833,11 @@ void __cpuinit generic_processor_info(in
 	num_processors++;
 	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
+	if (version != apic_version[boot_cpu_physical_apicid])
+		WARN_ONCE(1,
+			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
 		/*

