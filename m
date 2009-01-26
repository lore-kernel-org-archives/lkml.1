Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbZAZPBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbZAZPBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZAZPAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:00:53 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:60097 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZAZPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:00:52 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2009 10:00:51 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FZSE/UQ7UVXag8kNS60vzGquLVdOGVV28h957/e097oq4xqop0N7W1eB4AH09bnpwk
         5kp0ZrwN9VWEnGfR8P87a8yv5MWTvYQPjApznKY47GLFggOuny28UYkGCt0doiZi+IG1
         FxqGOKCnF/SNuHLKxo0+f+FonZJjb+Cw9vJGg=
MIME-Version: 1.0
In-Reply-To: <20090126144313.GC4445@elte.hu>
References: <4966897E.5020302@free.fr>
	 <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
	 <20090111024945.GC7077@elte.hu> <20090114020040.GA19806@wotan.suse.de>
	 <f19298770901241633l736801f6r760ef54883ca9c87@mail.gmail.com>
	 <20090126144313.GC4445@elte.hu>
Date: Mon, 26 Jan 2009 17:53:49 +0300
Message-ID: <f19298770901260653n2ff13438j504fd77c11abef71@mail.gmail.com>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435 sub_preempt_count
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 17:43, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
>> On Wed, Jan 14, 2009 at 05:00, Nick Piggin <npiggin@suse.de> wrote:
>> > On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
>> >>
>> >> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>> >>
>> >> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
>> >> > Added Ingo Molnar to CC.
>> >>
>> >> added Nick on Cc:. Nick, it's about:
>> >>
>> >> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>> >> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
>> >> > Date:   Tue Sep 30 20:50:27 2008 +1000
>> >> >
>> >> >    sched: improve preempt debugging
>> >>
>> >> causing a seemingly spurious warning.
>> >
>> > I don't know how it is spurious... Presumably the sequence _would_ have
>> > caused preempt count to go negative if the bkl were not held...
>> >
>> > __do_softirq does a __local_bh_disable on entry, and it seems like the
>> > _local_bh_enable on exit is what causes this warning. So something is
>> > unbalanced somehow. Or is it some weird thing we do in early boot that
>> > I am missing?
>> >
>> > Can you put in some printks around these functions in early boot to
>> > get an idea of what preempt_count is doing?
>> >
>>
>> Hi again.
>>
>> Finally got to debug this. The preempt count on the first __do_softirq entry
>> ever is 0, as it is set in irq_ctx_init(). The interrupted swapper
>> thread happens
>> to be in the kernel_locked() state at the moment, so the warning.
>>
>> I don't understand why the softirq preempt count is initialized to 0.
>> Should not it be SOFTIRQ_OFFSET instead?
>
> hm, indeed. So this triggers on irqstacks, if an irq happens to hit the
> first time a softirq executes (ever)? After that point the preempt_count
> in the irq-stack ought to stay elevated.

No, this happens on the first softirq, which is run after an irq. An
irq interrupts
the swapper thread while it is holding the blk. It is executed on the
hard irq stack,
and the corresponding thread_info.preempt_count is set correctly by
irq_ctx_init(),
so nothing happens. After the hard IRQ is over, a softirq is run on
the soft irq stack,
but irq_ctx_init() set it's preempt_count to zero. So after the first
softirq os over,
sub_preempt_count() discovers that the preempt count is goind back to
zero, while
the BKL is held (by the interrupted thread), and refuses to decrease
the count. So the
spftirq preempt_count stays SOFTIRQ_OFFSET which is now correct, so no further
warnings are triggered.



>        Ingo
>
