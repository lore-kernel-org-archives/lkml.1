Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYH0Gji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYH0Gji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYH0Gja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:39:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37232 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYH0Gj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:39:29 -0400
Date: Wed, 27 Aug 2008 08:39:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080827063915.GC6255@elte.hu>
References: <20080815152938.4bc9d48c@infradead.org> <12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com> <20080825215555.2331f2cc@infradead.org> <12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com> <20080826092220.66290440@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826092220.66290440@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> The patch below fixes this;
> Ingo, please replace the patch with this one.

well, this one is now less than cheap on x86:

> +int func_ptr_is_kernel_text(void *ptr)
> +{
> +	unsigned long addr;
> +	addr = (unsigned long) dereference_function_descriptor(ptr);
> +	if (core_kernel_text(addr))
> +		return 1;
> +	return module_text_address(addr) != NULL;
> +}

as it's rather large. So i kept the config option, and it defaults to 
off.

> +		if (!func_ptr_is_kernel_text(nb->notifier_call)) {
> +			WARN(1, "Invalid notifier called!");
> +			nb = next_nb;
> +			continue;
> +		}

and that should be an unlikely() too i guess.

i've applied v2 as a delta patch to -tip, with these changes - see the 
commit below.

	Ingo

-------------------->
>From e0f789bde8bda8ee6cf084197b6f3fc951ad241a Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 15 Aug 2008 15:29:38 -0700
Subject: [PATCH] debug: add notifier chain debugging, v2

- unbreak ia64 (and powerpc) where function pointers dont
  point at code but at data (reported by Tony Luck)

[ mingo@elte.hu: various cleanups ]

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    3 +++
 kernel/extable.c       |   16 ++++++++++++++++
 kernel/notifier.c      |   10 +---------
 lib/vsprintf.c         |    2 +-
 4 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 1ceafa4..892529d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -187,6 +187,9 @@ extern unsigned long long memparse(char *ptr, char **retptr);
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int func_ptr_is_kernel_text(void *ptr);
+extern void *dereference_function_descriptor(void *ptr);
+
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
diff --git a/kernel/extable.c b/kernel/extable.c
index a26cb2e..adf0cc9 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -66,3 +66,19 @@ int kernel_text_address(unsigned long addr)
 		return 1;
 	return module_text_address(addr) != NULL;
 }
+
+/*
+ * On some architectures (PPC64, IA64) function pointers
+ * are actually only tokens to some data that then holds the
+ * real function address. As a result, to find if a function
+ * pointer is part of the kernel text, we need to do some
+ * special dereferencing first.
+ */
+int func_ptr_is_kernel_text(void *ptr)
+{
+	unsigned long addr;
+	addr = (unsigned long) dereference_function_descriptor(ptr);
+	if (core_kernel_text(addr))
+		return 1;
+	return module_text_address(addr) != NULL;
+}
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 143fdd7..0f39e39 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -21,10 +21,6 @@ BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
 static int notifier_chain_register(struct notifier_block **nl,
 		struct notifier_block *n)
 {
-	if (!kernel_text_address((unsigned long)n->notifier_call)) {
-		WARN(1, "Invalid notifier registered!");
-		return 0;
-	}
 	while ((*nl) != NULL) {
 		if (n->priority > (*nl)->priority)
 			break;
@@ -38,10 +34,6 @@ static int notifier_chain_register(struct notifier_block **nl,
 static int notifier_chain_cond_register(struct notifier_block **nl,
 		struct notifier_block *n)
 {
-	if (!kernel_text_address((unsigned long)n->notifier_call)) {
-		WARN(1, "Invalid notifier registered!");
-		return 0;
-	}
 	while ((*nl) != NULL) {
 		if ((*nl) == n)
 			return 0;
@@ -92,7 +84,7 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 		next_nb = rcu_dereference(nb->next);
 
 #ifdef CONFIG_DEBUG_NOTIFIERS
-		if (!kernel_text_address((unsigned long)nb->notifier_call)) {
+		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
 			WARN(1, "Invalid notifier called!");
 			nb = next_nb;
 			continue;
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d8d1d11..f5e5ffb 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -513,7 +513,7 @@ static char *string(char *buf, char *end, char *s, int field_width, int precisio
 	return buf;
 }
 
-static inline void *dereference_function_descriptor(void *ptr)
+void *dereference_function_descriptor(void *ptr)
 {
 #if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
 	void *p;
