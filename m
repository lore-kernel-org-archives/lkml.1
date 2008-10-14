Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYJNMU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYJNMU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 08:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYJNMUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 08:20:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39060 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYJNMUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:20:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net> <m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org>
	<m1myh8rnf4.fsf@frodo.ebiederm.org> <48F45075.7000003@kernel.org>
Date: Tue, 14 Oct 2008 05:19:10 -0700
In-Reply-To: <48F45075.7000003@kernel.org> (Tejun Heo's message of "Tue, 14
	Oct 2008 16:55:33 +0900")
Message-ID: <m1ej2jjrnl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Aieeeee... I wanna run screaming and crying.  Any chance these can be
> done using FUSE?  FUSE is pretty flexible and should be able to
> emulate most of proc files w/o too much difficulty.

I don't see how FUSE can help.  The problem is getting the information 
out of the kernel, and not breaking backwards compatiblity while we
do it.  As I understand FUSE it just allows for user space filesystems.
Which is great if I want to hide information.

> And can we do the same thing for sysfs using FUSE?  So that not only
> the policy but also the implementation is in userland?  The changes
> are quite pervasive and makes the whole thing pretty difficult to
> follow.

I don't see how.  If userspace doesn't have the information I don't
see how placing a filter will allow it to show up there.

The challenge is to not conflict on network device names.  If someone can
think of where we can put the network devices that are in different
network namespaces in sysfs so they don't conflict when they have the
same name I have no problem with that.  But where can we put them?

>> From the perspective of the internal sysfs data structures tagged
>> dirents are clean and simple so I don't see a reason to re-architect
>> that.
>
> Heh... you know I have some reservations on that one too.  :-)

Well compared to the rest of it the part with dirents is just a handful
of lines of code.  The vfs part is the expensive and hairy part.

>> I have spent the last several days looking deeply at what the vfs
>> can do, and how similar situations are handled.  My observations
>> are:
>
> Thanks.  Much appreciated.
>
>> 1) exportfs from nfsd is similar to our kobject to sysfs_dirent layer,
>>    and solves that set of problems cleanly, including remote rename.
>>    So there is no fundamental reason we need inverted twisting locking in
>>    sysfs, or otherwise violate existing vfs rules.
>
> eGreat.  IIRC, it does it by not moving the existing dentry but
> invalidating it, right?
>
> The current twisted state is more of what's left from the original
> tree-of-dentries-and-inodes implementation.  It would be great to do
> proper distributed fs instead.

Yes.  I am looking at that.

>> 2) i_mutex seems to protect very little if anything that we care about.
>>    The dcache has it's own set of locks.  So we may be able to completely
>>    avoid taking i_mutex in sysfs and simplify things enormously.
>>    Currently I believe we are very similar to ocfs2 in terms of locking
>>    requirements.
>
> I think the timestamps are one of the things it protects.

Yes.  I think parts of the page cache and anything in the inode itself
is protected by i_mutex.  As for timestamsp or anything else that
we really care about we can and should put them in sysfs_dirent and
we can have the stat method recreate it, and possibly have d_revalidate
refresh it.

>> 3) For i_notify and d_notify that seems to require pinning the inode
>>    or the dentry in question, so I see no reason why a d_revalidate
>>    style of update will have problems.
>
> Because the existing notifications won't be moved over to the new
> dentry.  dnotify wouldn't work the same way.  ISTR that was the reason
> why I didn't do the d_revalidate thing, but I don't think it really
> matters.  dnotify on sysfs nodes doesn't work properly anyway.

Reasonable.  I have seen two ways of handling rename properly.
Some weird variant d_splice_alias or some cleaner variant of what
we are doing today.

>> 4) For finer locking granularity of readdir.  All we need to do is do
>>    the semi-expensive restart for each dirent, and the problem is
>>    trivially solved.
>
> That can show the same entry multiple times or skip existing entries.
> I think it's better to put fake entries and implement iterators.

The guarantee is that we will see all entries that are there for the
duration of readdir, we order the directory by inode, and stick
the inode number in f_pos.  So now we don't have the problem of
returning the same entry multiple times or skipping existing entries.

>> 5) Large directories are a potential performance problem in sysfs.
>
> Yes, it is.  It hasn't been an issue till now.  You're worrying about
> look up performance, right? 

Lookup, create, unlink and if we drop the lock during readdir, readdir
restart.  The all require a linear scan.

