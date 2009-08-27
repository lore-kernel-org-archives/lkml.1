Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbZH0BDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbZH0BDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 21:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZH0BDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 21:03:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55318 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbZH0BDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:03:21 -0400
Message-ID: <4A95DAF9.9070400@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 09:01:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
References: <20090825103907.GB28287@elte.hu> <1251197235.7538.1142.camel@twins> <1251211963.7538.1164.camel@twins> <4A94D3A8.1090902@cn.fujitsu.com> <1251269207.7538.1217.camel@twins> <1251270092.7538.1226.camel@twins> <4A94DFF4.5030301@cn.fujitsu.com> <alpine.DEB.2.00.0908261012020.23885@gandalf.stny.rr.com> <20090826164624.GA21456@Krystal> <alpine.DEB.2.00.0908261343010.11291@gandalf.stny.rr.com> <20090826180114.GA29130@Krystal>
In-Reply-To: <20090826180114.GA29130@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
>> This patch solves the problem that Li originally reported. If something 
>> registers a trace point belonging to a module, then it ups the ref count 
>> of the module. This prevents a process from registering a probe to a 
>> tracepoint belonging to a module and then having the module disappear.
>>
>> Doing the example with perf in Li's original post, now errors on the 
>> rmmod, with "ERROR: Module trace_events_sample is in use".
>>
>> Mathieu, can I have your acked-by on this?
>>
> 
> Sorry, it looks buggy.
> 

And the patch itself is buggy.

> It does not deal with the fact that tracepoints with the same name and
> arguments can be present in more than one module, or in a combination of
> kernel core and modules.
> 
> The struct tracepoint_entry is specific to a a tracepoint name, used for
> registration, but is eventually tied to all tracepoint instrumentation
> instances for this tracepoint name.
> 
> Mathieu
> 

...

>> -tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
>> +tracepoint_update_probe_range(struct module *mod,
>> +			      struct tracepoint *begin, struct tracepoint *end)
>>  {
>>  	struct tracepoint *iter;
>>  	struct tracepoint_entry *mark_entry;
>> @@ -286,9 +291,15 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
>>  	for (iter = begin; iter < end; iter++) {
>>  		mark_entry = get_tracepoint(iter->name);
>>  		if (mark_entry) {
>> +			if (mod && !mark_entry->mod) {
>> +				if (!try_module_get(mod))
>> +					goto disable;

You can hit this code-path even when you unregister a probe,
so the right way is:
	module_get() when iter->state changed from 0 from 1
	module_put() when iter->state changed from 1 to 0

But still has some other problems. You don't fail the registration,
profile_enable() will return success even when the module is
being destructed.

>> +				mark_entry->mod = mod;
>> +			}
>>  			set_tracepoint(&mark_entry, iter,
>>  					!!mark_entry->refcount);
>>  		} else {
>> + disable:
>>  			disable_tracepoint(iter);
>>  		}
>>  	}
