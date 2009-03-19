Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbZCSVLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbZCSVLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760670AbZCSVJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:09:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760752AbZCSVJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:09:44 -0400
Message-ID: <49C2B4D4.1040205@redhat.com>
Date: Thu, 19 Mar 2009 17:10:44 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
CC: Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [RFC][PATCH -tip 8/9] kprobes: support respawn probes for module
 probing
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add module_*probe API's to respawn probes on kernel modules.
kprobes which have been registered through register_module_*probe are
activated when the target module is loaded, and deactivated when unloading.
register_module_*probe require an activate_handler which is called right
before activating the probe, and if it returns !0, kprobes will be activated.

Thus, users can check whether the target module is true target or not
(e.g. checking build-id) in activate_handler.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 include/linux/kprobes.h |   39 ++++++++
 kernel/kprobes.c        |  250 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 289 insertions(+), 0 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 2ec6cc1..9d47d08 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/module.h>

 #ifdef CONFIG_KPROBES
 #include <asm/kprobes.h>
@@ -69,6 +70,7 @@ typedef int (*kprobe_fault_handler_t) (struct kprobe *, struct pt_regs *,
 				       int trapnr);
 typedef int (*kretprobe_handler_t) (struct kretprobe_instance *,
 				    struct pt_regs *);
+typedef int (*probe_activate_handler_t)(void *, struct module *);

 struct kprobe {
 	struct hlist_node hlist;
@@ -279,6 +281,16 @@ void unregister_kretprobes(struct kretprobe **rps, int num);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);

+int register_module_kprobe(struct kprobe *kp,
+			   probe_activate_handler_t handler, void *data);
+int register_module_kretprobe(struct kretprobe *rp,
+			      probe_activate_handler_t handler, void *data);
+int register_module_jprobe(struct jprobe *jp,
+			   probe_activate_handler_t handler, void *data);
+void unregister_module_kprobe(struct kprobe *kp);
+void unregister_module_kretprobe(struct kretprobe *rp);
+void unregister_module_jprobe(struct jprobe *jp);
+
 #else /* !CONFIG_KPROBES: */

 static inline int kprobes_built_in(void)
@@ -345,5 +357,32 @@ static inline void unregister_kretprobes(struct kretprobe **rps, int num)
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline int register_module_kprobe(struct kprobe *kp,
+					 probe_activate_handler_t handler,
+					 void *data)
+{
+	return -ENOSYS;
+}
+static inline int register_module_kretprobe(struct kretprobe *rp,
+					    probe_activate_handler_t handler,
+					    void *data)
+{
+	return -ENOSYS;
+}
+static inline int register_module_jprobe(struct jprobe *jp,
+					 probe_activate_handler_t handler,
+					 void *data)
+{
+	return -ENOSYS;
+}
+void unregister_module_kprobe(struct kprobe *kp)
+{
+}
+void unregister_module_kretprobe(struct kretprobe *rp)
+{
+}
+void unregister_module_jprobe(struct jprobe *jp)
+{
+}
 #endif /* CONFIG_KPROBES */
 #endif /* _LINUX_KPROBES_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 5016bfb..f16a54e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1416,6 +1416,256 @@ static int __kprobes debugfs_kprobe_init(void)
 late_initcall(debugfs_kprobe_init);
 #endif /* CONFIG_DEBUG_FS */

