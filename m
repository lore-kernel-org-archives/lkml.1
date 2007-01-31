Return-Path: <linux-kernel-owner+w=401wt.eu-S932981AbXAaLJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbXAaLJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932989AbXAaLJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:09:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932981AbXAaLJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:09:00 -0500
Date: Wed, 31 Jan 2007 12:07:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH 11/23] clocksource: atomic signals
Message-ID: <20070131110722.GA1847@elte.hu>
References: <20070131033710.420168478@mvista.com> <20070131033806.468210824@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131033806.468210824@mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> Modifies the way clocks are switched to in the timekeeping code. The 
> original code would constantly monitor the clocksource list checking 
> for newly added clocksources. I modified this by using atomic types to 
> signal when a new clock is added. This allows the operation to be used 
> only when it's needed.

I see little difference between your and John's code: both poll 
something - you poll an atomic "did a new clocksource arrive" flag in 
the timer interrupt, John takes the clocksource_lock spinlock and checks 
a "did a new clocksource arrive" variable. Both are global atomic 
variables in essence.

what i'd see as a real cleanup here would be to get away from this 'poll 
whether there's any clocksource update' model, and to just ensure that a 
running timer irq will always see the latest clocksource. I.e. to run 
the change_clocksource() logic (and the following updates) when a new 
clock source is selected - not when the next timer interrupt runs. That 
would propagate all effects of a new clock source immediately.

	Ingo
