Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYGVEdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYGVEdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYGVEdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:33:41 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:29086 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750919AbYGVEdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:33:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hUTNI8z9GDjHPfzJGHGwILbKZSuT3pf033rdov5RCrhwtf5K9RWmb6OdhZVGbt6J6xb5X93FsyYchT/gvmAlwhv8sARpKFqV9hG08GS/Sk6TBfaJ3O4C4H4mWUck7UWMi/W578pn2bOW4rgqmywlBKf0QUYiOjoqhGGqiRkD/io=  ;
X-YMail-OSG: ygncq_4VM1kzKzF3V4pNKsSqcTgWNuKVLZ6qw7sgQVvWUHPr2ap53Ik1H2ez6XbKz5FAZwGs3lN1HyrBJ8HEcjktK4p86r8OUWdDEGphOM8jyLc4sc5o1WOhYbX_mtAZ2rE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] schedule_timeout_range()
Date: Tue, 22 Jul 2008 14:33:32 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
References: <1216695757.18980.16.camel@shinybook.infradead.org> <200807221356.29892.nickpiggin@yahoo.com.au> <1216699922.18980.66.camel@shinybook.infradead.org>
In-Reply-To: <1216699922.18980.66.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221433.32412.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 14:12, David Woodhouse wrote:
> On Tue, 2008-07-22 at 13:56 +1000, Nick Piggin wrote:
> > Rather than specific "deadline" values (which we can't guarantee anyway),
> > or vague "can defer" values,
>
> We already _have_ those vague 'can defer' timers. They'll get run the
> next time the CPU happens to be awake after they expire.

Right, but that may be too vague to be really useful. OK, not exactly:
as with anything, if we really need an exact response, we have to wait
with interrupts disabled etc. However I don't think it would hurt to
get away from the all or nothing approach with future APIs that are added
(eventually the old ones could just be implemented over the new).


> >  I would prefer just a small selection of maybe orders of magnitude
> > flags, maybe SECONDS, MILLISECONDS, MICROSECONDS which gives an amount
> > of delay the kernel might add to the timer.
>
> As far as I can tell, any implementation of that ends up being converted
> into what we have at the moment -- a deferrable timer which gets run
> some time after it expires, and a timer which would actually _wake_ a
> sleeping CPU. You have to create a value for that final timer anyway, so
> why not just let the in-kernel caller provide it?

That is a fair point.


> There's no point in trying to coalesce the 'final' timeouts; if just one
> of them wakes the CPU and we're in the range for any other 'range
> timers', those others will happy immediately anyway.

Sure.


> We did ponder the idea of a per-process setting which affects userspace
> delays like nanosleep/poll/select, and introduces a variable extra delay
> if the CPU is actually sleeping. So we can reduce the number of CPU
> wakeup events for thosee userspace apps which aren't timing-sensitive.

Not such a bad idea. Maybe also something to think about adding explicitly
to future syscalls (if not a complete new parameter for delay time, then
at least a flag or two or different variants for different amounts of
accuracy). I guess select/poll is pretty widely used though, so there will
be some good gains just from a per-process setting.


> We were also thinking of extending nanosleep/ppoll/pselect also to take
> a 'range', for those cases where the process-wide setting needs to be
> overridden. The prctl is a simple solution which doesn't involve
> modifying large chunks of userspace to use new system calls, but it's
> not a panacea -- in some places, an app might _want_ a prompt wakeup.
>
> For kernel timers, though, I think it's better to let the caller set a
> non-deferrable timer at a specific time. Although you're right that
> 'deadline' is probably a bad name for it.
>
> How about 'start' and 'end'? Or 'early' and 'late'? I really don't care
> too much what it's called.

Well I think 'timeout' is fine for the "at least this much time", that's
well understood and used. As for the slop... slop? deferrable? Hmm,
precision might come pretty close to the engineering definition, no?

The only thing I dislike about explicit times is that when a driver or
someone doesn't _really_ know how much to specify. Do you say 10s, 100s?
It shouldn't be arbitrary, but we should have a few constants I think.

Some upper bound would be nice, which basically would not have to ever
fire by itself unless there is some CPU activity (so you don't have to
set two timers as a bonus). After that, I wonder, perhaps some "maximum
power savings value but not completely deferred"? Say give it a max of
30s? Or perhaps even that is not future-proof enough if we one day want
to suspend most of the system between external IOs?

if 
