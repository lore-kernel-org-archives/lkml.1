Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYCNOLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYCNOLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYCNOL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:11:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55248 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYCNOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:11:27 -0400
X-Sasl-enc: C7d1e3gq9lWTtIbR6URPV7sPpULgEBdDh0sxyH2Fw7LF 1205503885
Subject: Re: [RFC] Re: [PATCH 4/4] autofs4 - add miscelaneous device for
	ioctls
From: Ian Kent <raven@themaw.net>
To: Thomas Graf <tgraf@suug.ch>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20080314124551.GN20815@postel.suug.ch>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>
	 <Pine.LNX.4.64.0802261218230.8490@raven.themaw.net>
	 <20080227211723.d5d27c09.akpm@linux-foundation.org>
	 <1204179539.3501.17.camel@raven.themaw.net>
	 <Pine.LNX.4.64.0803131408460.4608@raven.themaw.net>
	 <20080314124551.GN20815@postel.suug.ch>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 23:10:11 +0900
Message-Id: <1205503811.3162.38.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 13:45 +0100, Thomas Graf wrote:
> * Ian Kent <raven@themaw.net> 2008-03-13 16:00
> > The function that is a problem is the sending of expire requests. In the 
> > current implementation this function is synchronous. An ioctl is used to 
> > ask the kernel module (autofs4) to check for mounts that can be expired 
> > and, if a candidate is found the module sends a request to the user space 
> > daemon asking it to try and umount the select mount after which the daemon 
> > sends a success or fail status back to the module which marks the 
> > completion of the original ioctl expire request.
> > 
> > The Generic Netlink interface won't allow this because only one concurrent 
> > send request can be active for "all" Generic Netlink Families in use, 
> > since the socket receive function is bracketed by a single mutex. So I would 
> > need to use a workqueue to queue the request but that has it's own set of 
> > problems.
> >
> > The next issue is that in order to keep track of multiple in flight 
> > requests a separate Netlink socket would need to be opened for every 
> > expire request in order to ensure that the Netlink completion reply makes 
> > it back to the original requesting thread (Is that actually correct?). Not 
> > really such a big problem but it defeats another aim of the 
> > re-implementation, which is to reduce the selinux user space exposure to 
> > file descriptors that are open but don't yet have close-on-exec flag set 
> > when a mount or umount is spawned by the automount daemon. This can 
> > obviously be resolved by adding a mutex around the fork/exec code but 
> > isn't a popular idea due to added performance overhead.
> 
> Netlink is a messaging protocol, synchronization is up to the user.

Yes, I realize that, but what I'm curious about are the options that I
have within the messaging system to control delivery of message replies,
other than using separate sockets. Can this be achieved by using the pid
set in the originating message?

> 
> I suggest that you send a netlink notification to a multicast group for
> every expire candiate when an expire request is received. Unmount
> daemons simply subscribe to the group and wait for work to do. Put the
> request onto a list including the netlink pid and sequence number so you
> can address the orignal source of the request later on. Exit the netlink
> receive function and wait for the userspace daemon to get back to you.

I'll have to think about what you've said here to relate it to the
situation I have. I don't actually have umount daemons, at the moment I
request an expire and the daemon creates a thread to do the umount and
sends a status message to the kernel module. But that may not matter,
see below.

> 
> The userspace daemon notifies you of successful or unsuccesful unmount
> attempts by sending notifications. Update your list entry accordingly
> and once the request is fullfilled send a notification to the original
> source of the request by using the stored pid and sequence number.
> 
> The userspace application requesting the expire can simply block on the
> receival of this notification in order to make the whole operation
> synchronous.

Actually, I've progressed on this since posting.

I've implemented the first steps toward using a workqueue to perform the
expire and, to my surprise, my code worked for a simple test case.
Basically, a thread in the daemon issues the expire, the kernel module
queues the work and replies. The expire workqueue task does the expire
check and if no candidates are found it sends an expire complete
notification, or it sends a umount request to the daemon and waits for
the status result, then returns that result as the expire compete
notification. Seems to work quite well.

I expect this is possibly the method you're suggesting above anyway.

Unfortunately, having now stepped up intensity of the testing, I'm
getting a hard hang on my system. I've setup to reduce the message
functions used to only two simple notification messages to the kernel
module to ensure it isn't the expire implementation causing the problem.
It's hard to see where I could have messed these two functions as they
are essentially re-entrant but there is fairly heavy mount activity of
about 10-15 mounts a second. Such is life!

Any ideas on what might be causing this?

Ian



