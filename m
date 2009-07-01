Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZGAEKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZGAEKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZGAEKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:10:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37343 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZGAEKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:10:39 -0400
Date: Tue, 30 Jun 2009 21:10:39 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net,
       Containers <containers@lists.linux-foundation.org>
Subject: Re: fanotify: the fscking all notification system
Message-ID: <20090701041039.GB23013@count0.beaverton.ibm.com>
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 04:08:45PM -0400, Eric Paris wrote:
> So it's back to that time.  I'm not quite sure how to present fanotify.
> I can start sending patches (they are available), but this message is
> just going to be a re-into, what questions and problems are still out
> there?
> 
> Long ago the anti-malware vendors started asking the community for a
> reasonable way to do on access file scanning, historically they have
> used syscall table rewrites and binary LSM hook hacks to get their
> information.  Customers and Linux users keep demanding this stuff and in
> an effort give them a supportable method to use these products I have
> been working to develop fanotify.
> 
> fanotify provides two things:
> 1) a new notification system, sorta like inotify, only instead of an
> arbitrary 'watch descriptor' which userspace has to know how to map back
> to an object on the filesystem, fanotify provides an open read-only fd
> back to the original object.  It should be noted that the set of
> fanotify events is much smaller than the set of inotify events.
> 
> 2) an access system in which processes may be blocked until the fanotify
> userspace listener has decided if the operation should be allowed.
> 
> There was a long discussion in which I was asked to define the security
> model being implemented and at the end of the day the answer is that
> there is no security model here.  This is NOT an LSM.  This is not
> intended to provide system security.  fanotify is intended to provide an
> interface for on access file scanning and permissions gating based on
> the results of those scans.  fanotify does not prevent, nor does it
> attempt to prevent, malicious code running on the Linux machine.  Read
> that again, once malicious code is running on the Linux machine this
> interface (along with whatever magic someone creates in userspace) is
> not intended to prevent malicious actions.  There is some hope in that
> if userspace can identify the malicious code it could prevent it from
> every being executed by a normal program and so there is clearly
> security benefit possible, but it is a very very weak assurance.  Those
> long discussion can be found at:
> http://thread.gmane.org/gmane.linux.kernel.malware/22
> http://thread.gmane.org/gmane.linux.kernel/716539
> 
> fanotify is close to working, although some of the 'features' are
> completely untested and a couple are unimplemented but it's pretty
> close.  It's currently implemented over 34 patches which hopefully are
> each small enough for good review, I'll be sending them a couple or so
> at a time for review but first I want to make sure we are all on the
> same page....
> 
> fanotify has two basic 'modes' directed and global.  fanotify directed
> works much like inotify in that userspace marks inodes it is interested
> in and gets events from those inodes.  fanotify global instead indicates
> that it wants everything on the system and then individually marks
> inodes that it doesn't care about.  They both have the same userspace
> interface and rely on the same fsnotify in kernel infrastrucute
> (although the infrastructure did have to modified to support the global
> listener concept)
> 
> In either case the fanotify userspace interface is based on socket calls
> loosely of this format.  
> 
> 1) open an fanotify socket
> 2) bind the socket here you define yourself and directed or global and
> if global define all the events you want.
> 2.5) if directed call setsockattr to attach marks to inodes you care
> about.
> 3) call getsockattr on the socket to get back data about events that
> took place and to get fd's opened in your context
> 
> At the very end of the message is a small program which, might even
> build, and will printf for every single open that takes place on the
> system as a reference for a brief understanding of the interface.
> (although it does not provide an example of access decisions)
> 
> fanotify has a limited set of events, open, close, access(read),
> modify(write) and a permissions event for open and modify.  fanotify
> provides no means to notice mv/rename.  This is something I plan to look
> into to simplify fanotify's use for use file indexers, but at this time
> the requisite information is not available in the right places in the
> kernel.
> 
> When userspace gets an event it comes in the form of one or more struct
> fanotify_event_metadata in the getsockopt buffer.
> 
> struct fanotify_event_metadata {
>         __u32 event_len;
>         __s32 fd;
>         __u32 mask;
>         __u32 f_flags;
>         pid_t pid;
>         pid_t tgid;
>         __u64 cookie;
> }  __attribute__((packed));

Since it passes pids from the kernel to userspace via a socket I suspect
this needs input from the folks working on pid namespaces. The events may
need to be dropped if the pid namespace of the event's origin doesn't
match that of the destination. Otherwise the pid would be ambiguous and
this interface will only work for tasks in the initial pid namespace.

<snip>
 
> Later today a 'working' set of fanotify patches should be available at
>   git://git.infradead.org/users/eparis/notify.git fanotify-experimental
> THIS BRANCH WILL REGULARLY REBASE, I'm not trying to work nicely with
> downstream trees!  Patches gladly accepted, merge requests? not so much.

Cheers,
	-Matt Helsley