> If that's a real concern we can link sd's
> into a hash table, but I'm not sure tho.  For listing, O(n) is the
> best we can do anyway and after the initial lookup, the result would
> be cached via dcache anyway, so I'm not really sure how much adding a
> hashtable will buy us.

Depends on how many devices people are adding and removing dynamically
I guess.  sysctl has had that issue so I am thinking about it.  I
figure we need to make things work properly first.

>> So it appears that the path forward is:
>> - Cleanup sysfs locking and other issues.
>> - Return to the network namespace code.
>> 
>> Possibly with an intermediate step of only showing the network
>> devices in the initial network namespace in sysfs.
>> 
>>> Can somebody hammer the big picture regarding namespaces into my
>>> small head?
>> 
>> 100,000 foot view.  A namespace introduces a scope so multiple
>> objects can have the same name.  Like network devices.
>> 
>> 10,000 foot view.  The network namespace looks to user space
>> as if the kernel has multiple independent network stacks.
>> 
>> 1000 foot view.  I have two network devices named lo, and sysfs
>> does not currently have a place for me to put them.
>> 
>> Leakage and being able to fool an application that it has the entire
>> kernel to itself are not concerns.  The goal is simply to get the
>> entire object name to object translation boundary and the namespace
>> work is done.  We have largely achieved, and the code to do
>> so once complete is reasonable enough that it should be no
>> worse than dealing with any other kernel bug.
>
> Yes, I'm aware of the goals.  What I'm curious about is the consensus
> regarding network namespace and all its implications.  It adds a lot
> of complexities over a lot of places.

Not really.  It is really very straight forward. 99% of the modified
code simply has an extra pointer dereference.  

Except for sysfs the network namespace code that has merged is in a
very usable state.  There are a few little things like iptables
support that still needs some work.  From a practical standpoint sysfs
was one of the first things I started working on and it is one of the
last things to be done.

> e.g. following the sysfs code
> becomes quite a bit more difficult after the namespace changes (maybe
> it's just me but still).

Some of it yes.  Which asks for a more comprehensive solution.  Part
of the challenge is that there has been insistence on an especially
generic solution, in sysfs and I'm not certain that has helped.

> So, I was asking whether people generally
> agree that having the namespace thing is worth the added complexities.

To my knowledge yes.  Most of the cost is trivial, and it makes
a darn good excuse to clean up problem code.

> I think it serves pretty small group of users.  Hosting service
> providers and people trying to migrate processes from one machine to
> another, both of which can be served pretty well with virtualization.
> It does have higher overhead both processing power and memory wise but
> IIUC the former is being actively worked on w/ new processor features
> like nested paging tables and all and memory is really cheap these
> days, so I'm a bit skeptical how much this is needed and how much we
> should pay for it.

So far sysfs is the most costly and the hardest part.  Most of the
cost is in the noise and in the design.

One thing the namespaces fundamentally get you is scaling.  You can
run probably 10x more environments on a single server.  Which makes
then cheaper and available, on all hardware.

Beyond that there are people who actually just want to use a single
namespace for what you can do.  They are general tools and are useful
in more ways than just checkpoint restart and virtualization.

Think what happens if you are a switch/router and you switch two
different networks both using overlaping addresses in the 10.x segment.

Or think how much easier it is to test routing with just a single machine.

All kinds of interesting uses.

> Another venue to explore is whether the partial view of proc and sysfs
> can be implemented in less pervasive way.  Implementing it via FUSE
> might not be easier per-se but I think it would be better to do it
> that way if we can instead of adding complexities to both proc and
> sysfs.

This isn't a partial view thing really.  This is how do I put it all
in there not have conflicts and preserve backwards compatibility.

In proc.  I have work as hard as I can to build a design that will let
us see it all without sacrificing backwards compatibility.  With /proc/<pid>
I have a natural place to put data in a per process view.  I don't
have that in sysfs, and sysfs at some point stopped being about just
the hardware.  So the only way I have found to have places for everything
is to do multiple mounts.

> One last thing that came to mind is, how would uevents be handled?
> ie. what happens if a network card which is presented as ethN in the
> namespace goes away?  How does the system deal with it?

It is probably worth a double check.  Coming in all physical network
devices happen in the initial network namespace so that direction isn't
a problem.  Worse case I expect we figure out how to add a field that
specifies enough about the network namespace so the events can be relayed
to appropriate part of user space.

Eric

