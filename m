Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbXGUGtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbXGUGtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXGUGsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:48:54 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:55238
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXGUGsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:48:53 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Sat, 21 Jul 2007 02:23:30 -0400
User-Agent: KMail/1.9.6
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
References: <200707171703.31340.rob@landley.net> <200707200114.28654.rob@landley.net> <20070720070001.GC25620@kroah.com>
In-Reply-To: <20070720070001.GC25620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210223.31054.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 3:00:01 am Greg KH wrote:
> On Fri, Jul 20, 2007 at 01:14:27AM -0400, Rob Landley wrote:
> > Is there anything in /sys/class/block that _isn't_ in /sys/block?
>
> No.
>
> > Does "if you want to use it, but /sys/block will still be there" NOT
> > mean, as I assumed at the time, that I could safely ignore it?
>
> Ignore what?  /sys/block?  If you see /sys/class/block, then yes, you
> can ignore it as they are just symlinks back to each other.

I read "if you want to use it" as meaning "if you want to 
use "/sys/class/block", I.E. it was optional.

If /sys/block is going to remain a symlink to /sys/class/block then using the 
path "/sys/block" should work on both existing kernels and on new kernels 
without modification.

What moving it will force me to do is edit out "/sys/class/block' if I find it 
looking for char devices under "/sys/class".  Moving it forces me to add code 
to remove it.  I don't know what the supposed benefit is...

Ah, hang on.  Most likely this is an implementation detail from moving 
everything under /sys/subsystem and making /sys/class a symlink -> subsystem 
and /sys/block a symlink -> subsystem/block.  So it sounds like it's not 
really intentional breakage, just an implementation side effect.  Ok, that 
makes sense.

(Sorry, this hadn't occurred to me until now.  I'm not the one implementing 
this stuff, so I haven't spent the past few months thinking through the 
ramifications already.  This entire thread is one of about 12 things I'm 
working on at the moment.)

> > (My impression from the meeting at OLS was that adding /sys/block to
> > /sys/class/block had been just an idea rejected in favor of adding it
> > to /sys/subsystem/block.
>
> No, the /sys/class/block is in -mm and has been for some time.

A yes, "set back up an automated -mm testing thing that away when previous 
laptop did".  I need to bump that up on my todo list...

> > I note that neither my Ubuntu 7.04 laptop nor the 2.6.22 system I
> > built has either a /sys/class/block or a /sys/subsystem/block, so
> > anything written attempting to use that won't work on any currently
> > deployed Linux system.  You can't use it today, and will never be able
> > to use it on any kernel version deployed today.)
>
> Not true at all, it works just fine here on my machines, and on all
> distros released in the past year or so as tested out by a lot of users.

"All the distros" meaning "not Ubuntu 7.04"?  I just checked again, it doesn't 
have either a /sys/class/block or /sys/subsystem/block.  I realize they're 
coming...

> The only reason it isn't in Linus's tree just yet, is that some very old
> mkinitrd programs don't seem to like it (we are talking Fedora Core 3
> based distros, not Fedora itself.)  People are trying to work out what
> the proper fix is for userspace there when they get the time.
>
> So, expect the change to show up in 2.6.24.

Ok.

> > > > To all of this, I would like to humbly ask:
> > > >
> > > > PICK ONE!  JUST #*%(&#%& PICK ONE!  AAAAAAAAHHHHHHH!!!!!!!!!
> > >
> > > Man, you totally miss the point.
> >
> > I want to document a stable API, including the subset of sysfs that will
> > remain stable.  The "point" appears to be that there isn't one because
> > sysfs is "special", and udev should be in the kernel source tarball.
>
> What?  Since when does udev have to be in the kernel source tarball?
> Who ever said that?

I got that impression from:
  http://lkml.org/lkml/2006/7/30/228
  http://lwn.net/Articles/193603/

