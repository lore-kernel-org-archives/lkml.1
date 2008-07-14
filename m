Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYGNTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYGNTro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbYGNTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:47:36 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:17034 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYGNTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=YDOMNj0ukWshJMvNIYLCfH3FapIPbhiavKjC92y6M+FYezVg+OpHhEDQA/W2i8KP31
         pSywO1UgQmMifAdjI7XWIlz9u0Y/PC6pRJ3JJYEpmfhD3B6XqpMCsLR4YPDBvKaHXf5F
         4FSABkdxaW5iv4OnAHgiASLWLNrewZkW7F4Nc=
Message-ID: <487BAD4F.60105@gmail.com>
Date: Mon, 14 Jul 2008 16:47:27 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: /proc/data information
References: <487A606E.5040202@gmail.com> <87ej5wzahp.fsf@basil.nowhere.org>
In-Reply-To: <87ej5wzahp.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Rafael C. de Almeida" <almeidaraf@gmail.com> writes:
> 
>> I'm interested in knowing how the cpu data from /proc/stat is gathered.
>> Following my way from this function:
>>
>> 	http://lxr.linux.no/linux+v2.6.25.10/fs/proc/proc_misc.c#L459
>>
>> I've figured that the time is probably gathered using those
>> account_*_time on sched.c. I'm not sure where the times are read from,
>> though.
> 
> They are normally (some architectures do it differently to cope with
> virtualized environments) sampled by a regular timer interrupt, which
> runs HZ times per second on each CPU. Common values for HZ is 250
> (2.5ms interval), but you can compile with others too.

How can it always sample regularly like that? The only way I can think
of accounting is doing so in an event-based manner. That is, when a
process is given to a CPU you start counting, when you remove it you
stop the counter, that would be your CPU user time, then you'd start
counting for the system. Accounting for IO time and other CPU times
would happen in the same manner.

Now, I took a look at ``void scheduler_tick(void)'' (from sched.c). I
think it's the function that gets called in a timely manner. All I can
see it doing regarding clock is updating its value. It doesn't seem to
account for idle, user and system time.

> I suspect the effects you're seeing all come from sampling error.
> The interval is also not fully stable because the kernel sometimes
> disables interrupts and that will delay the timer interrupt of course.
> How often this happens depends on the workload.

I didn't think about the kernel disabling interrupts. But I'm not sure
that's the main issue in my experimentation, after all, that would make
me get smaller values rather than big values, no? I mean, on a idle
system each second has 100 samples, what I observed was that sometimes I
get as much as 500 samples in one second. If disabling interrupts was
the issue I think that I'd see values much smaller than 100.

I've noticed that the error doesn't change (thus becoming relatively
smaller) when I sleep for more time. So, looking at the samples each 10
seconds usually gives me 1000 samples, but it gets at 1500 at tops
(which is much better than getting 100 samples and reaching 500 at
tops). I wonder if maybe the error I'm seeing here has more to do with
the system not respecting the sleep time too well.

> Then there are architectures like s390 who do "microstate accounting": 
> they keep track instead on every kernel entry/exit and every interrupt.
> That can be more accurate, but is also more costly.

My interest here is on the x86 architeture, I don't suppose I can turn
on microstate accounting on it, can I?
