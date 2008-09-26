Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYIZVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYIZVh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYIZVhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:37:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51891 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbYIZVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:37:15 -0400
Date: Fri, 26 Sep 2008 22:34:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       arjan@infradead.org, bunk@kernel.org, tytso@mit.edu,
       tvrtko.ursulin@sophos.com, david@lang.hm, hch@infradead.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, peterz@infradead.org,
       Jonathan.Press@ca.com, riel@redhat.com
Subject: Re: [RFC] 0/11 fanotify: fscking all notifiction and file access
 system (intended for antivirus scanning and file indexers)
Message-ID: <20080926223404.7c4894df@lxorguk.ukuu.org.uk>
In-Reply-To: <1222463220.2872.193.camel@localhost.localdomain>
References: <1222463220.2872.193.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It all starts when 'something' registers a group.  Registering a group
> is as simple as 'echo "open_grp 50 0x10" > /security/fanotify/register.

I thought the operation was usually called "mkdir" which also nicely
deals with races and exclusion.

> open_grp is just the name of the group, 50 is the priority (only
> interesting for blocking/access events, will describe later) and 0x10 is
> FAN_OPEN. If one wanted open and close you would use 0x1c = (FAN_OPEN |
> FAN_CLOSE).  Inside the kernel this creates the new directory called

How do you change group on the fly in this model ?

> The listener process will get a string that looks like "fd=10 cookie=0
> mask=10."  This is telling the listener process that a new fd has been
> created, #10.  The cookie (if this notification required an access
> decision) was 0 and the mask of the event was 0x10 (FAN_OPEN.)

Ok that is foul as an interface, utterly gross. I guess it would be
useful to also be able to not want fds

> event is added to the group->access_list AND to the group->event_list.
> The original process is then blocked for a (now fixed 5 second) timeout
> waiting for the event to get a non-zero event->response on the
> group->access_waitq.

That raises security and correctness questions with things like "make it
swap hard" attacks. Given that any timeout can be configured its not a
big deal. Do need to handle process death or close of the notification
descriptors.

I think the mechanism is pretty sound. There are some "how do I" cases to
do with open and watching for events when I want to rescan something as
it has been dirty for a while. I'm not sure mmap dirty properly updates
the file mtime - that wants doing anyway for backups tho so is the real
fix.

The userspace API you propoe should however be taken out and shot, then
buried with a stake through its heart, holy water in its mouth and its
head cut off, at midnight in a pentacle at a crossroads in the presence
of a priest.

The two discussions are fortunately orthogonal. Is there any reason you
can't use the socket based notification model - that gives you a much
more natural way to express the thing


		socket
		bind(AF_FAN, group=foo+flags etc, PF_FAN);

		fd = accept(old_fd, &addr[returned info])

		close(fd);

as well as fairly natural and importantly standards defined semantics for
poll including polling for a new file handles, for reconfiguration of
stuff via get/setsockopt (which do pass stuff like object sizes unlike
ioctls) and for reading/writing data.

Its not quite the same as a normal socket given you accept and get a non
socket fd with the info you need in the return address area but its much
closer than the rather mad file system proposal.

It would certainly be sane enough to, for example, start righting
scanners in stuff like python-twisted or ruby on rails (not that this is
neccessarily a good thing!)

Alan

