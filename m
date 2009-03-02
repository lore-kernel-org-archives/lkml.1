Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbZCBS4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbZCBS4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759243AbZCBSzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:55:45 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:49695 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987AbZCBSzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:55:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wUmeoYan3gILj5z7IQzGnDlnsfrqYMQxVKn+hMv6OWO54p5Vp2XblUQyIznLBrazTE
         aLPWyx33BBLrfZYy15pGMLBSx0iV5Sn1yrr2Ue6HwrpxkOTY5jGV77UzqlZGihV0caUI
         g0p+v2nOVGZf+k3Q+bD313IC3t4yzPhfoK+wY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0903021311190.4771@gandalf.stny.rr.com>
References: <20090228091305.GA20533@elte.hu>
	 <49aa088b.1c07d00a.4512.ffffe781@mx.google.com>
	 <alpine.DEB.2.00.0903021128380.4771@gandalf.stny.rr.com>
	 <c62985530903020945i6098682bh59a5c6d6c6de759c@mail.gmail.com>
	 <alpine.DEB.2.00.0903021252420.4771@gandalf.stny.rr.com>
	 <c62985530903021006k1a0b1197tc336800379cb5ded@mail.gmail.com>
	 <alpine.DEB.2.00.0903021311190.4771@gandalf.stny.rr.com>
Date: Mon, 2 Mar 2009 19:55:41 +0100
Message-ID: <c62985530903021055v55a184b1tb856df28d2192197@mail.gmail.com>
Subject: Re: [PATCH 3/5] ftrace: add ftrace_bprintk()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/2 Steven Rostedt <rostedt@goodmis.org>:
>
> On Mon, 2 Mar 2009, Fr?d?ric Weisbecker wrote:
>
>> 2009/3/2 Steven Rostedt <rostedt@goodmis.org>:
>> >
>> > On Mon, 2 Mar 2009, Fr?d?ric Weisbecker wrote:
>> >> >> +
>> >> >> +static
>> >> >> +void release_module_trace_bprintk_format(const char **start, const char **end)
>> >> >> +{
>> >> >> +     const char **iter;
>> >> >> +     lock_btrace();
>> >> >> +     for (iter = start; iter < end; iter++) {
>> >> >> +             struct trace_bprintk_fmt *tb_fmt;
>> >> >> +             if (!*iter)
>> >> >> +                     continue;
>> >> >> +
>> >> >> +             tb_fmt = container_of(*iter, struct trace_bprintk_fmt, fmt[0]);
>> >> >> +             tb_fmt->count--;
>> >> >> +             if (!tb_fmt->count && !btrace_metadata_count) {
>> >> >> +                     list_del(&tb_fmt->list);
>> >> >> +                     kfree(tb_fmt);
>> >> >
>> >> > Shouldn't *iter get assigned to NULL somewhere here?
>> >> >
>> >> > -- Steve
>> >>
>> >>
>> >> Hm, why?
>> >
>> > Well, after we free tb_fmt, the *iter will then point to garbage. Right?
>> >
>> > -- Steve
>>
>>
>> Now that you say it, I have some doubts about the possible sites that
>> can still dereference it
>> at this point.
>> I have to review and test it more seriously. I was convinced that the
>> count field kept track
>> of all references but now I'm not so sure, there can be still one
>> pending event that uses it into
>> the ring buffer, or it can be perhaps in use at the same time it is freed.
>> We should perhaps use rcu here, will see.
>>
>
> How do you deal with ref counters in the ring buffer? If the ring buffer
> is set to overwrite mode (in which is usually is), then you will never
> know if a print was erased.


Ah, I didn't think about it.

>
> I haven't looked too deep into the implementation. But one safe way to
> do this, with respect to modules, is the following:
>
> #define ftrace_bprintk(fmt, args...) \
>        do { \
>                static const char __attribute__((section(ftrace_fmt))\
>                        *f = fmt; \
>                _ftrace_bprintk(&f, args); \
>        } while(0)
>
> On output, you can do:
>
>        trace_print_bprintk(...)
>        {
>                char **f = field->f;
>
>                if (!f)
>                        trace_seq_printf(s, "MODULE UNLOADED?\n");
>                trace_seq_printf(s, *f, ...)
>
> Do you see what I'm doing?
>
> Make the ftrace_printk create a constant pointer to the format instead
> of passing in the format. It will istead pass in the address of something
> pointing to the format.
>
> Then on module load, you allocate the area and copy in all the ftrace_fmt
> sections.
>
> On module unload, you just NULL out that area. You could probably reuse
> those NULL spots, but you would need some kind of checksum to be added
> such that a new module will be detected on print out.


Yeah ok, but it seems rather complex.
I think we can still use this list of format pointers but:

- make it a hashlist of format strings
- if a module is loaded we make a copy of each printk formats but
firstly we verify if it already exists into the hashlist. If so, then
only override the format pointer on the module (don't allocate any new
thing)

_when it is unloaded...don't do anything.

So yes, perhaps we will never free these strings, but at least we
avoid duplicated formats on the
list and then somewhat limit the bad consequences.

Hm?

>
> This is the reason I avoided doing ftrace printk via pointers :-/
>
> -- Steve
>
