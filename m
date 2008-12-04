Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYLDVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYLDVKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYLDVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:10:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:58224 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYLDVKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:10:08 -0500
Message-ID: <493846E1.7010104@kernel.org>
Date: Thu, 04 Dec 2008 13:08:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost> <20081204123335.GP6703@one.firstfloor.org> <20081204153411.GA18306@elte.hu>
In-Reply-To: <20081204153411.GA18306@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> The exception raised on dereferencing mpf or mpf_found.
>> This obvious patch should fix it then. Does it?
>>
>> --
>>
>> Fix early exception in __get_smp_config with nosmp
>>
>> Bail out early when there is no MP table.
>>
>> Reported by Wu Fengguang
>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>
>> ---
>>  arch/x86/kernel/mpparse.c |    3 +++
>>  1 file changed, 3 insertions(+)
> 
> applied to tip/x86/urgent, thanks Andi!
> 

looks like his system doesn't have mps table.
and when maxcpus=0, or nosmp will cause skip_ioapic_setup = 1, and acpi_ioapic = 0

but smp_found_config is set acpi_boot_init.. with madt.

could move that check earlier

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 0f4c1fd..18f90af 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -586,6 +586,9 @@ static void __init __get_smp_config(unsigned int early)
 {
 	struct intel_mp_floating *mpf = mpf_found;
 
+	if (!mpf)
+		return;
+
 	if (x86_quirks->mach_get_smp_config) {
 		if (x86_quirks->mach_get_smp_config(early))
 			return;
@@ -604,9 +607,6 @@ static void __init __get_smp_config(unsigned int early)
 		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
 		       "configuration information\n");
 
-	if (!mpf)
-		return;
-
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
 	       mpf->mpf_specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)



YH
