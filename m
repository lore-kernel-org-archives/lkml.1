Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbYHOW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbYHOW3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHOW32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:29:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:40178 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYHOW31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:29:27 -0400
Date: Fri, 15 Aug 2008 15:29:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: PATCH] debug: add notifier chain debugging
Message-ID: <20080815152938.4bc9d48c@infradead.org>
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
---
 kernel/notifier.c |   16 ++++++++++++++++
 lib/Kconfig.debug |   10 ++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/notifier.c b/kernel/notifier.c
index 823be11..143fdd7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -21,6 +21,10 @@ BLOCKING_NOTIFIER_HEAD(reboot_notifier_list);
 static int notifier_chain_register(struct notifier_block **nl,
 		struct notifier_block *n)
 {
+	if (!kernel_text_address((unsigned long)n->notifier_call)) {
+		WARN(1, "Invalid notifier registered!");
+		return 0;
+	}
 	while ((*nl) != NULL) {
 		if (n->priority > (*nl)->priority)
 			break;
@@ -34,6 +38,10 @@ static int notifier_chain_register(struct notifier_block **nl,
 static int notifier_chain_cond_register(struct notifier_block **nl,
 		struct notifier_block *n)
 {
+	if (!kernel_text_address((unsigned long)n->notifier_call)) {
+		WARN(1, "Invalid notifier registered!");
+		return 0;
+	}
 	while ((*nl) != NULL) {
 		if ((*nl) == n)
 			return 0;
@@ -82,6 +90,14 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference(nb->next);
+
+#ifdef CONFIG_DEBUG_NOTIFIERS
+		if (!kernel_text_address((unsigned long)nb->notifier_call)) {
+			WARN(1, "Invalid notifier called!");
+			nb = next_nb;
+			continue;
+		}
+#endif
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 800ac84..f4bb36e 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -536,6 +536,16 @@ config DEBUG_SG
 
 	  If unsure, say N.
 
+config DEBUG_NOTIFIERS
+	bool "Debug notifier call chains"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on sanity checking for notifier call chains.
+	  This is most useful for kernel developers to make sure that
+	  modules properly unregister themselves from notifier chains.
+	  This is a relatively cheap check but if you care about maximum
+	  performance, say N.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
-- 
1.5.5.1

