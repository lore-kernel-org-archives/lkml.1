Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZGXWmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZGXWmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZGXWmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:42:54 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61101 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZGXWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:42:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 24 Jul 2009 16:42:23 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: fanotify - overall design before I start sending patches
In-reply-to: <1248470485.3567.106.camel@localhost>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
Message-id: <20090724224223.GH4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248466429.3567.82.camel@localhost>
 <20090724210008.GE4231@webber.adilger.int>
 <1248470485.3567.106.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24, 2009  17:21 -0400, Eric Paris wrote:
> On Fri, 2009-07-24 at 15:00 -0600, Andreas Dilger wrote:
> > On Jul 24, 2009  16:13 -0400, Eric Paris wrote:
> > It seems like a 32-bit mask might not be enough, it wouldn't be hard
> > at this stage to add a 64-bit mask.  Lustre has a similar mechanism
> > (changelog) that allows tracking all different kinds of filesystem
> > events (create/unlink/symlink/link/rename/mkdir/setxattr/etc), instead
> > of just open/close, also use by HSM, enhanced rsync, etc.
> 
> I had a 64 bit mask, but Al Viro ask me to go back to a 32 bit mask
> because of i386 register pressure.  The bitmask operations are on VERY
> hot paths inside the kernel.

How about adding a spare "__u32 mask_hi" for future use, so that it can
be changed directly into a __u64 on LE machines?  That preserves the
extensibility for the future, without hitting performance on 32-bit
machines before it is needed.

> > > struct fanotify_event_metadata {
> > >         __u32 event_len;
> > >         __s32 fd;
> > >         __u32 mask;
> > >         __u32 f_flags;
> > >         __s32 pid;
> > >         __s32 tgid;
> > >         __u64 cookie;
> > > }  __attribute__((packed));
> > 
> > Getting the attributes that have changed into this message is also
> > useful, as it avoids a continual stream of "stat" calls on the inodes.
> 
> Hmmm, I'll take a look.  Do you have a good example of what you would
> want to see?  I don't think we know in the notification hooks what
> actually is being changed  :(

Well, I'm thinking there will be a lot of events that some applications
will not care about (e.g. PERM checks where the user is only changing
the file mode, vs. PERM checks where the owner of the file is changing).
Even if the old attributes are not available, having a mask of which
fields in the inode changed, and struct stat64 would be very useful.

> > The other thing that is important for HSM is that this log is atomic
> > and persistent, otherwise there may be files that are missed if the
> > node crashes.  This involves creating atomic update records as part
> > of the filesystem operation, and then userspace consumes them and
> > tells the kernel that it is finished with records up to X.  Otherwise
> > you risk inconsistencies between rsync/HSM/updatedb for files that
> > are updated just before a crash.
> 
> Uhhh, persistent across a crash?  Nope, don't have that.  Notification
> is all in memory.  Can't I just put the onus on userspace to recheck
> things maybe?  Sounds like a user for i_version....

Well, if new files are created then userspace won't have any idea which
inodes need to be checked, and it will also need to keep a persistent
database of all file i_version values.  If you are trying to hook a
backup tool onto such an interface and files created persistently on
disk before a crash are not handled, then they may never be backed up.

Tools like inotify are fine for desktop window refresh and similar uses,
but for applications which require robust handling they also need to
work over a crash.

The other issue is that you might get quite a large queue of operations
in memory, and if this can't be saved to the filesystem then it might
result in OOMing itself.

> > > If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> > > must send a response before the 5 second timeout.  If no response is
> > > sent before the 5 second timeout the original operation is allowed.  If
> > > this happens too many times (10 in a row) the fanotify group is evicted
> > > from the kernel and will not get any new events.
> > 
> > This should be a tunable, since if the intent is to monitor PERM checks
> > it would be possible for users to DOS the machine and delay the userspace
> > programs and access files they shouldn't be able to.
> 
> At the moment I cheat and say root only to bind.  I do plan to open it
> up to non-root users after it's in and working, but I'm seriously
> considering leaving _PERM events as root only.  It's hard to map the
> original to listener security implications.  So making sure the listener
> is always root is easy   :)

My comment has nothing to do with non-root access.  It has to do with
how long the userspace watcher has to handle an event.  If a regular user
is running a 50-thread iozone with a 1M file directory you can imagine it
will create a lot of events to watch, along with a lot of seeking to slow
down the processing of events.  If the user then does "open(secretfile)"
(where your _PERM check is doing something useful) it is possible
that the userspace listener will time out and miss some events.

> Userspace would never be able to access a file it shouldn't be allowed
> to (the new fd is created in the context of the listener and EPERM is
> possible.)

Ah, so the _PERM check is only intended to grant extra access, instead
of restricting it?  That should be made clear in the documentation that
doing the opposite is an easily-bypassed security vulnerability.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

