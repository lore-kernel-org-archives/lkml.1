Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXJEGT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXJEGT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 02:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJEGTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 02:19:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58647 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJEGTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 02:19:47 -0400
Date: Thu, 4 Oct 2007 23:18:12 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver
	model
Message-ID: <20071005061812.GA16914@kroah.com>
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FB956B.8000205@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 04:35:07AM -0700, Tejun Heo wrote:
> Hello, Greg.
> 
> Sorry about the late reply.  I'm sandwiched between several release
> dates (I bet you know) and sudden burst of family/personal events (all
> kinds of them - good, annual and bad).

Same here, I'm swamped with stuff, and now am on vacation for a few
days...

> I suppose I failed to sell new sysfs_dirent based interface idea
> face-to-face.  I'll try it one more time on-line.  I tend to do these
> things better on-line, especially in English.  So, please spare some
> more time on the subject.
> 
> IMHO, removal of kobject from sysfs interface is a logical and necessary
> step toward easier driver model, not an unnecessary because-we-can
> modification.  I need to go back to what a "kobject" is to explain this.
> 
> 1. What is a kobject?
> 
> If I understood it correctly, kobject was separated out from device
> driver model to allow entities outside of driver model to use sysfs, so
> it's a part of device driver object which is necessary to interact with
> sysfs.

Yes, it was done so that we could have /sys/block for block devices.  Al
Viro did that work.

> Originally, driver model objects and their sysfs representation was
> tightly coupled.  This is what made kobject a "kobject" not
> "sysfs_something".  Driver model and sysfs shared the same object to
> represent kernel and sysfs-side.  kobject was a base class of all driver
> model objects, interaction with sysfs was through this base object and
> implementation of sysfs also depended on kobject.
> 
> The functionality served by kobject can be broken down into the
> following two.
> 
> F-a. To serve as an entity both subsystems can share lifespan
> management.  ie. both subsystems reference count on kobject.
> 
> F-b. To serve as an entity both subsystems can base their internal
> representation on.  (base object in OO term).

Yes, those are two functions, I can agree with.

> 2. Implementation of immediate detach of sysfs nodes
> 
> Unfortunately, this tight coupling caused several problems.  One of the
> most annoying problems was that userland was allowed to interfere
> directly with lifespan management of kernel objects which formed basis
> of driver model, causing quite some number of problems directly and
> indirectly and unfortunately the problem couldn't be contained inside
> driver model.  Mid or low level driver implementation was affected too.
> 
> As a response, immediate detach of sysfs nodes was implemented.  When a
> sysfs node is removed, it immediately disconnects from the associated
> kobject.  This way, the burden of lifespan management (at least sysfs
> related part of it) is contained inside sysfs proper where we can afford
> more effort, testing and thus complexity.  On an unrelated note, I think
> this is the beginning step toward a bigger change, that is, shielding
> drivers from the complexity of object lifespan management.

I agree.  Your work in this area has been great and helped out a lot.

> Anyways, so, now that immediate disconnect is in place, sysfs is no
> longer involved in lifespan management of driver model objects.  It
> attaches and detaches when it's told to do so.  Naturally, most of
> internal implementation changed to use independent objects
> (sysfs_dirent) instead of kobject in the process.
> 
> 3. Where does that leave kobject?
> 
> If you combine #1 and #2, both functionalities become questionable.
> 
> F-a. sysfs no longer plays role in lifespan management of driver model
> object.  This functionality is exactly what's killed by #2.

Yes, but a kobject is still needed internally for the lifespan
management.

> F-b. In the process of #2, the internal representation naturally moved
> over to sysfs_dirent.  The interface remained the same but after
> dereferencing kobject->sd, kobject itself is mostly irrelevant to sysfs
> and where kobj is still used, the code is either difficult to read or
> outright buggy.  This is expected.  Lifespans of sysfs and driver model
> objects are managed completely independently.  Dereferencing objects on
> the other domain is inherently cumbersome.
> 
> With both F-a and F-b nullified, left purposes kobject still serve are
> the followings.
> 
> L-a. Serve as opaque token in sysfs interface but with all the reasons
> to do so removed, this is at best cumbersome.  It's an opaque token but
> with a lot of unnecessary baggages.  This role can be _much_ better
> served by sysfs_dirent.

Possibly, I'm still not sold on this.

> L-b. Serve as something a subsystem can use to count references which
> also can be used to access sysfs if wanted.  To me, this feels like a a
> flash light which can also be used to spread butter.

Heh, that's a good analogy :)

> IMHO, both L-a and L-b contribute only to obfuscation of the driver
> model and sysfs.

No.  I think you are missing a number of things that kobjects provide
and allow:
	- a structurual heirachy of devices.  Combine kobjects with
	  ksets and ktypes, and you have a very powerful system to
	  categorize objects and their representation to each other.
	- a consistant and easy interface to userspace through
	  uevents/hotplug of the creation and removal of these objects.
	  This keeps the different parts of the kernel that need this
	  interface from having to create it every time on their own.
	- a way to easily create and export attributes in sysfs
	  automatically.
	- a way to provide working reference counting for a variety of
	  different objects.

All of those are still needed for the kernel.

