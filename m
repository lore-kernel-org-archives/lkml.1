Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYJHOS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYJHOS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 10:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYJHOSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 10:18:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34151 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYJHOSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 10:18:49 -0400
Date: Wed, 8 Oct 2008 09:18:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: sysfs: tagged directories not merged completely yet
Message-ID: <20081008141818.GA23453@us.ibm.com>
References: <48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org> <20081003101331.GH28946@ZenIV.linux.org.uk> <20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org> <20081007222726.GA9465@kroah.com> <20081007225424.GA9430@us.ibm.com> <20081007233936.GA23282@kroah.com> <20081008001203.GA21918@us.ibm.com> <20081008003834.GA8680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008003834.GA8680@kroah.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Tue, Oct 07, 2008 at 07:12:03PM -0500, Serge E. Hallyn wrote:
> > Quoting Greg KH (greg@kroah.com):
> > > On Tue, Oct 07, 2008 at 05:54:24PM -0500, Serge E. Hallyn wrote:
> > > > Quoting Greg KH (greg@kroah.com):
> > > > > On Tue, Oct 07, 2008 at 01:27:17AM -0700, Eric W. Biederman wrote:
> > > > > > Unless someone will give an example of how having multiple superblocks
> > > > > > sharing inodes is a problem in practice for sysfs and call it good
> > > > > > for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
> > > > > > code is compiled out.  And it should greatly improve testing of the
> > > > > > network namespace to at least have access to sysfs.
> > > > > 
> > > > > But if the network namespace code is in?  THen we have problems, right?
> > > > > And that's the whole point here.
> > > > > 
> > > > > The fact that you are trying to limit userspace view of in-kernel data
> > > > > structures, based on that specific user, is, in my opinion, crazy.
> > > > > 
> > > > > Why not just keep all users from seeing sysfs, and then have a user
> > > > > daemon doing something on top of FUSE if you really want to see this
> > > > > kind of stuff.
> > > > 
> > > > Well the blocker is really that when you create a new network namespace,
> > > > it wants to create a new loopback interface, but
> > > > /sys/devices/virtual/net/lo already exists.  That's the same issue with
> > > > user namespace when the fair scheduler is enabled, which tries to
> > > > re-create /sys/kernel/uids/0.
> > > > 
> > > > Otherwise yeah at least for my own uses, containers wouldn't need to
> > > > look at /sys at all.
> > > > 
> > > > Heck you wouldn't even need FUSE, just mount -t tmpfs /sys/class/net
> > > > and manually link the right devices from /sys/devices/virtual/net.
> > > 
> > > Great, that sounds like a solution.
> > > 
> > > So tell me again why we need these huge sysfs reworks? :)
> > 
> > Because :
> > 
> > > > Well the blocker is really that when you create a new network namespace,
> 
> No, wait.  Why would you want to do such a thing in the first place?

So I can have db2, a few apaches, etc, each in different containers with
their network devices and their own ipfilter rules.

So I can take one of those apache containers and migrate it along with
its ip address to another machine.

So I can do the openvz/vserver thing and run a 'virtual machine' (or 50)
without the overhead of another full OS.  Now like Eric said our goal
isn't to fool the distro installed in the container and not let it know
it's in a container.  But the same tools should be able to administer
inside a container as outside a container.  That was the reason for the
filtering of /proc to show the right pids inside a container, for
instance.

So given that, what I describe below should probably suffice.  Though I
wonder whether things depending on uevents will get messed up in a
container.  It should be fine, I assume, so long as the devicename (lo)
is sent along withthe filename (lo.childXYZ).

> > > > it wants to create a new loopback interface, but
> > > > /sys/devices/virtual/net/lo already exists.  That's the same issue with
> > 
> > So at least we'd have to do something to allow creation of 'duplicate'
> > devices in different namespaces.  It might be fine if we just ended up
> > with /sys/devices/virtual/net/lo, if created in a child net namespace,
> > be named /sys/devices/virtual/net/lo.childXYZ.  Then userspace can
> > mount -t tmpfs none /sys/class/net and ln -s
> > /sys/devices/virtual/net/lo.childXYZ /sys/class/net/lo.
> 
> ick.
> 
> I agree with Tejun here, what's this whole network namespace stuff, what
> problems is it trying to solve and what are its goals?
> 
> thanks,
> 
> greg k-h
