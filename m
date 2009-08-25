Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZHYGeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZHYGeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZHYGef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:34:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZHYGef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:34:35 -0400
Message-ID: <4A9385AA.508@cn.fujitsu.com>
Date: Tue, 25 Aug 2009 14:33:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/profile: Fix profile_disable vs module_unload
References: <4A9214E3.2070807@cn.fujitsu.com>	 <1251093660.7538.119.camel@twins> <4A923197.4040708@cn.fujitsu.com>	 <1251097012.7538.123.camel@twins>  <20090824092455.GA25267@elte.hu>	 <1251106058.7538.149.camel@twins>  <4A937505.5000209@cn.fujitsu.com> <1251181266.7538.1016.camel@twins>
In-Reply-To: <1251181266.7538.1016.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>>>> If the correspoding module is unloaded before ftrace_profile_disable()
>>>>>>>> is called, event->profile_disable() won't be called, which can
>>>>>>>> cause oops:
>>>>>>>>
>>>>>>>>   # insmod trace-events-sample.ko
>>>>>>>>   # perf record -f -a -e sample:foo_bar sleep 3 &
>>>>>>>>   # sleep 1
>>>>>>>>   # rmmod trace_events_sample
>>>>>>>>   # insmod trace-events-sample.ko
>>>>>>>>   OOPS!
>>>>>>>>
>>>>>>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>>>>>> Hrmm, feel fragile, why don't we check if all a modules tracepoints are
>>>>>>> unused on unload?
>>>>>>>
>>>>>> I don't think it's fragile. We are profiling via a module's
>>>>>> tracepoint, so we should pin the module, via module_get().
>>>>>> If event->profile_enable() has been calld, we should make
>>>>>> sure it's profile_disable() will be called.
>>>>> What I call fragile is that everyone registering a tracepoint 
>>>>> callback will now apparently need to worry about modules, _that_ 
>>>>> is fragile.
>>>>>
>>>>> Either make module unload look at tracepoint users, or place the 
>>>>> try_get_module() in the registration hooks so that regular users 
>>>>> don't need to worry about it.
>>>> The bug found by Li needs to be fixed obviously.
>>>>
>>>> I tend to agree with you that this does not appear to be the best 
>>>> place to do it: so you suggest to implicitly increase the module 
>>>> refcount on callback registr instead? (and releasing it when 
>>>> unregistering)
>>>>
>>>> Same end result, slightly cleaner place to bump the refcount.
>>> Yes, because the user of tracepoints should never need to care about
>>> modules.
>>>
>> I'm afraid it is not feasible to bump module refcnt implicitly
>> in tracepoint_probe_register().
>>
>> If a tracepoint is registered in module_init, and unregistered
>> in module_exit (see sample/tracepoints), the module is unloadable:
>>
>>  insmod
>>  ->call mod->init()
>>    ->trace_reg_foo()
>>      ->module_get()
>>
>>  rmmod
>>  ->check mod refcnt
>>  ->call mod->exit()
>>    ->trace_unreg_foo()
>>      ->module_put()
> 
> Not tracepoint_probe_{un,}register(), in {un,}register_trace_$call().
> 

Is there any difference?

	static inline int register_trace_##name(void (*probe)(proto))	\
	{								\
		int ret;						\
		void (*func)(void) = reg;				\
									\
		ret = tracepoint_probe_register(#name, (void *)probe);	\
		if (func && !ret)					\
			func();						\
		return ret;						\
	}

> Basically avoid module unload when a tracepoint from that module has
> registered callbacks.

TRACE_EVENT() won't prevent this. Instead at module unload, a module
notifier callback will be called to unregistread those tracepoint callbacks.

