Return-Path: <linux-kernel-owner+w=401wt.eu-S1161047AbXBGJTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161047AbXBGJTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161054AbXBGJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:19:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161047AbXBGJTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:19:34 -0500
Date: Wed, 7 Feb 2007 10:19:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] KVM, hotplug: export register_cpu_notifier
Message-ID: <20070207091913.GA15384@elte.hu>
References: <20070207081633.GA6723@elte.hu> <45C997F1.9060102@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C997F1.9060102@qumranet.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_20 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1616]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> >-#ifdef CONFIG_HOTPLUG_CPU
> >-
> > EXPORT_SYMBOL(register_cpu_notifier);
> > 
> >+#ifdef CONFIG_HOTPLUG_CPU
> >+
> > void unregister_cpu_notifier(struct notifier_block *nb)
> > {
> > 	mutex_lock(&cpu_add_remove_lock);
> >  
> 
> This is broken: register_cpu_notifier() is __cpuinit, which means it 
> disappears at module time if !CONFIG_CPU_HOTPLUG.
> 
> I submitted a hackaround to Andrew some time ago with the suspend 
> patchset.

ok. What does your patch do - turns it into an inline? I fixed it up in 
-rt via the patch below.

	Ingo

---------------------->
Subject: [patch] KVM: export register_cpu_notifier
From: Ingo Molnar <mingo@elte.hu>

KVM-trunk uses register_cpu_notifier() but it's not exported
on CONFIG_HOTPLUG_CPU. Make it a nop inline.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpu.h |    6 +++++-
 kernel/cpu.c        |    4 ----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux/include/linux/cpu.h
===================================================================
--- linux.orig/include/linux/cpu.h
+++ linux/include/linux/cpu.h
@@ -49,10 +49,14 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
-extern int register_cpu_notifier(struct notifier_block *nb);
 #ifdef CONFIG_HOTPLUG_CPU
+extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
 #else
+static inline int register_cpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 static inline void unregister_cpu_notifier(struct notifier_block *nb)
 {
 }
Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c
+++ linux/kernel/cpu.c
@@ -63,8 +63,6 @@ void unlock_cpu_hotplug(void)
 }
 EXPORT_SYMBOL_GPL(unlock_cpu_hotplug);
 
-#endif	/* CONFIG_HOTPLUG_CPU */
-
 /* Need to know about CPUs going up/down? */
 int __cpuinit register_cpu_notifier(struct notifier_block *nb)
 {
@@ -75,8 +73,6 @@ int __cpuinit register_cpu_notifier(stru
 	return ret;
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
 EXPORT_SYMBOL(register_cpu_notifier);
 
 void unregister_cpu_notifier(struct notifier_block *nb)
