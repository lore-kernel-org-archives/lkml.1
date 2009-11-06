Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZKFPtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZKFPtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZKFPtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:49:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:34816 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751517AbZKFPtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:49:09 -0500
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="iso-8859-1"
Date: Fri, 06 Nov 2009 16:49:11 +0100
From: "Martin Schleier" <drahemmaps@gmx.net>
Message-ID: <20091106154911.29400@gmx.net>
MIME-Version: 1.0
Subject: Re: i686 quirk for AMD Geode
To: Matteo Croce <technoboy85@gmail.com>, mingo@elte.hu
X-Authenticated: #35928486
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/Xk2wDAqnXcymJarBT31DsoZNXqRBN5N/sdx5f1u
 zfK0mYto6bEIDKroUrHCt9dn1eQFuFwArCaQ== 
X-GMX-UID: GSiWHjsrbXB+RsNLFjY29V4iLyUmZchY
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 15:59:16 +0100 Matteo Croce wrote:
> On Sat, Oct 3, 2009 at 8:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Matteo Croce <technoboy85@gmail.com> wrote:
[snip]
> > Looks good, but your signoff line is missing.
> >
> >        Ingo
> >
> 
> The AMD Geode LX has an x86 id of 5 (i586) tought it's technically an
> i686:
> 
> root@alix:~# egrep '^(cpu family|model name|flags)' /proc/cpuinfo
> cpu family      : 5
> model name      : Geode(TM) Integrated Processor by AMD PCS
> flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
> mmxext 3dnowext 3dnow
> 
> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction
> (NOPL).
> This patch adds a quirck to promote the Geode to an i686 and emulates
> the NOPL in the do_invalid_op trap, so the userspace never notices.
> Emulating the NOPL has minimum performance loss, emulating a NOPL
> takes 0.5 usecs
> and they are rarely used in x86
> 
> Signed-off-by: Matteo Croce <technoboy85@gmail.com>
> 
> --- a/arch/x86/kernel/Makefile	2009-11-06 15:06:52.246223989 +0100
> +++ b/arch/x86/kernel/Makefile	2009-11-06 15:07:04.294054613 +0100
> @@ -89,7 +89,7 @@
>  obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
> 
>  obj-$(CONFIG_K8_NB)		+= k8.o
> -obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
> +obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o nopl_emu.o
>  obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
>  obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
> 
> --- a/arch/x86/kernel/cpu/amd.c	2009-11-06 15:06:52.254223805 +0100
> +++ b/arch/x86/kernel/cpu/amd.c	2009-11-06 15:07:04.294054613 +0100
> @@ -138,8 +138,10 @@
>  	}
> 
>  	if (c->x86_model == 10) {
> -		/* AMD Geode LX is model 10 */
> -		/* placeholder for any needed mods */
> +		/* Geode only lacks the NOPL instruction to be i686,
> +		   but we can emulate it in the exception handler
> +		   and promote it to a class 6 cpu */
> +		boot_cpu_data.x86 = 6;
>  		return;
>  	}
>  }
> --- a/arch/x86/kernel/entry_32.S	2009-11-06 15:06:52.258224172 +0100
> +++ b/arch/x86/kernel/entry_32.S	2009-11-06 15:07:04.306230613 +0100
> @@ -901,7 +901,11 @@
>  	RING0_INT_FRAME
>  	pushl $0
>  	CFI_ADJUST_CFA_OFFSET 4
> +#ifdef CONFIG_MGEODE_LX
> +	pushl $do_nopl_emu
> +#else
>  	pushl $do_invalid_op
> +#endif
>  	CFI_ADJUST_CFA_OFFSET 4
>  	jmp error_code
>  	CFI_ENDPROC
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ b/arch/x86/kernel/nopl_emu.c	2009-11-06 15:07:33.537723795 +0100
> @@ -0,0 +1,102 @@
> +/*
> + *  linux/arch/x86/kernel/nopl_emu.c
> + *
> + *  Copyright (C) 2002  Willy Tarreau
> + *  Copyright (C) 2009  Matteo Croce
> + */
> +
> +#include <linux/sched.h>
> +#include <linux/linkage.h>
> +#include <linux/preempt.h>
> +#include <linux/types.h>
> +
> +void do_invalid_op(struct pt_regs *regs, long error_code);
> +
> +/* This code can be used to allow the AMD Geode to hopefully correctly
> execute
> + * some code which was originally compiled for an i686, by emulating
> NOPL,
> + * the only missing i686 instruction in the CPU
> + *
> + * Willy Tarreau <willy@meta-x.org>
> + * Matteo Croce <technoboy85@gmail.com>
> + */
> +
> +static inline int do_1f(u8 *ip)
> +{
> +	int length = 3;
> +	switch(*ip) {
> +		case 0x84:if(!ip[5])
> +				length++;
> +			else
> +				return 0;
> +		case 0x80:if(!ip[4] && !ip[3])
> +				length += 2;
> +			else
> +				return 0;
> +		case 0x44:if(!ip[2])
> +				length++;
> +			else
> +				return 0;
> +		case 0x40:if(!ip[1])
> +				length++;
> +			else
> +				return 0;
> +		case 0x00:return length;
> +		default: return 0;
> +	}
> +	return length;
> +}
> +
> +static inline int do_0f(u8 *ip)
> +{
> +	if(*ip == 0x1f)
> +		return do_1f(ip + 1);
> +	return 0;
> +}
> +
> +static inline int do_66(u8 *ip)
> +{
> +	if(*ip == 0x90)
> +		return 2;
> +	if(*ip == 0x0f) {
> +		int res = do_0f(ip + 1);
> +		if(res)
> +			return res + 1;
> +		else
> +			return 0;
> +	}
> +	return 0;
> +}
> +
> +static inline int do_start(u8 *ip)
> +{
> +	if(*ip == 0x0f)
> +		return do_0f(ip + 1);
> +	if(*ip == 0x66)
> +		return do_66(ip + 1);
> +	return 0;
> +}
> +
> +/* [do_nopl_emu] is called by exception 6 after an invalid opcode has
> been
> + * encountered. It will try to emulate it by doing nothing,
> + * and will send a SIGILL or SIGSEGV to the process if not possible.
> + * the NOPL can have variable length opcodes:
> +
> +bytes number	opcode
> +	2	66 90
> +	3	0f 1f 00
> +	4	0f 1f 40 00
> +	5	0f 1f 44 00 00
> +	6	66 0f 1f 44 00 00
> +	7	0f 1f 80 00 00 00 00
> +	8	0f 1f 84 00 00 00 00 00
> +	9	66 0f 1f 84 00 00 00 00 00
> +*/
> +void do_nopl_emu(struct pt_regs *regs, long error_code)
> +{
> +	int res = do_start((u8*)regs->ip);
> +
> +	if(res)
> +		regs->ip += res;
> +	else
> +		do_invalid_op(regs, error_code);
> +}
> --

