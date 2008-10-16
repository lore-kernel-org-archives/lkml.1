Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYJPWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYJPWA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbYJPWAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:00:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58597 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYJPWAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:00:12 -0400
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
	<m1ej2jjrnl.fsf@frodo.ebiederm.org> <48F5CE43.2030207@kernel.org>
Date: Thu, 16 Oct 2008 14:58:12 -0700
In-Reply-To: <48F5CE43.2030207@kernel.org> (Tejun Heo's message of "Wed, 15
	Oct 2008 20:04:35 +0900")
Message-ID: <m1r66gb3t7.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Eric W. Biederman wrote:
>> Tejun Heo <tj@kernel.org> writes:



>>>> 2) i_mutex seems to protect very little if anything that we care about.
>>>>    The dcache has it's own set of locks.  So we may be able to completely
>>>>    avoid taking i_mutex in sysfs and simplify things enormously.
>>>>    Currently I believe we are very similar to ocfs2 in terms of locking
>>>>    requirements.
>>> I think the timestamps are one of the things it protects.
>> 
>> Yes.  I think parts of the page cache and anything in the inode itself
>> is protected by i_mutex.  As for timestamsp or anything else that
>> we really care about we can and should put them in sysfs_dirent and
>> we can have the stat method recreate it, and possibly have d_revalidate
>> refresh it.
>
> Some of the timestamps are not on the sysfs_dirent because 1. nobody
> cared (the original sd implementation didn't preserve it) and
> 2. of memory overhead.

Yep.  Which basically boils down to nobody cared.


>>>> 3) For i_notify and d_notify that seems to require pinning the inode
>>>>    or the dentry in question, so I see no reason why a d_revalidate
>>>>    style of update will have problems.
>>> Because the existing notifications won't be moved over to the new
>>> dentry.  dnotify wouldn't work the same way.  ISTR that was the reason
>>> why I didn't do the d_revalidate thing, but I don't think it really
>>> matters.  dnotify on sysfs nodes doesn't work properly anyway.
>> 
>> Reasonable.  I have seen two ways of handling rename properly.
>> Some weird variant d_splice_alias or some cleaner variant of what
>> we are doing today.
>
> FWIW, I think it would be just fine to invalidate the renamed dentry.

I have a working implementation now and it needs a little bit of cleanup.
The patch that gets me there is to big.

I have realized the following things.
1) Keeping the VFS in sync with the sysfs_dirent tree is impossible
   because the VFS occasionally denies operations for internal
   consistency reasons (think removing a mount point from the dcache)
   and getting the sysfs_dirent tree out of sync with the kobject
   tree could get very hairy.

2) For a distributed filesystem there are small races in lookup
   and revalidate between when the change was made and when it
   appears so lookup and revalidate need to cope.

3) fsnotify and the like is pointless to worry about because it looks
   like only sysfs_file_chmod does the necessary magic and
   sysfs_file_chmod appears to only happen at file creation.

4) If we really need to we can run what is essentially sysfs_get_dirent
   after the appropriate operations and in a timely manner see
   renames and have notifications, but I don't think the cost
   is worth it.

>> Depends on how many devices people are adding and removing dynamically
>> I guess.  sysctl has had that issue so I am thinking about it.  I
>> figure we need to make things work properly first.
>
> Yeap, let's think about optimization later.  The problem hasn't come
> up yet even on machines where the memory footprint of sysfs dentries
> and inodes posed serious problems, so I don't think optimizing it is a
> high priority at this point.

Agreed, worry about optimization later.  Except at the extreme end it
isn't a real issue.  I keep thinking about it because it has come up
with sysctl.  When creating lots of virtual network devices.  sysfs is
the next obvious target.


> Well, I suppose most of that blame falls on me but I still can't bring
> myself to agree with the current implementation.  The biggest problem
> I have is that the implementation doesn't really show in straight
> forward manner what it tries to achieve (showing partial tree
> depending on sb).

Alright.

I guess we really need to talk about this some more and look at patches.
I expect some of the blame falls on me for being a bit impatient.  sysfs
has not been the interesting part just a silly little filesystem that
is in the way.


> Getting the clean up part in usually isn't a problem, right?  But
> getting in the actual namespace part is (and should be).

Nah.  Getting the namespace design agreed to is the hard part.
Once everyone is on the same page namespace patches are no harder
than any others.  Unfortunately it looks like we really haven't
agreed to the design.



So back to basics.  Where I think we should go from 10,000 feet.

- Multiple superblocks for sysfs.
- Each superblock showing the devices in sysfs from a different network namespace.
- There should be one instance of uevent_sock for each network namespae.
- kobject_uevents should be out all uevent_socks unless it is for a network device.
- kobject_uevents should be sent out the uevent_sock for their network namespae.
- kobject_uevents for network devices no in the initial network namespace will not
  be sent with uevent_helper.

Reasons.

Foremost namespaces don't have names.  Namespaces without names
allow us to have nested containers.

Without a name for the network namespace there is not a way to create
a unique entry in sysfs for each network device.  As the network device
names themselves can repeat in each network namespace.  So I have chosen
the point of user space control the mount of sysfs to encode the network
namespace information.  This allows everything to be visible and user space
to still set policy.

Without a change to the policy of how things are named in sysfs the existing
user space code will just work.  Both inside and outside a network namespace.

Since the network namespace is available on the kobject it is easy to stuff
packets into the correct socket and user space code will just work.

Since uevent_helper is a limited and essentially legacy mechanism it makes sense
to only tell it about devices in the initial network namespace.


What clinches it for me is that even if network namespaces had names if we don't
have a different view on different mounts I don't see how we could put network
devices in sysfs without breaking user space backwards compatibility.

Eric
