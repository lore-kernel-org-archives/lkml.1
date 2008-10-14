Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYJNIBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYJNIBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYJNIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:01:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:49899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbYJNIBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:01:11 -0400
Message-ID: <48F45075.7000003@kernel.org>
Date: Tue, 14 Oct 2008 16:55:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>	<20081003101331.GH28946@ZenIV.linux.org.uk>	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>	<20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org> <m1myh8rnf4.fsf@frodo.ebiederm.org>
In-Reply-To: <m1myh8rnf4.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 07:57:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
>> That sounds nice.  Out of ignorance, how is the /proc dealt with?
>> Maybe we can have some unified approach for this multiple views of the
>> system stuff.
> 
> /proc uses just about every trick in the book to make this work.
> 
> /proc/sys uses a magic d_compare method.
>       
> /proc/net becomes a symlink to /proc/<pid>/net and we get completely
>       different directory trees below that.   Shortly that code will
>       use auto mounts of a proc_net filesystem, that has different
>       super blocks one for each different network namespace.
> 
> /proc/sysvipc/* simply returns different values from it's files depending
>       upon which process is reading them.
> 
> /proc itself has multiple super blocks one for each different pid namespace.

Aieeeee... I wanna run screaming and crying.  Any chance these can be
done using FUSE?  FUSE is pretty flexible and should be able to
emulate most of proc files w/o too much difficulty.

> The long term direction is to be able to see everything at once.  If
> you mount all of the filesystems multiple times in the proper way.
> That allows monitoring software to watch what is going on inside of a
> container without a challenge, and it makes it a user space policy
> decision how much an individual container sees.
> 
> For sysfs there isn't have the option of putting things under
> /proc/<pid>, the directories I am interested in (at least for network
> devices) are scattered all over sysfs and come and go with device
> hotplug events so I don't see a realistic way of splitting those
> directories out into their own filesystem.
>
> From a user interface design perspective I don't see a good
> alternative to having /sys/class/net/, /sys/virtual/net/, and all of
> the other directories different based on network namespace.  Then have
> the network namespace be specified by super block.  Looking at current
> and doing the magic d_compare trick almost works, but it runs into
> problems with sysfs_get_dentry.
> 

And can we do the same thing for sysfs using FUSE?  So that not only
the policy but also the implementation is in userland?  The changes
are quite pervasive and makes the whole thing pretty difficult to
follow.

> From the perspective of the internal sysfs data structures tagged
> dirents are clean and simple so I don't see a reason to re-architect
> that.

Heh... you know I have some reservations on that one too.  :-)

> I have spent the last several days looking deeply at what the vfs
> can do, and how similar situations are handled.  My observations
> are:

Thanks.  Much appreciated.

> 1) exportfs from nfsd is similar to our kobject to sysfs_dirent layer,
>    and solves that set of problems cleanly, including remote rename.
>    So there is no fundamental reason we need inverted twisting locking in
>    sysfs, or otherwise violate existing vfs rules.

eGreat.  IIRC, it does it by not moving the existing dentry but
invalidating it, right?

The current twisted state is more of what's left from the original
tree-of-dentries-and-inodes implementation.  It would be great to do
proper distributed fs instead.

> 2) i_mutex seems to protect very little if anything that we care about.
>    The dcache has it's own set of locks.  So we may be able to completely
>    avoid taking i_mutex in sysfs and simplify things enormously.
>    Currently I believe we are very similar to ocfs2 in terms of locking
>    requirements.

I think the timestamps are one of the things it protects.

> 3) For i_notify and d_notify that seems to require pinning the inode
>    or the dentry in question, so I see no reason why a d_revalidate
>    style of update will have problems.

Because the existing notifications won't be moved over to the new
dentry.  dnotify wouldn't work the same way.  ISTR that was the reason
why I didn't do the d_revalidate thing, but I don't think it really
matters.  dnotify on sysfs nodes doesn't work properly anyway.

> 4) For finer locking granularity of readdir.  All we need to do is do
>    the semi-expensive restart for each dirent, and the problem is
>    trivially solved.

That can show the same entry multiple times or skip existing entries.
I think it's better to put fake entries and implement iterators.

> 5) Large directories are a potential performance problem in sysfs.

Yes, it is.  It hasn't been an issue till now.  You're worrying about
look up performance, right?  If that's a real concern we can link sd's
into a hash table, but I'm not sure tho.  For listing, O(n) is the
best we can do anyway and after the initial lookup, the result would
be cached via dcache anyway, so I'm not really sure how much adding a
hashtable will buy us.

> So it appears that the path forward is:
> - Cleanup sysfs locking and other issues.
> - Return to the network namespace code.
> 
> Possibly with an intermediate step of only showing the network
> devices in the initial network namespace in sysfs.
> 
>> Can somebody hammer the big picture regarding namespaces into my
>> small head?
> 
> 100,000 foot view.  A namespace introduces a scope so multiple
> objects can have the same name.  Like network devices.
> 
> 10,000 foot view.  The network namespace looks to user space
> as if the kernel has multiple independent network stacks.
> 
> 1000 foot view.  I have two network devices named lo, and sysfs
> does not currently have a place for me to put them.
> 
> Leakage and being able to fool an application that it has the entire
> kernel to itself are not concerns.  The goal is simply to get the
> entire object name to object translation boundary and the namespace
> work is done.  We have largely achieved, and the code to do
> so once complete is reasonable enough that it should be no
> worse than dealing with any other kernel bug.

Yes, I'm aware of the goals.  What I'm curious about is the consensus
regarding network namespace and all its implications.  It adds a lot
of complexities over a lot of places.  e.g. following the sysfs code
becomes quite a bit more difficult after the namespace changes (maybe
it's just me but still).  So, I was asking whether people generally
agree that having the namespace thing is worth the added complexities.

I think it serves pretty small group of users.  Hosting service
providers and people trying to migrate processes from one machine to
another, both of which can be served pretty well with virtualization.
It does have higher overhead both processing power and memory wise but
IIUC the former is being actively worked on w/ new processor features
like nested paging tables and all and memory is really cheap these
days, so I'm a bit skeptical how much this is needed and how much we
should pay for it.

Another venue to explore is whether the partial view of proc and sysfs
can be implemented in less pervasive way.  Implementing it via FUSE
might not be easier per-se but I think it would be better to do it
that way if we can instead of adding complexities to both proc and
sysfs.

One last thing that came to mind is, how would uevents be handled?
ie. what happens if a network card which is presented as ethN in the
namespace goes away?  How does the system deal with it?

Thanks.

-- 
tejun