+/* Kprobes module respawn support */
+enum probe_type {
+	PROBE_TYPE_KPROBE,
+	PROBE_TYPE_KRETPROBE,
+	PROBE_TYPE_JPROBE,
+};
+
+struct module_probe_client {
+	struct list_head list;
+	const char *module;	/* including symbol name */
+	int active;
+	void *data;
+	probe_activate_handler_t handler;
+	enum probe_type type;
+	union {
+		struct kprobe *kp;
+		struct kretprobe *rp;
+		struct jprobe *jp;
+	};
+};
+
+static DEFINE_MUTEX(module_probe_mutex);
+static LIST_HEAD(module_probe_list);
+
+static int activate_module_probe(struct module_probe_client *pc)
+{
+	int ret = 0;
+	if (pc->active)
+		return 0;
+	switch (pc->type) {
+	case PROBE_TYPE_KPROBE:
+		ret = register_kprobe(pc->kp);
+		break;
+	case PROBE_TYPE_KRETPROBE:
+		ret = register_kretprobe(pc->rp);
+		break;
+	case PROBE_TYPE_JPROBE:
+		ret = register_jprobe(pc->jp);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+	if (!ret)
+		pc->active = 1;
+	return ret;
+}
+
+static void deactivate_module_probe(struct module_probe_client *pc)
+{
+	if (!pc->active)
+		return;
+	switch (pc->type) {
+	case PROBE_TYPE_KPROBE:
+		unregister_kprobe(pc->kp);
+		break;
+	case PROBE_TYPE_KRETPROBE:
+		unregister_kretprobe(pc->rp);
+		break;
+	case PROBE_TYPE_JPROBE:
+		unregister_jprobe(pc->jp);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+	pc->active = 0;
+}
+
+static const char *probed_module_name(struct kprobe *kp)
+{
+	if ((kp->symbol_name) && strchr(kp->symbol_name, ':'))
+		return kp->symbol_name;
+	return NULL;
+}
+
+static int module_is_exist(const char *module)
+{
+	char buf[MODULE_NAME_LEN + 8];
+	snprintf(buf, MODULE_NAME_LEN + 8, "%s:__stext", module);
+	return module_kallsyms_lookup_name(buf) ? 1 : 0;
+}
+
+static int add_module_probe(const char *module, void *p, enum probe_type type,
+			    probe_activate_handler_t handler, void *data)
+{
+	struct module_probe_client *pc;
+	int ret = 0;
+
+	if (!handler)
+		return -EINVAL;
+
+	pc = kzalloc(sizeof(struct module_probe_client), GFP_KERNEL);
+	pc->kp = p;
+	pc->type = type;
+	pc->module = module;
+	pc->handler = handler;
+	pc->data = data;
+	INIT_LIST_HEAD(&pc->list);
+
+	mutex_lock(&module_probe_mutex);
+	if (module_is_exist(module))
+		ret = activate_module_probe(pc);
+	if (ret)
+		kfree(pc);
+	else
+		list_add_tail(&pc->list, &module_probe_list);
+	mutex_unlock(&module_probe_mutex);
+	return ret;
+}
+
+static void __del_module_probe(struct module_probe_client *pc)
+{
+	list_del(&pc->list);
+	deactivate_module_probe(pc);
+	kfree(pc);
+}
+
+static int del_module_probe(void *p)
+{
+	struct module_probe_client *pc;
+	int ret;
+
+	mutex_lock(&module_probe_mutex);
+	list_for_each_entry(pc, &module_probe_list, list)
+		if (pc->kp == p) {
+			/* don't need safe loop, we exit soon */
+			__del_module_probe(pc);
+			goto found;
+		}
+	ret = -ENOENT;
+found:
+	mutex_unlock(&module_probe_mutex);
+	return ret;
+}
+
+int __kprobes
+register_module_kprobe(struct kprobe *kp,
+		       probe_activate_handler_t handler, void *data)
+{
+	const char *module;
+	module = probed_module_name(kp);
+	if (!module)
+		return register_kprobe(kp);
+	return add_module_probe(module, kp, PROBE_TYPE_KPROBE,
+				handler, data);
+}
+EXPORT_SYMBOL_GPL(register_module_kprobe);
+
+int __kprobes
+register_module_kretprobe(struct kretprobe *rp,
+			  probe_activate_handler_t handler, void *data)
+{
+	const char *module;
+	module = probed_module_name(&rp->kp);
+	if (!module)
+		return register_kretprobe(rp);
+	return add_module_probe(module, rp, PROBE_TYPE_KRETPROBE,
+				handler, data);
+}
+EXPORT_SYMBOL_GPL(register_module_kretprobe);
+
+int __kprobes
+register_module_jprobe(struct jprobe *jp,
+		       probe_activate_handler_t handler, void *data)
+{
+	const char *module;
+	module = probed_module_name(&jp->kp);
+	if (!module)
+		return register_jprobe(jp);
+	return add_module_probe(module, jp, PROBE_TYPE_JPROBE,
+				handler, data);
+}
+EXPORT_SYMBOL_GPL(register_module_jprobe);
+
+void __kprobes unregister_module_kprobe(struct kprobe *kp)
+{
+	const char *module;
+	module = probed_module_name(kp);
+	if (!module)
+		unregister_kprobe(kp);
+	else
+		del_module_probe(kp);
+}
+EXPORT_SYMBOL_GPL(unregister_module_kprobe);
+
+void __kprobes unregister_module_kretprobe(struct kretprobe *rp)
+{
+	const char *module;
+	module = probed_module_name(&rp->kp);
+	if (!module)
+		unregister_kretprobe(rp);
+	else
+		del_module_probe(rp);
+}
+EXPORT_SYMBOL_GPL(unregister_module_kretprobe);
+
+void __kprobes unregister_module_jprobe(struct jprobe *jp)
+{
+	const char *module;
+	module = probed_module_name(&jp->kp);
+	if (!module)
+		unregister_jprobe(jp);
+	else
+		del_module_probe(jp);
+}
+EXPORT_SYMBOL_GPL(unregister_module_jprobe);
+
+static int module_is_probed(const char *mod, const char *sym)
+{
+	int len = strlen(mod);
+	return strncmp(mod, sym, len) == 0 && sym[len] == ':';
+}
+
+static int module_probe_callback(struct notifier_block *nb,
+				 unsigned long state, void *module)
+{
+	struct module_probe_client *pc;
+	struct module *mod = module;
+	if (state == MODULE_STATE_LIVE)
+		return NOTIFY_DONE;
+
+	mutex_lock(&module_probe_mutex);
+	list_for_each_entry(pc, &module_probe_list, list) {
+		if (!module_is_probed(mod->name, pc->module))
+			continue;
+		if (state == MODULE_STATE_COMING &&
+		    pc->handler(pc->data, module)) {
+			activate_module_probe(pc);
+		} else if (state == MODULE_STATE_GOING)
+			deactivate_module_probe(pc);
+	}
+	mutex_unlock(&module_probe_mutex);
+	return NOTIFY_DONE;
+}
+
+struct notifier_block module_probe_nb = {
+	.notifier_call = module_probe_callback
+};
+
+static int __init init_module_probes(void)
+{
+	int ret;
+	ret = register_module_notifier(&module_probe_nb);
+	if (ret)
+		pr_warning("Failed to register module notifier\n");
+	return ret;
+}
+module_init(init_module_probes);
+
 module_init(init_kprobes);

 EXPORT_SYMBOL_GPL(register_kprobe);
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


