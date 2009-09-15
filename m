Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZION7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZION7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbZION7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZION7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:59:49 -0400
Message-ID: <4AAF9E30.5030705@redhat.com>
Date: Tue, 15 Sep 2009 10:01:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
References: <4AAF6728.6010807@bk.jp.nec.com> <1253022224.20020.102.camel@gandalf.stny.rr.com>
In-Reply-To: <1253022224.20020.102.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
>> Export register_ and unresgister_ftrace_function_probe to modules. This can
>> be used by SystemTap.
>>
>> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
>> ---
>>  kernel/trace/ftrace.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 5ef8f59..9c32291 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2042,6 +2042,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>>  
>>  	return count;
>>  }
>> +EXPORT_SYMBOL_GPL(register_ftrace_function_probe);
>>  
>>  enum {
>>  	PROBE_TEST_FUNC		= 1,
>> @@ -2108,6 +2109,7 @@ unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>>  	__unregister_ftrace_function_probe(glob, ops, data,
>>  					  PROBE_TEST_FUNC | PROBE_TEST_DATA);
>>  }
>> +EXPORT_SYMBOL_GPL(unregister_ftrace_function_probe);
> 
> I have to NAK this as is. There's a reason I never exported these to
> modules, and that is because they are not module safe. There's nothing
> to stop a module from registering a probe and then being removed. Then
> the function probe will still be called causing a kernel panic.
> 
> 
> Now I know of two ways to fix this.
> 
> 1) The simple way. Up the module ref count so once it registers a
> function it can never be disabled. Of course there's the "force module
> unload" but people should not do that anyway.
> 
> 2) Create a second hook handler for modules. That is the function caller
> for modules will go to a wrapper first. This wrapper could disable
> interrupts or grab a lock or something that would prevent a module from
> being unloaded as the hooks are being called. Perhaps even disabling
> preemption while calling the hooks will be enough (this is not something
> I want the normal function caller to do).

I think this is better solution.
Out of curiously, is disabling preemption so harmful?

> And the current function
> tracer will optimize that if only one function is registered to mcount,
> then the mcount caller will call that function directly.

Would you mean that current mcount hook supports only one handler?

> 
> It will still need to up the mod ref count when a probe is added, but it
> can also remove it.
> 
> 
> The problem with the current method, is that a probe can be executing at
> anytime. Here's an example if we did it your way.
> 
> 1. module installed
> 2. module adds probe
> 3. function X in kernel calls probe but gets preempted.
> 4. module removes probe
> 5. module unistalled
> 6. function X in kernel continues to run probe but probe no longer
> exists --- Oops!

Agreed, if mcount doesn't disable preemption, this will happen.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

