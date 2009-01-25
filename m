Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZAYAdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZAYAdU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 19:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZAYAdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 19:33:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:35579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZAYAdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 19:33:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HWdh9fxDHAf2n5UywR1QxTW5ihKPcU9cIM1vCzJu0uzxj9RG0cszV/Zp/45Yc9nZHM
         Ukv+LV+Y6XdZFWDc4vXffpqt2Bn8X0jLblvGXtM5Wk6Y4wdfQKS8jw4wY/Ic6Hd2Cx8P
         oTGGm1bicUd0c0w06VKw4QQ9CPZ+kgjWdEvNA=
MIME-Version: 1.0
In-Reply-To: <20090114020040.GA19806@wotan.suse.de>
References: <4966897E.5020302@free.fr>
	 <f19298770901090209m7076f3afyd1e01e0fc9bbca59@mail.gmail.com>
	 <20090111024945.GC7077@elte.hu> <20090114020040.GA19806@wotan.suse.de>
Date: Sun, 25 Jan 2009 03:33:07 +0300
Message-ID: <f19298770901241633l736801f6r760ef54883ca9c87@mail.gmail.com>
Subject: Re: next-20090107: WARNING: at kernel/sched.c:4435 sub_preempt_count
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 05:00, Nick Piggin <npiggin@suse.de> wrote:
> On Sun, Jan 11, 2009 at 03:49:45AM +0100, Ingo Molnar wrote:
>>
>> * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>>
>> > One more instance of http://marc.info/?l=linux-kernel&m=123134586202636&w=2
>> > Added Ingo Molnar to CC.
>>
>> added Nick on Cc:. Nick, it's about:
>>
>> > commit 7317d7b87edb41a9135e30be1ec3f7ef817c53dd
>> > Author: Nick Piggin <nickpiggin@yahoo.com.au>
>> > Date:   Tue Sep 30 20:50:27 2008 +1000
>> >
>> >    sched: improve preempt debugging
>>
>> causing a seemingly spurious warning.
>
> I don't know how it is spurious... Presumably the sequence _would_ have
> caused preempt count to go negative if the bkl were not held...
>
> __do_softirq does a __local_bh_disable on entry, and it seems like the
> _local_bh_enable on exit is what causes this warning. So something is
> unbalanced somehow. Or is it some weird thing we do in early boot that
> I am missing?
>
> Can you put in some printks around these functions in early boot to
> get an idea of what preempt_count is doing?
>

Hi again.

Finally got to debug this. The preempt count on the first __do_softirq entry
ever is 0, as it is set in irq_ctx_init(). The interrupted swapper
thread happens
to be in the kernel_locked() state at the moment, so the warning.

I don't understand why the softirq preempt count is initialized to 0. Should not
it be SOFTIRQ_OFFSET instead?
