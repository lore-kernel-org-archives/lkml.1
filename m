Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbXGTHBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbXGTHBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbXGTHBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:01:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58245 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbXGTHBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:01:32 -0400
Date: Fri, 20 Jul 2007 00:00:01 -0700
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070720070001.GC25620@kroah.com>
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <3ae72650707181633w244904a6l2cee81d307b7dda1@mail.gmail.com> <200707200114.28654.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707200114.28654.rob@landley.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 01:14:27AM -0400, Rob Landley wrote:
> Is there anything in /sys/class/block that _isn't_ in /sys/block?

No.

> Does "if you want to use it, but /sys/block will still be there" NOT
> mean, as I assumed at the time, that I could safely ignore it?

Ignore what?  /sys/block?  If you see /sys/class/block, then yes, you
can ignore it as they are just symlinks back to each other.

> (My impression from the meeting at OLS was that adding /sys/block to
> /sys/class/block had been just an idea rejected in favor of adding it
> to /sys/subsystem/block.

No, the /sys/class/block is in -mm and has been for some time.

> I note that neither my Ubuntu 7.04 laptop nor the 2.6.22 system I
> built has either a /sys/class/block or a /sys/subsystem/block, so
> anything written attempting to use that won't work on any currently
> deployed Linux system.  You can't use it today, and will never be able
> to use it on any kernel version deployed today.)

Not true at all, it works just fine here on my machines, and on all
distros released in the past year or so as tested out by a lot of users.

The only reason it isn't in Linus's tree just yet, is that some very old
mkinitrd programs don't seem to like it (we are talking Fedora Core 3
based distros, not Fedora itself.)  People are trying to work out what
the proper fix is for userspace there when they get the time.

So, expect the change to show up in 2.6.24.

> > > To all of this, I would like to humbly ask:
> > >
> > > PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!
> >
> > Man, you totally miss the point.
> 
> I want to document a stable API, including the subset of sysfs that will 
> remain stable.  The "point" appears to be that there isn't one because sysfs 
> is "special", and udev should be in the kernel source tarball.

What?  Since when does udev have to be in the kernel source tarball?
Who ever said that?

The issue here is that if you follow the rules as specified by the file,
Documentation/sysfs-rules.txt and Documentation/ABI/*/sysfs-* you should
be just fine.  To ignore them, as you have done in your examples, will
cause problems.

> I'm trying to write down here the minimal information needed to find the "dev" 
> nodes to populate /dev.  There's no functional reason I'm aware of for them 
> to keep moving around.

The issue is that the devices themselves keep moving around in the sysfs
tree all the time as systems are dynamic and change.

Again, look at the udevtrigger program for a simple way to achieve this
/dev population that you so desire.

But also realize that sysfs is much bigger than just trying to get the
information to create a /dev tree.

> > > > > Entries for char devices are found at the following locations:
> > > > >
> > > > >  /sys/bus/*/devices/*/dev
> > > > >  /sys/class/*/*/dev
> > > >
> > > > Uh, that is actually the generic location?
> > >
> > > It's what Kay Sievers and Greg KH told me at OLS when I tracked them down
> > > to ask.  I've also experimentally verified it working on Ubuntu 7.04. 
> > > That was cut and pasted from Kay's email, and it works today.
> >
> > That is still true, but it still does not tell you the type of node to
> > create, as you seem to insist on.
> 
> I don't insist on it, mknod insists on it.  You cannot mknod a dev node 
> without specifying block or char.
> 
> You're saying that sysfs should provide major and minor numbers without 
> anywhere specifying "char" or "block", meaning the major and minor numbers 
> cannot be _used_.  I am insisting on getting the third piece of information 
> without which "major" and "minor" are useless.
> 
> I asked very specifically about this at OLS, several times.  What you're 
> telling me now seems to contradict what you told me then.

Here's the rule:
	If the SUBSYSTEM is "block", it's a block device.  Otherwise
	it's a char device.

But also realize that the majority of events you will get have nothing
to do with device nodes.  I think you are forgetting this fact.

> If block is going to move to sys/class, I can put in a warning about this 
> pending breakage in the documentation, and modify my example code to filter 
> it out.

It's not a "breakage", we are preserving a symlink.  The point is that
you should not rely on the fact that /sys/block will be there in the
future, as the documentation I pointed to above describes.

> > > > It may be enough (and less confusing) to just state that the dev
> > > > attribute will belong to the associated "class" device sitting
> > > > under /sys/class/ (with the current exception of /sys/block/).
> > >
> > > Nope.  If you recurse down under /sys/class following symlinks, you go
> > > into an endless loop bouncing off of /sys/devices and getting pointed
> > > back.  If you don't follow symlinks, it works fine up until about 2.6.20
> > > at which point things that were previously directories BECAME symlinks
> > > because the directories got moved, and it all broke.
> >
> > That's total nonsense.
> 
> Which part, the "following symlinks produced an endless loop" or 
> the "directories turned into symlinks so not following them broke?"
> 
> Let's see...
> 
> According to my blog, Frank Sorensen first sent me a C port of my /dev 
> populating script on December 12, 2005.  The current kernel at the time was 
> 2.6.14, so grab that, build user Mode Linux...  Huh, it won't build with gcc 
> 4.1.2.  Or 3.4.  Ok, defconfig?  Nope, that wants a stack check symbol?  
> Let's see...  Ah, google says add -fno-stack-protector to CFLAGS.  Right...  
> Fire it up under qemu, "mount -t sysfs /sys /sys", and:
> 
> In 2.6.14, /sys/block/hda/device points 
> to ../../devices/pci0000:00/0000:00:01.1/ide0/0.0
> 
> /sys/block/hda/device/block points to ../../../../../block/hda
> 
> So in 2.6.14 you could 
> go /sys/block/hda/device/block/device/block/device/block... endlessly, which 
> is the reason I wrote mdev not to follow symlinks but to instead only look at 
> actual subdirectories.

