Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZHTHMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZHTHMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 03:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZHTHMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 03:12:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:3375 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbZHTHMW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 03:12:22 -0400
Message-Id: <4A8D13740200007800010BC7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 20 Aug 2009 08:12:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make use of inc/dec conditional
References: <4A8BCA850200007800010836@vpn.id2.novell.com>
 <4A8C2CDE.1010405@zytor.com>
In-Reply-To: <4A8C2CDE.1010405@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 19.08.09 18:48 >>>
>On 08/19/2009 12:48 AM, Jan Beulich wrote:
>> According to gcc's instruction selection, inc/dec can be used without
>> penalty on most CPU models, but should be avoided on others. Hence we
>> should have a config option controlling the use of inc/dec, and
>> respective abstraction macros to avoid making the resulting code too
>> ugly. There are a few instances of inc/dec that must be retained in
>> assembly code, due to that code's dependency on the instruction not
>> changing the carry flag.
>
>One thing: I doubt it matters one measurable iota when it comes to
>locked operations.

Okay, I think I agree to this point.

>Furthermore:
>
>-		     "decl %2	;\n"
>+		     _ASM_DECL "%2	;\n"
> 		     "jne 1b		;\n"
> 		     "adcl $0, %0	;\n"
>
>It looks to me that the carry flag is live across the dec there.  The

Indeed, I overlooked that when going through and checking for the
CF-is-live instances.

>other csum code look scary to me too.
>
>The rest of them look technically okay, but you're bloating them by two
>bytes (one byte in 64-bit mode) for every instance.  You may want to
>consider if any particular instance is more icache-critical than
>stall-critical.  This is probably more of a concern for inlines than for
>regular single-instance code like the string operations.

So the background really is that I wanted to introduce a percpu_inc()
operation subsequently (here with the goal to reduce code size by one
byte in a couple of places - initially just for inc_irq_stat(), didn't look
for other potential users), but then realized that it wouldn't be nice
to unconditionally introduce a possible stall here. Hence I went and
first created said config option, and then also went through and
identified the uses of inc/dec that could be replaced based on that
config option.

Jan

--- head-2009-07-28.orig/arch/x86/include/asm/hardirq.h	2009-08-10 14:39:11.000000000 +0200
+++ head-2009-07-28/arch/x86/include/asm/hardirq.h	2009-07-29 12:26:40.000000000 +0200
@@ -35,7 +35,7 @@ DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpust
 
 #define __ARCH_IRQ_STAT
 
-#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
+#define inc_irq_stat(member)	percpu_inc(irq_stat.member)
 
 #define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
 
--- head-2009-07-28.orig/arch/x86/include/asm/percpu.h	2009-08-10 14:39:11.000000000 +0200
+++ head-2009-07-28/arch/x86/include/asm/percpu.h	2009-08-10 14:41:46.000000000 +0200
@@ -165,6 +165,29 @@ do {							\
 	ret__;						\
 })
 
+#define percpu_unary_op(op, var)			\
+({							\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_arg(0)		\
+		    : "+m" (var));			\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+})
+
 #define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
 #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
 #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
@@ -176,6 +199,11 @@ do {							\
 #if defined(CONFIG_X86_XADD) || defined(CONFIG_X86_64)
 #define percpu_xadd(var, val)   percpu_xchg_op("xadd", per_cpu__##var, val)
 #endif
+#ifdef CONFIG_X86_INCDEC
+#define percpu_inc(var)		percpu_unary_op("inc", per_cpu__##var)
+#else
+#define percpu_inc(var)		percpu_to_op("add", per_cpu__##var, 1)
+#endif
 
 /* This is not atomic against other CPUs -- CPU preemption needs to be off */
 #define x86_test_and_clear_bit_percpu(bit, var)				\


