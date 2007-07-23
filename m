Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXGWVuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXGWVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758738AbXGWVt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:49:58 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34229
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758314AbXGWVt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:49:57 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: 7eggert@gmx.de
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Mon, 23 Jul 2007 17:49:50 -0400
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel@vger.kernel.org, Michael-Luke Jones <mlj28@cam.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>, Rod Whitby <rod@whitby.id.au>,
       Russell King <rmk@arm.linux.org.uk>, david@lang.hm
References: <8I2t1-7jt-5@gated-at.bofh.it> <8Jbuh-84N-3@gated-at.bofh.it> <E1ICDr7-0000e9-P4@be1.lrz>
In-Reply-To: <E1ICDr7-0000e9-P4@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707231749.50405.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 8:14:41 am Bodo Eggert wrote:
> Greg KH <greg@kroah.com> wrote:
> > On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:
> >> I'm not trying to document /sys/devices.  I'm trying to document
> >> hotplug, populating /dev, and things like firmware loading that fall out
> >> of that. This requires use of sysfs, and I'm only trying to document as
> >> much of sysfs as you need to do that.
> >
> > Like I stated before, you do not need to even have sysfs mounted to have
> > a dynamic /dev.
> >
> > And why do you need to document populating /dev dynamically?  udev
> > already solves this problem for you, it's not like people are going off
> > and reinventing udev for their own enjoyment would not at least look at
> > how it solves this problem first.
>
> Turning your words around, you get: "Whatever one of these programs does
> documents how dynamic devices should be handled." If this is true, any
> change that makes one of these programs break is a kernel bug.
>
> Besides that: How am I supposed to be able to correctly change udev if
> there is no document telling me what would work and what happens to
> work by accident?

You aren't expected to.  Remember that udev and sysfs are written by the same 
people, working together off-list.  They're free to break the exported data 
format on a whim, because they write the code at both ends and fundamentally 
they're talking to themselves.  They honestly say you can't expect a new 
kernel to work with an old udev, and they say it with a straight face.  (To 
me, this sounds like saying you can't expect a new kernel to work with an old 
version of ps, because of /proc.)

Documentation is a threat to this way of working, because it would impose 
restrictions on them.  A spec is only of use if you introduce the radical 
idea that the information exported by sysfs exists for some purpose _other_ 
than simply to provide udev with information (and a specific version of udev 
matched to that kernel version, at that).

> > To do otherwise would be foolish :)
>
> Some people like to fool around and create even smaller wheels.
> E.g. I'm changing the ACPI button driver to just call Ctrl_alt_del
> in order not to have an extra process running and free 0.2 % of my RAM.

When I started looking at udev in 2005, it was a disaster.  My commentary at 
the time is at http://lkml.org/lkml/2005/10/30/189 and the relevant bit is:

