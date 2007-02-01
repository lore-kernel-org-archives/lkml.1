Return-Path: <linux-kernel-owner+w=401wt.eu-S1422835AbXBAMZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422835AbXBAMZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 07:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422836AbXBAMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 07:25:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60728 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422835AbXBAMZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 07:25:48 -0500
Date: Thu, 1 Feb 2007 13:24:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com, Andrew Morton <akpm@osdl.org>
Subject: Re: [-mm patch] x86_64 GTOD: offer scalable vgettimeofday II
Message-ID: <20070201122433.GA5255@elte.hu>
References: <20070201095952.589234000@jet.suse.cz> <20070201114644.GB26453@elte.hu> <200702011317.45876.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011317.45876.ak@suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > The 'price' paid for it is lower resolution - but it's still good 
> > for those benchmarking TPC-C runs - and /alot/ simpler.
> 
> BTW another comment: I was told that at least one of the big databases 
> wants ms resolution here. So to make your scheme work would require a 
> HZ=1024 regular interrupt. [...]

if resolution is an issue then i can improve this thing to be based off 
a separate /optional/ hrtimer, thus if it's enabled it could enable 1000 
Hz (and not 1024 Hz) update for the variable. The update resolution 
could be tuned via a sysctl trivially, so everyone could tune the 
resolution of this to the value desired, and could do so runtime.

[ It could also be driven by the database right now: from a thread open 
  /dev/rtc, set it to 1024 HZ, and do a gettimeofday() call in every 
  tick - that will auto-update the timestamp. ]

> [...] But that would also make everything slower again due to CPU 
> overhead as it was learned in the 2.4->2.6 HZ transition.

note that this cost was measured on UP and on older hardware, and the 
cost of having a global 1000 Hz update gets linearly cheaper with the 
increase of CPUs on SMP: because only one such update has to be running. 
The systems those database vendors are interested in typically have a 
fair number of CPUs.

	Ingo