That was the problem right there.  Why would you ever want to traverse
symlinks blindly without realizing what you were walking?  You can't
just run 'find' on sysfs and expect to not get caught in endless loops,
as the goal of the different parts of sysfs is to be able to start in
one place, and figure out all of the needed information from there.

For example, if you have a device, you can get the subsystem it belongs
to, the driver bound to it, and other stuff.  If you start with a
driver, you can get the devices it binds.  Can you see the circle
already?

So, you need to watch what you are trying to find, and if you do that,
you never will get caught in circles.  We never had that problem in udev
at all, as we just work with what was passed to us, not blindly try to
walk the whole sysfs tree.

Please use the proper context in order to get the information you need.
And at all times, a directory can turn into a symlink in order to keep
the same information possible.

> (It uses the same code to traverse down 
> beneath /sys/block and /sys/class to look for "dev" entries.)  This works 
> fine up through the 2.6.20 in ubuntu 7.04, where everything 
> in /sys/class/tty/* is still a subdirectory.  But in 2.6.22, /sys/class/tty/* 
> is all symlinks.  Hence the code that was working before changed, due to 
> something that worked fine for a couple years but broke because it wasn't 
> considered part of a stable API.
> 
> Which part of this is "total nonsense"?

Your code :)

> > until you have proven to have read 
> > the udevtrigger code,
> 
> I read the udev code when it was first posted.  I read it again 20 versions 
> later, and read it again 20 versions after that.  I couldn't COMPILE the darn 
> thing for its first ~40 releases, the code got ripped out and re-written 
> several times, I watched as it grew and then threw out libsysfs.

You could not build it?  Why not?  Did you send me a patch for this
problem that was major enough to keep you from using the project?

> So essentially you're saying "well read it again, we've finally got it right 
> now"?

Not at all, we are saying to look at how to achive what you are trying
to achieve by reading a very small and well documented .c file (530
lines with comments) that explains how to easily and quickly achieve
what you are trying to duplicate.

Heck, I did the same thing in a bash script for the Gentoo startup code
a while back that still works, but has ordering issues that the .c file
fixes up.  Hence it was dropped for the replacement that we are pointing
you at.

> > and got a clue how to do stuff reliably, and get  
> > the basic knowledge needed to document it.
> 
> Because talking to you and having you email me the notes from this 
> conversation did not provide the basic knowledge needed to document hotplug 
> and firmware loading.  Nor did asking for feedback on the document I wrote 
> up.  Thanks ever so much.
> 
> I point out that udev changes from version to version, so that running an old 
> version of udev against a new kernel has been known to break.

Hence the Documenation/CHANGES file documents the version that is
needed.  Right now it shows a version that is over a year and a half
old.  I do know that you can get away with running versions that are
even older than that if you want to, but it's not really recommended.

> Udev was more or less completely rewritten three times while I was
> still paying attention to it.  Reading the udev code and seeing what
> it's doing struck me as about as likely to reveal a stable API as
> reading the kernel source, or experimenting with sysfs from userspace.
> (Both of which I've _done_ at various points, and it keeps changing.)

The development cycle of udev has nothing to do with sysfs here.  Other
than the fact that we learned how to interact with a kernel interface
that directly exposes the internals of the kernel itself, something that
no one had done before.  In learning how to handle such major changes,
udev has changed in order to support zillions of devices, small memory
footprints, and lightening fast speed, all changes that required big
udev internal changes, but had _nothing_ to do with the kernel and/or
sysfs.

> Are you saying that the current version of udev will work with all future 
> kernels, and thus if I can figure out what udev is doing today, I can just 
> document that as the stable API?

If you want to figure out how to create a dynamic /dev filesystem that
can handle persistance device names, dynamic rules created by users,
zillions of devices on small and big systems, small footprint, and very
quick speed, then yes, read the udev source code.

What is the goal of this document here?  You start out trying to explain
the hotplug interface, and then get side tracked into talking about
creating a dynamic /dev/ filesystem in userspace and then ramble on into
how sysfs is layed out.  These are three separate things

While the act of creating such a /dev filesystem does have something to
do with the hotplug/uevent interface of the kernel, it isn't reliant on
it.  And the layout of sysfs also doesn't really have much affect on the
creation of such a /dev filesystem, as udev proves (it works just fine
without sysfs even being mounted.)

If you want to just document the hotplug/uevent interface then do
that.

If you want to document sysfs and it's structure, do that too, after
reading the existing documentation and understanding that.

thanks,

greg k-h
