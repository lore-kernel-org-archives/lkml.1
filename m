Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbZKLGww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbZKLGww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 01:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZKLGwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 01:52:51 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40160 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZKLGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 01:52:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AFBB0B8.2070501@jp.fujitsu.com>
Date: Thu, 12 Nov 2009 15:52:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yong Wang <yong.y.wang@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, mce: fix __init annotations
References: <20091111075125.GA17900@ywang-moblin2.bj.intel.com> <4AFB9CFE.6010207@jp.fujitsu.com>
In-Reply-To: <4AFB9CFE.6010207@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> Yong Wang wrote:
>> @@ -268,7 +268,7 @@ void mcheck_intel_therm_init(void)
>>  		lvtthmr_init = apic_read(APIC_LVTTHMR);
>>  }
>>  
>> -void intel_init_thermal(struct cpuinfo_x86 *c)
>> +void __init intel_init_thermal(struct cpuinfo_x86 *c)
>>  {
>>  	unsigned int cpu = smp_processor_id();
>>  	int tm2 = 0;
> 
> But I think this could be called on hot-plugged AP.
> Should be __cpuinit ?
> 
> void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
>  ->  static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
>   ->  void mce_intel_feature_init(struct cpuinfo_x86 *c)
>    ->  void intel_init_thermal(struct cpuinfo_x86 *c)

I found it is called from resume path, so neither __init nor __cpuinit
will be applicable...

static int mce_resume(struct sys_device *dev)
 -> static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
  ->  void mce_intel_feature_init(struct cpuinfo_x86 *c)
   ->  void intel_init_thermal(struct cpuinfo_x86 *c)

Following patch is based on tip:perf/mce.


Thanks,
H.Seto

===

Subject: [PATCH] x86, mce: fix __init annotations

The intel_init_thermal() is called from resume path, so it cannot be
marked as __init.

OTOH mce_banks_init() is only called from __mcheck_cpu_cap_init()
which is marked as __cpuinit, so it can be also marked as __cpuinit.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c         |    4 ++--
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0d41020..5f277ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1201,7 +1201,7 @@ int mce_notify_irq(void)
 }
 EXPORT_SYMBOL_GPL(mce_notify_irq);
 
-static int mce_banks_init(void)
+static int __cpuinit __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
 
@@ -1242,7 +1242,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	WARN_ON(banks != 0 && b != banks);
 	banks = b;
 	if (!mce_banks) {
-		int err = mce_banks_init();
+		int err = __mcheck_cpu_mce_banks_init();
 
 		if (err)
 			return err;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 8a73d5c..4fef985 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -268,7 +268,7 @@ void __init mcheck_intel_therm_init(void)
 		lvtthmr_init = apic_read(APIC_LVTTHMR);
 }
 
-void __init intel_init_thermal(struct cpuinfo_x86 *c)
+void intel_init_thermal(struct cpuinfo_x86 *c)
 {
 	unsigned int cpu = smp_processor_id();
 	int tm2 = 0;
-- 
1.6.5.2


