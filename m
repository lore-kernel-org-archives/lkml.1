Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYKEVlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYKEVlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYKEVlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:41:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52032 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbYKEVlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:41:36 -0500
Message-ID: <491212C0.4030900@redhat.com>
Date: Wed, 05 Nov 2008 16:40:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       h-shimamoto@ct.jp.nec.com
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com> <4910FB3D.4020805@cn.fujitsu.com>
In-Reply-To: <4910FB3D.4020805@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> actually, calling __module_text_address() in __register_kprobe() is
> better after my fix applied. but I found that a line have exceed
> 80 characters, so I don't use __module_text_address().

I don't think that coding style is a good reason not to fix it...:(

Anyway, I think the issue that you pointed must be fixed.
I found there were same kind of issues in kprobes and updated
your patch. This includes fixes which Hiroshi pointed out.

Thanks a lot! :)

__register_kprobe() can be preempted after checking probing address
but before try_module_get() or module_put(), and in this interval the
module can be unloaded. In that case, try_module_get(probed_mod) or
module_put(mod) will access to invalid address, or kprobe will probe
invalid address.

this patch uses preempt_disable() to protect it and use
__module_text_address() and __kernel_text_address().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/kprobes.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

Index: 2.6.28-rc3/kernel/kprobes.c
===================================================================
--- 2.6.28-rc3.orig/kernel/kprobes.c
+++ 2.6.28-rc3/kernel/kprobes.c
@@ -613,30 +613,37 @@ static int __kprobes __register_kprobe(s
 		return -EINVAL;
 	p->addr = addr;

-	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr))
+	preempt_disable();
+	if (!__kernel_text_address((unsigned long) p->addr) ||
+	    in_kprobes_functions((unsigned long) p->addr)) {
+		preempt_enable();
 		return -EINVAL;
+	}

 	p->mod_refcounted = 0;

 	/*
 	 * Check if are we probing a module.
 	 */
-	probed_mod = module_text_address((unsigned long) p->addr);
+	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
-		struct module *calling_mod = module_text_address(called_from);
+		struct module *calling_mod;
+		calling_mod = __module_text_address(called_from);
 		/*
 		 * We must allow modules to probe themself and in this case
 		 * avoid incrementing the module refcount, so as to allow
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
@@ -718,9 +725,11 @@ static void __kprobes __unregister_kprob
 	struct kprobe *old_p;

 	if (p->mod_refcounted) {
-		mod = module_text_address((unsigned long)p->addr);
+		preempt_disable();
+		mod = __module_text_address((unsigned long)p->addr);
 		if (mod)
 			module_put(mod);
+		preempt_enable();
 	}

 	if (list_empty(&p->list) || list_is_singular(&p->list)) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


