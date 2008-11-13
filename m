Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYKMUGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYKMUGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKMUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:06:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:42298 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYKMUG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:06:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=o3LPdbsVzTmDSZQAzQrM94RDSccW1ISbuGu4ZodVhyXDaEmAHhVJewZubT9TWScBh/
         mKP+FDxqRoXAouWzCE/2m2Tsb87RzN1Vw6qHatV4RttSRFTNSUBjL1G0EgACo7b0nzhP
         fcbgk1kuRNE0D+E+UzaflXCsz3glhGFzTnd9o=
Message-ID: <c62985530811131206i5fd982c3r36f637412bb5ab95@mail.gmail.com>
Date: Thu, 13 Nov 2008 21:06:24 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081113185723.GC17851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112221552.GA6125@elte.hu> <20081113085551.GF25479@elte.hu>
	 <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
	 <20081113092340.GJ25479@elte.hu>
	 <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
	 <20081113094027.GK25479@elte.hu>
	 <c62985530811130436s160e3983nd7debbb96cc971ae@mail.gmail.com>
	 <20081113125419.GA32574@elte.hu>
	 <c62985530811130926y656f8f4ancd592f26cdbbee6b@mail.gmail.com>
	 <20081113185723.GC17851@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
> you are right - it needs a bit more logic.
>
> I think the simplest would be something like this:
>
>  atomic64_t global_clock = INIT_ATOMIC64(0);
>
>  u64 global_time()
>  {
>        u64 now, delta, now_global, prev_global;
>
>        do {
>                prev_global = atomic64_read(&global_clock);
>                now = cpu_clock(raw_smp_processor_id());
>
>                if ((s64)(now - prev_global) < 0) {
>                        now = prev_global;
>                        break;
>                }
>        } while (atomic64_cmpxchg(&global_clock,
>                                   prev_global, now) != prev_global);
>
>        return now;
>  }
>
> This is the simplest way of implementing monotonic time: we only allow
> global_clock to go forwards. If all cpu_clock()s are perfectly in
> sync, we've got no problem: then "now - prev_global" will never be
> negative and we can return the local clock as the latest global time.
>
> But if one of the CPU clocks is "behind", the function returns the
> latest global time up until the local clock catches up. Time wont be
> allowed to jump around by going back. If the clock is behind for a
> long time, then we get a lot of timestamps with the same value -


Ok! I understand now this approach.
So, if global ordering flag is set, we return this kind of protected value,
and on the opposite, we return the normal cpu_clock() local value.

> Would that work? [ Would you be interested in sending patches? :-) ]

Yes :-)

> that
> will be very visible in the trace and we'll then work in improving the
> cpu_clock() implementation.
>
> So i think we could start with this simplest approach, and see how
> often we get the same timestamp for a long time (indication of the
> clocks being not perfectly in sync).


Ok, good idea.
Thanks for the explanations!
