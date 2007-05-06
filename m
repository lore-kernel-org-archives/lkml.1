Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXEFRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXEFRqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXEFRqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 13:46:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753377AbXEFRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 13:46:17 -0400
Date: Sun, 6 May 2007 10:45:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v8
In-Reply-To: <20070506082911.GA32644@elte.hu>
Message-ID: <alpine.LFD.0.98.0705061037390.25245@woody.linux-foundation.org>
References: <20070501212223.GA29867@elte.hu> <463854F3.3020403@linux.vnet.ibm.com>
 <20070502100545.GA6857@elte.hu> <46386F2B.9050307@linux.vnet.ibm.com>
 <20070502111742.GA18132@elte.hu> <Pine.LNX.4.64.0705051016420.12880@frodo.shire>
 <alpine.LFD.0.98.0705051040420.3819@woody.linux-foundation.org>
 <20070506082911.GA32644@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 May 2007, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So the _only_ valid way to handle timers is to
> >  - either not allow wrapping at all (in which case "unsigned" is better, 
> >    since it is bigger)
> >  - or use wrapping explicitly, and use unsigned arithmetic (which is 
> >    well-defined in C) and do something like "(long)(a-b) > 0".
> 
> hm, there is a corner-case in CFS where a fix like this is necessary.
> 
> CFS uses 64-bit values for almost everything, and the majority of values 
> are of 'relative' nature with no danger of overflow. (They are signed 
> because they are relative values that center around zero and can be 
> negative or positive.)

Well, I'd like to just worry about that for a while.

You say there is "no danger of overflow", and I mostly agree that once 
we're talking about 64-bit values, the overflow issue simply doesn't 
exist, and furthermore the difference between 63 and 64 bits is not really 
relevant, so there's no major reason to actively avoid signed entries.

So in that sense, it all sounds perfectly sane. And I'm definitely not 
sure your "292 years after bootup" worry is really worth even considering. 

When we're really so well off that we expect the hardware and software 
stack to be stable over a hundred years, I'd start to think about issues 
like that, in the meantime, to me worrying about those kinds of issues 
just means that you're worrying about the wrong things.

BUT.

There's a fundamental reason relative timestamps are difficult and almost 
always have overflow issues: the "long long in the future" case as an 
approximation of "infinite timeout" is almost always relevant.

So rather than worry about the system staying up 292 years, I'd worry 
about whether people pass in big numbers (like some MAX_S64 approximation) 
as an approximation for "infinite", and once you have things like that, 
the "64 bits never overflows" argument is totally bogus.

There's a damn good reason for using only *absolute* time. The whole 
"signed values of relative time" may _sound_ good, but it really sucks in 
subtle and horrible ways!

			Linus
