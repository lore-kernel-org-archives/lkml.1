Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200Ab0AEBPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0AEBPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 20:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027Ab0AEBPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 20:15:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:36883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab0AEBPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 20:15:04 -0500
Message-ID: <4B4293A3.10106@kernel.org>
Date: Tue, 05 Jan 2010 10:19:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V9 4/7] Generic inc / dec percpu instructions
References: <20100104223439.228028923@quilx.com> <20100104223556.090044300@quilx.com>
In-Reply-To: <20100104223556.090044300@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 07:34 AM, Christoph Lameter wrote:
> Optimize code generated for percpu access by checking for increment and
> decrements.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  arch/x86/include/asm/percpu.h |  100 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 86 insertions(+), 14 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/percpu.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-01-04 15:33:02.000000000 -0600
> +++ linux-2.6/arch/x86/include/asm/percpu.h	2010-01-04 16:11:29.000000000 -0600
> @@ -104,6 +104,78 @@ do {							\
>  	}						\
>  } while (0)
>  
> +/*
> + * Generate a percpu add to memory instruction and optimize code
> + * if a one is added or subtracted.
> + */
> +#define percpu_add_op(var, val)				\
> +do {							\
> +	typedef typeof(var) pto_T__;			\
> +	if (0) {					\
> +		pto_T__ pto_tmp__;			\
> +		pto_tmp__ = (val);			\
> +	}						\
> +	switch (sizeof(var)) {				\
> +	case 1:						\
> +		if (__builtin_constant_p(val) == 1)	\

According to gcc doc, __builtin_constant_p() returns 1 on constant and
0 if not.  It doesn't return the original expression.  I'll commit the
following updated version after testing.

Thanks.

From: Christoph Lameter <cl@linux-foundation.org>

Optimize code generated for percpu access by checking for increment and
decrements.

tj: fix incorrect usage of __builtin_constant_p() and restructure
    percpu_add_op() macro.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |   86 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 72 insertions(+), 14 deletions(-)

Index: percpu/arch/x86/include/asm/percpu.h
===================================================================
--- percpu.orig/arch/x86/include/asm/percpu.h
+++ percpu/arch/x86/include/asm/percpu.h
@@ -103,6 +103,64 @@ do {							\
 	}						\
 } while (0)
 
+/*
+ * Generate a percpu add to memory instruction and optimize code
+ * if a one is added or subtracted.
+ */
+#define percpu_add_op(var, val)						\
+do {									\
+	typedef typeof(var) pao_T__;					\
+	const int pao_ID__ = (__builtin_constant_p(val) &&		\
+			      ((val) == 1 || (val) == -1)) ? (val) : 0;	\
+	if (0) {							\
+		pao_T__ pao_tmp__;					\
+		pao_tmp__ = (val);					\
+	}								\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		if (pao_ID__ == 1)					\
+			asm("incb "__percpu_arg(0) : "+m" (var));	\
+		else if (pao_ID__ == -1)				\
+			asm("decb "__percpu_arg(0) : "+m" (var));	\
+		else							\
+			asm("addb %1, "__percpu_arg(0)			\
+			    : "+m" (var)				\
+			    : "qi" ((pao_T__)(val)));			\
+		break;							\
+	case 2:								\
+		if (pao_ID__ == 1)					\
+			asm("incw "__percpu_arg(0) : "+m" (var));	\
+		else if (pao_ID__ == -1)				\
+			asm("decw "__percpu_arg(0) : "+m" (var));	\
+		else							\
+			asm("addw %1, "__percpu_arg(0)			\
+			    : "+m" (var)				\
+			    : "ri" ((pao_T__)(val)));			\
+		break;							\
+	case 4:								\
+		if (pao_ID__ == 1)					\
+			asm("incl "__percpu_arg(0) : "+m" (var));	\
+		else if (pao_ID__ == -1)				\
+			asm("decl "__percpu_arg(0) : "+m" (var));	\
+		else							\
+			asm("addl %1, "__percpu_arg(0)			\
+			    : "+m" (var)				\
+			    : "ri" ((pao_T__)(val)));			\
+		break;							\
+	case 8:								\
+		if (pao_ID__ == 1)					\
+			asm("incq "__percpu_arg(0) : "+m" (var));	\
+		else if (pao_ID__ == -1)				\
+			asm("decq "__percpu_arg(0) : "+m" (var));	\
+		else							\
+			asm("addq %1, "__percpu_arg(0)			\
+			    : "+m" (var)				\
+			    : "re" ((pao_T__)(val)));			\
+		break;							\
+	default: __bad_percpu_size();					\
+	}								\
+} while (0)
+
 #define percpu_from_op(op, var, constraint)		\
 ({							\
 	typeof(var) pfo_ret__;				\
@@ -144,8 +202,8 @@ do {							\
 #define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
 #define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
 #define percpu_write(var, val)		percpu_to_op("mov", var, val)
-#define percpu_add(var, val)		percpu_to_op("add", var, val)
-#define percpu_sub(var, val)		percpu_to_op("sub", var, val)
+#define percpu_add(var, val)		percpu_add_op(var, val)
+#define percpu_sub(var, val)		percpu_add_op(var, -(val))
 #define percpu_and(var, val)		percpu_to_op("and", var, val)
 #define percpu_or(var, val)		percpu_to_op("or", var, val)
 #define percpu_xor(var, val)		percpu_to_op("xor", var, val)
@@ -157,9 +215,9 @@ do {							\
 #define __this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define __this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define __this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
-#define __this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
-#define __this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define __this_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define __this_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
 #define __this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -176,9 +234,9 @@ do {							\
 #define this_cpu_write_1(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_2(pcp, val)	percpu_to_op("mov", (pcp), val)
 #define this_cpu_write_4(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define this_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
-#define this_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
-#define this_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define this_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define this_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
 #define this_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -189,9 +247,9 @@ do {							\
 #define this_cpu_xor_2(pcp, val)	percpu_to_op("xor", (pcp), val)
 #define this_cpu_xor_4(pcp, val)	percpu_to_op("xor", (pcp), val)
 
-#define irqsafe_cpu_add_1(pcp, val)	percpu_to_op("add", (pcp), val)
-#define irqsafe_cpu_add_2(pcp, val)	percpu_to_op("add", (pcp), val)
-#define irqsafe_cpu_add_4(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_add_1(pcp, val)	percpu_add_op((pcp), val)
+#define irqsafe_cpu_add_2(pcp, val)	percpu_add_op((pcp), val)
+#define irqsafe_cpu_add_4(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_and_1(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_and_2(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_and_4(pcp, val)	percpu_to_op("and", (pcp), val)
@@ -209,19 +267,19 @@ do {							\
 #ifdef CONFIG_X86_64
 #define __this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define __this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define __this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define __this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define __this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define __this_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define __this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
 #define this_cpu_read_8(pcp)		percpu_from_op("mov", (pcp), "m"(pcp))
 #define this_cpu_write_8(pcp, val)	percpu_to_op("mov", (pcp), val)
-#define this_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define this_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define this_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define this_cpu_or_8(pcp, val)		percpu_to_op("or", (pcp), val)
 #define this_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)
 
-#define irqsafe_cpu_add_8(pcp, val)	percpu_to_op("add", (pcp), val)
+#define irqsafe_cpu_add_8(pcp, val)	percpu_add_op((pcp), val)
 #define irqsafe_cpu_and_8(pcp, val)	percpu_to_op("and", (pcp), val)
 #define irqsafe_cpu_or_8(pcp, val)	percpu_to_op("or", (pcp), val)
 #define irqsafe_cpu_xor_8(pcp, val)	percpu_to_op("xor", (pcp), val)

-- 
tejun
