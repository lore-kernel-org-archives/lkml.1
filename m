Return-Path: <linux-kernel-owner+w=401wt.eu-S965400AbXCFRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400AbXCFRqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965404AbXCFRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:46:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49967 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965400AbXCFRq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:46:29 -0500
Date: Tue, 6 Mar 2007 09:41:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>, Soeren Sonnenburg <kernel@nn7.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] highres: do not run the TIMER_SOFTIRQ after switching
 to highres mode
In-Reply-To: <1173202195.24738.350.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703060935310.5963@woody.linux-foundation.org>
References: <20070305015040.GJ3441@stusta.de>  <1173138193.24738.236.camel@localhost.localdomain>
  <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org> 
 <1173142948.24738.257.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0703051730230.3998@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0703051810030.3998@woody.linux-foundation.org> 
 <20070306103315.GA4295@mellanox.co.il> <20070306103712.GA10942@elte.hu> 
 <20070306104618.GA5792@mellanox.co.il> <20070306113225.GA22561@elte.hu> 
 <Pine.LNX.4.64.0703060817060.5963@woody.linux-foundation.org>
 <1173202195.24738.350.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> 
> /me pleads guilty !
> 
> Replacement patch below.

Well, I already applied the original one that came through Andrew, so I 
really just wanted to note the coding style in general, and your fixed 
patch no longer applied ;)

Also, you do end up testing for "not error" with a

>  	if (tick_check_oneshot_change(!hrtimer_is_hres_enabled()))
> -		hrtimer_switch_to_hres();
> +		if (!hrtimer_switch_to_hres())
> +			return;

which I guess is ok, if only because we simply don't care about what the 
exact error was. But it means that this particular code sequence ends up 
having the same problem (which is still fewer places than the original 
patch, so we're good).

I personally hate the

	if (hrtimer_switch_to_hres() == SUCCESS)
		return;

kind of syntax (it's just too long, and it's *not* obvious at all that 
SUCCESS is zero and that this is a "negative error or zero" kind of 
function, so it's actually *worse* than just doing what you did, but some 
projects seem to have that kind of approach.

We could encourage people to do

	if (hrtimer_switch_to_hres() >= 0)
		return;

which is fairly obviously a "success" case for a negative error value, but 
I'm not sure the extra typing really is worth it. Does anybody have any 
smart ideas that people might even be ok with following (just making 
things more cumbersome is anti-productive, so I don't want to have some 
stupid rule that everybody really hates)?

			Linus
