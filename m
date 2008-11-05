Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYKETad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYKETad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYKETaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:30:23 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46801 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYKETaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:30:21 -0500
Message-ID: <4911F448.3010701@ct.jp.nec.com>
Date: Wed, 05 Nov 2008 11:30:16 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] kprobes: disable preempt for module_text_address()
References: <490FE405.1000105@cn.fujitsu.com> <4910F697.2050203@redhat.com> <4910FB3D.4020805@cn.fujitsu.com>
In-Reply-To: <4910FB3D.4020805@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Masami Hiramatsu wrote:
>> Hi Lai,
>>
>> Lai Jiangshan wrote:
>>> __register_kprobe() may be preempted after module_text_address()
>>> but before try_module_get(), and in this interval the module may be
>>> unloaded and try_module_get(probed_mod) will access to invalid address.
>>> this patch uses preempt_disable() to protect it.
>> Thank you for your work.
>>
>> I think this is the problem of module_text_address() because it can
>> return incorrect address of struct module if a preemption happens.
>> So, I think the module_text_address() would better to call try_module_get()
>> before returning its address, or at least they should comment that caller
>> needs disabling preemption.
>>
>> struct module *module_text_address(unsigned long addr)
>> {
>> 	struct module *mod;
>>
>> 	preempt_disable(); /*
>> 			    * I also think this preemption disabling is not so useful
>> 			    * without try_module_get(), because caller have to
>> 			    * disable preemption...
>> 			    */
>> 	mod = __module_text_address(addr);
>> 	/* here, try_module_get() is needed.
>> 	 * (or commenting "caller must disable preemption!") */
>> 	preempt_enable();
>>
>> 	/*
>> 	 * !!Here!! if the preemption happened, it could return invalid "mod".
>>          * In that case, even if module_text_address() returns non-NULL,
>> 	 * the addr is no longer in any module.
>> 	 */
>> 	return mod;
>> }
>>
>> Thank you,
>>
> 
> I don't think module_text_address() are needed to modified.
> only __register_kprobe() uses module_text_address()'s return value.
> other users of module_text_address() are just for testing it's
> return value. so only __register_kprobe() needs disabling preemption
> currently.

I guess, there is another issue if the module is unloaded before
module_text_address(). p->addr is no longer valid, but in
__register_kprobe(), module_text_address() returns NULL means
it's not a module.

How about this?
--------
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] kprobe: fix module checking in __register_kprobe()

__register_kprobe() may be preempted before/after module_text_address().
In this preemption, the module may be unloaded.

If the module is unloaded before module_text_address(), kprobe address
becomes invalid. If the module is unloaded after module_text_address()
and before try_module_get(), try_module_get(probe_mod) will access invalid
address.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/kprobes.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8b57a25..71dc2e9 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -605,7 +605,7 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 {
 	int ret = 0;
 	struct kprobe *old_p;
-	struct module *probed_mod;
+	struct module *probed_mod = NULL;
 	kprobe_opcode_t *addr;
 
 	addr = kprobe_addr(p);
@@ -622,20 +622,27 @@ static int __kprobes __register_kprobe(struct kprobe *p,
 	/*
 	 * Check if are we probing a module.
 	 */
-	probed_mod = module_text_address((unsigned long) p->addr);
-	if (probed_mod) {
-		struct module *calling_mod = module_text_address(called_from);
+	if (!core_kernel_text((unsigned long) p->addr)) {
+		preempt_disable();
+		probed_mod = __module_text_address((unsigned long) p->addr);
+		if (!probed_mod) {
+			preempt_enable();
+			return -EINVAL;
+		}
 		/*
 		 * We must allow modules to probe themself and in this case
 		 * avoid incrementing the module refcount, so as to allow
 		 * unloading of self probing modules.
 		 */
-		if (calling_mod && calling_mod != probed_mod) {
-			if (unlikely(!try_module_get(probed_mod)))
+		if (__module_text_address(called_from) != probed_mod) {
+			if (unlikely(!try_module_get(probed_mod))) {
+				preempt_enable();
 				return -EINVAL;
+			}
 			p->mod_refcounted = 1;
 		} else
 			probed_mod = NULL;
+		preempt_enable();
 	}
 
 	p->nmissed = 0;
-- 
1.5.6

