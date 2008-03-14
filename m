Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYCNCqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYCNCqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYCNCqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:46:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35704 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754559AbYCNCqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:46:42 -0400
X-Sasl-enc: O/+A5surNp/pddjOOPYzRs4Lr4/oTstUYyHsOhpVS0UU 1205462800
Date: Fri, 14 Mar 2008 11:45:38 +0900 (WST)
From: Ian Kent <raven@themaw.net>
To: Thomas Graf <tgraf@redhat.com>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] Re: [PATCH 4/4] autofs4 - add miscelaneous device for
 ioctls
In-Reply-To: <Pine.LNX.4.64.0803131408460.4608@raven.themaw.net>
Message-ID: <Pine.LNX.4.64.0803141141400.8730@raven.themaw.net>
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net> 
 <Pine.LNX.4.64.0802261218230.8490@raven.themaw.net> 
 <20080227211723.d5d27c09.akpm@linux-foundation.org> <1204179539.3501.17.camel@raven.themaw.net>
 <Pine.LNX.4.64.0803131408460.4608@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Ian Kent wrote:

Thomas, could you comment on the Netlink related questions I have posed 
blow please.

> On Thu, 28 Feb 2008, Ian Kent wrote:
> 
> > > 
> > > We seem to be passing some string into a misc-device ioctl and getting some
> > > results back.  Be aware that this won't be a terribly popular proposal, so
> > > I'd suggest that you fully describe the problem which it's trying to solve,
> > > and how it solves it, and why the various alternatives (sysfs, netlink,
> > > mount options, etc) were judged unsuitable.
> > 
> > Yes, as I said above.
> > 
> > I don't expect that people that aren't close to the development of
> > autofs will "get" the problem description in the leading post but I will
> > try and expand on it as best I can.
> > 
> > As for the possible alternatives, it sounds like I have some more work
> > to do on that. Mount options can't be used as I described in the lead in
> > post and, as far as my understanding of sysfs goes, I don't think it's
> > appropriate. But, I'm not aware of what the netlink interface may be
> > able to do for me so I will need to check on that.
> > 
> 
> I've attempted an implementation of this using the Generic Netlink 
> interface and I've struck a difficulty. I would like to use current 
> recommended development policy but I'm not sure how far I should go with 
> this in order to avoid using an ioctl implementation so I'm after some 
> advice and suggestions.
> 
> So, onto the description.
> Sorry about the length of the post.
> 
> Autofs user space uses a number of ioctls for mount control.
> 
> I have a problem that can only be resolved by adding an additional control 
> function that doesn't need to open the autofs mount point path directly 
> to issue ioctl commands. So I decided to re-implement the the control 
> interface, hopefully, in a cleaner way and solve a couple of other 
> problems at the same time (by adding two additional control functions 
> giving a total of three new functions) and improving one of the existing 
> functions.
> 
> My initial proposal used a miscellaneous device to route ioctl commands to 
> autofs mounts and the question of why current recommended alternatives 
> were not suitable was asked. The only alternative that may be suitable is 
> the Netlink interface.
> 
> I won't go into the details of the new functions now but focus on the 
> difficulty I have found implementing one of the existing functions using 
> the Netlink interface.
> 
> There are some restrictions on the scope of the change.
> The scope is only the ioctl interface. I don't want change too many things 
> at once, in particular things that are currently working OK. And I'd like 
> to retain the existing semantic behavior of the interface.
> 
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
> A workqueue can have only one active request going at a time but I may 
> have a number of concurrent expires happening at any one time and the 
> request could block for a significant amount of time so I would have to 
> use multiple queues. Also there isn't a one-to-one correspondence 
> between autofs super blocks and the stream of expire requests so the 
> number of needed workqueues isn't known. Hence, a workqueue would need to 
> be created, used and destroyed for every umount request or some other 
> elaborate mechanism developed to re-use workqueues. Ideas?
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
> 
> That's about it for a Generic Netlink solution.
> 
> It looks like it may be possible to avoid the need to use workqueues by 
> adding a new netlink protocol. I didn't notice any mutual exclusion 
> issues in the code but I may not have looked far enough (comments 
> please?). This approach would still have the issue of needing a new socket 
> opened for each expire for the tracking multiple requests and a 
> considerable increase in complexity in the autofs4 module for netlink 
> communication.
> 
> I'm concerned about the effort I would need to devote to make this work  
> and the increase in complexity that may be needed, especially if the 
> implementation is ultimately not satisfactory for inclusion in the kernel.
> 
> Please help!
> Ian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
