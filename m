Return-Path: <linux-kernel-owner+w=401wt.eu-S933414AbXDAOos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414AbXDAOos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933227AbXDAOoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:44:46 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:45244 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbXDAOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:44:19 -0400
Date: Sun, 01 Apr 2007 10:44:00 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: plain 2.6.21-rc5 (1) vs amanda (0)
In-reply-to: <20070401065101.GA17729@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, amanda-hackers@amanda.org,
       amanda-users@amanda.org, Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Message-id: <200704011044.00601.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704010100.19016.gene.heskett@verizon.net>
 <20070401065101.GA17729@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@verizon.net> wrote:
>> Hi Ingo;
>>
>> Running 2.6.21-rc5 tonight.
>>
>> It appears that as of 2.6.21-rc5, (actually anything with a 2.6.21 in
>> its version string) amanda is still a loser. [...]
>
>here 'is a loser' means: "tries to back up way too much stuff instead of
>doing a nice incremental backup like it does on 2.6.20.4", correct?

Yes, and as an additional clue, 2.6.20.4-rc1 does this, the later 2.6.20.4 
does not, so we have narrowed it down to one or more of the 31 patches in 
that gap.

>since it appears to be caused by a kernel change, this is a serious
>regression in v2.6.21-to-be.

Yes, that's why I'm fussing now, hopefully before this gets into the field 
as a final version.

>> Good, 2.6.20.4 was running
>> sendsize.20070331000507.debug:sendsize[762]: time 248.361: getting
>> size via gnutar for /usr/music level 0
>> sendsize.20070331000507.debug:sendsize[762]: estimate time for
>> /usr/music level 0: 1.239 sendsize.20070331000507.debug:sendsize[762]:
>> estimate size for /usr/music level 0: 2466050 KB
>> sendsize.20070331000507.debug:sendsize[762]: time 249.605: getting
>> size via gnutar for /usr/music level 1
>> sendsize.20070331000507.debug:sendsize[762]: estimate time for
>> /usr/music level 1: 0.027 sendsize.20070331000507.debug:sendsize[762]:
>> estimate size for /usr/music level 1: 80 KB
>>
>> Bad, 2.6.21-rc5 is running
>> sendsize.20070401000504.debug:sendsize[18465]: time 167.371: getting
>> size via gnutar for /usr/music level 0
>> sendsize.20070401000504.debug:sendsize[18465]: estimate time for
>> /usr/music level 0: 0.398
>> sendsize.20070401000504.debug:sendsize[18465]: estimate size for
>> /usr/music level 0: 2466050 KB
>> sendsize.20070401000504.debug:sendsize[18465]: time 167.773: getting
>> size via gnutar for /usr/music level 1
>> sendsize.20070401000504.debug:sendsize[18465]: estimate time for
>> /usr/music level 1: 0.049
>> sendsize.20070401000504.debug:sendsize[18465]: estimate size for
>> /usr/music level 1: 2448290 KB
>>
>> Yesterdays run, dated 20070331000507 were correct as that directory
>> hasn't been write accessed in a couple of months.
>>
>> Today's, dated 20070401000504, shows totally bogus figures for exactly
>> the same data.
>
>'totally bogus figures' needs to be analyzed further. What system call
>or library calls returns incorrect data?

Tar is used with the output sent to /dev/null, to obtain those numbers 
since the last $level figures and these are then assigned to $level + 1.  
Each disklist entry gets scanned twice during the estimate phase, once 
for a level 0 reference, and once for a "since $timestamp" value.  I'm 
not sure if the timestamp in the /etc/amandates file is used, or the 
timestamp on the indice file amandates names is used. Amanda then decides 
what to do next in an attempt to balance the tape usage run to run, and 
not let a needed level 0 ever get more than 1 run behind if amanda can 
help it.  It will drop incrementals to meet that goal if it has to with 
the current order I have setup in my amanda.conf.

>> This effect I have isolated down to something in the 31 patches from
>> 2.6.20.4 to 2.6.20.5-rc1, but I'm going to need additional guidance in
>> setting up the bisect to find it.  If indeed its a kernel problem.

And I miss-quoted the above, its the 31 patches between 2.6.20.3 and 
2.6.20.4-rc1.  Then for some reason I don't grok, 2.6.20.4 is good again.

>> This same effect has been present in any and every 2.6.21.* release.
>
>maybe it's some sort of timestamp problem, on the FS level?
>
>	Ingo

I wasn't aware of a 'timestamp' problem on the FS level ever being 
discussed at any length here on lkml.  As far as my checking, I'm limited 
to what "ls -lc?" tells me, and those figures seem to be sane.

Is there additional data present now that could screw up tar, and do it 
without being obvious to ls?  I don't know. :-\

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
We have only two things to worry about:  That things will never get
back to normal, and that they already have.