> 4. So?
> 
> From #3, as kobject no longer serves any valid purpose to sysfs, it's
> natural conclusion to try to remove kobject from sysfs, which of course
> brings up the question of conversion cost.

I don't mind the removal of kobjects from sysfs in order to make sysfs
and kobjects work better/simpler.  However the majority of the patches
you created to do this end up with more code overall, and are of no
benifit to the current users of sysfs and kobjects in the kernel.

> 95+% of sysfs users use it through driver model which wraps sysfs
> interface and exports it as a part of driver model.  For these,
> conversion only needs to happen inside the driver model, so we
> definitely can do that.

But what would that benifit the driver model?

> The rest isn't great in number and, much more importantly, many of those
> suffer from the current interface which is painful to use independently.
>  For example, kernel/module.c does all the kobject dances including
> defining a subsystem just to ignore everything else and use it as an
> opaque token to sysfs (kset_find_obj doesn't count, a generic map or
> sysfs with sysfs_dirent interface can do that just as well).

I will not deny that the current use of kobjects/ksets/ktypes (subsystem
is now gone) is difficult and extreemly painful.  I am currently working
to fix this issue.  But don't think that the reason this is hard to use
means that it should be abolished alltogether.

Rather, it means that this interface to using kobjects needs to be fixed
and made easier, not circumvented.

> 5. Wouldn't that allow manifestation of random hierarchy all over sysfs?
> 
> I really don't know whether it will or not but I don't agree interface
> obfuscation is the right way to prevent that.  IMHO, if we need better
> policing under /sys than regular review process can provide, we should
> force it by clearly defined policies and documentation not by
> obfuscation, which, BTW, can't really prevent anything.

No, I think that we have been lucky so far that it is so hard to get
sysfs representation working properly for "raw" kobjects.  It has made
people really think why they want to add things there, and usually just
give up and go and put things into the proper place in the /sys/devices/
tree.

Also, not everything that people keep wanting to put in /sys should go
there.  The perfict example of that is the recent BDI stuff.  It belongs
in the driver tree, not in a new /sys/bdi/ location.  If sysfs were
"easier" to use, then it would be abused this way.

The end goal for sysfs is to present a heirachy of devices that are in
the kernel today.  It is not a replacement for everything that people
feel they need to export to userspace in whatever form they want to.
There are rules that need to be followed in the exportation of data, as
userspace programs expect this.  The current kobject interface tries
very hard to enforce those rules, and it needs to stay combined with
sysfs that way.

> For example...
> 
> * I don't worry too much about hierarchy under /sys/devices.  Most use
> and will continue to use interface provided by the driver model which
> forces the current structure.  If this is not enough, we can, for
> example, disallow a sysfs node representing a device from having subdirs
> deeper than one level or any subdirs which can generate uevent.

No, I don't think that is necessary as the driver model kind of enforces
that already today.

> * For the other currently existing top directories, I think they're
> already too specific for anyone to add random hierarchy under.  If
> random top level directory is worried, we can add a central list of
> allowed top directories in fs/sysfs/mount.c so that no one can sneak behind.

That might be a good idea to implement today :)

> These are just examples but both can be implemented and documented
> easily and IMHO will usually result in better end result.
> 
> So, no, I don't agree to keeping kobject based interface to keep sysfs
> hierarchy tidy.

I strongly object here.

I think that if your current patches are accepted, we will see a lot of
new users of sysfs in ways that are not "standard" to how it is used
today.  Things that rely on "close" happening to the sysfs file, or
trees created that do not emit uevents.

A good example for why we need to keep things the same way today is the
SLUB code.  It exports data through sysfs and automatically started
exporting things through uevents.  People realized this and can now
easily write tools that watch for those events to show things happening
in the slab allocator.

> 6. Conclusion
> 
> I think I said enough about why kobject based interface isn't such a
> good idea anymore.  I'll try to cover why it's a good idea to move over
> to new sysfs_dirent based interface.
> 
> * It's a clean up and a big one at that.  It makes sysfs code and
> interface much more straight-forward and its users will benefit too when
> they are converted over to new interface.

I don't object to a clean up.  What I object to is the use by other code
of sysfs by not using kobjects.  I feel that if you really want to do
that, then go write a new filesystem for that kind of thing.  We have
already done this with debugfs and securityfs.  I really want to enforce
the kobject interface to the users of sysfs.

Now if we can keep that enforcement of sysfs, then I have no objections
to cleaning up the internal interface between sysfs and kobjects, and
the overall fixing of the kobject/kset/ktype code.  That is all good
things overall.

> * It removes unnecessary API-visible use of kobject.  I think driver
> model should head toward moving object lifespan management and other
> complexities to higher level - ie. driver model, block layer, etc - and
> export simple interface to drivers.  kobject is too much of
> implementation detail to export to drivers.  Removing kobject from sysfs
> interface is a step toward that direction.

The driver model never shows kobjects to users.  Ok, in places it does
sneak through, but I'll be glad to take patches to fix that up wherever
needed.

> * sysfs_dirent interface is native to what sysfs does and thus can be
> much more flexible.  This will help improving the driver model and
> adding new features.

I'm all for helping the driver model and adding new features to it.
Just don't take away the enforcement of kobjects and sysfs at the same
time please.

thanks,

greg k-h