Looks good? checkpatch.pl has a very different opinion.

WARNING: externs should be avoided in .c files
#56: FILE: arch/x86/kernel/nopl_emu.c:13:
+void do_invalid_op(struct pt_regs *regs, long error_code);

ERROR: switch and case should be at the same indent
#69: FILE: arch/x86/kernel/nopl_emu.c:26:
+	switch(*ip) {
+		case 0x84:if(!ip[5])
[...]
+		case 0x80:if(!ip[4] && !ip[3])
[...]
+		case 0x44:if(!ip[2])
[...]
+		case 0x40:if(!ip[1])
[...]
+		case 0x00:return length;
+		default: return 0;

ERROR: space required before the open parenthesis '('
#69: FILE: arch/x86/kernel/nopl_emu.c:26:
+	switch(*ip) {

ERROR: space required before the open parenthesis '('
#70: FILE: arch/x86/kernel/nopl_emu.c:27:
+		case 0x84:if(!ip[5])

ERROR: trailing statements should be on next line
#70: FILE: arch/x86/kernel/nopl_emu.c:27:
+		case 0x84:if(!ip[5])

ERROR: space required before the open parenthesis '('
#74: FILE: arch/x86/kernel/nopl_emu.c:31:
+		case 0x80:if(!ip[4] && !ip[3])

ERROR: trailing statements should be on next line
#74: FILE: arch/x86/kernel/nopl_emu.c:31:
+		case 0x80:if(!ip[4] && !ip[3])

ERROR: space required before the open parenthesis '('
#78: FILE: arch/x86/kernel/nopl_emu.c:35:
+		case 0x44:if(!ip[2])

ERROR: trailing statements should be on next line
#78: FILE: arch/x86/kernel/nopl_emu.c:35:
+		case 0x44:if(!ip[2])

ERROR: space required before the open parenthesis '('
#82: FILE: arch/x86/kernel/nopl_emu.c:39:
+		case 0x40:if(!ip[1])

ERROR: trailing statements should be on next line
#82: FILE: arch/x86/kernel/nopl_emu.c:39:
+		case 0x40:if(!ip[1])

ERROR: space required before the open parenthesis '('
#94: FILE: arch/x86/kernel/nopl_emu.c:51:
+	if(*ip == 0x1f)

ERROR: space required before the open parenthesis '('
#101: FILE: arch/x86/kernel/nopl_emu.c:58:
+	if(*ip == 0x90)

ERROR: space required before the open parenthesis '('
#103: FILE: arch/x86/kernel/nopl_emu.c:60:
+	if(*ip == 0x0f) {

ERROR: space required before the open parenthesis '('
#105: FILE: arch/x86/kernel/nopl_emu.c:62:
+		if(res)

ERROR: space required before the open parenthesis '('
#115: FILE: arch/x86/kernel/nopl_emu.c:72:
+	if(*ip == 0x0f)

ERROR: space required before the open parenthesis '('
#117: FILE: arch/x86/kernel/nopl_emu.c:74:
+	if(*ip == 0x66)

ERROR: "(foo*)" should be "(foo *)"
#139: FILE: arch/x86/kernel/nopl_emu.c:96:
+	int res = do_start((u8*)regs->ip);

ERROR: space required before the open parenthesis '('
#141: FILE: arch/x86/kernel/nopl_emu.c:98:
+	if(res)

ERROR: Missing Signed-off-by: line(s)

total: 19 errors, 1 warnings, 133 lines checked

This patch has style problems, please review.
If any of these errors are false positives report them
to the maintainer, see CHECKPATCH in MAINTAINERS.

-- 
DSL-Preisknaller: DSL Komplettpakete von GMX schon für 
16,99 Euro mtl.!* Hier klicken: http://portal.gmx.net/de/go/dsl02
