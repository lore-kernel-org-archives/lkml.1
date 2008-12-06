Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYLFAJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYLFAJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYLFAJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:09:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49436 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbYLFAJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:09:14 -0500
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>, Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 4/7] Ksplice: Add module_data_address (the analogue of module_text_address)
Date: Fri,  5 Dec 2008 19:03:57 -0500
Message-Id: <1228521840-3886-5-git-send-email-jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1228521840-3886-4-git-send-email-jbarnold@mit.edu>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-2-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-3-git-send-email-jbarnold@mit.edu>
 <1228521840-3886-4-git-send-email-jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Ksplice's run-pre matching process needs to be able to determine the module
that contains a particular text or data address.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 include/linux/module.h |    2 ++
 kernel/module.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 3bfed01..2268147 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -366,6 +366,8 @@ static inline int module_is_live(struct module *mod)
 /* Is this address in a module? (second is with no locks, for oops) */
 struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
+struct module *module_data_address(unsigned long addr);
+struct module *__module_data_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
diff --git a/kernel/module.c b/kernel/module.c
index 0d361f0..c3cf234 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2724,6 +2724,7 @@ struct module *__module_text_address(unsigned long addr)
 			return mod;
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__module_text_address);
 
 struct module *module_text_address(unsigned long addr)
 {
@@ -2735,6 +2736,37 @@ struct module *module_text_address(unsigned long addr)
 
 	return mod;
 }
+EXPORT_SYMBOL_GPL(module_text_address);
+
+struct module *__module_data_address(unsigned long addr)
+{
+	struct module *mod;
+
+	if (addr < module_addr_min || addr > module_addr_max)
+		return NULL;
+
+	list_for_each_entry(mod, &modules, list) {
+		if (within(addr, mod->module_core + mod->core_text_size,
+			   mod->core_size - mod->core_text_size) ||
+		    within(addr, mod->module_init + mod->init_text_size,
+			   mod->init_size - mod->init_text_size))
+			return mod;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(__module_data_address);
+
+struct module *module_data_address(unsigned long addr)
+{
+	struct module *mod;
+
+	preempt_disable();
+	mod = __module_data_address(addr);
+	preempt_enable();
+
+	return mod;
+}
+EXPORT_SYMBOL_GPL(module_data_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
-- 
1.5.6.3

