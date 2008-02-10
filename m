Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbYBJSwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbYBJSwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 13:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYBJSwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 13:52:05 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:1753 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYBJSwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 13:52:03 -0500
Date: Sun, 10 Feb 2008 19:45:32 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1202523452.6174.45.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0802101917030.3378@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home>  <1201573686.6766.13.camel@localhost>
  <Pine.LNX.4.64.0801290439480.17507@scrub.home>  <1201659263.6766.40.camel@localhost>
  <Pine.LNX.4.64.0801310251090.17507@scrub.home>  <1201745776.6195.14.camel@localhost.localdomain>
  <Pine.LNX.4.64.0801310404480.17507@scrub.home>  <1201914175.6216.46.camel@jstultz-laptop>
  <Pine.LNX.4.64.0802081718040.3378@scrub.home> <1202523452.6174.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 8 Feb 2008, john stultz wrote:

> -ENOPATCH
> 
> We're taking weeks to critique fairly small bug fix. I'm sure we both
> have better things to do then continue to misunderstand each other. I'll
> do the testing and will happily ack it if it resolves the issue.

I don't want to just send a patch, I want you to understand why your 
approach is wrong.

> Now, If you're disputing that I'm correcting the wrong side of the
> equation, then we're getting somewhere. But its still not clear to me
> how you're suggesting the other side (which is calculated in
> ntp_update_frequency) be changed.
> [..]
> You keep on bringing up NO_HZ, and again, the bug I'm trying to fix
> occurs with or without NO_HZ. The fix I proposed resolves the issue with
> or without NO_HZ.

The correction is incorrect for NO_HZ.
Let's try it the other way around, as my explanation seem to lack 
something.
Please try to explain what this correction actually means and why it 
should be correct for NO_HZ as well.

> > The only other alternative would be to calculate this correction 
> > dynamically. For this you leave NTP_INTERVAL_LENGTH as is and when 
> > changing clocks you check whether "abs(((cs->xtime_interval * 
> > NTP_INTERVAL_FREQ) >> cs->shift) - NSEC_PER_SEC)" exceeds a certain limit 
> > (e.g. 200usec) and in this case you print a warning message, that the 
> > clock has large base drift value and is a bad ntp source and apply a 
> > correction value. This way the correction only hits the very few system 
> > which might need it and it would be the prefered solution, but it also 
> > requires a few more changes.
> 
> Uh, that seems to be just checking if the xtime_interval is off base, or
> if the ntp correction has gone too far. I just don't see how this
> connects to the issue at hand.

Above is the key to understanding the problem, if this difference is small 
enough there is no need to correct anything.

This is the original patch which introduced the correction:

http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=commitdiff;h=69c1cd9218e4cf3016b0f435d6ef3dffb5a53860

Keep in mind that at that time PIT was used as the base clock (even if the 
tsc was used, it was relative to PIT). So how much of those assumptions 
are still valid today (especially with NO_HZ enabled)?

bye, Roman
