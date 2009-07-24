Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZGXVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZGXVBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZGXVBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:01:00 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56991 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZGXVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:00:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 24 Jul 2009 15:00:09 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: fanotify - overall design before I start sending patches
In-reply-to: <1248466429.3567.82.camel@localhost>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
Message-id: <20090724210008.GE4231@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1248466429.3567.82.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24, 2009  16:13 -0400, Eric Paris wrote:
> fanotify kernel/userspace interaction is over a new socket protocol.  A
> listener opens a new socket in the new PF_FANOTIFY family.  The socket
> is then bound to an address.  Using the following struct:

Would it make sense to use existing netlink?

> struct fanotify_addr {
>         sa_family_t family;
>         __u32 priority;
>         __u32 group_num;
>         __u32 mask;
>         __u32 f_flags;
>         __u32 unused[16];
> }  __attribute__((packed));
> 
> The mask is the indication of the events this group is interested in.
> The set of events of interest if FAN_GLOBAL_LISTENER is set at bind
> time.  If FAN_GLOBAL_LISTENER is not set, this field is meaningless as
> the registration of events on individual inodes will dictate the
> reception of events.
> 
> * FAN_ACCESS: every file access.
> * FAN_MODIFY: file modifications.
> * FAN_CLOSE: files are closed.
> * FAN_OPEN: open() calls.
> * FAN_ACCESS_PERM: like FAN_ACCESS, except that the process trying to
> access the file is put on hold while the fanotify client decides whether
> to allow the operation.
> * FAN_OPEN_PERM: like FAN_OPEN, but with the permission check.
> * FAN_EVENT_ON_CHILD: receive notification of events on inodes inside
> this subdirectory. (this is not a full recursive notification of all
> descendants, only direct children)
> * FAN_GLOBAL_LISTENER: notify for events on all files in the system.
> * FAN_SURVIVE_MODIFY: special flag that ignores should survive inode
> modification.  Discussed below.

It seems like a 32-bit mask might not be enough, it wouldn't be hard
at this stage to add a 64-bit mask.  Lustre has a similar mechanism
(changelog) that allows tracking all different kinds of filesystem
events (create/unlink/symlink/link/rename/mkdir/setxattr/etc), instead
of just open/close, also use by HSM, enhanced rsync, etc.

> struct fanotify_event_metadata {
>         __u32 event_len;
>         __s32 fd;
>         __u32 mask;
>         __u32 f_flags;
>         __s32 pid;
>         __s32 tgid;
>         __u64 cookie;
> }  __attribute__((packed));

Getting the attributes that have changed into this message is also
useful, as it avoids a continual stream of "stat" calls on the inodes.

The other thing that is important for HSM is that this log is atomic
and persistent, otherwise there may be files that are missed if the
node crashes.  This involves creating atomic update records as part
of the filesystem operation, and then userspace consumes them and
tells the kernel that it is finished with records up to X.  Otherwise
you risk inconsistencies between rsync/HSM/updatedb for files that
are updated just before a crash.

> If a FAN_ACCESS_PERM or FAN_OPEN_PERM event is received the listener
> must send a response before the 5 second timeout.  If no response is
> sent before the 5 second timeout the original operation is allowed.  If
> this happens too many times (10 in a row) the fanotify group is evicted
> from the kernel and will not get any new events.

This should be a tunable, since if the intent is to monitor PERM checks
it would be possible for users to DOS the machine and delay the userspace
programs and access files they shouldn't be able to.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

