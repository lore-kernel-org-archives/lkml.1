Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZKFO7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZKFO7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZKFO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:59:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56883 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbZKFO7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:59:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VVZT1MnVcekWDmDtmrnUFuuizdnAx4lBPHQwc1ZAdBoLZgCys/K9cIKPOj+sPOaW3N
         uvab0h8YrZT3Hs6gyOOU2/IBrYMuLt14WEBtRZEETmKYGducsJ3eewwHRZghwnzua+Vb
         5m2Mm3l3vTIkRLxv/FW77AsIs/9+gPvla5TEg=
MIME-Version: 1.0
In-Reply-To: <20091003072127.GC21407@elte.hu>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu>
From: Matteo Croce <technoboy85@gmail.com>
Date: Fri, 6 Nov 2009 15:59:16 +0100
Message-ID: <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 8:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Matteo Croce <technoboy85@gmail.com> wrote:
>
>> Hi,
>>
>> the AMD GEode LX has an x86 id of 5 (i586) tought it's technically an i686:
>>
>> root@alix:/usr/src# cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 5
>> model           : 10
>> model name      : Geode(TM) Integrated Processor by AMD PCS
>> stepping        : 2
>> cpu MHz         : 498.060
>> cache size      : 128 KB
>> fdiv_bug        : no
>> hlt_bug         : no
>> f00f_bug        : no
>> coma_bug        : no
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 1
>> wp              : yes
>> flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
>> mmxext 3dnowext 3dnow
>> bogomips        : 996.12
>> clflush size    : 32
>> cache_alignment : 32
>> address sizes   : 32 bits physical, 32 bits virtual
>> power management:
>>
>> indeed it has mmx, mmxext and cmov.
>> So I added the quirk below and I can confirm that the system is running fine.
>> I did an x264 encode to trigger any SIGILL due to missing opcodes, but
>> it worked.
>>
>> I also did this simple test which gives a ~2.5x speed boost:
>> http://pastebin.ca/1590089
>>
>> I wish some feedback from someone, I really dunno why AMD set the
>> cpuid value to 5
>>
>> --- a/arch/x86/kernel/cpu/bugs.c      2009-10-03 03:43:02.399323313 +0200
>> +++ b/arch/x86/kernel/cpu/bugs.c      2009-10-03 03:54:22.582205090 +0200
>> @@ -151,6 +151,12 @@
>>  #endif
>>  }
>>
>> +static void __init check_geode_i586(void)
>> +{
>> +     if(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
>> +        boot_cpu_data.x86_model == 10 && boot_cpu_data.x86 == 5)
>> +             boot_cpu_data.x86 = 6;
>> +}
>>
>>  void __init check_bugs(void)
>>  {
>> @@ -163,6 +169,7 @@
>>       check_fpu();
>>       check_hlt();
>>       check_popad();
>> +     check_geode_i586();
>>       init_utsname()->machine[1] =
>>               '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
>>       alternative_instructions();
>
> Looks good, but your signoff line is missing.
>
>        Ingo
>

The AMD Geode LX has an x86 id of 5 (i586) tought it's technically an i686:

root@alix:~# egrep '^(cpu family|model name|flags)' /proc/cpuinfo
cpu family      : 5
model name      : Geode(TM) Integrated Processor by AMD PCS
flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
mmxext 3dnowext 3dnow

indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
This patch adds a quirck to promote the Geode to an i686 and emulates
the NOPL in the do_invalid_op trap, so the userspace never notices.
Emulating the NOPL has minimum performance loss, emulating a NOPL
takes 0.5 usecs
and they are rarely used in x86

Signed-off-by: Matteo Croce <technoboy85@gmail.com>

--- a/arch/x86/kernel/Makefile	2009-11-06 15:06:52.246223989 +0100
+++ b/arch/x86/kernel/Makefile	2009-11-06 15:07:04.294054613 +0100
@@ -89,7 +89,7 @@
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o

 obj-$(CONFIG_K8_NB)		+= k8.o
-obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
+obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o nopl_emu.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o

--- a/arch/x86/kernel/cpu/amd.c	2009-11-06 15:06:52.254223805 +0100
+++ b/arch/x86/kernel/cpu/amd.c	2009-11-06 15:07:04.294054613 +0100
@@ -138,8 +138,10 @@
 	}

 	if (c->x86_model == 10) {
-		/* AMD Geode LX is model 10 */
-		/* placeholder for any needed mods */
+		/* Geode only lacks the NOPL instruction to be i686,
+		   but we can emulate it in the exception handler
+		   and promote it to a class 6 cpu */
+		boot_cpu_data.x86 = 6;
 		return;
 	}
 }
