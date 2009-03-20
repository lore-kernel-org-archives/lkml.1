Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbZCTDws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbZCTDws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZCTDwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:52:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54175 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbZCTDwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:52:37 -0400
Message-ID: <49C31314.40508@redhat.com>
Date: Thu, 19 Mar 2009 23:52:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PATCH -tip 8/9] kprobes: support respawn probes for 	module
 probing
References: <49C2B4D4.1040205@redhat.com> <20090320011114.GD6895@nowhere>
In-Reply-To: <20090320011114.GD6895@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Mar 19, 2009 at 05:10:44PM -0400, Masami Hiramatsu wrote:
>> Add module_*probe API's to respawn probes on kernel modules.
>> kprobes which have been registered through register_module_*probe are
>> activated when the target module is loaded, and deactivated when unloading.
>> register_module_*probe require an activate_handler which is called right
>> before activating the probe, and if it returns !0, kprobes will be activated.
>>
>> Thus, users can check whether the target module is true target or not
>> (e.g. checking build-id) in activate_handler.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> ---
>>  include/linux/kprobes.h |   39 ++++++++
>>  kernel/kprobes.c        |  250 +++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 289 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
>> index 2ec6cc1..9d47d08 100644
>> --- a/include/linux/kprobes.h
>> +++ b/include/linux/kprobes.h
>> @@ -37,6 +37,7 @@
>>  #include <linux/spinlock.h>
>>  #include <linux/rcupdate.h>
>>  #include <linux/mutex.h>
>> +#include <linux/module.h>
>>
>>  #ifdef CONFIG_KPROBES
>>  #include <asm/kprobes.h>
>> @@ -69,6 +70,7 @@ typedef int (*kprobe_fault_handler_t) (struct kprobe *, struct pt_regs *,
>>  				       int trapnr);
>>  typedef int (*kretprobe_handler_t) (struct kretprobe_instance *,
>>  				    struct pt_regs *);
>> +typedef int (*probe_activate_handler_t)(void *, struct module *);
> 
> 
> I guess it could also be useful to call the handler when the module
> is unloaded. Be using another parameter with a LOAD/UNLOAD enum value.

Hmm, when unloading module, kprobes becomes "gone". So I think we don't
need to check whether it can be deactivated or not when unloading.



>>  struct kprobe {
>>  	struct hlist_node hlist;
>> @@ -279,6 +281,16 @@ void unregister_kretprobes(struct kretprobe **rps, int num);
>>  void kprobe_flush_task(struct task_struct *tk);
>>  void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
>>
>> +int register_module_kprobe(struct kprobe *kp,
>> +			   probe_activate_handler_t handler, void *data);
>> +int register_module_kretprobe(struct kretprobe *rp,
>> +			      probe_activate_handler_t handler, void *data);
>> +int register_module_jprobe(struct jprobe *jp,
>> +			   probe_activate_handler_t handler, void *data);
>> +void unregister_module_kprobe(struct kprobe *kp);
>> +void unregister_module_kretprobe(struct kretprobe *rp);
>> +void unregister_module_jprobe(struct jprobe *jp);
>> +
>>  #else /* !CONFIG_KPROBES: */
>>
>>  static inline int kprobes_built_in(void)
>> @@ -345,5 +357,32 @@ static inline void unregister_kretprobes(struct kretprobe **rps, int num)
>>  static inline void kprobe_flush_task(struct task_struct *tk)
>>  {
>>  }
>> +static inline int register_module_kprobe(struct kprobe *kp,
>> +					 probe_activate_handler_t handler,
>> +					 void *data)
>> +{
>> +	return -ENOSYS;
>> +}
>> +static inline int register_module_kretprobe(struct kretprobe *rp,
>> +					    probe_activate_handler_t handler,
>> +					    void *data)
>> +{
>> +	return -ENOSYS;
>> +}
>> +static inline int register_module_jprobe(struct jprobe *jp,
>> +					 probe_activate_handler_t handler,
>> +					 void *data)
>> +{
>> +	return -ENOSYS;
>> +}
>> +void unregister_module_kprobe(struct kprobe *kp)
>> +{
>> +}
>> +void unregister_module_kretprobe(struct kretprobe *rp)
>> +{
>> +}
>> +void unregister_module_jprobe(struct jprobe *jp)
>> +{
>> +}
> 
> 
> Shouldn't the unregister_* be inlined too?
> I think they all could be static inlined too in case of !CONFIG_MODULE

Ah, right... it was my mistake.


>>  #endif /* CONFIG_KPROBES */
>>  #endif /* _LINUX_KPROBES_H */
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
> 
> 
> #ifdef CONFIG_MODULE ?
> 
> Frederic.

Yes.

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

