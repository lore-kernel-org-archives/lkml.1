Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZJFR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZJFR0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbZJFR0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:26:44 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49185 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbZJFR0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=wJ8W3g5KTLGu8aTrvPghEodoVXN8ohIZF510W+U1QWE1Eoy0A1mip9tLSRvPr13oad
         5UdIiZP6KRmD2FI6A9YIT3nPJ9fvHk0IsqMOaV7Wgwz/bD7oYP4Uso097nrDyJUP3+u2
         XrRyRXNeIM9I/2LfgaS5zoQZB368ktipGIGWw=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1254846544.21044.298.camel@laptop>
References: <1254840129-6198-1-git-send-email-eranian@gmail.com>
	 <1254840129-6198-2-git-send-email-eranian@gmail.com>
	 <1254840129-6198-3-git-send-email-eranian@gmail.com>
	 <1254846544.21044.298.camel@laptop>
Date: Tue, 6 Oct 2009 19:26:06 +0200
Message-ID: <7c86c4470910061026o247c182dwdea7fa7296027@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf_events: add event constraints support for Intel 
	processors
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 6:29 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-10-06 at 16:42 +0200, Stephane Eranian wrote:
>
>>       This patch changes the event to counter assignment logic to take
>>       into account event constraints for Intel P6, Core and Nehalem
>>       processors. There is no contraints on Intel Atom. There are
>>       constraints on Intel Yonah (Core Duo) but they are not provided
>>       in this patch given that this processor is not yet supported by
>>       perf_events.
>
> I don't think there's much missing for that, right?
>
Yonah implements architectural perfmon v1. It has two generic
counters but no fixed counters. You already handled that part.
But what it does not have is all the GLOBAL_* MSR.   You could
consider it as P6, but the difference is that the two counters can
be started and stopped independently. Given the organization of
the code, Yonah present a hybrid configuration. That is where
the problem is. So either:

  - you go the architected PMU path, but you protect all accesses
    to GLOBAL_*

  - you go the P6 path, and you make the counters independent.


> I don't actually have that hardware, so I can't test it.
>
I don't have that either but I can find people who have that.

>>       As a result of the constraints, it is possible for some event groups
>>       to never actually be loaded onto the PMU if they contain two events
>>       which can only be measured on a single counter. That situation can be
>>       detected with the scaling information extracted with read().
>
> Right, that's a pre existing bug in the x86 code (we can create groups
> larger than the PMU) and should be fixed.
>
Nope, this happens event if you specify only two events on a two-counter
PMU. For instance, if I want to breakdown the number of multiplication
between user and kernel to compute a ratio. I would measure MUL twice:

    perf stat -e MUL:u,MUL:k

Assuming that with perf you could express that you want those events grouped.
This would always yield zero. I am not using all the counters but my two events
compete for the same counter, here counter 0.

The problem is that for the tool it is hard to print some meaningful
messages to help
the user. You can detect something is wrong with the group because time_enabled
will be zero. But there are multiple reasons why this can happen.

But what is more problematic is if I build a group with an event
without a constraint
and one with a constraint. For instance, I want to measure BACLEARS and MUL in
the same group. If I make BACLEARS the group leader then the group will never
be loaded. That's because the assignment code  looks at each event individually.
Thus it will assign BACLEARS to the first available counter, i.e.,
counter 0. Then it will
try to assign MUL, which can only run on counter 0, and it will always
fail. The assignment
code needs to look at groups not individual events. Then, it will be
able to find a working
assignment: MUL -> counter0, BACLEARS -> counter 1.

By design of this API, the user should never be concerned about
ordering the events
in a group a certain way to get a successful assignment to counters.
This should all
be handled by the kernel.

> Patch looks nice though.
>

Thanks.
