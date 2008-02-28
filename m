Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbYB1VUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbYB1VUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759730AbYB1VT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:19:58 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:27616 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758703AbYB1VT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:19:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=n2Vfk1+CM934OjKGs1F8tXCHFswxtE02PTVyC5rdc/4RPwsNTZaiWBGt0pvWtXMtDKKWTwCyO7oipYT/TdGDhHIP8Z5nodUFnsslqr5RFSdJMl448sBH+zXgGP7pUEAjNsNmEBZH7kDKd5pFtuFfOvPLZIeyfE56cXRLAGiR8IU=
Date: Thu, 28 Feb 2008 18:21:26 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ray-lk@madrabbit.org, mingo@elte.hu
Subject: Re: Interactivity issue in 2.6.25-rc3
Message-ID: <20080228212126.GA4819@localhost.ift.unesp.br>
Mail-Followup-To: linux-kernel@vger.kernel.org, ray-lk@madrabbit.org,
	mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with lkml Cc:ed.

On Thu 28.Feb'08 at 11:54:04 -0800, Ray Lee wrote:
> On Thu, Feb 28, 2008 at 11:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Carlos R. Mafra <crmafra2@gmail.com> wrote:
> >
> >  > I want to report a bad interactivity which happened in my desktop
> >  > running the latest kernel (2.6.25-rc3-00081-g7704a8b).
> >  >
> >  > I tried to play 'flightgear' and the desktop became _very_ slow while
> >  > flightgear was "loading scenery objects" (a task which never finished
> >  > and I could not play it).
> >  >
> >  > The desktop is a P4 @ 3.0 GHz, 512MB, with the nv graphics driver.
> >
> >  yes, but this means you run the soft-3D driver under Xorg, right? That
> >  is known to starve its clients. The stats you sent show no worse than a
> >  few tens of msecs delays caused by CPU scheduling itself:
> >
> >   mrxvt (3730, #threads: 1)
> >   se.wait_max                        :            18.679129
> >

Thanks Ingo!

Hm, but I remember that my desktop became unusable. I was experiencing
latencies _much_ higher than msecs. But I think I have an explanation
for this low number, if you excuse my attempt to understand this.

Could it be that your debug script generated these numbers while
fgfs was being killed, and then it felt no more the bad latencies
fgfs was causing? 

This was the first scenario:

1) Start 'fgfs' as normal user.

2) Wait a few seconds until fgfs' message "loading scenery objects"
   appeared.
   
3) Everything becomes _very_ slow (measured in seconds, not msecs),
   so I notice something is wrong (at least I thought it was).
   
4) Killed fgfs with Ctrl-c.

5) I go to Ingo's page and download his debug scripts.

6) Preparing for the battle to follow, I run cfs-debug-info-clear.sh
   
7) Start 'fgfs' and system becomes slow while loading scenery objects.
   
8) I try to reach the mrxvt terminal to run cfs-debug-info.sh. Each
   letter I type takes seconds to appear.

9) I manage to start cfs-debug-info.sh. I could read the first line after 
   a few seconds: 
   
   sched info dump (of tasks, modules, hw, dmesg, config, fs):

   But I am sure I did not see the 
   "gathering statistics for 15 seconds ..."
   
   As that was the first time ever that I used this script, I didn't 
   even know what I was supposed to do, but I was waiting for more
   than a minute and nothing happened.

10) I managed to change tab and kill fgfs with Crtl-c.

11) I got back to the debug script tab and waited a few seconds
    for it to finish.

12) That is the debug log which I put in the page mentioned in the
    first email.

I am sorry to especulate about it, but maybe the script got the
latencies after (or meanwhile) I was killing fgfs.

> Also, please try disabling the group scheduler and run the test again.
> The group scheduler has known bad interactivity issues. Also be on the
> watch for any abnormally high disk activity, to rule out starvation
> due to the kernel choosing poor candidates for swap-in/swap-out.
> (Running a vmstat 1 in a console ahead of time and watching for high
> IO Wait -- the last column printed -- will give you a good indicator
> other than the drive LED.)

I have rebooted and tried to repeat the experiment, but I couldn't
reproduce the bad interactivity I reported earlier. Flightgear 
loaded the scenery (which it did not do before) and the airplane
appeared in the screen. The game was slow, but I had a very good
usability of the desktop and I could type things almost normally,
I could switch desktops etc. Definitely not what happened before!

So I am sorry for the noise, but something bad happened before 
and unfortunately I am not sure I could run Ingo's debug script
correctly. I'll be more patient if that happens again.

Anyway, I want to thank Ingo and Ray for their replies and
would like to humbly ask: 

Is it an scheduler anomaly if 'se.wait_max' is bigger than
40 msecs for _any_ of the processes which appear in the 
debug script log? In other words, is the scheduler 
mathematically build to not allow latencies higher than
40 msecs?

