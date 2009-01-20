Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZATGgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZATGgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 01:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZATGgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 01:36:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZATGgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 01:36:39 -0500
Message-ID: <497570E5.2090702@zytor.com>
Date: Mon, 19 Jan 2009 22:36:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 to dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com>            <20090119215736.GE31356@linux-os.sc.intel.com> <85492.1232422525@turing-police.cc.vt.edu>
In-Reply-To: <85492.1232422525@turing-police.cc.vt.edu>
Content-Type: multipart/mixed;
 boundary="------------060508000605040101080200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060508000605040101080200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 19 Jan 2009 13:57:36 PST, Suresh Siddha said:
> 
>> Though the bios is the culprit and this option will severely limit
>> the cpu capabilities that OS can take advantage of, OS should fallback
>> to a safer mode. I will have a patch for it.
>>
>> Also, I wonder, if we should complain/scream during boot if we find only
>> fewer cpuid levels on modern generation cpu's.
> 
> I think a KERN_INFO "Core2 E9700 expected 6 cpuid levels, got 4"
> would possibly be a good idea.
> 
> Might be a good idea to check what happens under VMWare and similar though, it
> looks like the type of thing a hypervisor is likely to do something odd to us...

I think a much better idea is to just clear the MSR bit.  Attached is a
patch to do exactly that, which I will commit after testing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------060508000605040101080200
Content-Type: text/x-patch;
 name="cpuid.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuid.diff"

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8ea6929..1107015 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,6 +29,16 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
+	/* If MSR_IA32_MISC_ENABLE exists, unmask CPUID levels if masked */
+	if (!rdmsrl_safe(MSR_IA32_MISC_ENABLE, &misc_enable)) {
+		if (misc_enable & (1 << 22)) {
+			misc_enable &= ~(1 << 22);
+			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		}
+	}
+
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);

--------------060508000605040101080200--
