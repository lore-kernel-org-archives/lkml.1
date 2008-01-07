Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYAGKYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYAGKYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYAGKYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:24:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34001 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYAGKYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:24:19 -0500
Date: Mon, 7 Jan 2008 10:24:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com,
       linux-fsdevel@vger.kernel.org, gregkh@suse.de
Subject: Re: [RFC] netns / sysfs interaction
Message-ID: <20080107102417.GY27894@ZenIV.linux.org.uk>
References: <20080107072301.GW27894@ZenIV.linux.org.uk> <m1y7b2j6no.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y7b2j6no.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 03:01:47AM -0700, Eric W. Biederman wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:

> What appears to be a clean solution is to have multiple sysfs superblocks
> and to capture the namespace at mount time.

It is not a clean solution at all.  In particular, it leaves you with hell
of a coherency issues between these trees.

>  For planning purposes there
> is a device namespace on the drawing board as well, so you can keep
> your same major minor numbers for devices (tty names, network attached
> disk) in a migration event.

Yes, I'm quite sure there's more coming.  Which is why I'm asking now,
before we are even deeper into that... area

>   This means netns isn't the only
> namespace we will have to worry about with sysfs before it is all
> done.

Exciting.
 
> > 	a) what happens if I do chdir("/sys/class/net/eth42/") and then
> > migrate?
> 
> It shouldn't be any better or worse then any other filesystem.  The
> prerequisite for a OS level migration is that the set of all
> namespaces and all of the processes that use them all go together.
> As we recreate the virtual filesystem and virtual devices we should
> recreate a sysfs that is essentially the same.  I doubt we will go
> to the trouble of keeping the unnamed device number we are mounted on
> and the inode numbers the same, but otherwise we should be able to
> recreate an identical looking sysfs (baring real hardware changes).

Have you even bothered to read the pathname in question?  Please, do so.

> > 	c) what happens to open files?  E.g. to /sys/class/net - say it,
> > if migration happens between two getdents(2).
> 
> How do we restore the internal state?  Hmm.    The rule is that you
> are only guaranteed to see directory entries that existed
> both before you started to read the directory and after you finished.
> 
> The cheap solution is just to declared everything hotplugged and
> deleted and recreated.  Removing any meaningful guarantee of seeing
> anything.
> 
> Since we only depend upon the value of f_pos that should largely work.
> 
> If we ever figure out how to preserve inode numbers over a migration
> event the current scheme will work unmodified but that sounds like
> more pain then it is worth.
> 

Inode numbers?  Are you suggesting a wholesale replacement of all struct
file referenced by descriptor tables, all way down to inodes?  May I see
the patches for that, please?

> Third when the goal is isolation and not migration (a better chroot)
> then our hardware never changes.

... and you have quite a bit of system state (starting with those net:eth0
symlinks, etc.) visible in there, not just the hardware.

> The idea is supporting multiple superblocks for sysfs:
> 
>   Ultimately capturing the relevant namespace at mount time
>   and if we don't have a superblock for that namespace creating
>   a new one.
> 
>   So we have one sysfs dirent tree and multiple dentry trees.
> 
>   The tricky parts are rename/move and blocking mount/unmount requests
>   for sysfs until we complete the rename operation calling d_move
>   everywhere.

Excuse me, _what_?  Are you seriously suggesting going through all dentry
trees, doing d_move() in each?  I want to see your locking.  It's promising
to be worse than devfs had ever been.  Much worse.
