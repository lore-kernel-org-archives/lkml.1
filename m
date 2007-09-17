Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbXIQOBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbXIQOBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbXIQOBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:01:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:1392 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbXIQOBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mfKr/WHeQ0Z+BACuJ+OQF2u8/LtoEG0ImRKXME89YOSv3puVSEBLrxC43OM5543uHD1TW2J+oFNVhu/ULz69eg5yBcsF0qVKZJ4IC9WOWadyOBrhzscTdOCtzbzjN3naxFPQ/8OLDZ3pOukqNbx5CbEfySU9qAlq9ZgYpQb4DRg=
Message-ID: <5c77e14b0709170701q2835669fu4d18b6734bcc5119@mail.gmail.com>
Date: Mon, 17 Sep 2007 16:01:31 +0200
From: "Jos Poortvliet" <jospoortvliet@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ck] Re: Scheduler benchmarks - a follow-up
Cc: "Rob Hussey" <robjhussey@gmail.com>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070917130524.GA10707@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
	 <20070917130524.GA10707@elte.hu>
X-Google-Sender-Auth: e621b21166b96991
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rob Hussey <robjhussey@gmail.com> wrote:
>
> > http://www.healthcarelinen.com/misc/benchmarks/BOUND_hackbench_benchmark2.png
>
> heh - am i the only one impressed by the consistency of the blue line in
> this graph? :-) [ and the green line looks a bit like a .. staircase? ]

Looks lovely, though as long as lower is better, that staircase does a
nice job ;-)

> i've meanwhile tested hackbench 90 and the performance difference
> between -ck and -cfs-devel seems to be mostly down to the more precise
> (but slower) sched_clock() introduced in v2.6.23 and to the startup
> penalty of freshly created tasks.
>
> Putting back the 2.6.22 version and tweaking the startup penalty gives
> this:
>
>                             [hackbench 90, smaller is better]
>
>            sched-devel.git      sched-devel.git+lowres-sched-clock+dsp
>            ---------------      --------------------------------------
>                      5.555                  5.149
>                      5.641                  5.149
>                      5.572                  5.171
>                      5.583                  5.155
>                      5.532                  5.111
>                      5.540                  5.138
>                      5.617                  5.176
>                      5.542                  5.119
>                      5.587                  5.159
>                      5.553                  5.177
>            --------------------------------------
>                 avg: 5.572             avg: 5.150 (-8.1%)

Hmmm. So cfs was 0.8% slower compared to ck in the test by Rob, it
became 8% faster so... it should be faster than CK - provided these
results are valid over different tests.

But this is all microbenchmarks, which won't have much effect in real
life, right? Besides, will the lowres sched clock patch get in?

> ('lowres-sched-clock' is the patch i sent in the previous mail. 'dsp' is
> a disable-startup-penalty patch that is in the latest sched-devel.git)
>
> i have used your .config to conduct this test.
>
> can you reproduce this with the (very-) latest sched-devel git tree:
>
>  git-pull git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
>
> plus with the low-res-sched-clock patch (re-) attached below?
>
>        Ingo
> ---
>  arch/i386/kernel/tsc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux/arch/i386/kernel/tsc.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/tsc.c
> +++ linux/arch/i386/kernel/tsc.c
> @@ -110,9 +110,9 @@ unsigned long long native_sched_clock(vo
>         *   very important for it to be as fast as the platform
>         *   can achive it. )
>         */
> -       if (unlikely(!tsc_enabled && !tsc_unstable))
> +       if (1 || unlikely(!tsc_enabled && !tsc_unstable))
>                /* No locking but a rare wrong value is not a big deal: */
> -               return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
> +               return jiffies_64 * (1000000000 / HZ);
>
>        /* read the Time Stamp Counter: */
>        rdtscll(this_offset);
> _______________________________________________
> http://ck.kolivas.org/faqs/replying-to-mailing-list.txt
> ck mailing list - mailto: ck@vds.kolivas.org
> http://vds.kolivas.org/mailman/listinfo/ck
>
