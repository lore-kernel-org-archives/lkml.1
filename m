Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbXEITYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbXEITYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 15:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbXEITYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 15:24:22 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:42105 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317AbXEITYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 15:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tGCR+oZ1H2WbiLb8GoCZcKHbolC9lNhGUJXiuRUO0fC7EhMBp5rAsZDU8laFpjDW/89mF9O3s+okbWVtt7RYnoGeE+WMyDxV1Bt41hWSI2UmsWuMs+34nW/HFTpbeoW9rDasKqOdE0dVPaAceRpgnKXGkFmDNoTeJpUpqy+9Xwo=
Message-ID: <b647ffbd0705091224m75bf8caawa0019ecfe8bf82e7@mail.gmail.com>
Date: Wed, 9 May 2007 21:24:17 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: vatsa@in.ibm.com
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Con Kolivas" <kernel@kolivas.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070509180205.GA27462@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070508150431.GA26977@elte.hu>
	 <20070509180205.GA27462@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Tue, May 08, 2007 at 05:04:31PM +0200, Ingo Molnar wrote:
> > thanks Mike - value 0x8 looks pretty good here and doesnt have the
> > artifacts you found. I've done a quick -v11 release with that fixed,
> > available at the usual place:
> >
> >     http://people.redhat.com/mingo/cfs-scheduler/
> >
> > with no other changes.
>
> Ingo,
>         I had a question with respect to the definition of fairness used, esp
> for tasks that are not 100% cpu hogs.
>
> Ex: consider two equally important tasks T1 and T2 running on same CPU and
> whose execution nature is:
>
>         T1 = 100% cpu hog
>         T2 = 60% cpu hog (run for 600ms, sleep for 400ms)
>
> Over a arbitrary observation period of 10 sec,
>
>         T1 was ready to run for all 10sec
>         T2 was ready to run for 6 sec
>

One quick observation.

Isn't it important for both processes to have the same "loops_per_ms" value?

At least on my machine, it's not always the case. See how results
differ in the following 2 tests:

(1) when loops_per_ms happen to be quite different;
(2) ----//---- pretty same values.

Both are for mainline 2.6.19 and both processes have equal characteristics.
namely,

./cpuhog 600 400 10

I run them one by one from different shells.

(1)

dimm@dimm:/mnt/storage/kernel/sched-bench> ./cpuhog 600 400 10
loops_per_ms = 94517.958412  <---------- (*)

run time = 600 ms (56710775 loops), sleep time = 400 ms, epoch time = 10 s
Obtained 6.39 seconds of execution time in 10 elapsed seconds
Obtained 4.52 seconds of execution time in 11 elapsed seconds
Obtained 4.47 seconds of execution time in 10 elapsed seconds
Obtained 4.47 seconds of execution time in 10 elapsed seconds
Obtained 4.53 seconds of execution time in 10 elapsed seconds
Obtained 4.14 seconds of execution time in 10 elapsed seconds
...

dimm@dimm:/mnt/storage/kernel/sched-bench> ./cpuhog 600 400 10
loops_per_ms = 51599.587203  <------------- (**)

run time = 600 ms (30959752 loops), sleep time = 400 ms, epoch time = 10 s
Obtained 3.91 seconds of execution time in 10 elapsed seconds
Obtained 3.16 seconds of execution time in 10 elapsed seconds
Obtained 3.18 seconds of execution time in 10 elapsed seconds
Obtained 3.19 seconds of execution time in 10 elapsed seconds
Obtained 2.97 seconds of execution time in 10 elapsed seconds

Look at a difference between (*) and (**) and we can see the reported
results are different.
Although, one would expect both are treated "equally" with the current
scheduler (whatever one puts in this meaning :)


(2) now another attempt.

dimm@dimm:/mnt/storage/kernel/sched-bench> ./cpuhog 600 400 10
loops_per_ms = 96711.798839

run time = 600 ms (58027079 loops), sleep time = 400 ms, epoch time = 10 s
Obtained 4.32 seconds of execution time in 10 elapsed seconds
Obtained 3.84 seconds of execution time in 11 elapsed seconds
Obtained 3.86 seconds of execution time in 11 elapsed seconds
Obtained 3.84 seconds of execution time in 11 elapsed seconds
Obtained 3.86 seconds of execution time in 11 elapsed seconds
...

dimm@dimm:/mnt/storage/kernel/sched-bench> ./cpuhog 600 400 10
loops_per_ms = 96899.224806

run time = 600 ms (58139534 loops), sleep time = 400 ms, epoch time = 10 s
Obtained 4.28 seconds of execution time in 10 elapsed seconds
Obtained 3.88 seconds of execution time in 11 elapsed seconds
Obtained 3.88 seconds of execution time in 10 elapsed seconds
Obtained 3.40 seconds of execution time in 10 elapsed seconds
Obtained 3.42 seconds of execution time in 10 elapsed seconds
Obtained 3.89 seconds of execution time in 11 elapsed seconds
...


In this case, "loops_per_ms" happened to be pretty equal so the
reported results look pretty similar. "top" showed very close numbers
in this case as well.

Maybe it's different in your case (besides I don't claim that
everything is ok with SD and CFS) but I guess this could be one of the
reasons.

At least, fork()-ing the second process (with different
run_time/sleep_time characteristics) from the first one would ensure
both have the same "loop_per_ms".


-- 
Best regards,
Dmitry Adamushko
