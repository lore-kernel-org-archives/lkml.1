Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbXK0JiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbXK0JiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXK0Jh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:37:59 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37651 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbXK0Jh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:37:58 -0500
Message-Id: <474BE583.2080000@mxs.nes.nec.co.jp>
Date: Tue, 27 Nov 2007 18:38:11 +0900
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kexec-ml <kexec@lists.infradead.org>, lkml <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 4/5] Fix the configuration dependencies
References: <473CFE14.3010400@mxs.nes.nec.co.jp>	<473D0170.1060304@mxs.nes.nec.co.jp> <20071125235843.69440d4a.akpm@linux-foundation.org>
In-Reply-To: <20071125235843.69440d4a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Andrew Morton wrote:
>> diff -rpuN a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
>> --- a/arch/x86/kernel/machine_kexec_64.c	2007-11-14 15:39:19.000000000 +0900
>> +++ b/arch/x86/kernel/machine_kexec_64.c	2007-11-14 15:39:33.000000000 +0900
>> @@ -235,7 +235,7 @@ void arch_crash_save_vmcoreinfo(void)
>>  {
>>  	VMCOREINFO_SYMBOL(init_level4_pgt);
>>  
>> -#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
>> +#ifdef CONFIG_NUMA
>>  	VMCOREINFO_SYMBOL(node_data);
>>  	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
>>  #endif
>> _
>>
> 
> x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch removes the
> `VMCOREINFO_SYMBOL(node_data);' from arch/x86/kernel/machine_kexec_64.c
> altogether, so I dropped that part of your patch.

The above part is necessary for a NUMA kernel.
Could you please merge the attached patch ?

I guess that Christoph Lameter deleted the above part (which is added
by the attached patch again) with the other part of discontigmem lines,
because it depended on CONFIG_ARCH_DISCONTIGMEM_ENABLE.
But the dependency was wrong, and it should depend on CONFIG_NUMA.
The part is necessary for a NUMA kernel even if sparsemem.


Thanks
Ken'ichi Ohmichi

---
Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
---
diff -rpuN a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c	2007-11-27 13:36:32.000000000 +0900
+++ b/arch/x86/kernel/machine_kexec_64.c	2007-11-27 13:37:37.000000000 +0900
@@ -234,5 +234,10 @@ NORET_TYPE void machine_kexec(struct kim
 void arch_crash_save_vmcoreinfo(void)
 {
 	VMCOREINFO_SYMBOL(init_level4_pgt);
+
+#ifdef CONFIG_NUMA
+	VMCOREINFO_SYMBOL(node_data);
+	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
+#endif
 }
 
_
