Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbYAGKCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbYAGKCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbYAGKC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:02:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42472 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbYAGKCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:02:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com,
       linux-fsdevel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC] netns / sysfs interaction
References: <20080107072301.GW27894@ZenIV.linux.org.uk>
Date: Mon, 07 Jan 2008 03:01:47 -0700
In-Reply-To: <20080107072301.GW27894@ZenIV.linux.org.uk> (Al Viro's message of
	"Mon, 7 Jan 2008 07:23:01 +0000")
Message-ID: <m1y7b2j6no.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> 	As much as I hate to touch either subject, let alone both at
> once...  Eric, would you mind explaining what exactly do you want
> sysfs to do in presense of your "namespaces"?  On the "what does user
> see if we do <...>" level.

Right.  I need to repost the patches since Greg didn't get them applied
last time.

What appears to be a clean solution is to have multiple sysfs superblocks
and to capture the namespace at mount time.  For planning purposes there
is a device namespace on the drawing board as well, so you can keep
your same major minor numbers for devices (tty names, network attached
disk) in a migration event.   This means netns isn't the only
namespace we will have to worry about with sysfs before it is all
done.

> 	a) what happens if I do chdir("/sys/class/net/eth42/") and then
> migrate?

It shouldn't be any better or worse then any other filesystem.  The
prerequisite for a OS level migration is that the set of all
namespaces and all of the processes that use them all go together.

As we recreate the virtual filesystem and virtual devices we should
recreate a sysfs that is essentially the same.  I doubt we will go
to the trouble of keeping the unnamed device number we are mounted on
and the inode numbers the same, but otherwise we should be able to
recreate an identical looking sysfs (baring real hardware changes).

> 	b) what happens to /sys/class/net/eth0/device visibility/things
> it points to/etc.?

That should continue to work without any changes at all.  We only play
with /sys/class/net (and it's cousin directories that only exist
when we don't enable sysfs backwards compatibility).  The symlink
might change but that is about it.

> 	c) what happens to open files?  E.g. to /sys/class/net - say it,
> if migration happens between two getdents(2).

How do we restore the internal state?  Hmm.    The rule is that you
are only guaranteed to see directory entries that existed
both before you started to read the directory and after you finished.

The cheap solution is just to declared everything hotplugged and
deleted and recreated.  Removing any meaningful guarantee of seeing
anything.

Since we only depend upon the value of f_pos that should largely work.

If we ever figure out how to preserve inode numbers over a migration
event the current scheme will work unmodified but that sounds like
more pain then it is worth.

> 	d) what happens to visibility in other parts of sysfs?  E.g. to
> things like
> $ ls  /sys/devices/pci0000\:00/0000\:00\:0a.0/
> bus     device  local_cpus  power      resource1         uevent
> class   driver  modalias    resource   subsystem_device  vendor
> config  irq     net:eth0    resource0  subsystem_vendor

It all shows up.  Nothing is hidden except for the directories 
and possibly the symlinks to the directories for network devices.

We aren't trying to virtualize the hardware.

> $
> See that net:eth0 in there?  Are all such suckers seen?

Yep.  Grr.  net:eth0  from another namespace should either
be a broken symlink or disappear completely.  It has been ages
since I looked at what my patches do in that case, it should be
just a broken symlink.

This is a big of a challenge to explain because the relevant directory
structure changes in sysfs when CONFIG_SYSFS_DEPRECATED=n.  Then
instead of net:eth0 we have net/eth0 and the all of the device
specific files there.

> 	e) while we are at it, wouldn't seeing the information in
> /sys/devices/pci in general defeat whatever purpose you have in mind
> for your stuff?

No.

First when you migrate or whatever you can report all of the hardware
in the machine was hot unplugged and a new set of essentially
identical hardware was hotplugged.  For stuff that goes through
an OS abstraction like a fs they don't care.  For stuff that talks
to the hardware directly you don't have a choice you have to make
user space deal with it.  However the set of applications that
care is actually quite rare.

Secondly the goal is not to hide the fact you are running in a set
namespace that don't cover the entire machine, but to make it so
that you don't care.  Which is close but not quite the same thing.

Third when the goal is isolation and not migration (a better chroot)
then our hardware never changes.

> Context: we need sane locking for sysfs.  I think I have a more or less
> workable scheme, but its feasibility depends big way on what netns needs
> to have.

I think on the netns side Tejun and I have hashed it over enough
that the semantics if not the implementation comes out cleanly.

The idea is supporting multiple superblocks for sysfs:

  Ultimately capturing the relevant namespace at mount time
  and if we don't have a superblock for that namespace creating
  a new one.

  So we have one sysfs dirent tree and multiple dentry trees.

  The tricky parts are rename/move and blocking mount/unmount requests
  for sysfs until we complete the rename operation calling d_move
  everywhere.

Essentially the dentry and sysfs dirent separation was the big part I
needed.



If all I had to deal with was /sys/class/net I think I would have
split that off into it's own filesystem.  However with the latest
sysfs layout we are far beyond that and there are symlinks going
all over tying all of the pieces together.


Eric

