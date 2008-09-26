Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbYIZWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbYIZWEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYIZWE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:04:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYIZWE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:04:27 -0400
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
	system (intended for antivirus scanning and file indexers)
From: Eric Paris <eparis@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, david@lang.hm, hch@infradead.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, peterz@infradead.org,
       Jonathan.Press@ca.com, riel@redhat.com
In-Reply-To: <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
References: <1222463220.2872.193.camel@localhost.localdomain>
	 <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 18:03:35 -0400
Message-Id: <1222466615.2872.249.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-26 at 22:34 +0100, Alan Cox wrote:
> > It all starts when 'something' registers a group.  Registering a group
> > is as simple as 'echo "open_grp 50 0x10" > /security/fanotify/register.
> 
> I thought the operation was usually called "mkdir" which also nicely
> deals with races and exclusion.
> 
> > open_grp is just the name of the group, 50 is the priority (only
> > interesting for blocking/access events, will describe later) and 0x10 is
> > FAN_OPEN. If one wanted open and close you would use 0x1c = (FAN_OPEN |
> > FAN_CLOSE).  Inside the kernel this creates the new directory called
> 
> How do you change group on the fly in this model ?

you don't, you create a new one and unregister the old one if you want
something different.  There is no limit on the number of groups and
registered groups with nothing actively sitting there with the
notification file open have very minimal performance hit.

> 
> > The listener process will get a string that looks like "fd=10 cookie=0
> > mask=10."  This is telling the listener process that a new fd has been
> > created, #10.  The cookie (if this notification required an access
> > decision) was 0 and the mask of the event was 0x10 (FAN_OPEN.)
> 
> Ok that is foul as an interface, utterly gross. I guess it would be
> useful to also be able to not want fds

I took great care in making sure the interface and the implementation
were cleanly separated.  Heck, they are even in different _user files.
I clearly remembered gregkh hating me passing binary blobs and you
suggested syscalls.  This interface was to be easily extended, quickly
prototyped, and eventually thrown away for something the list likes.
The main goal was to make sure all communication was unidirectional and
race free.  A very similar interface with syscalls could use

fanotify_control (need to think about it, register/unregister)
fd = fanotify_get_notify(%[buffer for string of metadata])
error = fanotify_send_mesg(access/fastpath, value, cookie, fd)

> > event is added to the group->access_list AND to the group->event_list.
> > The original process is then blocked for a (now fixed 5 second) timeout
> > waiting for the event to get a non-zero event->response on the
> > group->access_waitq.
> 
> That raises security and correctness questions with things like "make it
> swap hard" attacks. Given that any timeout can be configured its not a
> big deal. Do need to handle process death or close of the notification
> descriptors.

You're suggesting a malicious program attached to a listener?  Yeah,
they can do horrible things to your machine.  My thoughts were these
files are root only and selinux can easily control who can read/write
from them....

> I think the mechanism is pretty sound. There are some "how do I" cases to
> do with open and watching for events when I want to rescan something as
> it has been dirty for a while. I'm not sure mmap dirty properly updates
> the file mtime - that wants doing anyway for backups tho so is the real
> fix.

not sure what you meant by part 1.  ACCESS events require an immediate
answer.  If you want to batch up some write events and scan it with
another process that's fine.  Pass your fd to that other process and
remember the pid of that other process.  Every time you get an event
from that other process just allow it.  That other process should not
have trouble adding the fastpath entry itself.

I thought we fixed mmap updates mtime a while back.  I'll test and make
sure.  That would throw a huge wrench in the works...

> The userspace API you propoe should however be taken out and shot, then
> buried with a stake through its heart, holy water in its mouth and its
> head cut off, at midnight in a pentacle at a crossroads in the presence
> of a priest.

shooting for an lwn quote of the week?

> 
> The two discussions are fortunately orthogonal. Is there any reason you
> can't use the socket based notification model - that gives you a much
> more natural way to express the thing
> 
> 
> 		socket
> 		bind(AF_FAN, group=foo+flags etc, PF_FAN);
> 
> 		fd = accept(old_fd, &addr[returned info])
> 
> 		close(fd);
> 
> as well as fairly natural and importantly standards defined semantics for
> poll including polling for a new file handles, for reconfiguration of
> stuff via get/setsockopt (which do pass stuff like object sizes unlike
> ioctls) and for reading/writing data.
> 
> Its not quite the same as a normal socket given you accept and get a non
> socket fd with the info you need in the return address area but its much
> closer than the rather mad file system proposal.
> 
> It would certainly be sane enough to, for example, start righting
> scanners in stuff like python-twisted or ruby on rails (not that this is
> neccessarily a good thing!)

The socket model you describe works very well and cleanly to replace the
'notification' part, but I can't think offhand how to send information
nearly as cleanly back.  I guess we replace writing to access and
fastpath with setsockopt?  Now how to make those easily extensible.....


As an aside I'm trying to get some quick and dirty perf numbers.  My
scsi driver isn't loading on my test machine with hand built kernel so I
might not have any numbers till monday.

-Eric

