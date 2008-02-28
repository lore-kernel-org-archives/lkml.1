Return-Path: <linux-kernel-owner+w=401wt.eu-S1757508AbYB1Hvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbYB1Hvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 02:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYB1Hvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 02:51:41 -0500
Received: from sacred.ru ([62.205.161.221]:55558 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYB1Hvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 02:51:40 -0500
Message-ID: <47C667EC.6060700@openvz.org>
Date: Thu, 28 Feb 2008 10:51:08 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] autofs4 - track uid and gid of last mount requestor
References: <Pine.LNX.4.64.0802261151400.8490@raven.themaw.net>	 <Pine.LNX.4.64.0802261208400.8490@raven.themaw.net>	 <20080227204546.72e16e8d.akpm@linux-foundation.org>	 <1204179747.3501.21.camel@raven.themaw.net>	 <20080227223734.caab0165.akpm@linux-foundation.org> <1204182500.3501.49.camel@raven.themaw.net>
In-Reply-To: <1204182500.3501.49.camel@raven.themaw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 28 Feb 2008 10:51:06 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote:
> On Wed, 2008-02-27 at 22:37 -0800, Andrew Morton wrote:
>> On Thu, 28 Feb 2008 15:22:27 +0900 Ian Kent <raven@themaw.net> wrote:
>>
>>>>> +++ linux-2.6.25-rc2-mm1/fs/autofs4/waitq.c	2008-02-20 13:10:23.000000000 +0900
>>>>> @@ -363,6 +363,38 @@ int autofs4_wait(struct autofs_sb_info *
>>>>>  
>>>>>  	status = wq->status;
>>>>>  
>>>>> +	/*
>>>>> +	 * For direct and offset mounts we need to track the requestor
>>>>> +	 * uid and gid in the dentry info struct. This is so it can be
>>>>> +	 * supplied, on request, by the misc device ioctl interface.
>>>>> +	 * This is needed during daemon resatart when reconnecting
>>>>> +	 * to existing, active, autofs mounts. The uid and gid (and
>>>>> +	 * related string values) may be used for macro substitution
>>>>> +	 * in autofs mount maps.
>>>>> +	 */
>>>>> +	if (!status) {
>>>>> +		struct dentry *de = NULL;
>>>>> +
>>>>> +		/* direct mount or browsable map */
>>>>> +		ino = autofs4_dentry_ino(dentry);
>>>>> +		if (!ino) {
>>>>> +			/* If not lookup actual dentry used */
>>>>> +			de = d_lookup(dentry->d_parent, &dentry->d_name);
>>>>> +			ino = autofs4_dentry_ino(de);
>>>>> +		}
>>>>> +
>>>>> +		/* Set mount requestor */
>>>>> +		if (ino) {
>>>>> +			if (ino) {
>>>>> +				ino->uid = wq->uid;
>>>>> +				ino->gid = wq->gid;
>>>>> +			}
>>>>> +		}
>>>>> +
>>>>> +		if (de)
>>>>> +			dput(de);
>>>>> +	}
>>>>> +
>>>> But uids and gids are no longer system-wide-unique.  Two different users
>>>> can have the same identifiers in different namespaces.  What happens then?
>>> That's a tricky question.
>>>
>>> Presumably, the process requesting the mount has the user space daemon
>>> running in the namespace within which the uid and gid are to be looked
>>> up, by the daemon.
>>>
>>> Am I missing something?
>>>
>> err, you assume more knowledge at this end about what you're trying to do
>> than actually exists :)
>>
>> You seem to imply that if a machine is running 100 user namespaces then it
>> needs to run 100 mount daemons.  Doesn't seem good.
> 
> More likely my lack of understanding of how namespaces are meant to
> work.
> 
>> What problem are you actually trying to solve here?
> 
> The basic problem arises only when we want to restart the user space
> daemon and there are active autofs managed mounts in place at exit (ie.
> autofs mounts that have busy user mounts). They are left mounted and
> processes using them continue to function. But then, when we startup
> autofs we need to reconnect to these autofs mounts, some of which can
> covered the by mounted file systems, and hence the need for another way
> to open an ioctl descriptor to them.
> 
> It may have been overkill to re-implement all the current ioctls (and
> add a couple of other much needed ones) but I though it sensible for
> completeness, and we get to identify any possible problems the current
> ioctls might have had due to the use of the BKL (by the VFS when calling
> the ioctls).
> 
> So, why do we need the uid and gid? When someone walks over an autofs
> dentry that is meant to cause a mount we send a request packet to the
> daemon via a pipe which includes the process uid and gid, and as part of
> the lookup we set macros for several mount map substitution variables,
> derived from the uid and gid of the process requesting the mount and
> they can be used within autofs maps.

Why do we need the uid then? Is just pid not enough to uniquely 
identify a task?

Assuming we can get by with a pid only, this problem can be solved
by sending a pid_nr() of a task, i.e. the pid by which this task is
seen from an initial namespace. This pid is unique across the system
even when pid namespaces are created.

But this ... trick is only valid if the daemon, that receives the 
pid doesn't try to communicate with this task (e.g. send him a signal),
but just uses this as a key to lookup in some hash. This is not about
security - even having someone's global pid task can do nothing useful 
with it - this is about the consistency - when sending a signal to a
task, giving its _global_ pid to sys_kill() the signal may arrive to a 
wrong task if the sender lives in a sub-namespace.

> This is all fine as long as we don't need to re-connect to these mounts
> when starting up, since we don't get kernel requests for the mounts, we
> need to obtain that information from the active mount itself.
> 
> Ian
> 
> 
> 
> 

