Return-Path: <linux-kernel-owner+w=401wt.eu-S933615AbZJFWbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615AbZJFWbC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933429AbZJFWbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:31:01 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49044 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256AbZJFWa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:30:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AnIX8pE+kxL70FaD3j0nfNr2ZmhTiURKKj1dB/EnDb+v155LCSm0c5953o+LM74SbG
         fnIKaMDn0NhGe0oNmf7lWsi3T/5ztIRZZtqb4KPoCdFyX7t51NFspn3JG8Hlhpi0cog/
         V1z+J/F39UJx0DvnocEg94w6aQGBC0Yi6mql0=
Message-ID: <4ACBC510.1060006@gmail.com>
Date: Tue, 06 Oct 2009 15:30:40 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com> <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com> <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com> <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com> <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com> <20091002211211.GA2633@redhat.com> <1254792249.13160.213.camel@gandalf.stny.rr.com> <20091006203225.GC2631@redhat.com>
In-Reply-To: <20091006203225.GC2631@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> On Mon, Oct 05, 2009 at 09:24:09PM -0400, Steven Rostedt wrote:
>    
>> On Fri, 2009-10-02 at 17:12 -0400, Jason Baron wrote:
>>
>>      
>>> hi Justin,
>>>
>>> I've been playing around with gcc '4.5' as well and hit a panic that
>>> looks very similar to what you've seen with stock 2.6.31 - I haven't
>>> seen it anywhere else. Anyways, it seems to be some sort of alignment
>>> issue with the 'struct ftrace_event_call'. I'm not sure yet if this is a
>>> compiler or kernel issue. But the following kernel patch fixes the issue
>>> for me. It would be interesting to verify if the patch also resolves the
>>> issue for you.
>>>
>>> thanks,
>>>
>>> -Jason
>>>
>>>
>>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>>> index 6ad76bf..0029af4 100644
>>> --- a/include/asm-generic/vmlinux.lds.h
>>> +++ b/include/asm-generic/vmlinux.lds.h
>>> @@ -164,6 +164,7 @@
>>>   	LIKELY_PROFILE()		       				\
>>>   	BRANCH_PROFILE()						\
>>>   	TRACE_PRINTKS()							\
>>> +	. = ALIGN(32);							\
>>>   	FTRACE_EVENTS()							\
>>>   	TRACE_SYSCALLS()
>>>
>>> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
>>> index a81170d..43f9f1e 100644
>>> --- a/include/linux/ftrace_event.h
>>> +++ b/include/linux/ftrace_event.h
>>> @@ -124,7 +124,7 @@ struct ftrace_event_call {
>>>   	atomic_t		profile_count;
>>>   	int			(*profile_enable)(struct ftrace_event_call *);
>>>   	void			(*profile_disable)(struct ftrace_event_call *);
>>> -};
>>> +} __attribute__((aligned(32)));
>>>
>>>   #define MAX_FILTER_PRED		32
>>>   #define MAX_FILTER_STR_VAL	128
>>> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
>>> index f64fbaa..4697fb6 100644
>>> --- a/include/trace/ftrace.h
>>> +++ b/include/trace/ftrace.h
>>> @@ -600,7 +600,7 @@ static int ftrace_raw_init_event_##call(void)				\
>>>   }									\
>>>   									\
>>>   static struct ftrace_event_call __used					\
>>> -__attribute__((__aligned__(4)))						\
>>> +__attribute__((__aligned__(32)))					\
>>>   __attribute__((section("_ftrace_events"))) event_##call = {		\
>>>   	.name			= #call,				\
>>>   	.system			= __stringify(TRACE_SYSTEM),		\
>>>        
>> Are all alignments needed? Or just adding one might help. Or removing
>> the one directly above?
>>
>> -- Steve
>>
>>      
>
> So the problem I'm seeing is an oops on boot caused by the call->system pointer
> deference in event_create_dir(). The 'call' variable is of type 'struct
> ftrace_event_call'.
>
> What's going on is that the 'struct ftrace_event_call' is of size 168 bytes
> (sizeof(struct ftrace_event_call)) = 168 = 0xA8. However, in memory the
> structures are 16-byte aligned. Thus, the stride for walking through the
> pointers needs to be 176 (0xB0), but instead its 168 causing the oops.
>
> I've only seen this issue while using gcc (GCC) 4.5.0 20090916, on a
> vanilla 2.6.31 kernel.
>
> That said, I'm not sure the compiler is doing the wrong thing here. The
> 'struct ftrace_event_call' contains an embedded 'struct list_head' which
> is 16 bytes. According to the gcc docs, the aligned attribute, 'specifies a
> minimum alignment for the variable or structure field, measured in bytes'.
> Thus, at least according to the docs, gcc can increase the alignment of the
> 'struct ftrace_event_call', from its original specification of 4, to 16. Even
> in the case where we are working corectly the structures are 8-byte aligned.
>
> Thus, I would reccommend the patch below as a preventive measure. Its
> the minimal patch I've found to resolve this issue. In general, if we
> are going to walk data structures embedded in a special elf section, I
> think the general rules needs to be to set the alignment to the power of
> two which is greater than or equal to the largest item in the structure.
>
> thanks,
>
> -Jason
>
> Signed-off-by: Jason Baron<jbaron@redhat.com>
>
>
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index a81170d..7182f03 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -124,7 +124,10 @@ struct ftrace_event_call {
>   	atomic_t		profile_count;
>   	int			(*profile_enable)(struct ftrace_event_call *);
>   	void			(*profile_disable)(struct ftrace_event_call *);
> -};
> +} __attribute__((aligned(16)));
> +
> +/* Align to the largest field in the data structure:
> + * sizeof(struct list_head) = 16 */
>
>   #define MAX_FILTER_PRED		32
>   #define MAX_FILTER_STR_VAL	128
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index f64fbaa..e344e81 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -600,7 +600,6 @@ static int ftrace_raw_init_event_##call(void)				\
>   }									\
>   									\
>   static struct ftrace_event_call __used					\
> -__attribute__((__aligned__(4)))						\
>   __attribute__((section("_ftrace_events"))) event_##call = {		\
>   	.name			= #call,				\
>   	.system			= __stringify(TRACE_SYSTEM),		\
>
>
>
>
>    
shoot I don't know why this is still hitting.
tried both patches and still.
As of now the only thing I can think of besides looking
at kernel/compiler is the patch for sysvinit to load
the policy(maybe something in there is old/outdated).

(BTW: not sure if it means anything but this system is x86_64
built from  the multilib clfs, but with no 32 bit libs, pretty much
how fedora11 has there system built)

Justin P. Mattock
