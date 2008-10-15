Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYJOLIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYJOLIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYJOLH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:07:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:49322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYJOLHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:07:55 -0400
Message-ID: <48F5CE43.2030207@kernel.org>
Date: Wed, 15 Oct 2008 20:04:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sysfs: tagged directories not merged completely yet
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>	<20081003101331.GH28946@ZenIV.linux.org.uk>	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>	<20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org>	<m1myh8rnf4.fsf@frodo.ebiederm.org> <48F45075.7000003@kernel.org> <m1ej2jjrnl.fsf@frodo.ebiederm.org>
In-Reply-To: <m1ej2jjrnl.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Oct 2008 11:06:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Aieeeee... I wanna run screaming and crying.  Any chance these can be
>> done using FUSE?  FUSE is pretty flexible and should be able to
>> emulate most of proc files w/o too much difficulty.
> 
> I don't see how FUSE can help.  The problem is getting the information 
> out of the kernel, and not breaking backwards compatiblity while we
> do it.  As I understand FUSE it just allows for user space filesystems.
> Which is great if I want to hide information.

Well, you can modify the information too.  FUSE can easily present
ethN as eth0 of a namespace.  I don't know how it will play out with
the actual network interfaces tho.

>> And can we do the same thing for sysfs using FUSE?  So that not only
>> the policy but also the implementation is in userland?  The changes
>> are quite pervasive and makes the whole thing pretty difficult to
>> follow.
> 
> I don't see how.  If userspace doesn't have the information I don't
> see how placing a filter will allow it to show up there.
> 
> The challenge is to not conflict on network device names.  If someone can
> think of where we can put the network devices that are in different
> network namespaces in sysfs so they don't conflict when they have the
> same name I have no problem with that.  But where can we put them?

I was thinking about just letting them be ethN with unique Ns and
letting FUSE server present some of them as ethX on namespaces.

>>> 2) i_mutex seems to protect very little if anything that we care about.
>>>    The dcache has it's own set of locks.  So we may be able to completely
>>>    avoid taking i_mutex in sysfs and simplify things enormously.
>>>    Currently I believe we are very similar to ocfs2 in terms of locking
>>>    requirements.
>> I think the timestamps are one of the things it protects.
> 
> Yes.  I think parts of the page cache and anything in the inode itself
> is protected by i_mutex.  As for timestamsp or anything else that
> we really care about we can and should put them in sysfs_dirent and
> we can have the stat method recreate it, and possibly have d_revalidate
> refresh it.

Some of the timestamps are not on the sysfs_dirent because 1. nobody
cared (the original sd implementation didn't preserve it) and
2. of memory overhead.

>>> 3) For i_notify and d_notify that seems to require pinning the inode
>>>    or the dentry in question, so I see no reason why a d_revalidate
>>>    style of update will have problems.
>> Because the existing notifications won't be moved over to the new
>> dentry.  dnotify wouldn't work the same way.  ISTR that was the reason
>> why I didn't do the d_revalidate thing, but I don't think it really
>> matters.  dnotify on sysfs nodes doesn't work properly anyway.
> 
> Reasonable.  I have seen two ways of handling rename properly.
> Some weird variant d_splice_alias or some cleaner variant of what
> we are doing today.

FWIW, I think it would be just fine to invalidate the renamed dentry.

>>> 4) For finer locking granularity of readdir.  All we need to do is do
>>>    the semi-expensive restart for each dirent, and the problem is
>>>    trivially solved.
>> That can show the same entry multiple times or skip existing entries.
>> I think it's better to put fake entries and implement iterators.
> 
> The guarantee is that we will see all entries that are there for the
> duration of readdir, we order the directory by inode, and stick
> the inode number in f_pos.  So now we don't have the problem of
> returning the same entry multiple times or skipping existing entries.

Right, great.  :-)

>>> 5) Large directories are a potential performance problem in sysfs.
>> Yes, it is.  It hasn't been an issue till now.  You're worrying about
>> look up performance, right? 
> 
> Lookup, create, unlink and if we drop the lock during readdir, readdir
> restart.  The all require a linear scan.
> 
>> If that's a real concern we can link sd's
>> into a hash table, but I'm not sure tho.  For listing, O(n) is the
>> best we can do anyway and after the initial lookup, the result would
>> be cached via dcache anyway, so I'm not really sure how much adding a
>> hashtable will buy us.
> 
> Depends on how many devices people are adding and removing dynamically
> I guess.  sysctl has had that issue so I am thinking about it.  I
> figure we need to make things work properly first.

