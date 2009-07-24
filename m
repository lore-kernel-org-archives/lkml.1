Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZGXVoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZGXVoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZGXVoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:44:20 -0400
Received: from mail2.shareable.org ([80.68.89.115]:35397 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZGXVoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:44:19 -0400
Date: Fri, 24 Jul 2009 22:44:01 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: david@lang.hm, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, jengelh@medozas.de, aviro@redhat.com,
       mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090724214401.GJ27755@shareable.org>
References: <1248466429.3567.82.camel@localhost> <alpine.DEB.1.10.0907241340580.28013@asgard.lang.hm> <1248469278.3567.88.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248469278.3567.88.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Fri, 2009-07-24 at 13:48 -0700, david@lang.hm wrote:
> > getting an open fd to the file is good for things like content scanning, 
> > but for other things like a HSM re-populating the file, you would need to 
> > pass the path used to open the file at open time. is this in the metadata 
> > you are passing?
> 
> No, I will NOT EVER pass a pathname.  Period.  End of story.  I stated
> the if userspace wants to deal with pathnames (and they understand the
> system setup well enough to know if pathnames even make sense to them)
> they can use readlink(2) on /proc/self/fd

That makes sense.

In most cases where events trigger userspace cache or index updates,
userspace already has enough information to calculate the path (and
any derived data) from the inode number (in the case of non-hard-link
files) or from the inode number of the parent directory and the name
(not full path).

So it wouldn't even need to call readlink(2), provided those bits of
information are passed in the event.

That is one thing which inotify _nearly_ gets right.  Nearly, because
it doesn't pass the inode number when you're watching a directory, and
watching every inode is too expensive.

> > to avoid race conditions, you may want some way that a listener on a 
> > directory can flag that it wants to also be a listener for all new 
> > directories created under the one it is listening on.
> 
> Interesting way to get the subtree checking people want, you do the
> registration yourself the first time on the entire hierarchy and new
> directories will be automagically added.  I could probably do that, I'll
> have to look.

Yes, automagically adding directories is essential, otherwise they can
be added, and someone can populate them with files that have some
effect before userspace gets a chance to scan them.

The other part of useful subtree notification is getting notifications
for a subtree without having to initially scan the whole hierachy
,which can take a long time as well as a huge amount of unnecessary
seeking and I/O.

The third part, which by the way is really recommended for security
applications, is persistence across umount/reboot/mount.  That can be
done either by assuming there are no filesystem changes when userspace
isn't watching it, or by the simple expedient of letting userspace add
an xattr to things it has indexed, with a specially recognised name
that is automatically removed whenever the file/directory is changed.

-- Jamie
