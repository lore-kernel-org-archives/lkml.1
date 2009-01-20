Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbZATBex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbZATBex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbZATBdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:33:15 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42114 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756836AbZATBdK (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:33:10 -0500
Message-Id: <20090120013258.426205000@sgi.com>
References: <20090120012930.020621000@sgi.com>
User-Agent: quilt/0.44-16.4
Date: Tue, 20 Jan 2009 12:29:32 +1100
From: Greg Banks <gnb@sgi.com>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Cc: Linux NFS ML <linux-nfs@vger.kernel.org>,
       Linux NFSv4 ML <nfsv4@linux-nfs.org>,
       SystemTAP ML <systemtap@sources.redhat.com>
Subject: [patch 2/5] Add apply_modules() which applies a function to each module.
Content-Disposition: inline; filename=gnb-add-apply-modules
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new dprintk module needs to apply a particular function
to each module when the dprintk module loads.

Signed-off-by: Greg Banks <gnb@sgi.com>
---

 include/linux/module.h |    1 +
 kernel/module.c        |   13 +++++++++++++
 2 files changed, 14 insertions(+)

Index: bfields/kernel/module.c
===================================================================
--- bfields.orig/kernel/module.c
+++ bfields/kernel/module.c
@@ -365,6 +365,19 @@ static struct module *find_module(const 
 	return NULL;
 }
 
+void apply_modules(void (*func)(struct module*, void *), void *closure)
+{
+	struct module *mod;
+
+	preempt_disable();
+	list_for_each_entry_rcu(mod, &modules, list) {
+		func(mod, closure);
+	}
+	preempt_enable();
+}
+EXPORT_SYMBOL(apply_modules);
+
+
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
 static unsigned int pcpu_num_used, pcpu_num_allocated;
Index: bfields/include/linux/module.h
===================================================================
--- bfields.orig/include/linux/module.h
+++ bfields/include/linux/module.h
@@ -475,6 +475,7 @@ extern void module_update_markers(void);
 
 extern void module_update_tracepoints(void);
 extern int module_get_iter_tracepoints(struct tracepoint_iter *iter);
+extern void apply_modules(void (*func)(struct module*, void *), void *closure);
 
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)

--
-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.
