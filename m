Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYFJUFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYFJUFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYFJUFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:05:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:50156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYFJUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:05:24 -0400
Date: Tue, 10 Jun 2008 13:05:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: rusty@rustcorp.com.au
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] modules: Take a shortcut for checking if an address is in a
 module
Message-ID: <20080610130519.21bc66f3@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] modules: Take a shortcut for checking if an address is in a module

Various pieces of the kernel (lockdep, latencytop, etc) tend to store
backtraces, sometimes at a relatively high frequency. In itself this
isn't a big performance deal (after all you're using diagnostics features),
but there have been some complaints from people who have over 100 modules
loaded that this is a tad too slow.

This is due to the new backtracer code which looks at every slot on the stack
to see if it's a kernel/module text address, so that's 1024 slots.
1024 times 100 modules... that's a lot of list walking.

On some architectures (esp x86), the modules go into a specific range of
virtual memory; this patch adds a check just before walking the module
list to see if the address that's asked for is in the module range in
the first place, and manages to skip the list walk for the (common) case
of this not being so.


Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/module.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 5f80478..b7dbef1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2595,6 +2595,21 @@ struct module *__module_text_address(unsigned long addr)
 {
 	struct module *mod;
 
+	/* 
+	 * shortcut for the architectures that have a well
+	 * defined start/end virtual address of modules:
+	 * we can decide something for sure isn't a module
+	 * without walking the potentially long module list.
+	 */
+#ifdef MODULES_VADDR
+	if (addr < MODULES_VADDR)
+		return NULL;
+#endif
+#ifdef MODULES_END
+	if (addr > MODULES_END)
+		return NULL;
+#endif
+
 	list_for_each_entry(mod, &modules, list)
 		if (within(addr, mod->module_init, mod->init_text_size)
 		    || within(addr, mod->module_core, mod->core_text_size))
-- 
1.5.4.5


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
