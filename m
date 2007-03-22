Return-Path: <linux-kernel-owner+w=401wt.eu-S1161141AbXCVWUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141AbXCVWUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161142AbXCVWUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:20:25 -0400
Received: from mail03.syd.optusnet.com.au ([211.29.132.184]:49329 "EHLO
	mail03.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161141AbXCVWUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:20:24 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.21-rc4-mm1
Date: Fri, 23 Mar 2007 09:14:24 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, "Martin J. Bligh" <mbligh@mbligh.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <4602B7D3.4030108@shadowen.org> <4602C83B.20608@shadowen.org>
In-Reply-To: <4602C83B.20608@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703230914.25041.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007 05:17, Andy Whitcroft wrote:
> Andy Whitcroft wrote:
> > Con Kolivas wrote:
> >> On Thursday 22 March 2007 20:48, Andy Whitcroft wrote:
> >>> Andy Whitcroft wrote:
> >>>> Andy Whitcroft wrote:
> >>>>> Andrew Morton wrote:
> >>>>>> Temporarily at
> >>>>>>
> >>>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> >>>>>>
> >>>>>> Will appear later at
> >>>>>>
> >>>>>>
> >>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21
> >>>>>>-rc 4/2.6.21-rc4-mm1/
> >>>>>
> >>>>> [All of the below is from the pre hot-fix runs.  The very few results
> >>>>> which are in for the hot-fix runs seem worse if anything.  :(  All
> >>>>> results should be out on TKO.]
> >>>>>
> >>>>>> - Restored the RSDL CPU scheduler (a new version thereof)
> >>>>>
> >>>>> Unsure if the above is the culprit but there seems to be a smattering
> >>>>> of BUG's in kernbench from the schedular on several systems, and
> >>>>> panics which do not fully dump out.
> >>>>>
> >>>>> elm3b239 is about 2/4 kernbench being the test in progress when we
> >>>>> blammo in both failed tests, elm3b234 doesn't boot at all.
> >>>>
> >>>> Well I have one result through for backing RSDL out on elm3b239 and
> >>>> that does indeed seem to give us a successful boot and test.  peterz
> >>>> has pointed me to an incremental patch from Con which I'll push
> >>>> through testing and see if that sorts it out.
> >>>
> >>> Ok, tested the patch below on top of 2.6.21-rc4-mm1 and this seems to
> >>> fix the problem:
> >>>
> >>> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc4-mm1-rsdl-0.
> >>>32.p atch
> >>>
> >>> Hard to tell from that patch whether it will be fixed in the changes
> >>> already committed to the next -mm.
> >>>
> >>> Its possible that it may be fixed by the following patch:
> >>>
> >>>     sched-rsdl-improvements.patch
> >>>
> >>> Which has the following slipped in at the end of the changelog:
> >>>
> >>>     A tiny change checking for MAX_PRIO in normal_prio()
> >>>     may prevent oopses on bootup on large SMP due to
> >>>     forking off the idle task.
> >>>
> >>> Con, are all the changes in the 0.32 patch above with akpm?
> >>
> >> Yes he's queued everything in that patch you tested for the next -mm.
> >> Thanks very much for testing it.
> >
> > No worries.  I've just got through the results on the other machine in
> > the mix.  That machine seems to be fixed by backing out RSDL and not by
> > the fixup 0.32 patch ...
> >
> > This second machine seems to had hard very soon after user space starts
> > executing but without a panic.  I can't say that the symptoms are very
> > definitive, but I do have a good result from that machine without RSDL
> > and not with rsdl-0.32.
> >
> > The machine is a dual-core x86_64 machine: Dual Core AMD Opteron(tm)
> > Processor 275.
> >
> > I'll let you know if I find out anything else.  Shout if you want any
> > information or have anything you want poked or tested.
>
> Ok, I have yet a third x86_64 machine is is blowing up with the latest
> 2.6.21-rc4-mm1+hotfixes+rsdl-0.32 but working with
> 2.6.21-rc4-mm1+hotfixes-RSDL.  I have results on various hotfix levels
> so I have just fired off a set of tests across the affected machines on
> that latest hotfix stack plus the RSDL backout and the results should be
> in in the next hour or two.
>
> I think there is a strong correlation between RSDL and these hangs.  Any
> suggestions as to the next step.

If it's hitting the bug_on that I put in sched.c which you say it is then it 
is most certainly my fault. It implies a task has been queued without a 
corresponding bit being anywhere in the priority bitmaps. Somehow you only 
seem to be hitting it on big(ger) smp which is why I haven't seen it. It 
implies some complication occuring at sched or idle init/fork off these 
accounting not working. If I could reproduce it on qemu I'd step through the 
kernel init checking where each task is being queued and see if the bitmaps 
are being set. This is obviously time consuming and laborious so I don't 
expect you to do it. 

The next best thing is if you can send me the config of one of the machines 
that's oopsing I can try that on qemu but qemu is only good at debugging 
i386. If any of the machines that were oopsing were i386 that would be very 
helpful, otherwise x86_64 is the next best. Then I need to make a creative 
debugging patch for you to try which checks every queued/dequeued task and 
dumps all that information. I don't have that patch just yet so I need to 
find enough accumulated short stints at the pc to do that (still hurts a lot 
and worsens my condition).

Thanks!

-- 
-ck
