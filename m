Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYJNBU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYJNBU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYJNBUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:20:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35512 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYJNBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:20:07 -0400
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
Date: Mon, 13 Oct 2008 18:11:11 -0700
In-Reply-To: <48EBF21E.40709@kernel.org> (Tejun Heo's message of "Wed, 08 Oct
	2008 08:34:54 +0900")
Message-ID: <m1myh8rnf4.fsf@frodo.ebiederm.org>
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
	*      [score: 0.4792]
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

> Hello, Greg.
>
> Greg KH wrote:
>> On Tue, Oct 07, 2008 at 01:27:17AM -0700, Eric W. Biederman wrote:
>>> Unless someone will give an example of how having multiple superblocks
>>> sharing inodes is a problem in practice for sysfs and call it good
>>> for 2.6.28.  Certainly it shouldn't be an issue if the network namespace
>>> code is compiled out.  And it should greatly improve testing of the
>>> network namespace to at least have access to sysfs.
>> 
>> But if the network namespace code is in?  THen we have problems, right?
>> And that's the whole point here.
>> 
>> The fact that you are trying to limit userspace view of in-kernel data
>> structures, based on that specific user, is, in my opinion, crazy.
>
> Well, that's the whole point of all the namespace stuff.  If we're
> gonna do namespaces, view of in-kernel data structures need to be
> limited and modified one way or the other.
>
>> Why not just keep all users from seeing sysfs, and then have a user
>> daemon doing something on top of FUSE if you really want to see this
>> kind of stuff.
>
> That sounds nice.  Out of ignorance, how is the /proc dealt with?
> Maybe we can have some unified approach for this multiple views of the
> system stuff.

/proc uses just about every trick in the book to make this work.

/proc/sys uses a magic d_compare method.
      
/proc/net becomes a symlink to /proc/<pid>/net and we get completely
      different directory trees below that.   Shortly that code will
      use auto mounts of a proc_net filesystem, that has different
      super blocks one for each different network namespace.

/proc/sysvipc/* simply returns different values from it's files depending
      upon which process is reading them.

/proc itself has multiple super blocks one for each different pid namespace.

The long term direction is to be able to see everything at once.  If
you mount all of the filesystems multiple times in the proper way.
That allows monitoring software to watch what is going on inside of a
container without a challenge, and it makes it a user space policy
decision how much an individual container sees.

For sysfs there isn't have the option of putting things under
/proc/<pid>, the directories I am interested in (at least for network
devices) are scattered all over sysfs and come and go with device
hotplug events so I don't see a realistic way of splitting those
directories out into their own filesystem.

>From a user interface design perspective I don't see a good
alternative to having /sys/class/net/, /sys/virtual/net/, and all of
the other directories different based on network namespace.  Then have
the network namespace be specified by super block.  Looking at current
and doing the magic d_compare trick almost works, but it runs into
problems with sysfs_get_dentry.

>From the perspective of the internal sysfs data structures tagged
dirents are clean and simple so I don't see a reason to re-architect
that.

I have spent the last several days looking deeply at what the vfs
can do, and how similar situations are handled.  My observations
are:
1) exportfs from nfsd is similar to our kobject to sysfs_dirent layer,
   and solves that set of problems cleanly, including remote rename.
   So there is no fundamental reason we need inverted twisting locking in
   sysfs, or otherwise violate existing vfs rules.
2) i_mutex seems to protect very little if anything that we care about.
   The dcache has it's own set of locks.  So we may be able to completely
   avoid taking i_mutex in sysfs and simplify things enormously.
   Currently I believe we are very similar to ocfs2 in terms of locking
   requirements.
3) For i_notify and d_notify that seems to require pinning the inode
   or the dentry in question, so I see no reason why a d_revalidate
   style of update will have problems.
4) For finer locking granularity of readdir.  All we need to do is do
   the semi-expensive restart for each dirent, and the problem is
   trivially solved.
5) Large directories are a potential performance problem in sysfs.

So it appears that the path forward is:
- Cleanup sysfs locking and other issues.
- Return to the network namespace code.

Possibly with an intermediate step of only showing the network
devices in the initial network namespace in sysfs.

> Can somebody hammer the big picture regarding namespaces into my
> small head?

100,000 foot view.  A namespace introduces a scope so multiple
objects can have the same name.  Like network devices.

10,000 foot view.  The network namespace looks to user space
as if the kernel has multiple independent network stacks.

1000 foot view.  I have two network devices named lo, and sysfs
does not currently have a place for me to put them.

Leakage and being able to fool an application that it has the entire
kernel to itself are not concerns.  The goal is simply to get the
entire object name to object translation boundary and the namespace
work is done.  We have largely achieved, and the code to do
so once complete is reasonable enough that it should be no
worse than dealing with any other kernel bug.

Eric


