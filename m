Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbZCWI3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbZCWI3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZCWI3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:29:13 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:59074 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbZCWI3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:29:12 -0400
Message-ID: <49C748EA.6040809@msgid.tls.msk.ru>
Date: Mon, 23 Mar 2009 11:31:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: phenom, amd780g, tsc, hpet, kvm, kernel -- who's at fault?
References: <49BACABE.7060003@msgid.tls.msk.ru> <20090323080441.GA27170@elte.hu>
In-Reply-To: <20090323080441.GA27170@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, I lost any hope already to hear anything about this one..
Surprise.  Thank you for replying!

Ingo Molnar wrote:
[]
>> top/strace, but nothing interesting shows.  I captured Sysrq+T of this situation
>> here: http://www.corpit.ru/mjt/host-high-la -- everything I was able to find
>> in kern.log.
> 
> 403

Fixed both.  Didn't notice it was 0640 (i copied the kern.log).  I just
checked my apache access.log - no one but several bots even looked at
those pages before you.  Oh well.

[]
>> So, to the hell out of it all, and ignoring the magical Friday the 13th --
>> who's fault it is?
>>
>>  o why it declares tsc is unstable while phenom supposed to keep it ok?
> 
> the TSC can drift slowly between cores, and it might not be in sync 
> at bootup time already. You check check the TSC from user-space (on 
> any kernel) via time-warp-test:
> 
>     http://redhat.com/~mingo/time-warp-test/MINI-HOWTO

Aha.  Will do.  But see below.

>>  o why hpet is malfunctioning?
> 
> That's a question for Thomas i guess.
> 
>>  o why the system time on this machine is dog slow without special
>>    adjtimex adjustments, while it worked before (circa 2.6.26) and
>>    windows works ok here?
>>
>> For reference:
>>
>>  https://sourceforge.net/tracker/?func=detail&atid=893831&aid=2351676&group_id=180599
>>   -- kvm bug on sourceforge, without any visible interest in even looking at it
>>
>>  http://www.google.com/search?q=CE%3A+hpet+increasing+min_delta_ns
>>   -- numerous references to that "CE: hpet increasing min_delta_ns" on the 'net,
>>   mostly for C2Ds, mentioning various lockup issues
>>
>>  http://marc.info/?t=123246270000002&r=1&w=2 --
>>   "slow clock on AMD 740G chipset" -- it's about the clock issue, also without
>>   any visible interest.
>>
>> What's the next thing to do here?  I for one don't want to see 
>> todays failures again, it was very, and I mean *very* difficult 
>> day to restore the functionality of this system that (and it isn't 
>> restored at full because of the slowness of its current state).
> 
> it's not clear which kernel you tried - if you tried a recent enough 
> one then i'd chalk this up as a yet-unfixed timekeeping problem - 
> which probably had ripple effects on KVM and the rest of the system.

It is 2.6.28.7 compiled for x86-64 (64 bits).
Config is at http://www.corpit.ru/mjt/2.6.28.7-x86-64.config

> What would be helpful is to debug the problem :-) First verify that 
> basic timekeeping is OK: does 'time sleep 10' really take precisely 
> 10 seconds? Does 'date' advance precisely one second per physical 
> second?
[...]

I'll try - maybe today.  The thing is that this is a production machine
running quite several of various (virtual) servers which are all our
infrastructure.  When it started misbehaving at 13th (just because there
was high load, not because of failures or any other changes), all our
office was stopped... ;)

Now, after quite some googling around, I tried to disable hpet, booting
with hpet=disable parameter.  And that one fixed all the problems at once.
7 days uptime, I stress-tested it several times, it works with TSC as
timesource (still a problem within guests as those shows unstable TSC
anyway) since boot, no issues logged.  Even cpufreq works as expected...

Note that i tried to disable hpet as clocksource several times but without
any noticeable effect - kernel still used hpet and hpet2 for something,
and printed that scary "increasing min_delay" message on a semi-regular
basis usually after the next 'stuck' state....

> A generic hw/sw state output of:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> would also help people taking a look at this problem.
> 
> If the problem persists, there might be a chance to debug it without 
> rebooting the system. Rebooting and trying out various patches wont 
> really work well for a server i guess.

..so it has to be rebooted back to enable hpet.  Hence I'll do it not
before evening.  But I really want to debug and fix the issue, as it
gave me quite some headaches and I want to kill it once and for all ;)

Thanks for noticing this!

/mjt
