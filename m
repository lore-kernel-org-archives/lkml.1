Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXAZSnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXAZSnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161157AbXAZSnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:43:23 -0500
Received: from mx1.suse.de ([195.135.220.2]:37674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXAZSnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:43:22 -0500
Date: Fri, 26 Jan 2007 10:42:18 -0800
From: Greg KH <greg@kroah.com>
To: xiphmont@xiph.org
Cc: Takashi Iwai <tiwai@suse.de>, Pierre Ossman <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       Lennart Poettering <lennart@poettering.net>, perex@suse.cz
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Message-ID: <20070126184218.GA30365@kroah.com>
References: <s5h7ivbuhg1.wl%tiwai@suse.de> <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com> <s5h4pqfufs8.wl%tiwai@suse.de> <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com> <s5h1wljuf2f.wl%tiwai@suse.de> <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com> <20070125194933.GA27857@kroah.com> <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com> <20070125215943.GC3126@kroah.com> <806dafc20701261003s1790ada8xbec94c914424c86f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806dafc20701261003s1790ada8xbec94c914424c86f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 01:03:41PM -0500, xiphmont@xiph.org wrote:
> Before I get to the less focused rant below, I wanted to mention that
> the HELP text for 'Create deprecated sysfs files' does not make it
> clear that one is opting for old in exclusion of new.

Hm, can you think of some better wording that I might use for it?

> On 1/25/07, Greg KH <greg@kroah.com> wrote:
> 
> >There is no such thing as a "stable release update" series anymore, you
> >should know that :)
> 
> To the detriment of the users, yes.  Subminor release update and
> *bam*, audio doesn't work and it takes a kernel hacker to figure out
> why, and because of a small but inevitable error (error is inevitable
> in change). If this was a Windows service pack or a MacOS subminor
> update, it would be front page news in industry trade mags.  The fact
> that it isn't is because it's Linux and we're frankly still the
> retarded foster child adopted for tax purposes, at least as far as the
> desktop goes.

Again, the kernel will only have "subminor release updates" as per the
number, but not as per what we are really doing here in the kernel.

And it only looks like it affected a subset of the distros out there, my
boxes all worked just fine, even with that config option turned off,
otherwise I would have caught it very early in testing.

> I'm not saying change is bad, I'm saying this was a subtle, large
> change and no one has explained the functional benefit beyond 'it's
> cleaner' to outweigh 'many users want to strangle us'.

Well, users should never want to strangle us, that means we messed up.
And yes, this was a bug, sorry.

As for why we are doing this kind of change, it makes sense from a
hierarchical point of view (one device tree, symlinks into the tree for
information that you need instead of many multiple device trees all
scattered around.)  It also properly gives us the "card" abstraction for
ALSA devices, something people have been asking for quite some time (in
order to do persistent device names and other stuff).  And it fixes a
number of suspend/resume issues by allowing the class core that controls
the device to be notified of a suspend/resume before the device is, so
that it can do common work without all of the individual drivers having
to be changed.

> >Well, as this HALD issue is the only thing that I have had reported, and
> >these patches have been in the -mm tree for quite some time, yes, I
> >think it is the only thing that has broken.
> 
> Plenty of people spotted it, several bugs got filed, and the fact that
> you're only hearing about it from me at least two months after
> introduction is mildly worrisome.  (I am already worried that *I*
> didn't hear about it till recently as I attempted to push out Pulse in
> fc rawhide and found it magically no longer worked.  At all.)

Where were they filed?  Should I be looking somewhere else for kernel
bug reports?

> If the hald developers were caught unprepared (so unprepared, in fact,
> they've all ben inaccessable due to holiday + conference + vacation
> for over a month and we can't push an update out), what is the average
> user to do?

Some of the HAL developers knew about this a long time ago, as they were
one of the main people who did the kernel changes.  So I don't think
they were all unprepared :)

> Not to mention the fact that it's just a little embarrassing that
> sysfs was invented for 2.6 and the original version has already been
> declared deprecated, still in 2.6.  There's change, and then there's
> churn.

How would you go about making changes like the above?  I had two
choices:
	- fix all broken userspace programs for all old, unsupported
	  distros before making the change.  I actually started to do
	  this, but quickly got lost in a maze of old distro images...
	- add a kernel option that kept the old structure of sysfs, so
	  that people can slowly migrate over as their userspace
	  programs catch up and get updated in the future.

I implemented the latter, and so far, this is the only hic-up that has
been reported in the mainline kernel with it so far (there were bug
reports about stuff in the -mm tree, but that is what it is there for,
and they were quickly fixed.)

> >In short, it's a bug, I messed up somehow.  And I'm trying to fix it
> >now, I don't think there's more that I can do, do you?
> 
> No.  I'm not pushing back against you, I'm pushing back against the
> budding 'stable APIs are for boring losers' culture.

Note, I don't think that at all.  We are changing these userspace things
because we have learned and realize that after a few years of using this
model, things need to be tweaked to properly reflect the needs of the
real world.  It's almost impossible to get such a change right the first
time, and Linux relies on evolution of stuff in order to adapt properly.

Again, I'm providing a way to allow backward compatibility so that we do
not break anything that is currently out there.  So far no one has
objected to this :)

> There's a reason I refuse to update my personal machines more often
> than once every year or two-- they spend the next few weeks completely
> dysfunctional each time.  To be fair, the kernel is usually far better
> than userland [excepting ALSA, GRRRR], but let's not go pissing away
> that relative lead :-)

And there's a reason that I'm always using the latest experimental
userspace and use a distro that lets me do that :)

But I also have old machines that I don't update to ensure that things
still work properly.  Unfortunatly in this case, they were too old such
that the problem was never seen (pre-HAL-relying-gnome-distro).

thanks,

greg k-h
