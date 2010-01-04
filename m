Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832Ab0ADSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0ADSnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799Ab0ADSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:43:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:14521 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0ADSnT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M28LdwRlVa4DhByHmbR4fTJBX0qG4S4MyqWeqoUvnaGi/C4SiTonejldTyATJR44PH
         WXI7uY198J6ldDoMktGxDBqKa2g5jwI7tv4e+RGVGEn3qUuwn4UtbemZrvZ16+mA3L25
         wesVKWbmBZzV1NbCXiUlLMaZa/eRIryA6k10A=
MIME-Version: 1.0
In-Reply-To: <1262392920.32223.10.camel@laptop>
References: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>
	 <1262392920.32223.10.camel@laptop>
Date: Mon, 4 Jan 2010 13:43:17 -0500
Message-ID: <6041d2001001041043ka810288l64ae9d6d8105b284@mail.gmail.com>
Subject: Re: BUG during shutdown - bisected to commit e2912009
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Xiaotian Feng <dfeng@redhat.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 1, 2010 at 7:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-01-01 at 19:27 -0500, Marc Dionne wrote:
>> I'm getting a BUG with current kernels from
>> kernel/time/clockevents.c:263 when halting the system - a restart
>> behaves normally.  I don't have a good camera handy at the moment to
>> capture the call stack on screen, but the call sequence is:
>>
>> clockevents_notify
>> hrtimer_cpu_notify
>> notifier_call_chain
>> raw_notifier_call_chain
>> _cpu_down
>> disable_nonboot_cpus
>> kernel_power_off
>> sys_reboot
>>
>> I bisected it down to commit e2912009: sched: Ensure set_task_cpu() is
>> never called on blocked tasks.  There were a few commits tested along
>> the way where I got a freeze (with the power still on) instead of a
>> BUG. Reverting that commit from the current kernel doesn't look
>> trivial, but the commit immediately preceding this one does halt fine.
>
> We somehow seem to trip up the below patch, which doesn't really make
> sense, as I can't find how task placement would affect the below error.
>
> It seems to purely test against the hot-unplugged cpu, not a cpu the
> task is running on.
>
> ---
> commit bb6eddf7676e1c1f3e637aa93c5224488d99036f
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Thu Dec 10 15:35:10 2009 +0100

Probably predictable but worth testing, reverting that patch does
allow my system to shutdown cleanly.

Marc
