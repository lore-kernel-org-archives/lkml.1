Return-Path: <linux-kernel-owner+w=401wt.eu-S1765308AbXEVLxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765308AbXEVLxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933936AbXEVLwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:52:53 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:57389 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762126AbXEVLww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:52:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DbKZtSQJ94znQsWxvjutI8DpBI+YB9Wo1Bru0DGA7pY2a8s50tbtBPO4CDCUsr1AV2EyGYGGg8ULLSr6xlk9Jqr/Eq9uuz5qRmVnSPfFWbg55fNWTcSmvwZUY6urjH53fMh+J+IUoZtvaucmbOJ6DyxCgFKBGgn8rcM0Jdbtv8w=
Message-ID: <b647ffbd0705220452n711a8d1dtdf4cad07a01c8b64@mail.gmail.com>
Date: Tue, 22 May 2007 13:52:51 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Williams" <pwil3058@bigpond.net.au>
Subject: Re: [patch] CFS scheduler, -v12
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <46523081.6050007@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>
	 <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au>
	 <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au>
	 <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com>
	 <46523081.6050007@bigpond.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
> > [...]
> > Hum.. I guess, a 0/4 scenario wouldn't fit well in this explanation..
>
> No, and I haven't seen one.

Well, I just took one of your calculated probabilities as something
you have really observed - (*) below.

"The probabilities for the 3 split possibilities for random allocation are:

       2/2 (the desired outcome) is 3/8 likely,
       1/3 is 4/8 likely, and
       0/4 is 1/8 likely.            <-------------------------- (*)
"

> The split that I see is 3/1 and neither CPU seems to be favoured with
> respect to getting the majority.  However, top, gkrellm and X seem to be
> always on the CPU with the single spinner.  The CPU% reported by top is
> approx. 33%, 33%, 33% and 100% for the spinners.

Yes. That said, idle_balance() is out of work in this case.

> If I renice the spinners to -10 (so that there load weights dominate the
> run queue load calculations) the problem goes away and the spinner to
> CPU allocation is 2/2 and top reports them all getting approx. 50% each.

I wonder what would happen if X gets reniced to -10 instead (and
spinners are at 0).. I guess, something I described in my previous
mail (and dubbed "unlikely cospiracy" :) could happen, i.e. 0/4 and
then idle_balance() comes into play..

ok, I see. You have probably achieved a similar effect with the
spinners being reniced to 10 (but here both "X" and "top" gain
additional "weight" wrt the load balancing).

> I'm playing with some jitter experiments at the moment.  The amount of
> jitter needs to be small (a few tenths of a second) as the
> synchronization (if it's happening) is happening at the seconds level as
> the intervals for top and gkrellm will be in the 1 to 5 second range (I
> guess -- I haven't checked) and the load balancing is every 60 seconds.

Hum.. the "every 60 seconds" part puzzles me quite a bit. Looking at
the run_rebalance_domain(), I'd say that it's normally overwritten by
the following code

               if (time_after(next_balance, sd->last_balance + interval))
                        next_balance = sd->last_balance + interval;

the "interval" seems to be *normally* shorter than "60*HZ" (according
to the default params in topology.h).. moreover, in case of the CFS

                if (interval > HZ*NR_CPUS/10)
                        interval = HZ*NR_CPUS/10;

so it can't be > 0.2 HZ in your case (== once in 200 ms at max with
HZ=1000).. am I missing something? TIA


>
> Peter

-- 
Best regards,
Dmitry Adamushko
