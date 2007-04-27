Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbXD0AKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbXD0AKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXD0AKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:10:43 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3629 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbXD0AKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:10:40 -0400
Date: Fri, 27 Apr 2007 02:10:38 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
Message-ID: <20070427001038.GA11265@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Xavier Bestel <xavier.bestel@free.fr>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> <1177573348.5025.224.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> <1177607026.30284.197.camel@frg-rhel40-em64t-04> <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org> <1177618081.4737.42.camel@nigel.suspend2.net> <alpine.LFD.0.98.0704261343150.9964@woody.linux-foundation.org> <1177620656.4737.56.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177620656.4737.56.camel@nigel.suspend2.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 06:50:56AM +1000, Nigel Cunningham wrote:
> I'm perfectly willing to think through some alternate approach if you
> suggest something or prod my thinking in a new direction, but I'm afraid
> I just can't see right now how we can achieve what you're after.

Ok, what about this approach I've been mulling about for a while:

Suspend-to-disk is pretty much an exercise in state saving.  There are
multiple ways to do state saving, but they tend to end up in two
categories: implicit and explicit.

In implicit state saving, you try to save the state of the
system/application/whatever "under its feet", more or less, and then
fixup what is no saved/saveable correctly.  A well-known example is
the undumping process Emacs goes (went?) where it tries to dump the
state of the memory as a new executable, with a lot of pleasure with
various executable formats and subtleties due to side effects in libc
code you don't control.

In explicit state saving each object saves what is needed from its
state to an independently defined format (instead of "whatever the
memory organization happens to be at that point").  When reloading the
state you have to parse it, and it usually requires
rebuilding/relocating all references/pointers/etc.  XEmacs currently
has a "portable dumper" that pretty much does just that.  We don't
have any redumping problems anymore, they're over.

Which one is the best depends heavily on the application.  The amount
of code in the implicit case depends on the amount of fixups to do.
In the kernel case it happens to be a lot, pretty much everything that
touches hardware has to save to memory the device state and reload it
on resume.  And bugs on hardware handling can be quite annoying to
debug.  And if some driver does not to saving/resume correctly, you
have no way outside of playing with modules to ensure the safety of
the suspend cycle.

The amount of code in the explicit case is an interesting variable in
the case of the kernel.  You have to save what is needed, but how do
you define what is needed?  It is, pretty much, what running processes
can observe from userspace.  Now, what can a process observe:
- its application text and anonymous memory pages
- its file handles
- its mapped files
- its mapped whatever else
- its sys5 IPC stuff
- futex stuff and friends, namespaces, etc
- its intrinsic characteristics it can reach through syscalls
  (i.e. the user-visible parts of current, like pid, uid...)
- its currently running system call, if any

So that's what we'd have to explicitely save.  Anonymous memory, sys5
IPC, futex and current structures, that's easy stuff in practice.  The
fun part are pretty much:
- references to files
- references to active networking links
- references to devices and associated visible state
- currently running system call, aka the kernel stack for the process

The last one is the one I'm the most afraid of.  I hope that the
signal stuff and/or the asynchronous syscall stuff that was discussed
recently would allow to "unwind" blocking system calls back to the
syscall level and then store the parameters for resume-time restart.
The non-blocking calls you can just let finish.

The first one is really interesting.  If you value your filesystems,
you'd rather have them clean after the suspend.  And also you pretty
much know that filesystems can move around when you're not looking, be
it USB hotplug stuff (discovery order is random-ish isn't it?), module
loading order issues or multithreaded device discovery.  So you're way
more happy *not* caching anything from the filesystem you can avoid.

But what is a file reference, really?  With the dcache handy, it's
pretty much a path, since inodes don't always exist reliably.  And if
you have the lists of paths used by the processes on a particular
filesystem, you can easily get an idea of where, if anywhere, the
filesystem is even if you don't have reliable serials.  More
interestingly, you cannot, in any case, instantly corrupt your
filesystem by having a mismatch between the in-memory cache and the
reality.

The processes which referenced files you can't find anywhere will
end-up with EBADF or segfault depending on whether it was fd or mmap,
ala revoke().  They'll probably die horribly.  I'd rather have
processes die than filesystems die, since in any case if the file
isn't here anymore in practice the process could only destroy things.

An interesting things there, nothing in that touches either the
filesystem or the block devices.  Everything is done at the VFS level.
The devices don't need to care.  And the "this filesystem goes there"
can be done in userspace in an initramfs if people want to experiment
with kinky strategies.  After all, why not allow a sysadmin to regroup
two filesystems into one though a suspend, the processes mostly don't
need to care (well, tar may, but heh).  Deleted files would have to be
sillyrenamed or something.  Implementation details ;-)

Active networking links, you can consider them dead for a start.  The
networking guys can play with keepalives and stuff if they want to in
a second step.  Network seldom survives suspend anyway, too many
timeouts involved, especially with dynamic IPs.

That leaves references to devices.  null, ptys, random, log are not a
problem, they're virtual constructs.  In a first approximation you can
revoke() the rest brutally.  On a "standard" system that will kill X
(ouch), GPM and other input-interested devices, and everything with an
opened sound device.  Then you can add explicit state saving support
to the devices you want, one by one.  It may be possible to handle
sound collectively at the ALSA layer level, I don't really know.
Input shouldn't be too hard, not much state to save, X will be a pain
and will probably need special casing.  X is a big special case
anyway, no matter what happens.

For the less directly used devices you can always all explicit support
when you feel like it.  The interesting part is that either the device
supports the suspend and says so explicitely, or the process can't
access the device anymore using the previous fds/mmaps after resume.
No weird half-condition.  If (very) resilient, the process can even
close, reopen, reconfigure and go on its merry way.

And if you design the saving format correctly (attribute name/value
pairs as text work beautifully for such a case), you can be resilient
to extreme things including kernel version change or rsync-ing / and
the state file and resuming in another box.  And if a device gets
something it can't parse as the state to go back to for a given
fd/mmap for a process, it can always revoke() that one and go on.

The main point of that kind of state-saving is to be
trustable-by-design.  For each process, either its environment could
be restored correctly or the incorrect parts can not be accessed
anymore.  And the stability of the system and its filesystems is
ensured pretty much whatever happens.


There are a billion details to take into account in a real
implementation, but I'm sure you can get the gist of the idea.

  OG.