Yeap, let's think about optimization later.  The problem hasn't come
up yet even on machines where the memory footprint of sysfs dentries
and inodes posed serious problems, so I don't think optimizing it is a
high priority at this point.

>>> Leakage and being able to fool an application that it has the entire
>>> kernel to itself are not concerns.  The goal is simply to get the
>>> entire object name to object translation boundary and the namespace
>>> work is done.  We have largely achieved, and the code to do
>>> so once complete is reasonable enough that it should be no
>>> worse than dealing with any other kernel bug.
>> Yes, I'm aware of the goals.  What I'm curious about is the consensus
>> regarding network namespace and all its implications.  It adds a lot
>> of complexities over a lot of places.
> 
> Not really.  It is really very straight forward. 99% of the modified
> code simply has an extra pointer dereference.  
> 
> Except for sysfs the network namespace code that has merged is in a
> very usable state.  There are a few little things like iptables
> support that still needs some work.  From a practical standpoint sysfs
> was one of the first things I started working on and it is one of the
> last things to be done.
> 
>> e.g. following the sysfs code
>> becomes quite a bit more difficult after the namespace changes (maybe
>> it's just me but still).
> 
> Some of it yes.  Which asks for a more comprehensive solution.  Part
> of the challenge is that there has been insistence on an especially
> generic solution, in sysfs and I'm not certain that has helped.

Well, I suppose most of that blame falls on me but I still can't bring
myself to agree with the current implementation.  The biggest problem
I have is that the implementation doesn't really show in straight
forward manner what it tries to achieve (showing partial tree
depending on sb).

>> So, I was asking whether people generally agree that having the
>> namespace thing is worth the added complexities.
> 
> To my knowledge yes.  Most of the cost is trivial, and it makes
> a darn good excuse to clean up problem code.

Getting the clean up part in usually isn't a problem, right?  But
getting in the actual namespace part is (and should be).

>> I think it serves pretty small group of users.  Hosting service
>> providers and people trying to migrate processes from one machine to
>> another, both of which can be served pretty well with virtualization.
>> It does have higher overhead both processing power and memory wise but
>> IIUC the former is being actively worked on w/ new processor features
>> like nested paging tables and all and memory is really cheap these
>> days, so I'm a bit skeptical how much this is needed and how much we
>> should pay for it.
> 
> So far sysfs is the most costly and the hardest part.  Most of the
> cost is in the noise and in the design.

As ugly as it is, it's designed to export internal data structure
as-is to userland and bound tightly with the driver model in
not-so-orthodox way, so it's not very inclined to dance at the tune of
namespaces.  :-)

> One thing the namespaces fundamentally get you is scaling.  You can
> run probably 10x more environments on a single server.  Which makes
> then cheaper and available, on all hardware.
> 
> Beyond that there are people who actually just want to use a single
> namespace for what you can do.  They are general tools and are useful
> in more ways than just checkpoint restart and virtualization.
> 
> Think what happens if you are a switch/router and you switch two
> different networks both using overlaping addresses in the 10.x segment.
> 
> Or think how much easier it is to test routing with just a single machine.
> 
> All kinds of interesting uses.

Other than the scaling argument which probably applies mostly to the
hosting people, I also find other usages interesting but not sure how
popular they would be.

>> Another venue to explore is whether the partial view of proc and sysfs
>> can be implemented in less pervasive way.  Implementing it via FUSE
>> might not be easier per-se but I think it would be better to do it
>> that way if we can instead of adding complexities to both proc and
>> sysfs.
> 
> This isn't a partial view thing really.  This is how do I put it all
> in there not have conflicts and preserve backwards compatibility.
> 
> In proc.  I have work as hard as I can to build a design that will let
> us see it all without sacrificing backwards compatibility.  With /proc/<pid>
> I have a natural place to put data in a per process view.  I don't
> have that in sysfs, and sysfs at some point stopped being about just
> the hardware.  So the only way I have found to have places for everything
> is to do multiple mounts.

As I wrote above, FUSE can modify or create data in-flight, but it's
not like proc and sysfs are the only ones which need to be changed, so
it might not matter after all.

>> One last thing that came to mind is, how would uevents be handled?
>> ie. what happens if a network card which is presented as ethN in the
>> namespace goes away?  How does the system deal with it?
> 
> It is probably worth a double check.  Coming in all physical network
> devices happen in the initial network namespace so that direction isn't
> a problem.  Worse case I expect we figure out how to add a field that
> specifies enough about the network namespace so the events can be relayed
> to appropriate part of user space.

Thanks.

-- 
tejun
