Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZGXVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZGXVWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZGXVWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:22:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43681 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbZGXVWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:22:45 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Andreas Dilger <adilger@sun.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
In-Reply-To: <20090724210008.GE4231@webber.adilger.int>
References: <1248466429.3567.82.camel@localhost>
	 <20090724210008.GE4231@webber.adilger.int>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 17:21:25 -0400
Message-Id: <1248470485.3567.106.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 15:00 -0600, Andreas Dilger wrote:
> On Jul 24, 2009  16:13 -0400, Eric Paris wrote:
> > fanotify kernel/userspace interaction is over a new socket protocol.  A
> > listener opens a new socket in the new PF_FANOTIFY family.  The socket
> > is then bound to an address.  Using the following struct:
> 
> Would it make sense to use existing netlink?

I looked at netlink, but because of the nature of the fact that fd
creation has to be done in the listener context I couldn't figure out
how to make it suitable.

> > struct fanotify_addr {
> >         sa_family_t family;
> >         __u32 priority;
> >         __u32 group_num;
> >         __u32 mask;
> >         __u32 f_flags;
> >         __u32 unused[16];
> > }  __attribute__((packed));
> > 
> > The mask is the indication of the events this group is interested in.
> > The set of events of interest if FAN_GLOBAL_LISTENER is set at bind
> > time.  If FAN_GLOBAL_LISTENER is not set, this field is meaningless as
> > the registration of events on individual inodes will dictate the
> > reception of events.
> > 
> > * FAN_ACCESS: every file access.
> > * FAN_MODIFY: file modifications.
> > * FAN_CLOSE: files are closed.
> > * FAN_OPEN: open() calls.
> > * FAN_ACCESS_PERM: like FAN_ACCESS, except that the process trying to
> > access the file is put on hold while the fanotify client decides whether
> > to allow the operation.
> > * FAN_OPEN_PERM: like FAN_OPEN, but with the permission check.
> > * FAN_EVENT_ON_CHILD: receive notification of events on inodes inside
> > this subdirectory. (this is not a full recursive notification of all
> > descendants, only direct children)
> > * FAN_GLOBAL_LISTENER: notify for events on all files in the system.
> > * FAN_SURVIVE_MODIFY: special flag that ignores should survive inode
> > modification.  Discussed below.
> 
> It seems like a 32-bit mask might not be enough, it wouldn't be hard
> at this stage to add a 64-bit mask.  Lustre has a similar mechanism
> (changelog) that allows tracking all different kinds of filesystem
> events (create/unlink/symlink/link/rename/mkdir/setxattr/etc), instead
> of just open/close, also use by HSM, enhanced rsync, etc.

I had a 64 bit mask, but Al Viro ask me to go back to a 32 bit mask
because of i386 register pressure.  The bitmask operations are on VERY
hot paths inside the kernel.

> > struct fanotify_event_metadata {
> >         __u32 event_len;
> >         __s32 fd;
> >         __u32 mask;
> >         __u32 f_flags;
> >         __s32 pid;
> >         __s32 tgid;
> >         __u64 cookie;
> > }  __attribute__((packed));
> 
> Getting the attributes that have changed into this message is also
> useful, as it avoids a continual stream of "stat" calls on the inodes.

Hmmm, I'll take a look.  Do you have a good example of what you would
want to see?  I don't think we know in the notification hooks what
actually is being changed  :(

> The other thing that is important for HSM is that this log is atomic
> and persistent, otherwise there may be files that are missed if the
> node crashes.  This involves creating atomic update records as part
> of the filesystem operation, and then userspace consumes them and
> tells the kernel that it is finished with records up to X.  Otherwise
> you risk inconsistencies between rsync/HSM/updatedb for files that
> are updated just before a crash.

Uhhh, persistent across a crash?  Nope, don't have that.  Notification
is all in memory.  Can't I just put the onus on userspace to recheck
things maybe?  Sounds like a user for i_version....

> > If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> > must send a response before the 5 second timeout.  If no response is
> > sent before the 5 second timeout the original operation is allowed.  If
> > this happens too many times (10 in a row) the fanotify group is evicted
> > from the kernel and will not get any new events.
> 
> This should be a tunable, since if the intent is to monitor PERM checks
> it would be possible for users to DOS the machine and delay the userspace
> programs and access files they shouldn't be able to.

At the moment I cheat and say root only to bind.  I do plan to open it
up to non-root users after it's in and working, but I'm seriously
considering leaving _PERM events as root only.  It's hard to map the
original to listener security implications.  So making sure the listener
is always root is easy   :)

Userspace would never be able to access a file it shouldn't be allowed
to (the new fd is created in the context of the listener and EPERM is
possible.)

