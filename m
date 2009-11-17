Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZKQUkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZKQUkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZKQUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:40:13 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33251 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKQUkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:40:12 -0500
Date: Tue, 17 Nov 2009 21:40:16 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FIX IT
Message-ID: <20091117204015.GB5746@rhlx01.hs-esslingen.de>
References: <20091116194015.GA13820@rhlx01.hs-esslingen.de> <20091116203545.GA2028@emergent.ellipticsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091116203545.GA2028@emergent.ellipticsemi.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 03:35:45PM -0500, Nick Bowler wrote:
> On 20:40 Mon 16 Nov     , Andreas Mohr wrote:
> > --- linux-2.6/init/main.c.orig	2009-11-16 20:13:08.000000000 +0100
> > +++ linux-2.6/init/main.c	2009-11-16 20:14:51.000000000 +0100
> > @@ -846,7 +846,8 @@ static noinline int init_post(void)
> >  	run_init_process("/bin/init");
> >  	run_init_process("/bin/sh");
> >  
> > -	panic("No init found.  Try passing init= option to kernel.");
> > +	panic("No init found.  Try passing init= option to kernel. "
> > +	      "See Linux Documentation/init.txt for guidance.");
> 
> I think that the people who know where to look after reading this are
> mainly the people who don't need to read that file, with one exception -
> point (C) later on.

I'm afraid I have to disagree with some parts in this mail.

As an LKML regular I've certainly had a rather higher share of problems
in all this than I'd ever have expected.

As for less-involved people, they will just raise eyebrows on
"Documentation/init.txt", Google the term (as long as they've got a second
working computer, that is ;) and be happy.

> > +OK, so you've got this pretty unintuitive message (currently located
> > +in init/main.c) and are wondering what the H*** went wrong.
> > +Some high-level reasons for failure (listed roughly in order of execution)
> > +to load the init binary are:
> > +A) Unable to mount root FS
> 
> Whenever the root FS has been unable to mount, I've always received an
> error message that included the string "VFS: Unable to mount root fs".
> Has this changed recently?  What sort of setup causes one to receive "No
> init found" instead?

This _might_ be the case (I think it happens often indeed), but you
never know whether it's correctly output in 100% of these cases
(e.g. possibly depending on whether "debug" is specified or not, as one
factor only!).

And given the avalanchy multitude of problems in this area my
staunch opinion is that this guidance should be committed NOW regardless
of whether it's got a "perfect" appearance (i.e. 100% of the content is
fully accurate, lists all required hints and doesn't contain false positives).
So far we've provided almost NOTHING, so let's at least add something, soon.

I'll just give further examples:
a) [same day] saw http://lkml.org/lkml/2009/11/10/526 during some light LKML reading
b) [same day] _first_ pastebin plea for help that I encountered on #openwrt
- guess what it was about?
c) [next day] wasting half a day at work due to Red Hat's sheer
inability to make a system work with more than 7MB/s on SATA hardware.
Even worse, trying to fix this up by going the way of building a custom
2.6.31.5 (something I'm doing all the time elsewhere), I even managed to hit
SEVERE Red Hat initrd root device issues (culminating in "Init not found."),
with about a hundred UNSOLVED Google results in trying to make a buggy
initrd / nash setup accept a different root device.
Talk about double fault, for crying out loud.
d) [second next day] private thankful reply of another power user to my patch mail
citing Debian initrd issues due to ldd issues causing .so's to get lost and
thus a "No init found." message produced.

> > +B) init binary doesn't exist on rootfs
> > +C) other requirements not met
> 
> The introduction to this list already stated that it is not exhaustive,
> so this entry adds no new information.  After reading the detailed
> explanation, "broken console device" seems more appropriate here.

Indeed, it's better to have one-liners with specific issues and then
multi-liners elaborating on these issues, I'll update it.

> > +D) binary exists but dependencies not available
> > +E) binary cannot be loaded
> 
> To me, (B), (D) and (E) are the same thing, and could just be "binary
> cannot be loaded".  The details can be expanded upon in the next
> section.
> 
> > +Detailed explanations:
> <snip>
> > +C) Possibly a conflict in console= setup --> initial console unavailable.
> > +E.g. some serial consoles are unreliable due to serial IRQ issues (e.g. missing
> > +interrupt-based configuration).
> > +Try using a different console= device or e.g. netconsole=.
> 
> This appears to be by far the most interesting point in this file, since
> it clarifies that "No init found." might be caused by a configuration
> problem which seems completely unrelated to loading init.

Users don't care much whether the message is "Init not found." or
"console broken." or whatever, all they know is that their system
doesn't work and that they want immediate help and earnest attempts
in getting this thing resolved.
Of course it would be nice to have individual areas of problems output
their fair share of log messages (e.g. console setup), but as long as we
don't have that entirely and I'm not fully ready to figure out myself
all places that are lacking certain messages (as opposed to e.g.
core developers), we need (certainly imperfect) helper documentation NOW.

> > +D) e.g. crucial library dependencies of the init binary such as
> > +/lib/ld-linux.so.2 missing or broken. Use readelf -d <INIT>|grep NEEDED
> > +to find out which libraries are required.
> > +E) make sure the binary's architecture matches your hardware.
> > +E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
> > +Or did you try loading a non-binary file here!?! (shell script?)
> 
> Linux is perfectly happy to load a shell script as init, so this comment
> is very misleading.

Oh, interesting. I've seen a warning about this in a forum, thus I added
it here, but I don't have experience with this myself, so I guess it's
ok after all, thanks!
(and there are several reports that seem to confirm that a shell script is
possible, probably since the shebang mechanism likely is ld.so-related)

This part should thus be altered to mention that a script needs to have its fully
working interpreter binary plus dependencies available.

I'll submit a new version of this patch very soon.

Thanks,

Andreas Mohr
