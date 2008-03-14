Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYCNNO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYCNNO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 09:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYCNNOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 09:14:49 -0400
Received: from postel.suug.ch ([194.88.212.233]:45452 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYCNNOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 09:14:48 -0400
X-Greylist: delayed 1754 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 09:14:48 EDT
Date: Fri, 14 Mar 2008 13:45:51 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Ian Kent <raven@themaw.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] Re: [PATCH 4/4] autofs4 - add miscelaneous device for ioctls
Message-ID: <20080314124551.GN20815@postel.suug.ch>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net> <Pine.LNX.4.64.0802261218230.8490@raven.themaw.net> <20080227211723.d5d27c09.akpm@linux-foundation.org> <1204179539.3501.17.camel@raven.themaw.net> <Pine.LNX.4.64.0803131408460.4608@raven.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803131408460.4608@raven.themaw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ian Kent <raven@themaw.net> 2008-03-13 16:00
> The function that is a problem is the sending of expire requests. In the 
> current implementation this function is synchronous. An ioctl is used to 
> ask the kernel module (autofs4) to check for mounts that can be expired 
> and, if a candidate is found the module sends a request to the user space 
> daemon asking it to try and umount the select mount after which the daemon 
> sends a success or fail status back to the module which marks the 
> completion of the original ioctl expire request.
> 
> The Generic Netlink interface won't allow this because only one concurrent 
> send request can be active for "all" Generic Netlink Families in use, 
> since the socket receive function is bracketed by a single mutex. So I would 
> need to use a workqueue to queue the request but that has it's own set of 
> problems.
>
> The next issue is that in order to keep track of multiple in flight 
> requests a separate Netlink socket would need to be opened for every 
> expire request in order to ensure that the Netlink completion reply makes 
> it back to the original requesting thread (Is that actually correct?). Not 
> really such a big problem but it defeats another aim of the 
> re-implementation, which is to reduce the selinux user space exposure to 
> file descriptors that are open but don't yet have close-on-exec flag set 
> when a mount or umount is spawned by the automount daemon. This can 
> obviously be resolved by adding a mutex around the fork/exec code but 
> isn't a popular idea due to added performance overhead.

Netlink is a messaging protocol, synchronization is up to the user.

I suggest that you send a netlink notification to a multicast group for
every expire candiate when an expire request is received. Unmount
daemons simply subscribe to the group and wait for work to do. Put the
request onto a list including the netlink pid and sequence number so you
can address the orignal source of the request later on. Exit the netlink
receive function and wait for the userspace daemon to get back to you.

The userspace daemon notifies you of successful or unsuccesful unmount
attempts by sending notifications. Update your list entry accordingly
and once the request is fullfilled send a notification to the original
source of the request by using the stored pid and sequence number.

The userspace application requesting the expire can simply block on the
receival of this notification in order to make the whole operation
synchronous.

Sounds acceptable?
