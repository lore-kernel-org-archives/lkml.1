Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYDGA5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYDGA5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 20:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYDGA5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 20:57:05 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:3846 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbYDGA5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 20:57:04 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] Close small window for vsyscall time inconsistencies
Date: Mon, 7 Apr 2008 01:55:19 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
References: <1207340264.6222.17.camel@localhost.localdomain>
In-Reply-To: <1207340264.6222.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804070255.22516.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 4. April 2008, john stultz wrote:

> So Thomas and Ingo pointed out to me that they were occasionally seeing
> small 1ns inconsistencies from clock_gettime() (and more rarely, 1us
> inconsistencies from gettimeofday() when the 1ns inconsistency occurred
> on a us boundary)

What does inconsistency mean?

> Looking over the code, the only possible reason I could find would be
> from an interaction with the vsyscall code.
>
> In update_wall_time(), if we read the hardware at time A and start
> accumulating time, and adjusting the clocksource frequency, slowing it
> for ntp.
>
> Right before we call update_vsyscall(), another processor makes a
> vsyscall gettimeofday call, reading the hardware at time B, but using
> the clocksource frequency and offsets from pre-time A.
>
> The update_vsyscall then runs, and updates the clocksource frequency
> with a slower frequency.
>
> Another processor immediately calls vsyscall gettimeofday, reading the
> hardware (lets imagine its very slow hardware) at time B (or very
> shortly there after), and then uses the post-time A clocksource
> frequency which has been slowed.
>
> Since we're using basically the same hardware value B, but using
> different frequencies, its possible for a very small 1ns time
> inconsistency to occur.

One thing to keep in mind here is that if update_wall_time() adjusts the 
frequency at time A, the time is still the same after the frequency change at 
this point.
This means on the same cpu the time keeps increasing, if the update on another 
cpu is now delayed due to update_vsyscall() at time B, it's possible that 
there is a small time jump at this time, but in the common case it should be 
quite small to be even noticable, e.g. if the frequency is changed by 1us/s 
and it takes 1ms for the update the jump is 1ns and IMO that is already a 
lot.
I'm not saying that it's impossible that it results in a visible problem, but 
I think it should be rather rare. NTP frequency should be quite rare, at most 
every 16s and in standard configurations every 64s (over time even less). 
Inbetween these updates NTP changes its frequency very slowly. That leaves 
the clock frequency when it tries to match the NTP frequency, if you really 
see that large frequency changes, it suggest that something else is quite 
wrong, e.g. if the clock code has a problem to hold a halfway steady 
frequency, this should be fixed first.
So instead of shooting in the dark, I'd suggest to collect some numbers first, 
which support your theory. This starts with the NTP logs and then try add 
some stats to the adjustment code to see by how much the clock frequency is 
changed (e.g. the min/max/last mult values and the same for the number of 
cycles until update_vsyscall() is called).

bye, Roman
