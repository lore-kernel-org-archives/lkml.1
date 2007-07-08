Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbXGHOZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbXGHOZW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXGHOZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 10:25:11 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:55791 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbXGHOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 10:25:10 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070708123748.GB3866@ucw.cz> (message from Pavel Machek on Sun,
	8 Jul 2007 12:37:48 +0000)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz> <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu> <20070708123748.GB3866@ucw.cz>
Message-Id: <E1I7Xfc-0008PO-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 08 Jul 2007 16:23:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > We can just wait for all fuse requests to be serviced before
> > > > > proceeding further with freeze, right?
> > > > 
> > > > Right.  Nice way to slow down or stop the suspend with an unprivileged
> > > > process.  Avoiding that sort of DoS is one of the design goals of
> > > > fuse.
> > > 
> > > So you want me to handle _malicious_ filesystems now?
> > 
> > What I'd like, is a suspend, that works reliably, regardless of the
> > state of any userspace filesystem, network servers and such.
> 
> Well, fix userspace filesystems and maybe NFS. If they react to
> sigstop in timely manner, they will work with suspend properly, too.

Which is pretty much impossible, given the unix filesystem API.  To be
able to react to sigstop, the operations in question need to be
restartable.  Which they are not, so they can't react to sigstop.  End
of story.

> > > That should be easy... :-). You already have nasty deadlocks in FUSE,
> > > and you solve them by "root can echo 1 > abort"... so allow me the
> > > same possibility.
> > > 
> > > We can tell fused we are freezing, and if all the requests are not
> > > serviced within, say, 30 seconds, we call the filesystem malicious and
> > > do echo 1 > abort.
> > 
> > Arbitrary time limits, nice.  Not.
> > 
> > This freezer is like an old house that's close to collapsing, and you
> 
> Nice way to have useful discussion. Not.

Sorry, didn't mean to offend you.

> Look, Linux was not designed with malicious filesystems in mind. In
> particular, suspend was not designed with malicious filesystems in
> mind, and VFS was not designed with malicious filesystems in mind.
> That's why you have the nastiness with deadlocks... which you are
> unable/unwilling to solve because you'd have to redesign VFS and meet
> Al Viro.

No, I don't think we need to redesign the VFS, and also I think the
malicious filesystem thing has been adequately taken care of in fuse.

You may not like the fact that one process can cause another to go
into uninterruptible sleep, but in fact there's nothing wrong with
that.  The effects are localized to the mount owner, it won't cause
any system-wide ill, it's in fact no worse than a malicious process
doing ptrace().

And as explained above it's unavoidable due to the well established
userspace API.  The _point_ of fuse is to let this API be used by
unmodified programs and the filesystem be provided by a userspace
process.  After showing me the right way to do this with Podfuk, this
should not come as a surprise to you.

So the fact that the freezer can't handle this is unfortunate, but
it's just a symptom of the brokenness of it, not something that fuse
introduced.  Not being able to suspend with NFS (or other network
filesystems) when the network is lost shows that this is a deeper
problem.

And for some reason you seem not to accept that.  You think that the
problem is with fuse, NFS, CIFS, whatever, and not the freezer, when
in fact it's quite clear, that neither of the above should have
anything to do with power management.  Even if it was possible to fix
them, it would still be just fixing the symptoms.

> Now.. freezer already includes timeout; if some part of kernel knows
> nothing about suspend or had crashed, it will abort after some time,
> telling you which part to blame. Another timeout for detecting
> malicious userspace filesystems will not hurt much in this old house.
> (Maybe you don't want to auto abort them, just tell user what happened.
> 
> We are stuck with refrigerator for now, and at least for hibernation,
> I don't see any feasible alternative.

Even for hibernation, I don't see, why we would need all processes
being effectively in a stopped state.

As stated otherwise in the thread, suspend2 in fact allowed processes
to be in uninterruptible sleep instead, without negative side effects.

The current freezer does too much for suspend and for hibernate too.

> > Malicious programs are not something specific to fuse.  A lot of the
> > multiuser/multitasking OS design is about isolating things, so such a
> > program is limited in the damage it can do.
> 
> I'm talking malicious _filesystems_ here, and yes, fuse is first of
> this kind. We want to handle unresponding NFS, but I believe handling
> malicious NFS server nicely is slightly out of scope.

It doesn't have to be malicious, it's enough if the server crashes, or
the network connection is lost.

Do we want to maintain the status quo, just because we can live with
it?

> > > Not nice, but we don't know any better for now. "Just fix all the
> > > drivers" basically means "just fix 90% of kernel".
> > 
> > And how much of that 90% currently has any power management?
> 
> Anything that's used in today's notebooks, I'd say...

Which is what, 10% of all the drivers?  Then it really not as bad as
you try to make it sound.  And with the late suspend call (whatever it
does) that can take care of most of those, it really becomes just a
few drivers and subsystems to fix.

Miklos