--- a/arch/x86/kernel/entry_32.S	2009-11-06 15:06:52.258224172 +0100
+++ b/arch/x86/kernel/entry_32.S	2009-11-06 15:07:04.306230613 +0100
@@ -901,7 +901,11 @@
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
+#ifdef CONFIG_MGEODE_LX
+	pushl $do_nopl_emu
+#else
 	pushl $do_invalid_op
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/arch/x86/kernel/nopl_emu.c	2009-11-06 15:07:33.537723795 +0100
@@ -0,0 +1,102 @@
+/*
+ *  linux/arch/x86/kernel/nopl_emu.c
+ *
+ *  Copyright (C) 2002  Willy Tarreau
+ *  Copyright (C) 2009  Matteo Croce
+ */
+
+#include <linux/sched.h>
+#include <linux/linkage.h>
+#include <linux/preempt.h>
+#include <linux/types.h>
+
+void do_invalid_op(struct pt_regs *regs, long error_code);
+
+/* This code can be used to allow the AMD Geode to hopefully correctly execute
+ * some code which was originally compiled for an i686, by emulating NOPL,
+ * the only missing i686 instruction in the CPU
+ *
+ * Willy Tarreau <willy@meta-x.org>
+ * Matteo Croce <technoboy85@gmail.com>
+ */
+
+static inline int do_1f(u8 *ip)
+{
+	int length = 3;
+	switch(*ip) {
+		case 0x84:if(!ip[5])
+				length++;
+			else
+				return 0;
+		case 0x80:if(!ip[4] && !ip[3])
+				length += 2;
+			else
+				return 0;
+		case 0x44:if(!ip[2])
+				length++;
+			else
+				return 0;
+		case 0x40:if(!ip[1])
+				length++;
+			else
+				return 0;
+		case 0x00:return length;
+		default: return 0;
+	}
+	return length;
+}
+
+static inline int do_0f(u8 *ip)
+{
+	if(*ip == 0x1f)
+		return do_1f(ip + 1);
+	return 0;
+}
+
+static inline int do_66(u8 *ip)
+{
+	if(*ip == 0x90)
+		return 2;
+	if(*ip == 0x0f) {
+		int res = do_0f(ip + 1);
+		if(res)
+			return res + 1;
+		else
+			return 0;
+	}
+	return 0;
+}
+
+static inline int do_start(u8 *ip)
+{
+	if(*ip == 0x0f)
+		return do_0f(ip + 1);
+	if(*ip == 0x66)
+		return do_66(ip + 1);
+	return 0;
+}
+
+/* [do_nopl_emu] is called by exception 6 after an invalid opcode has been
+ * encountered. It will try to emulate it by doing nothing,
+ * and will send a SIGILL or SIGSEGV to the process if not possible.
+ * the NOPL can have variable length opcodes:
+
+bytes number	opcode
+	2	66 90
+	3	0f 1f 00
+	4	0f 1f 40 00
+	5	0f 1f 44 00 00
+	6	66 0f 1f 44 00 00
+	7	0f 1f 80 00 00 00 00
+	8	0f 1f 84 00 00 00 00 00
+	9	66 0f 1f 84 00 00 00 00 00
+*/
+void do_nopl_emu(struct pt_regs *regs, long error_code)
+{
+	int res = do_start((u8*)regs->ip);
+
+	if(res)
+		regs->ip += res;
+	else
+		do_invalid_op(regs, error_code);
+}
