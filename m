Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbXGHMiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbXGHMiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbXGHMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:38:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4909 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbXGHMiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:38:16 -0400
Date: Sun, 8 Jul 2007 12:37:48 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Message-ID: <20070708123748.GB3866@ucw.cz>
References: <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > We can just wait for all fuse requests to be serviced before
> > > > proceeding further with freeze, right?
> > > 
> > > Right.  Nice way to slow down or stop the suspend with an unprivileged
> > > process.  Avoiding that sort of DoS is one of the design goals of
> > > fuse.
> > 
> > So you want me to handle _malicious_ filesystems now?
> 
> What I'd like, is a suspend, that works reliably, regardless of the
> state of any userspace filesystem, network servers and such.

Well, fix userspace filesystems and maybe NFS. If they react to
sigstop in timely manner, they will work with suspend properly, too.

> > That should be easy... :-). You already have nasty deadlocks in FUSE,
> > and you solve them by "root can echo 1 > abort"... so allow me the
> > same possibility.
> > 
> > We can tell fused we are freezing, and if all the requests are not
> > serviced within, say, 30 seconds, we call the filesystem malicious and
> > do echo 1 > abort.
> 
> Arbitrary time limits, nice.  Not.
> 
> This freezer is like an old house that's close to collapsing, and you

Nice way to have useful discussion. Not.

Look, Linux was not designed with malicious filesystems in mind. In
particular, suspend was not designed with malicious filesystems in
mind, and VFS was not designed with malicious filesystems in mind.
That's why you have the nastiness with deadlocks... which you are
unable/unwilling to solve because you'd have to redesign VFS and meet
Al Viro.

Now.. freezer already includes timeout; if some part of kernel knows
nothing about suspend or had crashed, it will abort after some time,
telling you which part to blame. Another timeout for detecting
malicious userspace filesystems will not hurt much in this old house.
(Maybe you don't want to auto abort them, just tell user what happened.

We are stuck with refrigerator for now, and at least for hibernation,
I don't see any feasible alternative.

And now, can we get that sysrq-t trace? Dealing with 'unable to
freeze' may be hard, but the deadlock Matthew saw should be simple bug
for us to fix.

> > Not ideal, but neither is allowing malicious filesystems in the first
> > place...
> 
> Malicious programs are not something specific to fuse.  A lot of the
> multiuser/multitasking OS design is about isolating things, so such a
> program is limited in the damage it can do.

I'm talking malicious _filesystems_ here, and yes, fuse is first of
this kind. We want to handle unresponding NFS, but I believe handling
malicious NFS server nicely is slightly out of scope.

> > Not nice, but we don't know any better for now. "Just fix all the
> > drivers" basically means "just fix 90% of kernel".
> 
> And how much of that 90% currently has any power management?

Anything that's used in today's notebooks, I'd say...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
