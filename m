Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbZCXOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbZCXOVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbZCXON4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:13:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53202 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZCXONy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:13:54 -0400
Date: Tue, 24 Mar 2009 15:13:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC][PATCH] Logarithmic Timekeeping Accumulation
Message-ID: <20090324141338.GF32043@elte.hu>
References: <1237858102.7068.20.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237858102.7068.20.camel@jstultz-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <johnstul@us.ibm.com> wrote:

> Accumulating one tick at a time works well unless we're using 
> NOHZ. Then it can be an issue, since we may have to run through 
> the loop a few thousand times, which can increase timer interrupt 
> caused latency.
> 
> The current solution was to accumulate in half-second intervals 
> with NOHZ. This kept the number of loops down, however it did 
> slightly change how we make NTP adjustments. While not an issue 
> with NTPd users, as NTPd makes adjustments over a longer period of 
> time, other adjtimex() users have noticed the half-second 
> granularity with which we can apply frequency changes to the 
> clock.
> 
> For instance, if a application tries to apply a 100ppm frequency 
> correction for 20ms to correct a 2us offset, with NOHZ they either 
> get no correction, or a 50us correction.
> 
> Now, there will always be some granularity error for applying 
> frequency corrections. However with users sensitive to this error 
> have seen a 50-500x increase with NOHZ compared to running without 
> NOHZ.
> 
> So I figured I'd try another approach then just simply increasing 
> the interval. My approach is to consume the time interval 
> logarithmically. This reduces the number of times through the loop 
> needed keeping latency down, while still preserving the original 
> granularity error for adjtimex() changes.
> 
> This has been lightly tested and appears to work correctly, but 
> I'd appreciate any feedback or comments on the idea and code.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Hm, we used to have some sort of problem with a similar patch in the 
past. 

>  		/* accumulate error between NTP and clock interval */
> -		clock->error += tick_length;
> -		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
> +		clock->error += tick_length << shift;
> +		clock->error -= (clock->xtime_interval
> +				<< (NTP_SCALE_SHIFT - clock->shift))
> +					<< shift;

Why not:

		clock->error -= clock->xtime_interval
				<< (NTP_SCALE_SHIFT - clock->shift + shift);

?

> +		if (shift > 0) /*don't roll under!*/
> +			shift--;

(nit: watch out the comment style)

that bit looks a bit messy. We estimated the shift:

+	while (offset > (clock->cycle_interval << shift))
+               shift++;
+	shift--;

can it really ever roll under in this loop:

        while (offset >= clock->cycle_interval) {

        ...
                offset -= clock->cycle_interval << shift;

?

	Ingo
