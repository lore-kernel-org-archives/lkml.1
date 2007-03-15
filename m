Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXCOJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXCOJEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 05:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXCOJEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 05:04:22 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57920 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752201AbXCOJEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 05:04:21 -0400
Date: Thu, 15 Mar 2007 10:03:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jaroslav Kysela <perex@suse.cz>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: alsa was Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070315090330.GF16330@elf.ucw.cz>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.61.0703092135450.8799@yvahk01.tjqt.qr> <75b66ecd0703091450l26bdc12es4091018f2d87f0d3@mail.gmail.com> <20070314084155.GA3993@ucw.cz> <Pine.LNX.4.61.0703141644400.8322@tm8103.perex-int.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703141644400.8322@tm8103.perex-int.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >I think the sound example to the right really shows it. 
> > > >/dev/dsp has a
> > > >consistent ABI on a ton of systems. The API below it, 
> > > >varies. Linux got
> > > >file_operations and ALSA. Solaris/BSD may have its
> > > >vnode-and-so-on-functions and some sort of OSS.
> > > 
> > > I think this is a poor example as applications lose a 
> > > lot of
> > > functionality (multiple stream mixing, software volume 
> > > control, etc)
> > > by going through the legacy /dev/dsp interface vs. using 
> > > native ALSA.
> > 
> > OTOH /dev/dsp is nice, clean, unixy interface, while alsa creates ugly
> > ABI you should not even use unless you are libalsa. ouch.
> 
> Pavel, calm down. 

I'm pretty calm, thank you.

> World is not perfect and there are always probes to 
> optimize things. We use standard file operations - open/close/ioctl/mmap, 
> too.

Unfortunately AlSA _does not_ provide hardware abstraction. Instead,
it relies on libalsa in userland to do the kernel work. That means
that testing sound is ugly.

Plus, it made some "interesting choices" with naming, basically
inventing parallel system to /dev/. (Why do I have to specify "card 0"
number in xmms, and WTF it means? Why can't alsa use device paths as
rest of sane world?)

So... in dsp, if I wanted to record sound, I did

	cat /dev/dsp > /tmp/foo; cat /tmp/foo > /dev/dsp

If that worked, I had usable sound system, and if it broke, I knew it
is kernel fault. 

With alsa it is

	download & install alsalib
	download & install alsautils
	create 1007 nodes in /dev
	launch alsamixer, figure out what to do from inadequate descriptions
	launch arecord, try to guess some suitable options
	launch aplay, try to guess some options

...if it does not work, it may be a kernel problem or userspace
problem; I'm left with debugging both. That makes alsa pretty much
untestable.

(For _my_ usage, something like "alsatest" that is self-contained,
preferably statically linked, and just tests microphone and sound
output would be nice. But that does not fix the fact that alsa is
broken by design).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
