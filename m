Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZJ1EIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZJ1EIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZJ1EIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:08:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36970 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZJ1EId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:08:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE7C396.7040109@jp.fujitsu.com>
Date: Wed, 28 Oct 2009 13:07:50 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Roland Dreier <rdreier@cisco.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com>
In-Reply-To: <4AE75DB9.3040702@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> Mike Travis wrote:
>> Hi Roland,
>>
>> I've found that I'm getting one of these lines for every cpu:
>>
>> mce: CPU supports 0 MCE banks

I believe my patch at last in this mail will solve this issue.

> A bit more info.  THe data above was from our simulator which
> apparently is not simulating mce very well.  On a live system
> I get 383 lines (for 383 additional cpus) with what appears to be
> redundant lines...
> 
> [    4.882085] CPU 1 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6
> SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18
> SHD:19 SHD:20 SHD:21
> [    4.978893] CPU 2 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6
> SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18
> SHD:19 SHD:20 SHD:21
> ...
> [    4.978893] CPU 2 MCA banks SHD:0 SHD:1 CMCI:2 CMCI:3 CMCI:5 SHD:6
> SHD:7 SHD:8 SHD:9 SHD:12 SHD:13 SHD:14 SHD:15 SHD:16 SHD:17 SHD:18
> SHD:19 SHD:20 SHD:21

Hum, I suppose the line for CPU 0 was slightly different from others,
because SHD means "this bank is shared bank and controlled by other".
Maybe:
 CPU 0 MCA banks CMCI:0 CMCI:1 CMCI:2 CMCI:3 CMCI:5 ... CMCI:21

But I agree that we could some work for this messages...
Is it better to change the message level to debug from info?
How about changing the format like:
  CPU 0 MCA banks map : CCCC PCCC CCPP CCCC CCCC CC
  CPU 1 MCA banks map : ssCC PCss ssPP ssss ssss ss
   :

If there are no complains, I'll make another patch to do so.


Thanks,
H.Seto

===

Subject: [PATCH] x86, mce: disable MCE if cpu has no MCE banks

If cpu has no MCE banks (e.g. simulated processor on VMs), it is better to
disable MCE support on the system since we cannot handle MCE well.

Reported-by: Mike Travis <travis@sgi.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8080170..29055ab 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1228,6 +1228,10 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
+	if (!b) {
+		pr_info("MCE: no MCE banks - not enabling MCE support.\n");
+		return -ENODEV;
+	}
 	if (!banks)
 		printk(KERN_INFO "mce: CPU supports %d MCE banks\n", b);
 
-- 
1.6.5.2


