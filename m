Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYKDGBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYKDGBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKDGBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:01:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYKDGBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:01:36 -0500
Message-ID: <490FE405.1000105@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 13:56:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ananth@in.ibm.com, David Miller <davem@davemloft.net>, mhiramat@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kprobes: disable preempt for module_text_address()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__register_kprobe() may be preempted after module_text_address()
but before try_module_get(), and in this interval the module may be
unloaded and try_module_get(probed_mod) will access to invalid address.
this patch uses preempt_disable() to protect it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8b57a25..8238ec5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -622,6 +622,7 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 	/*
 	 * Check if are we probing a module.
 	 */
+	preempt_disable();
 	probed_mod = module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
 		struct module *calling_mod = module_text_address(called_from);
@@ -631,12 +632,15 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 		 * unloading of self probing modules.
 		 */
 		if (calling_mod && calling_mod != probed_mod) {
-			if (unlikely(!try_module_get(probed_mod)))
+			if (unlikely(!try_module_get(probed_mod))) {
+				preempt_enable();
 				return -EINVAL;
+			}
 			p->mod_refcounted = 1;
 		} else
 			probed_mod = NULL;
 	}
+	preempt_enable();
 
 	p->nmissed = 0;
 	INIT_LIST_HEAD(&p->list);