> The issue here is that if you follow the rules as specified by the file,
> Documentation/sysfs-rules.txt and Documentation/ABI/*/sysfs-* you should
> be just fine.  To ignore them, as you have done in your examples, will
> cause problems.

I read the Documentation/ABI ones in the current linus -git (well, as of... 
tuesday?)  and am unaware of any conflicts.  I read sysfs-rules.txt this 
morning, and the only _required_ change I'm aware of is filtering 
out /sys/class/block if it occurs.  (Is there more Documentation in Andrew 
Morton's tree that's not in Linus's?)

Lemme re-read my document...

Ok, /sys/bus/*/devices/*/dev is the path Kay told me to use during our 
discussion at OLS.  It's one of the paths I cut and pasted out of the email 
he sent me.  He typed that path, I didn't.  I see that the bit 
in "sysfs-rules.txt" about never using the "devices" symlink contradicts 
that.  Ok, so what _should_ I do?

Personally, I've never seen a dev link under "/sys/bus".  I neither own nor 
have personally encountered hardware that does that, and the first I heard 
that there _was_ such hardware was when talking to him at OLS.

Kay: if you get this, what path should I use?  Your email said:

> /sys/bus/*/devices/*/dev
> /sys/class/*/*/dev
> /sys/block/*/dev
> /sys/block/*/*/dev
>
> /sys/subsystem/*/devices/*/dev

The fifth of which isn't in currently deployed kernels (not in kernel.org, not 
in most recent ubuntu release, that counts as "not currently deployed" to 
me), and the first four should continue to work even when that goes in, so I 
didn't include it in "how to find this information", but I note that it also 
follows "devices"...

> > I'm trying to write down here the minimal information needed to find the
> > "dev" nodes to populate /dev.  There's no functional reason I'm aware of
> > for them to keep moving around.
>
> The issue is that the devices themselves keep moving around in the sysfs
> tree all the time as systems are dynamic and change.
>
> Again, look at the udevtrigger program for a simple way to achieve this
> /dev population that you so desire.

I'm aware of that program, and can iterate through the tree and write "add" 
to "uevent" instead of reading "dev".  Technically the /sbin/hotplug approach 
would have the same potential race condition with remove happening during 
scan: the potential downside is leaving a node in /dev that will give 
an -ENODEV if you try to open it, which is annoying but not fatal (no obvious 
security implications or anything), and a small enough race condition that it 
would seldom if ever inconvenience real users.

I can document this, though...

> But also realize that sysfs is much bigger than just trying to get the
> information to create a /dev tree.

I know.  At the moment I'm only trying to document the subset of sysfs needed 
to maintain a /dev tree via hotplug.  In future this may expand to include 
enough information to persistently name certain types of devices, but I'd be 
just as happy to have that under Devices/ABI and refer to it instead.

> > > > > > Entries for char devices are found at the following locations:
> > > > > >
> > > > > >  /sys/bus/*/devices/*/dev
> > > > > >  /sys/class/*/*/dev
> > > > >
> > > > > Uh, that is actually the generic location?
> > > >
> > > > It's what Kay Sievers and Greg KH told me at OLS when I tracked them
> > > > down to ask.  I've also experimentally verified it working on Ubuntu
> > > > 7.04. That was cut and pasted from Kay's email, and it works today.
> > >
> > > That is still true, but it still does not tell you the type of node to
> > > create, as you seem to insist on.
> >
> > I don't insist on it, mknod insists on it.  You cannot mknod a dev node
> > without specifying block or char.
> >
> > You're saying that sysfs should provide major and minor numbers without
> > anywhere specifying "char" or "block", meaning the major and minor
> > numbers cannot be _used_.  I am insisting on getting the third piece of
> > information without which "major" and "minor" are useless.
> >
> > I asked very specifically about this at OLS, several times.  What you're
> > telling me now seems to contradict what you told me then.
>
> Here's the rule:
> 	If the SUBSYSTEM is "block", it's a block device.  Otherwise
> 	it's a char device.

Ok.  Cornelia Huck seemed to disagree, but I see that's been resolved in 
another message.

> But also realize that the majority of events you will get have nothing
> to do with device nodes.  I think you are forgetting this fact.

