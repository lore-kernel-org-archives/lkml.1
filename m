Return-Path: <linux-kernel-owner+w=401wt.eu-S1758780AbZCBSG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbZCBSG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbZCBSGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:06:50 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:62059 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZCBSGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:06:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MknB1y1oTHWGHYoHlRJ/9yjEV6kjA2mGtuihZ/zwGuT6bDrq8KxYlDU4yg2FNg3bPd
         3vU8JlpCcq904IpCwRgIGkftSufNw+KPh5s0cYEy7NlTo+fIq8jGXd8/OoIDhciKgQj3
         f2AuCTNaU+2hHqqPSSMUXU9pJU2n0sVLUoV3U=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0903021252420.4771@gandalf.stny.rr.com>
References: <20090228091305.GA20533@elte.hu>
	 <49aa088b.1c07d00a.4512.ffffe781@mx.google.com>
	 <alpine.DEB.2.00.0903021128380.4771@gandalf.stny.rr.com>
	 <c62985530903020945i6098682bh59a5c6d6c6de759c@mail.gmail.com>
	 <alpine.DEB.2.00.0903021252420.4771@gandalf.stny.rr.com>
Date: Mon, 2 Mar 2009 19:06:44 +0100
Message-ID: <c62985530903021006k1a0b1197tc336800379cb5ded@mail.gmail.com>
Subject: Re: [PATCH 3/5] ftrace: add ftrace_bprintk()
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/2 Steven Rostedt <rostedt@goodmis.org>:
>
> On Mon, 2 Mar 2009, Fr?d?ric Weisbecker wrote:
>> >> +
>> >> +static
>> >> +void release_module_trace_bprintk_format(const char **start, const char **end)
>> >> +{
>> >> +     const char **iter;
>> >> +     lock_btrace();
>> >> +     for (iter = start; iter < end; iter++) {
>> >> +             struct trace_bprintk_fmt *tb_fmt;
>> >> +             if (!*iter)
>> >> +                     continue;
>> >> +
>> >> +             tb_fmt = container_of(*iter, struct trace_bprintk_fmt, fmt[0]);
>> >> +             tb_fmt->count--;
>> >> +             if (!tb_fmt->count && !btrace_metadata_count) {
>> >> +                     list_del(&tb_fmt->list);
>> >> +                     kfree(tb_fmt);
>> >
>> > Shouldn't *iter get assigned to NULL somewhere here?
>> >
>> > -- Steve
>>
>>
>> Hm, why?
>
> Well, after we free tb_fmt, the *iter will then point to garbage. Right?
>
> -- Steve


Now that you say it, I have some doubts about the possible sites that
can still dereference it
at this point.
I have to review and test it more seriously. I was convinced that the
count field kept track
of all references but now I'm not so sure, there can be still one
pending event that uses it into
the ring buffer, or it can be perhaps in use at the same time it is freed.
We should perhaps use rcu here, will see.
