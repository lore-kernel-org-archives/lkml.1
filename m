Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbYLLGhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbYLLGhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 01:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYLLGhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 01:37:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYLLGhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 01:37:37 -0500
Date: Fri, 12 Dec 2008 07:36:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH] clocksource: add enable() and disable() callbacks
Message-ID: <20081212063645.GF12451@elte.hu>
References: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211114909.17624.85712.sendpatchset@rx1.opensource.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Magnus Damm <magnus.damm@gmail.com> wrote:

> +static inline int clocksource_enable(struct clocksource *cs)
> +{
> +	return cs->enable ? cs->enable(cs) : 0;
> +}

> +static inline void clocksource_disable(struct clocksource *cs)
> +{
> +	if (cs->disable)
> +		cs->disable(cs);
> +}

why have the two different styles? The first one should be:

	if (cs->enable)
		return cs->enable(cs);
	return 0;

> @@ -193,11 +193,16 @@ static void change_clocksource(void)
>  
>  	clocksource_forward_now();
>  
> -	new->raw_time = clock->raw_time;
> +	if (clocksource_enable(new))
> +		return;

that looks fragile to me: if the enable fails we'll return silently, 
while change_clocksource() assumes that things went fine. At least put a 
WARN_ON_ONCE() in there.

also, why does it have to fail? If a clocksource cannot be enabled it 
should not be offered as a clocksource.

> +	clocksource_disable(old);

i do agree with the core purpose here, to allow lowlevel code to 
deactivate unused clocksources.

John, Thomas, what's your take on this?

	Ingo
