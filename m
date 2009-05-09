Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZEIPB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZEIPB5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 11:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZEIPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 11:01:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51479 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZEIPBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 11:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JIeA16Yp8OCwq3Y4fz5Yde/a/1vcnHwgKTSICzLoDvNZyQgZHtLFvQdt7ft8BzTDnL
         yCLMC5EIldNoTFTvfW0+Jhab13zD1iIo8ho/8VFkuiegPsAwl81do+z11SUnMx4bvf9E
         DfVF6N2IE9wRfbthBMn6ir3pD5shXqiVkKAVo=
MIME-Version: 1.0
In-Reply-To: <20090509142952.GA3511@Krystal>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu>
	 <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com>
	 <20090509133306.GA20684@elte.hu> <20090509135046.GA2344@Krystal>
	 <c62985530905090706t52929c0qe21418f86aca9ba8@mail.gmail.com>
	 <20090509141556.GA24082@elte.hu> <20090509142952.GA3511@Krystal>
Date: Sat, 9 May 2009 17:01:44 +0200
Message-ID: <c62985530905090801x1a2c34der364d4636ec667429@mail.gmail.com>
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/9 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>:
> * Ingo Molnar (mingo@elte.hu) wrote:
>>
>> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>>
>> > > I would expect to use copy_string_from_user (for strings) and
>> > > copy_from_user for structures, because without any strings
>> > > (especially), the trace information become much less useful.
>> >
>> > Yeah, for structures we would just need the copy_from_user.
>>
>> There's just a few places (mainly related to VFS APIs) where we
>> really want to do that, and there we want to do it a bit later, not
>> at syscall time: we want to do it after the getname(), to output a
>> stable (and already copied to kernel space) copy of the file name.
>>
>> So the right solution there would be to add special, case by case
>> tracepoints to those few places. We dont need strings for the
>> majority of the 300+ system calls that exist on Linux.
>>
>>       Ingo
>
> Hrm, this is an important design decision.. I cover a lot of those sites
> in my LTTng instrumentation, and this is clearly one way to do it, at
> the expense of adding tracepoints in many kernel locations when there
> could be a functionnal equivalent with syscall instrumentation.


Yeah, these tracepoints defined from DEFINE_SYSCALL are a good way
to proceed generically.
For specific cases, we can later add some upper layer, such as described below.


> The thing we would need to do it from the syscall tracing site is a
> table to map the system call numbers to their specific types (for the
> syscalls we care about) and therefore which would also map to a
> serialisation function to extract the parameters and write the correct
> content into the trace buffers.


I would rather see this not using the syscalls as a key but the type
of a parameter.
We can find a same specific complex type used by several syscalls.

If we want even better precision, we can also pair that with syscalls
mapping for specific post-computing in output time. As an exemple to
print O_RDONLY instead of the matching number.


>
> We could also use getname()/putname() in the syscall tracing primitive.
> Note that architectures like x86 64 needs some tweaks I have in my
> patchset to correctly ensure that syscall entry/exit are always paired.
> This is required because we change the thread flag synchronously with
> thread execution upen activation/deactivation.


Not sure I understand your point here. The only resulting problem of such
race would be rare unpaired syscall exit or entry traces... Is it that
much important?
