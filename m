Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbYF3UAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbYF3UAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbYF3UAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:00:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbYF3UAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:00:35 -0400
Message-ID: <48693AFB.1020304@redhat.com>
Date: Mon, 30 Jun 2008 15:58:51 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133009.GC13751@Krystal> <48655464.5040000@redhat.com> <20080630154002.GE17388@Krystal>
In-Reply-To: <20080630154002.GE17388@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Mathieu Desnoyers wrote:
>>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>>  >
>>>>> Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
>>>> What would you think redesigning markers on tracepoints? because most of the
>>>> logic (scaning sections, multiple probe and activation) seems very similar
>>>> to markers.
>>>>
>>> We could, although markers, because they use var args, allow to put the
>>> iteration on the multi probe array out-of-line. Tracepoints cannot
>>> afford this and the iteration must be done at the initial call-site.
>>>
>>> From what I see in your proposal, it's mostly to extract the if() call()
>>> code from the inner __trace_mark() macro and to put it in a separate
>>> macro, am I correct ? This would make the macro more readable.
>> Sure, I think marker and tracepoint can share below functions;
>> - definition of static local variables in specific sections
> 
> Given that we could want to keep activation of tracepoints and markers
> separate (so they don't share the same namespace), declaring the static
> variables in separated sections seems to make sense to me.

Sorry, I'm not sure what is "separate activation".
As far as I can see, both tracepoints and markers are activated
when its probe handlers are registered on each tracepoint/marker.
Aren't it separated?

I did not mean integrating registering interfaces, but
I think that they can share base(internal) functions.
for example, both of them has XXX_update_range/_module_XXX_update etc.

IMHO, current code is not so good for maintenance. there are
many code duplications (ex. kernel/module.c, I think
that both of them (and imv too?) can share the code for
handling its section and iterating entries). I'm not sure those
duplications are acceptable.

>> - probe activation code (if() call())
>> - multi probe handling
> 
> Hrm, the thing here is that because markers allow to do the iteration on
> the multiple probe callbacks within an internal wrapper (instead of
> doing it on-site as in the tracepoints), it allows to do some further
> optimizations (less memory allocation and less pointer dereference in
> the single probe case, not having to prepare the va_args in the
> MARK_NOARGS case) which are only done because it does not have to add
> code to the instrumentation site. However, tracepoints cannot have such
> "generic" wrapper and we have to do the iteration on callbacks in the
> code added to the instrumented object. Therefore, I keep it as small as
> possible in terms of bytes of instructions.

OK, I see. So, __tracepoint_block() macro can specify handler function.
what would you think about it?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

