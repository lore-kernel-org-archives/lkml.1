Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbXAaJga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbXAaJga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXAaJg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:36:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbXAaJg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:36:28 -0500
Date: Wed, 31 Jan 2007 10:34:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/23] clocksource: rating sorted list
Message-ID: <20070131093414.GA21335@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033805.183466048@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033805.183466048@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3685]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Converts the original plain list into a sorted list based on the clock 
> rating. Later in my tree this allows some of the variables to be 
> dropped since the highest rated clock is always at the front of the 
> list. This also does some other nice things like allow the sysfs files 
> to print the clocks in a more interesting order. It's forward looking.

Unfortunately this seems to be a step backwards to me. Please consider:

>  	if (clocksource_tsc.rating != 0 && check_tsc_unstable()) {
>  		clocksource_tsc.rating = 0;
> -		clocksource_reselect();
> +		clocksource_rating_change(&clocksource_tsc);
>  		change = 1;

this should be the following API:

	clocksource_rating_change(&clocksource_tsc, 0);

a rating change can occur due to other things as well, not only due to 
'tsc unstable' events. So keeping an API around that changes the rating 
(and propagates all related changes), makes more sense to me.

also, a pure function call is the most natural (and most flexible) API, 
for a centrally registered resource like a clock source driver. And a 
rating change should imply a reselect too, obviously. That way we 
replace 2 lines with 1 line - that's a real API improvement and a real 
cleanup patch.

and that's precisely what Thomas' patch in -mm that your queue undoes 
implements. (see: simplify-the-registration-of-clocksources.patch in 
-mm) Have you considered Thomas' change when you dropped it?

	Ingo
