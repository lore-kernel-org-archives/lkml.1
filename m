Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYIMExJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYIMExJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYIMEwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:52:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:37682 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbYIMEwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:52:53 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC PATCH 2/9] Ksplice: Add module_data_address (the analogue of module_text_address)
Date: Sat, 13 Sep 2008 00:49:48 -0400
Message-Id: <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221280912.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
References: <1221281397-7045-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221280912.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Ksplice's run-pre matching process needs to be able to determine the
module that contains a particular data address.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 include/linux/module.h |    2 ++
 kernel/module.c        |   28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 68e0955..b7cdfb4 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -362,6 +362,8 @@ static inline int module_is_live(struct module *mod)
 /* Is this address in a module? (second is with no locks, for oops) */
 struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
+struct module *module_data_address(unsigned long addr);
+struct module *__module_data_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
diff --git a/kernel/module.c b/kernel/module.c
index 8954556..dda2f80 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2682,6 +2682,34 @@ struct module *module_text_address(unsigned long addr)
 	return mod;
 }
 
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
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
-- 
1.5.4.3