Actually, I'm filtering them out, but I should make a note of it in the 
documentation.  (I'd happily document other events you might want to respond 
to that come into the hotplug mechanism, but I don't know what they are and 
am trying to start with the basics and flesh it out later.  Persistent device 
naming is a can of worms I'll have to open eventually.  Ubuntu 7.04 put uuids 
on every _partition_ in my laptop, and spins up my external usb hard drive 
trying to mount root.  When connected a machine with an IDE hard drive, 
that's now going through the scsi layer.  Sigh...)

> > If block is going to move to sys/class, I can put in a warning about this
> > pending breakage in the documentation, and modify my example code to
> > filter it out.
>
> It's not a "breakage", we are preserving a symlink.  The point is that
> you should not rely on the fact that /sys/block will be there in the
> future, as the documentation I pointed to above describes.

It doesn't say that /sys/block are deprecated or will be removed.  The closest 
it says is:

>   If /sys/subsystem exists, /sys/bus, /sys/class and /sys/block can be
>   ignored.

Which isn't the same as "must be ignored" or "may be removed".  I asked about 
this explicitly at OLS ("can I just keep using /sys/block and /sys/class") 
and was told that there were no plans to remove them.

Existing systems require using the older names, and I'm unaware of any 
information the new names provide that the old ones don't.

> > > > > It may be enough (and less confusing) to just state that the dev
> > > > > attribute will belong to the associated "class" device sitting
> > > > > under /sys/class/ (with the current exception of /sys/block/).
> > > >
> > > > Nope.  If you recurse down under /sys/class following symlinks, you
> > > > go into an endless loop bouncing off of /sys/devices and getting
> > > > pointed back.  If you don't follow symlinks, it works fine up until
> > > > about 2.6.20 at which point things that were previously directories
> > > > BECAME symlinks because the directories got moved, and it all broke.
> > >
> > > That's total nonsense.
> >
> > Which part, the "following symlinks produced an endless loop" or
> > the "directories turned into symlinks so not following them broke?"
> >
> > Let's see...
> >
> > According to my blog, Frank Sorensen first sent me a C port of my /dev
> > populating script on December 12, 2005.  The current kernel at the time
> > was 2.6.14, so grab that, build user Mode Linux...  Huh, it won't build
> > with gcc 4.1.2.  Or 3.4.  Ok, defconfig?  Nope, that wants a stack check
> > symbol? Let's see...  Ah, google says add -fno-stack-protector to CFLAGS.
> >  Right... Fire it up under qemu, "mount -t sysfs /sys /sys", and:
> >
> > In 2.6.14, /sys/block/hda/device points
> > to ../../devices/pci0000:00/0000:00:01.1/ide0/0.0
> >
> > /sys/block/hda/device/block points to ../../../../../block/hda
> >
> > So in 2.6.14 you could
> > go /sys/block/hda/device/block/device/block/device/block... endlessly,
> > which is the reason I wrote mdev not to follow symlinks but to instead
> > only look at actual subdirectories.
>
> That was the problem right there.  Why would you ever want to traverse
> symlinks blindly without realizing what you were walking?

Because I didn't want to encode an unknown structure of sysfs into the 
program?  Partitions were at the same level as hard drives one release (when 
I first came up with a working probing script for my Firmware Linux project, 
which according to my blog was October 27, 2005 and was using something like 
Linux 2.6.10), and moved into subdirectories the next, and I had no way of 
knowing if or when a third layer was going to be added to some future device 
I didn't know about.

Keep in mind I've been following this, on and off, for a while now:
http://lkml.org/lkml/2003/12/9/1
http://lkml.org/lkml/2003/12/10/16

And what I did was in response to the endless loop was _stop_ traversing 
symlinks at all, and only followed subdirectories.  Which worked fine until 
subdirectories got moved and replaced by symlinks, which is when I started 
asking "so what paths can I follow that will reliably be there in both 
current and future releases"?  Which is what I'm trying to document now.

> You can't 
> just run 'find' on sysfs and expect to not get caught in endless loops,
> as the goal of the different parts of sysfs is to be able to start in
> one place, and figure out all of the needed information from there.

I'm trying to document what those paths are.

People keep wanting to tell me about future plans that aren't merged yet.  A 
year ago the future plans were directories becoming symlinks, now the plans 
are /sys/subsystem, I'm sure in a year there will be new future plans.  I'd 
really like not to have to change existing code to still work with them, 
hence an attempt to document the API I _SHOULD_ use so that I don't have to.

If I discard what's there now and document the current future plans that 
aren't merged yet, how do I know that they won't themselves be ripped out a 
year after that?

> For example, if you have a device, you can get the subsystem it belongs
> to, the driver bound to it, and other stuff.

Can you get the default name of the device currently encoded as the last 
element of the path that "DEVPATH" points to (ala /class/mem/zero), but which 
I won't necessarily get if DEVPATH starts to point to /device/12345/:00 as 
some people keep saying DEVPATH should point to?

It's not encoded as one of the hotplug variables, other than extractable from 
DEVPATH in a way that may or may not continue to work...

> If you start with a 
> driver, you can get the devices it binds.  Can you see the circle
> already?
>
> So, you need to watch what you are trying to find, and if you do that,
> you never will get caught in circles.  We never had that problem in udev
> at all, as we just work with what was passed to us, not blindly try to
> walk the whole sysfs tree.

You wrote both the sysfs code and the udev code.  You wrote both sides of the 
export, changed both sides of the export fairly freely, and you know what you 
intended to do and what was merely an implementation artifact.

> Please use the proper context in order to get the information you need.
> And at all times, a directory can turn into a symlink in order to keep
> the same information possible.

I am aware of that, therefore I need to look at a known set of paths, which is 
what I'm trying to document now.

> > (It uses the same code to traverse down
> > beneath /sys/block and /sys/class to look for "dev" entries.)  This works
> > fine up through the 2.6.20 in ubuntu 7.04, where everything
> > in /sys/class/tty/* is still a subdirectory.  But in 2.6.22,
> > /sys/class/tty/* is all symlinks.  Hence the code that was working before
> > changed, due to something that worked fine for a couple years but broke
> > because it wasn't considered part of a stable API.
> >
> > Which part of this is "total nonsense"?
>
> Your code :)

*shrug*  There was a better way to do it back in 2005 without reading your 
mind?

> > > until you have proven to have read
> > > the udevtrigger code,
> >
> > I read the udev code when it was first posted.  I read it again 20
> > versions later, and read it again 20 versions after that.  I couldn't
> > COMPILE the darn thing for its first ~40 releases, the code got ripped
> > out and re-written several times, I watched as it grew and then threw out
> > libsysfs.
>
> You could not build it?  Why not?

I don't clearly remember the details from two years ago, but after glancing at 
my blog http://landley.net/notes-2005.html#27-10-2005 I vaguely recall that 
it had large numbers of undocumented environmental dependencies and I got 
sick of playing whack-a-mole installing packages, plus it had no 
documentation whatsoever and required a complicated configuration file to the 
point it was actually _easier_ to write a shell script to parse sysfs 
directly.  (Trying that got results in about 15 minutes.  Staring at udev for 
half a day did not.)

Plus I remember downloading different early versions of udev and finding 
things hugely rewritten between each update to the point that trying to pick 
it apart until it stabilized was a waste of time.

I also remember thinking that libsysfs sounded like a horrible idea (having 
your own copy of a shared library in the source tree defeats the purpose of 
having a shared library).  It was something that bothered me about the design 
from day one, libsysfs was in theory an external library but udev included 
its own copy, which made as much sense to me as including its own copy of 
glibc.  Here's the problem back in 2003:
http://www.ussg.iu.edu/hypermail/linux/kernel/0311.2/0716.html

Here's you replying to me on that topic in 2005:
http://www.ussg.iu.edu/hypermail/linux/kernel/0512.1/0617.html


> Did you send me a patch for this 
> problem that was major enough to keep you from using the project?

That problem was only one reason I didn't use the project.  I objected to most 
of the design, at some length, in this post back in 2005:
http://lkml.org/lkml/2005/10/30/189

> > So essentially you're saying "well read it again, we've finally got it
> > right now"?
>
> Not at all, we are saying to look at how to achive what you are trying
> to achieve by reading a very small and well documented .c file (530
> lines with comments) that explains how to easily and quickly achieve
> what you are trying to duplicate.

Ok.  I note that most of the stuff I was objecting to in 2005 wouldn't _fit_ 
in 530 lines, and my first gripe in my blog post was lack of documentation 
and unnecessary complexity, neither of which appear to be the case now...

> Heck, I did the same thing in a bash script for the Gentoo startup code
> a while back that still works, but has ordering issues that the .c file
> fixes up.  Hence it was dropped for the replacement that we are pointing
> you at.

Ok.

> > > and got a clue how to do stuff reliably, and get
> > > the basic knowledge needed to document it.
> >
> > Because talking to you and having you email me the notes from this
> > conversation did not provide the basic knowledge needed to document
> > hotplug and firmware loading.  Nor did asking for feedback on the
> > document I wrote up.  Thanks ever so much.
> >
> > I point out that udev changes from version to version, so that running an
> > old version of udev against a new kernel has been known to break.
>
> Hence the Documenation/CHANGES file documents the version that is
> needed.  Right now it shows a version that is over a year and a half
> old.  I do know that you can get away with running versions that are
> even older than that if you want to, but it's not really recommended.

Udev appears to have changed, for the better.  I'm still uncomfortable 
with "the implementation is the specification".

> > Udev was more or less completely rewritten three times while I was
> > still paying attention to it.  Reading the udev code and seeing what
> > it's doing struck me as about as likely to reveal a stable API as
> > reading the kernel source, or experimenting with sysfs from userspace.
> > (Both of which I've _done_ at various points, and it keeps changing.)
>
> The development cycle of udev has nothing to do with sysfs here.

I'm trying to figure out how to decouple them, yes. :)

> Other 
> than the fact that we learned how to interact with a kernel interface
> that directly exposes the internals of the kernel itself, something that
> no one had done before.  In learning how to handle such major changes,
> udev has changed in order to support zillions of devices, small memory
> footprints, and lightening fast speed, all changes that required big
> udev internal changes, but had _nothing_ to do with the kernel and/or
> sysfs.

Arriving at simple can take a lot of work.  You don't have to tell me that. :)

> > Are you saying that the current version of udev will work with all future
> > kernels, and thus if I can figure out what udev is doing today, I can
> > just document that as the stable API?
>
> If you want to figure out how to create a dynamic /dev filesystem that
> can handle persistance device names, dynamic rules created by users,
> zillions of devices on small and big systems, small footprint, and very
> quick speed, then yes, read the udev source code.

I did all that but the persistent device names in mdev, without ever referring 
to udev (after bad experiences with it in 2005), although I no longer 
maintain any part of busybox.

> What is the goal of this document here?  You start out trying to explain
> the hotplug interface, and then get side tracked into talking about
> creating a dynamic /dev/ filesystem in userspace and then ramble on into
> how sysfs is layed out.  These are three separate things

Various people asked me for documentation on hotplug and firmware loading, and 
what I know how to do with hotplug (because I had to work out how in 2005, 
and I'd like to nail down the approved way of doing it) is create /dev nodes.

> While the act of creating such a /dev filesystem does have something to
> do with the hotplug/uevent interface of the kernel, it isn't reliant on
> it.  And the layout of sysfs also doesn't really have much affect on the
> creation of such a /dev filesystem, as udev proves (it works just fine
> without sysfs even being mounted.)

Via netlink events?  I vaguely recall a thread about deferring all the "add" 
events until after a netlink daemon was up, but I thought you needed sysfs 
for that.

> If you want to just document the hotplug/uevent interface then do
> that.
>
> If you want to document sysfs and it's structure, do that too, after
> reading the existing documentation and understanding that.

I've read the existing documentation that I've seen.  Unfortunately I'm too 
jetlagged at the moment to finish collating it, and I need to go look at this 
cleaned-up no-longer-scary udev when I'm awake.

> thanks,
>
> greg k-h

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
