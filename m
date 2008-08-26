Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbYHZQW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbYHZQW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYHZQWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:22:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:48843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYHZQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:22:21 -0400
Date: Tue, 26 Aug 2008 09:22:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Tony Luck" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: PATCH] debug: add notifier chain debugging
Message-ID: <20080826092220.66290440@infradead.org>
In-Reply-To: <12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com>
References: <20080815152938.4bc9d48c@infradead.org>
	<12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
	<20080825215555.2331f2cc@infradead.org>
	<12c511ca0808252208n29043ab0lf9e56f94d5e4cb37@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008 22:08:00 -0700
"Tony Luck" <tony.luck@intel.com> wrote:

> >> This breaks on ia64 (and pa-risc I think) where function pointers
> >> don't point directly at the code, they point to a {code,data}
> >> structure which is itself located in data space, not text space.
> >
> > is there a way to go to the actual address? I'm sure this is a bit
> > more common.... (like kallsyms!)
> 
> See dereference_function_descriptor() in lib/vsprintf.c (where it will
> be clear that my memory was wrong and that PPC64 is the other
> architecture that needs this).
> 

The patch below fixes this;
Ingo, please replace the patch with this one.


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] debug: add notifier chain debugging

during some development we suspected a case where we left something
in a notifier chain that was from a module that was unloaded already...
and that sort of thing is rather hard to track down.

This patch adds a very simple sanity check (which isn't all that
expensive) to make sure the notifier we're about to call is
actually from either the kernel itself of from a still-loaded
module, avoiding a hard-to-chase-down crash.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/kernel.h |    3 +++
 kernel/extable.c       |   16 ++++++++++++++++
 kernel/notifier.c      |    6 ++++++
 lib/vsprintf.c         |    2 +-
 4 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..4e1366b 100644
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
index 823be11..522277c 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -82,6 +82,12 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference(nb->next);
+		if (!func_ptr_is_kernel_text(nb->notifier_call)) {
+			WARN(1, "Invalid notifier called!");
+			nb = next_nb;
+			continue;
+		}
+
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
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
-- 
1.5.5.1