> It turns out udev is smaller than it seems because it block copies
> code out of klibc and libsysfs (yes, having a standard interface library to
> sysfs is _such_ a good idea we should fork our own copy and bundle it. 
> After all, that's what shared libaries are for...)  And once you chop out
> all that, 90% of what's left is _still_ optional (try "grep ' main(' *.c'"
> and notice we have 12 separate occurrences of main().  For something that
> needs at most two (bootup and hotplug) and the bootup version can be a
> command line option. You don't need udevinfo, udevmonitor, udevsend, or
> udevtest.)  Add in the fact that udev/udevd use a gratuitous database that
> can be ditched, and then contemplate simplifying the config file (cut down
> the parser, and embedded users should NOT need a rules compiler; dunno
> whether it's worth it to keep the same config file syntax or come up with
> something tiny and dumb for embedded use)...

And so I made mdev, a utility which populated /dev _with_ a config file in 7k.  
Greg's upset I didn't just patch udev to remove libsysfs, remove the 
duplicated klibc code, remove the gratuitous database, remove the 
overcomplicated config file parser (with rules compiler), and so on.  They're 
boggling that I could ever have been unhappy with the One True Project to 
populate /dev.

> > Firmware loading is fine to document if you wish to do so.  But again,
> > why?  We already have multiple userspace programs that provide this
> > feature for them.  Perhaps you want to document how to add firmware to a
> > system in order for these different programs to pick them up?
>
> I once tried to install a firmware for hotplug. Even finding the place whre
> I'm supposed to put it was harder than rewriting that *beep* from start,
> but I could not rewrite it because I didn't have any documentation.
> Even digging in that pile of wrapper scrips in order to debug that thing
> was a nightmare. (Having a number of places where the firmware will be
> expected in one of many versions and formats stored using one of many
> filenames can drive you nuts.)

One of my todo list items is to see if loading firmware out of initramfs for 
statically linked devices, before /init gets spawned, can be made to work.  
Documenting how it works under normal circumstances is step 1.

Then again I'm wierd and think that documentation is a good thing in 
itself.  "You want to document this?  Why would you do a crazy thing like 
that?"  Because I'm that kind of crazy?  Because people have _ASKED_ me for 
this documentation off-list?  (Some of the people cc'd on this thread, in 
fact, although I didn't track down all of the requestors, just a few for 
review purposes...)

> > Or perhaps you want to document how to add this kind of functionality to
> > your kernel driver so that it can handle firmware loading by using the
> > firmware interface that the kernel provides?
>
> I suppose that's missing, too. Or scattered in a number of contradicting
> and mostly outdated howtos across the internet.

As I said, I really don't think they wanted it documented.  Look at the hugely 
defensive reaction they've had to my recent attempt.  Kay Sievers is _still_ 
spam blocking my email:

>                    The mail system
> <kay.sievers@vrfy.org>: host mx01.kundenserver.de[212.227.15.150] refused
> to talk to me: 421 mails from 71.162.243.5 refused: local dynamic IP
> address 71.162.243.5

Which it isn't, it's a FIOS that's had the same static IP since last year, and 
I told him about this at OLS, and I've had Greg forward email to him since 
then, but that cut and paste was from a bounce message that came in 
yesterday.  But that's a side issue.

The email Kay sent me from OLS (where I spoke to him in person for most of an 
hour) tells me to use /sys/bus/*/devices/*/dev but the documentation Greg 
posted a week ago explicitly says that any path following the "devices" 
symlink is a bug in the application.  (A document which of course, I wasn't 
CC'd on but was chastized for not having seen at the start of this thread, 
documentation which like the earlier version I _did_ comment on consists 
primarily of warnings "DO NOT DO $XXX".  And you wonder why I start to 
suspect they don't want third parties to use sysfs?)

I asked for clarification about this (how should I find devices under /sys/bus 
without following the devices symlink), but Greg said he won't reply to this 
thread anymore because his feelings were hurt.  Kay Sievers telling me I'm 
wasting his time and too stupid to understand what he tells me isn't expected 
to hurt my feelings, though:

> I invested a lot of time explaining stuff to you in email and
> personally, but really, that seems just like a total waste of time. I
> will not reply to any of your mails until you have proven to have read
> the udevtrigger code, and got a clue how to do stuff reliably, and get
> the basic knowledge needed to document it.

So him telling me to follow the "devices" symlink and Greg telling me never to 
do that are, collectively, my fault.  And he won't tell me anymore because 
I'm not worthy.  Add in Greg Kroah-Hartman saying he won't respond to this 
thread anymore and it's a bit...  frustrating, really.

I have Cornelia Huck presumably trying to help, saying things like the 
following exchange: http://lkml.org/lkml/2007/7/19/52
> > > >   SUBSYSTEM
> > > >     If this is "block", it's a block device.  Anything else is a char
> > > > device.
> > >
> > > No. For devices, SUBSYSTEM may be the class (like 'scsi_device') or the
> > > bus (like 'pci').
> >
> > Do you make a /dev node for either one?
> >
> > I'm trying to, at minimum, document what you pass to mknod.  I consider
> > it important to know.
>
> The problem is that your information is wrong. Imagine someone reading
> this document, thinking "cool, I'll create a char node if
> SUBSYSTEM!=block" and subsequently getting completely confused about
> all those SUBSYSTEM==pci events.

Except, it turns out, my information on that point _wasn't_ wrong, but even 
she (an existing sysfs developer) didn't know it and had to be corrected by 
Greg:
http://lkml.org/lkml/2007/7/20/66

I'm not blaming Cornelia, I'm thankful she's trying to help.  I'm just 
pointing out that this stuff is hard to document, because even developers who 
think they know it don't.  The fact that sysfs can give me a major and minor 
number without telling me whether it's "char" or "block" (without which major 
and minor are useless) strikes me as a design flaw, to be honest.  This 
ENTIRE THREAD boils down to me trying to figure out A) how do I find (iterate 
through) all the char devices in sysfs, B) how do I find all the block 
devices in sysfs, C) when I get a hotplug event that gives me major and 
minor, how do I tell if it's char or block.  (I now have an answer to C from 
Greg, although he gave it to Cordelia, not me, possibly because she wasn't 
trying to write documentation.)

When I ask questions of the sysfs developers they seldom bother to _correct_ 
me, they just tell me I'm wrong and make fun of me for not knowing it, and if 
I'm lucky they tell me to go read udev or the kernel sources.

Except the problem I have is that I _looked_ at the kernel many times over the 
years (and older versions of udev), and worked out how to do this circa 
2.6.12 and they changed it (by turning the flat /sys/block into a nested 
thing where partitions are subdirectories under the block device's 
subdirectory).  Then I had it working again circa 2.6.14 and they changed it 
again around 2.6.20 (turning subdirectories to symlinks so my strategy for 
avoiding the endless loops broke).  Then they changed it again by 
adding "/sys/class/block" so there are now block devices in a directory that 
formerly contained only char devices.

Plus they added char devices to /sys/bus that aren't referred to 
from /sys/class, so looking under /sys/class doesn't find all char devices 
anymore.  (They _say_ they did, anyway.  I still haven't actually seen a 
system that has one, but I'm taking them at their word here.)  I _still_ only 
know how to find the /sys/bus devices by following the path Kay told me, 
which Greg told me not to use, and resolution on that can't come in this 
thread because both Kay and Greg have told me they won't reply anymore.  (And 
I can't email kay off-list, because he's still spam-blocking me.)

Looking at the code doesn't tell me their intent.  It doesn't get a statement 
from them "this is how programs are expected to use information exported by 
the kernel, this subset of sysfs is a stable API, and it will continue to 
work with future kernels".  I've merely worked out a method that works, but 
they can always change it and blame me for not having done it the way they 
were thinking.  (Even when, like adding /sys/bus or /sys/class/block, the way 
they were thinking didn't exist yet.)

> > If you just want to document the hotplug/uevent api, then do just that.
> > However I think you are overreaching with your scope here and getting
> > mighty confused in the process.
>
> In other words: Grasping sysfs is not a feasible task? If this is true,
> how can anybody reliably use sysfs?

If it was possible to reliably use sysfs (without having written it), would 
you ever be _required_ to upgrade udev, except for security reasons or to 
gain new features?

As far as I can tell, "why do you need to document this" translates to "I do 
not want you to document this".  They consider sysfs, like the kernel 
internal APIs, something that's expected to change incompatibly from release 
to release.

Despite that, I'll post an updated version of the document that started this 
thread when I get back to Pittsburgh.  (I'm funny that way.)  I'm just 
working on other less-frustrating things for a while first.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
