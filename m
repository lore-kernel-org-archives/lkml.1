Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbXI0SSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbXI0SSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbXI0SSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:18:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:25740 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168AbXI0SSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pQwBwRmz0K8sWbSNxkWS5mk1ahlu0iWILkFrEIgTxIalgZzEPS1YaCbYtPy5fqXgMTGZDqLLqJiwhjrYjTJ/hB3ucHSzbB5I4lCilVR6fEPs6mrmS9gODC5IN0uzBvj+vjTdb5EkcQSEbi8YG3BkDNIQwCIVqd1drynDaiUtydw=
Message-ID: <46FB956B.8000205@gmail.com>
Date: Thu, 27 Sep 2007 04:35:07 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver	model
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com>
In-Reply-To: <20070925221736.GA3566@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Sorry about the late reply.  I'm sandwiched between several release
dates (I bet you know) and sudden burst of family/personal events (all
kinds of them - good, annual and bad).

Greg KH wrote:
>> * sysfs becomes a separate module and driver model becomes a user of
>>   sysfs.  Those two are not entangled anymore.  Things are easier to
>>   understand and test this way.
> 
> This is good, I like this.

Great. :-)

>> * Non-driver model users of sysfs (modules, blkdev, etc...) don't have
>>   to jump through hoops to use sysfs.  kobj based interface requires
>>   attribute wrapping and is awkward to use directly.  Also, the user
>>   is required to create a dummy kobj which doesn't serve much purpose
>>   than being a token for sysfs reference.  New sysfs-dirent based
>>   interface is straight forward proc-fs like interface and should be
>>   easier and more intuitive for those users.
> 
> This is not good, I don't like this :(
> 
> As we spoke a few weeks ago, the non-driver model users of sysfs are ok.
> Yes, it's not trivial to use sysfs in this manner, and it should be made
> easier, but we still need to keep our tree of objects.  Using a kobject
> for sysfs access is a good thing as it provides a tiny grasp on keeping
> the usage of sysfs under control.
> 
> So while I like the separation of sysfs and kobjects from an
> architectural and conceptual level for testing and understanding, I do
> not want to allow the use of sysfs without creating a backing kobject
> like we do today.
> 
> I'm all for making the "raw" kobject access easier, cleaning up the
> attribute "mess" that you need to go through.  The cleanups that Kay and
> I have been doing in the kset and subsystem area are steps in that
> direction and I have more I want to do there to help make it easier to
> use and understand.

I suppose I failed to sell new sysfs_dirent based interface idea
face-to-face.  I'll try it one more time on-line.  I tend to do these
things better on-line, especially in English.  So, please spare some
more time on the subject.

IMHO, removal of kobject from sysfs interface is a logical and necessary
step toward easier driver model, not an unnecessary because-we-can
modification.  I need to go back to what a "kobject" is to explain this.

1. What is a kobject?

If I understood it correctly, kobject was separated out from device
driver model to allow entities outside of driver model to use sysfs, so
it's a part of device driver object which is necessary to interact with
sysfs.

Originally, driver model objects and their sysfs representation was
tightly coupled.  This is what made kobject a "kobject" not
"sysfs_something".  Driver model and sysfs shared the same object to
represent kernel and sysfs-side.  kobject was a base class of all driver
model objects, interaction with sysfs was through this base object and
implementation of sysfs also depended on kobject.

The functionality served by kobject can be broken down into the
following two.

F-a. To serve as an entity both subsystems can share lifespan
management.  ie. both subsystems reference count on kobject.

F-b. To serve as an entity both subsystems can base their internal
representation on.  (base object in OO term).

2. Implementation of immediate detach of sysfs nodes

Unfortunately, this tight coupling caused several problems.  One of the
most annoying problems was that userland was allowed to interfere
directly with lifespan management of kernel objects which formed basis
of driver model, causing quite some number of problems directly and
indirectly and unfortunately the problem couldn't be contained inside
driver model.  Mid or low level driver implementation was affected too.

As a response, immediate detach of sysfs nodes was implemented.  When a
sysfs node is removed, it immediately disconnects from the associated
kobject.  This way, the burden of lifespan management (at least sysfs
related part of it) is contained inside sysfs proper where we can afford
more effort, testing and thus complexity.  On an unrelated note, I think
this is the beginning step toward a bigger change, that is, shielding
drivers from the complexity of object lifespan management.

Anyways, so, now that immediate disconnect is in place, sysfs is no
longer involved in lifespan management of driver model objects.  It
attaches and detaches when it's told to do so.  Naturally, most of
internal implementation changed to use independent objects
(sysfs_dirent) instead of kobject in the process.

3. Where does that leave kobject?

