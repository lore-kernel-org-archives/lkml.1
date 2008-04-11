Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbYDKIgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbYDKIgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYDKIfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:35:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbYDKIfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:35:52 -0400
Date: Fri, 11 Apr 2008 10:40:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Karsten Wiese <fzu@wemgehoertderstaat.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set_cyc2ns_scale() remove tsc_now and ns_now
Message-ID: <20080411084029.GT10019@one.firstfloor.org>
References: <200804102331.11815.fzu@wemgehoertderstaat.de> <873apsn8g7.fsf@basil.nowhere.org> <20080411075554.GA6834@elte.hu> <20080411080617.GP10019@one.firstfloor.org> <3d8471ca0804110125r1b4e97c0ua419587a64c9b1c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0804110125r1b4e97c0ua419587a64c9b1c7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 10:25:09AM +0200, Guillaume Chazarain wrote:
> On Fri, Apr 11, 2008 at 10:06 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >  At some point you have to generate an offset to something and that
> >  offset must be different for different frequencies, otherwise
> >  you get large systematic errors
> 
> This offset is already there, represented by rq->clock - sched_clock()

Same issue. Think about it.  Perhaps I should have written
the complicated proof :)

You really have to compute the offset before the scaling, otherwise it 
is useless.

TSC is a counter that adds up time units. Now when the frequency
changes the time units change, but counter doesn't reset.

Now the full absolue value of the counter is useless for exact time 
because there is no way to reconstruct what the lengths of the different 
time units meshed together in the single counter value were
and how long it ticked at the different frequencies.

So after a frequency change the only way to get anything 
approaching a sane time is to take a snapshot of the counter
already ticking at the new frequency (but before it is scaled!) 
and then only work with current TSC - snapshot and only scale
after that.

Then there is also the issue that you don't know when exactly
the counter changes and any measurements during that time
might be dodgy (but system is not usually fully stopped during
it). 

The rewritten sched_clock handled this by having a unstable period 
between cpufreq starting to change, cpufreq reporting end of change 
and falling back to another clock during this instable period.

Also there are of course other users, like printk who
don't have rq->clock.

-Andi
