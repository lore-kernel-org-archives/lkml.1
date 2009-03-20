Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZCTDsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZCTDsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZCTDsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:48:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZCTDs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:48:28 -0400
Message-ID: <49C31206.3060806@redhat.com>
Date: Thu, 19 Mar 2009 23:48:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 8/9] kprobes: support respawn probes for	module
 probing
References: <49C2B4D4.1040205@redhat.com> <20090320011929.GE6895@nowhere>
In-Reply-To: <20090320011929.GE6895@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
>> index 5016bfb..f16a54e 100644
>> --- a/kernel/kprobes.c
>> +++ b/kernel/kprobes.c
>> @@ -1416,6 +1416,256 @@ static int __kprobes debugfs_kprobe_init(void)
>>  late_initcall(debugfs_kprobe_init);
>>  #endif /* CONFIG_DEBUG_FS */
>>
>> +/* Kprobes module respawn support */
>> +enum probe_type {
>> +	PROBE_TYPE_KPROBE,
>> +	PROBE_TYPE_KRETPROBE,
>> +	PROBE_TYPE_JPROBE,
>> +};
>> +
>> +struct module_probe_client {
>> +	struct list_head list;
>> +	const char *module;	/* including symbol name */
>> +	int active;
>> +	void *data;
>> +	probe_activate_handler_t handler;
>> +	enum probe_type type;
>> +	union {
>> +		struct kprobe *kp;
>> +		struct kretprobe *rp;
>> +		struct jprobe *jp;
>> +	};
>> +};
>> +
>> +static DEFINE_MUTEX(module_probe_mutex);
>> +static LIST_HEAD(module_probe_list);
>> +
>> +static int activate_module_probe(struct module_probe_client *pc)
>> +{
>> +	int ret = 0;
>> +	if (pc->active)
>> +		return 0;
>> +	switch (pc->type) {
>> +	case PROBE_TYPE_KPROBE:
>> +		ret = register_kprobe(pc->kp);
>> +		break;
>> +	case PROBE_TYPE_KRETPROBE:
>> +		ret = register_kretprobe(pc->rp);
>> +		break;
>> +	case PROBE_TYPE_JPROBE:
>> +		ret = register_jprobe(pc->jp);
>> +		break;
>> +	default:
>> +		WARN_ON(1);
>> +		break;
>> +	}
>> +	if (!ret)
>> +		pc->active = 1;
>> +	return ret;
>> +}
>> +
>> +static void deactivate_module_probe(struct module_probe_client *pc)
>> +{
>> +	if (!pc->active)
>> +		return;
>> +	switch (pc->type) {
>> +	case PROBE_TYPE_KPROBE:
>> +		unregister_kprobe(pc->kp);
>> +		break;
>> +	case PROBE_TYPE_KRETPROBE:
>> +		unregister_kretprobe(pc->rp);
>> +		break;
>> +	case PROBE_TYPE_JPROBE:
>> +		unregister_jprobe(pc->jp);
>> +		break;
>> +	default:
>> +		WARN_ON(1);
>> +		break;
>> +	}
>> +	pc->active = 0;
>> +}
>> +
>> +static const char *probed_module_name(struct kprobe *kp)
>> +{
>> +	if ((kp->symbol_name) && strchr(kp->symbol_name, ':'))
>> +		return kp->symbol_name;
>> +	return NULL;
>> +}
>> +
>> +static int module_is_exist(const char *module)
>> +{
>> +	char buf[MODULE_NAME_LEN + 8];
>> +	snprintf(buf, MODULE_NAME_LEN + 8, "%s:__stext", module);
>> +	return module_kallsyms_lookup_name(buf) ? 1 : 0;
>> +}
>> +
>> +static int add_module_probe(const char *module, void *p, enum probe_type type,
>> +			    probe_activate_handler_t handler, void *data)
>> +{
>> +	struct module_probe_client *pc;
>> +	int ret = 0;
>> +
>> +	if (!handler)
>> +		return -EINVAL;
>> +
>> +	pc = kzalloc(sizeof(struct module_probe_client), GFP_KERNEL);
>> +	pc->kp = p;
>> +	pc->type = type;
>> +	pc->module = module;
>> +	pc->handler = handler;
>> +	pc->data = data;
>> +	INIT_LIST_HEAD(&pc->list);
>> +
>> +	mutex_lock(&module_probe_mutex);
>> +	if (module_is_exist(module))
>> +		ret = activate_module_probe(pc);
>> +	if (ret)
>> +		kfree(pc);
>> +	else
>> +		list_add_tail(&pc->list, &module_probe_list);
>> +	mutex_unlock(&module_probe_mutex);
>> +	return ret;
>> +}
>> +
>> +static void __del_module_probe(struct module_probe_client *pc)
>> +{
>> +	list_del(&pc->list);
>> +	deactivate_module_probe(pc);
>> +	kfree(pc);
>> +}
>> +
>> +static int del_module_probe(void *p)
>> +{
>> +	struct module_probe_client *pc;
>> +	int ret;
>> +
>> +	mutex_lock(&module_probe_mutex);
>> +	list_for_each_entry(pc, &module_probe_list, list)
>> +		if (pc->kp == p) {
>> +			/* don't need safe loop, we exit soon */
>> +			__del_module_probe(pc);
>> +			goto found;
>> +		}
>> +	ret = -ENOENT;
>> +found:
>> +	mutex_unlock(&module_probe_mutex);
>> +	return ret;
>> +}
>> +
>> +int __kprobes
>> +register_module_kprobe(struct kprobe *kp,
>> +		       probe_activate_handler_t handler, void *data)
>> +{
>> +	const char *module;
>> +	module = probed_module_name(kp);
>> +	if (!module)
>> +		return register_kprobe(kp);
>> +	return add_module_probe(module, kp, PROBE_TYPE_KPROBE,
>> +				handler, data);
>> +}
>> +EXPORT_SYMBOL_GPL(register_module_kprobe);
>> +
>> +int __kprobes
>> +register_module_kretprobe(struct kretprobe *rp,
>> +			  probe_activate_handler_t handler, void *data)
>> +{
>> +	const char *module;
>> +	module = probed_module_name(&rp->kp);
>> +	if (!module)
>> +		return register_kretprobe(rp);
>> +	return add_module_probe(module, rp, PROBE_TYPE_KRETPROBE,
>> +				handler, data);
>> +}
>> +EXPORT_SYMBOL_GPL(register_module_kretprobe);
>> +
>> +int __kprobes
>> +register_module_jprobe(struct jprobe *jp,
>> +		       probe_activate_handler_t handler, void *data)
>> +{
>> +	const char *module;
>> +	module = probed_module_name(&jp->kp);
>> +	if (!module)
>> +		return register_jprobe(jp);
>> +	return add_module_probe(module, jp, PROBE_TYPE_JPROBE,
>> +				handler, data);
>> +}
>> +EXPORT_SYMBOL_GPL(register_module_jprobe);
>> +
>> +void __kprobes unregister_module_kprobe(struct kprobe *kp)
>> +{
>> +	const char *module;
>> +	module = probed_module_name(kp);
>> +	if (!module)
>> +		unregister_kprobe(kp);
>> +	else
>> +		del_module_probe(kp);
>> +}
>> +EXPORT_SYMBOL_GPL(unregister_module_kprobe);
>> +
>> +void __kprobes unregister_module_kretprobe(struct kretprobe *rp)
>> +{
>> +	const char *module;
>> +	module = probed_module_name(&rp->kp);
>> +	if (!module)
>> +		unregister_kretprobe(rp);
>> +	else
>> +		del_module_probe(rp);
>> +}
>> +EXPORT_SYMBOL_GPL(unregister_module_kretprobe);
>> +
>> +void __kprobes unregister_module_jprobe(struct jprobe *jp)
>> +{
>> +	const char *module;
>> +	module = probed_module_name(&jp->kp);
>> +	if (!module)
>> +		unregister_jprobe(jp);
>> +	else
>> +		del_module_probe(jp);
>> +}
>> +EXPORT_SYMBOL_GPL(unregister_module_jprobe);
>> +
>> +static int module_is_probed(const char *mod, const char *sym)
>> +{
>> +	int len = strlen(mod);
>> +	return strncmp(mod, sym, len) == 0 && sym[len] == ':';
>> +}
>> +
>> +static int module_probe_callback(struct notifier_block *nb,
>> +				 unsigned long state, void *module)
>> +{
>> +	struct module_probe_client *pc;
>> +	struct module *mod = module;
>> +	if (state == MODULE_STATE_LIVE)
>> +		return NOTIFY_DONE;
>> +
>> +	mutex_lock(&module_probe_mutex);
>> +	list_for_each_entry(pc, &module_probe_list, list) {
>> +		if (!module_is_probed(mod->name, pc->module))
>> +			continue;
>> +		if (state == MODULE_STATE_COMING &&
>> +		    pc->handler(pc->data, module)) {
> 
> 
> I don't see a place where you check if pc->handler != NULL
> May be you could attach a stub in such cases.

Please see add_module_probe(), handler == NULL case returns -EINVAL,
and module_probe_list is internal list. So, pc->handler never be NULL.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

