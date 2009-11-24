Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZKXPcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZKXPcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZKXPci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:32:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090AbZKXPce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:32:34 -0500
Message-ID: <4B0BFCF0.3060607@redhat.com>
Date: Tue, 24 Nov 2009 10:34:08 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 03/10] kprobes: Introduce kprobes jump	optimization
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232141.22071.53317.stgit@dhcp-100-2-132.bos.redhat.com> <20091124024417.GA6752@nowhere>
In-Reply-To: <20091124024417.GA6752@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

Frederic Weisbecker wrote:
> On Mon, Nov 23, 2009 at 06:21:41PM -0500, Masami Hiramatsu wrote:
>> +config OPTPROBES
>> +	bool "Kprobes jump optimization support (EXPERIMENTAL)"
>> +	default y
>> +	depends on KPROBES
>> +	depends on !PREEMPT
> 
> 
> Why does it depends on !PREEMPT?

Oh, because it has not supported preemptive kernel yet.
(I'd like to tell you why in another mail)

>> @@ -301,6 +302,31 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
>>  	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
>>  	mutex_unlock(&kprobe_insn_mutex);
>>  }
>> +#ifdef CONFIG_OPTPROBES
>> +/* For optimized_kprobe buffer */
>> +static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
>> +static struct kprobe_insn_cache kprobe_optinsn_slots = {
>> +	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
>> +	/* .insn_size is initialized later */
>> +	.nr_garbage = 0,
>> +};
>> +/* Get a slot for optimized_kprobe buffer */
>> +kprobe_opcode_t __kprobes *get_optinsn_slot(void)
>> +{
>> +	kprobe_opcode_t *ret = NULL;
>> +	mutex_lock(&kprobe_optinsn_mutex);
>> +	ret = __get_insn_slot(&kprobe_optinsn_slots);
>> +	mutex_unlock(&kprobe_optinsn_mutex);
>> +	return ret;
>> +}
> 
> 
> 
> Just a small nano-neat: could you add a line between variable
> declarations and the rest? And also just before the return?
> It makes the code a bit easier to review.

Sure :-)

>> +static void kprobe_optimizer(struct work_struct *work);
>> +static DECLARE_DELAYED_WORK(optimizing_work, kprobe_optimizer);
>> +#define OPTIMIZE_DELAY 5
>> +
>> +/* Kprobe jump optimizer */
>> +static __kprobes void kprobe_optimizer(struct work_struct *work)
>> +{
>> +	struct optimized_kprobe *op, *tmp;
>> +
>> +	/* Lock modules while optimizing kprobes */
>> +	mutex_lock(&module_mutex);
>> +	mutex_lock(&kprobe_mutex);
>> +	if (kprobes_all_disarmed)
>> +		goto end;
>> +
>> +	/* Wait quiesence period for ensuring all interrupts are done */
>> +	synchronize_sched();
> 
> 
> 
> It's not clear to me why you are doing that.
> Is this waiting for pending int 3 kprobes handlers
> to complete? If so, why, and what does that prevent?
> 
> Also, why is it a delayed work? I'm not sure what we are
> waiting for here.
[...]
> Again, I think this dance with live patching protected
> by int 3 only, which patching is in turn a necessary
> stage before, is a complicated sequence that could be
> simplified by choosing only one patching in stop_machine()
> time.

There is a reason why we have to wait here and it's excuse
why it hasn't supported preemption yet too, I'll tell you
in next mail :-)

>> +
>> +	get_online_cpus();	/* Use online_cpus while optimizing */
> 
> 
> 
> And this comment doesn't tell us much what this brings us.
> The changelog tells it stands to avoid a text_mutex deadlock.
> I'm not sure why we would deadlock without it.

As Mathieu and I discussed on LKML (http://lkml.org/lkml/2009/11/21/187)
text_mutex will be locked on the way of cpu-hotplug.
Since kprobes locks text_mutex too and stop_machine() refers online_cpus,
it will cause a dead-lock. So, I decided to use get_online_cpus() to
locking hotplug while optimizing/unoptimizng.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