If you combine #1 and #2, both functionalities become questionable.

F-a. sysfs no longer plays role in lifespan management of driver model
object.  This functionality is exactly what's killed by #2.

F-b. In the process of #2, the internal representation naturally moved
over to sysfs_dirent.  The interface remained the same but after
dereferencing kobject->sd, kobject itself is mostly irrelevant to sysfs
and where kobj is still used, the code is either difficult to read or
outright buggy.  This is expected.  Lifespans of sysfs and driver model
objects are managed completely independently.  Dereferencing objects on
the other domain is inherently cumbersome.

With both F-a and F-b nullified, left purposes kobject still serve are
the followings.

L-a. Serve as opaque token in sysfs interface but with all the reasons
to do so removed, this is at best cumbersome.  It's an opaque token but
with a lot of unnecessary baggages.  This role can be _much_ better
served by sysfs_dirent.

L-b. Serve as something a subsystem can use to count references which
also can be used to access sysfs if wanted.  To me, this feels like a a
flash light which can also be used to spread butter.

IMHO, both L-a and L-b contribute only to obfuscation of the driver
model and sysfs.

4. So?

>From #3, as kobject no longer serves any valid purpose to sysfs, it's
natural conclusion to try to remove kobject from sysfs, which of course
brings up the question of conversion cost.

95+% of sysfs users use it through driver model which wraps sysfs
interface and exports it as a part of driver model.  For these,
conversion only needs to happen inside the driver model, so we
definitely can do that.

The rest isn't great in number and, much more importantly, many of those
suffer from the current interface which is painful to use independently.
 For example, kernel/module.c does all the kobject dances including
defining a subsystem just to ignore everything else and use it as an
opaque token to sysfs (kset_find_obj doesn't count, a generic map or
sysfs with sysfs_dirent interface can do that just as well).

In addition, as done in the current patchset series, the kobject
interface can be maintained while the conversion is in progress, so IMHO
converting to sysfs_dirent interface is the right thing to do (tm).

And, as we need to design new interface anyway, this is a good
opportunity to improve sysfs API so that it can be used more easily.
The requirement for sysfs is different from other filesystems, it's
userland visible presentation of kernel objects (most of them being
driver model objects) and has different requirements.  For example, a
symlink is completely dependent on the target it points to, so that's
where all the new functionalities came from.  I'll try to explain each
of them in respective replies.

5. Wouldn't that allow manifestation of random hierarchy all over sysfs?

I really don't know whether it will or not but I don't agree interface
obfuscation is the right way to prevent that.  IMHO, if we need better
policing under /sys than regular review process can provide, we should
force it by clearly defined policies and documentation not by
obfuscation, which, BTW, can't really prevent anything.

For example...

* I don't worry too much about hierarchy under /sys/devices.  Most use
and will continue to use interface provided by the driver model which
forces the current structure.  If this is not enough, we can, for
example, disallow a sysfs node representing a device from having subdirs
deeper than one level or any subdirs which can generate uevent.

* For the other currently existing top directories, I think they're
already too specific for anyone to add random hierarchy under.  If
random top level directory is worried, we can add a central list of
allowed top directories in fs/sysfs/mount.c so that no one can sneak behind.

These are just examples but both can be implemented and documented
easily and IMHO will usually result in better end result.

So, no, I don't agree to keeping kobject based interface to keep sysfs
hierarchy tidy.

6. Conclusion

I think I said enough about why kobject based interface isn't such a
good idea anymore.  I'll try to cover why it's a good idea to move over
to new sysfs_dirent based interface.

* It's a clean up and a big one at that.  It makes sysfs code and
interface much more straight-forward and its users will benefit too when
they are converted over to new interface.

* It removes unnecessary API-visible use of kobject.  I think driver
model should head toward moving object lifespan management and other
complexities to higher level - ie. driver model, block layer, etc - and
export simple interface to drivers.  kobject is too much of
implementation detail to export to drivers.  Removing kobject from sysfs
interface is a step toward that direction.

* sysfs_dirent interface is native to what sysfs does and thus can be
much more flexible.  This will help improving the driver model and
adding new features.

> So, I'll try to pick and choose from this patchset what I feel is ok for
> now.
> 
> Or does it depend on the second set of patches that are yet to be
> applied due to disagreements about module lifetimes?

The whole series is centered around ideas illustrated above.  I think it
would be better to establish consensus before starting to merge patches
(the first patchset was misc cleanup, so that's okay).  We might end up
heading different direction.

Hmmm... That was a rather long write-up.  If you're still reading, I
appreciate your time and hope I didn't waste it for nothing.  :-)

Thanks a lot.

-- 
tejun

