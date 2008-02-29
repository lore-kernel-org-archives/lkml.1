Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbYB2XMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbYB2XMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 18:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933061AbYB2XMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 18:12:00 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39383 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933041AbYB2XL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 18:11:59 -0500
Subject: Re: [PATCH] Remove obsolete CLOCK_TICK_ADJUST
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <Pine.LNX.4.64.0802292315480.2723@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801290439480.17507@scrub.home>
	 <1201659263.6766.40.camel@localhost>
	 <Pine.LNX.4.64.0801310251090.17507@scrub.home>
	 <1201745776.6195.14.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801310404480.17507@scrub.home>
	 <1201914175.6216.46.camel@jstultz-laptop>
	 <Pine.LNX.4.64.0802081718040.3378@scrub.home>
	 <1202523452.6174.45.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802101917030.3378@scrub.home>
	 <1202774999.5984.106.camel@localhost>
	 <Pine.LNX.4.64.0802120335170.3378@scrub.home>
	 <1202963796.6195.141.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802150436300.1822@scrub.home>
	 <1203382940.5984.242.camel@localhost>
	 <Pine.LNX.4.64.0802190219360.2723@scrub.home>
	 <1203472250.6123.98.camel@localhost>
	 <Pine.LNX.4.64.0802200348230.2723@scrub.home>
	 <1203647951.6150.80.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802290547320.2723@scrub.home>
	 <20080229140842.575e72aa.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0802292315480.2723@scrub.home>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 15:11:52 -0800
Message-Id: <1204326712.6136.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 23:27 +0100, Roman Zippel wrote:
> Hi,
> 
> On Fri, 29 Feb 2008, Andrew Morton wrote:
> 
> > The changelog provides no reason for the revert of those two patches.
> > 
> > Look at it from the point of view of a person who hasn't been following the
> > discussion (whose initials might be LT).  That person might get puzzled and
> > upset, no?
> 
> I'm puzzled at how to explain this...
> The whole details have been explained over and over during the discussion.
> The simple answer is that CLOCK_TICK_ADJUST has been causing extra clock 
> drift, John's attempt didn't fix the real cause.
> My patch doesn't just revert the patches, it also includes the _real_ fix, 
> so why would the real fix require more justification? That person also 
> didn't get puzzled why two patches claiming to fix the same problem got 
> merged...

How about this tweaked version of what I was using:


The first version of the ntp_interval/tick_length inconsistent usage
patch was recently merged as bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=bbe4d18ac2e058c56adb0cd71f49d9ed3216a405

While the fix did greatly improve the situation, it was correctly
pointed out by Roman that it does have a small bug: If the users change
clocksources after the system has been running and NTP has made
corrections, the correctoins made against the old clocksource will be
applied against the new clocksource, causing error.

The second attempt, which corrects the issue in the NTP_INTERVAL_LENGTH
definition has also made it up-stream as commit
e13a2e61dd5152f5499d2003470acf9c838eab84

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e13a2e61dd5152f5499d2003470acf9c838eab84

Roman has correctly pointed out that CLOCK_TICK_ADJUST is calculated
based on the PIT's frequency, and isn't really relevant to non-PIT
driven clocksources (that is, clocksources other then jiffies and pit).

This patch reverts both of those changes, and simply removes
CLOCK_TICK_ADJUST.

This does remove the granularity error correction for users of PIT and
Jiffies clocksource users, but the granularity error but for the
majority of users, it should be within the 500ppm range NTP can
accommodate for.

For systems that have granularity errors greater then 500ppm, the
"ntp_tick_adj=" boot option can be used to compensate.





