Return-Path: <linux-kernel-owner+w=401wt.eu-S1946457AbXBIN5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946457AbXBIN5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946466AbXBIN5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:57:21 -0500
Received: from mail07.syd.optusnet.com.au ([211.29.132.188]:46436 "EHLO
	mail07.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946457AbXBIN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:57:20 -0500
X-Greylist: delayed 1984 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 08:57:20 EST
From: Con Kolivas <kernel@kolivas.org>
To: jos poortvliet <jos@mijnkamer.nl>
Subject: Re: [ck] Re: Swap prefetch merge plans
Date: Sat, 10 Feb 2007 00:56:36 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
References: <200702091038.37143.kernel@kolivas.org> <200702092321.20615.kernel@kolivas.org> <200702091413.06949.jos@mijnkamer.nl>
In-Reply-To: <200702091413.06949.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702100056.37039.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 00:13, jos poortvliet wrote:
> > > > Hold.
> > >
> > > Why hold?
> > >
> > > It's been shown this patchset really helps desktop users.
> >
> > Has it?  I don't think I've ever observed any benefits from it and I
> > don't think anyone has ever got down and worked out what its drawbacks
> > might be, and seen if they can be demonstrated in practice.
>
> Well, I'd say it's disadvantage is that you might use the buffered diskdata
> in memory (which will be replaced with application data from swap) when you
> come back using the computer. But it's far more likely you'll use the app
> data, that's why swap prefetch helps

swap prefetch stores the data at the tail end of the lru list which means that 
even if you do want to use that ram for something else, the prefetched pages 
will be immediately dropped. Since the pages are still on backing store 
(swapspace) they will be droppped without any further I/O. 

> . Anyway, I'm sure you got some 
> response from users who did like it. Now I know the desktop isn't the focus
> of the Linux Kernel Developers, and you probably have much to hefty
> hardware to notice any difference. Heck, after my upgrade to 3GB ram, I
> never noticed swap prefetch anymore...

Even on 2GB ram at home, where I regularly move iso images around, compress 
large files with big window compression apps (like rzip), manipulate gimp 
images, print large colour photos in high resolution and so on, I hit swap 
regularly and do notice it being helpful. This is what normal desktop users 
do.

>
> But there ARE ppl using KDE or Gnome on a 256 MB ram system (or even less)
> and they would notice this. I know I do on my 192-mb-ram laptop with
> Kubuntu... It's lovely to do some compiling task, then while you work in vi
> swap prefetch ensures everything is smooth when you try to continue
> browsing with firefox...

Indeed.

>
> > I also have vague memories of some serious-sounding review comments about
> > the code from Nick.
>
> Nick's comment, replying to me some time ago:
> > > well, the reason i use it is my computer is much more reactive in the
> > > morning. linux uses to get very slow after a night of not-doing-much
> > > except some 'sleep 5h && blabla' and cron stuff. in the morning it
> > > takes a few HOURS to get up and running smoothly. with swap prefetch,
> > > it actually feels faster compared to a fresh boot. now you can force
> > > swap prefetch to start working, i use it now and then after some heavy
> > > taskts which pulled everything to swap.
> >
> > I have two issues with this argument (not that I'm trying to say it
> > couldn't make a difference in your case).
> >
> > Firstly, swap prefetch actually doesn't handle the midnight updatedb
> > pageout problem nicely. It doesn't do any prefetching when the
> > pagecache/vfs cache fills memory (which is what would have to happen for
> > updatedb to push stuff into swap).
>
> But doesn't it prefetch stuff after updatedb has run and the computer is
> idle? Updatedb here runs at night, and swap prefetch is supposed to get my
> app data back in memory during the time after updatedb pushed it out,
> right? Maybe Con can explain here...

It can't help the updatedb scenario. Updatedb leaves the ram full and swap 
prefetch wants to cost as little as possible so it will never move anything 
out of ram in preference for the pages it wants to swap back in. The use once 
logic in the vm might if you're lucky help the next time you use the memory, 
but anything you used prior to updatedb is trashed beyond oblivion and this 
has nothing to do with swap prefetch.

> > Secondly, with or without swap prefetch, I think we can do a better job
> > of handling these use-once patterns to begin with.
>
> well, i'd love to see you elaborate on this. I mean, if the kernel could be
> made smarter and swap prefetch wouldn't be needed, great...

They're not mutually exclusive. We will _always_ have a load that causes 
swapping. Whatever the resources available on a pc, an application will come 
along that outstrips it. The nature of normal desktops is they're always 
driven to this level.

> > > Why keep it in -mm for so long?
> >
> > I'm waiting to be shown that its benefits exceed its costs.  Sometimes
> > that's hard.
>
> Nobody has said anything about costs, indeed. Now afaik, swap prefetch is
> designed to have no/as little as possible costs, so that makes sense. Does
> it have to have some bugs, which have to be adressed, before it can enter?
> I'm sure this can be arranged, right, Con?

I'm stuck developing code I'm having trouble proving it helps. Normal users 
find it helps and an artificial testcase shows it helps, but that is not 
enough, since the normal users will be tainted in their opinion, and the 
artificial testcase will always be artificial. My mistake of developing novel 
code in areas that were unquantifiable has been my undoing.  If it's 
unquantifiable, but "obvious" then it has a chance...(like most of what goes 
into mainline). Precious few of the patches that I keep in -ck belong to that 
group though. 

P.S. Sorry about being harsh in the last email Jos, I understood your 
frustration.

-- 
-ck
