Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbZLJDS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbZLJDS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbZLJDSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:18:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56519 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758730AbZLJDSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:18:23 -0500
Message-ID: <4B20686E.3070907@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 11:18:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu> <4B1E0283.70108@cn.fujitsu.com> <20091209055016.GA12342@andrew.cmu.edu> <4B1F3EB9.6080502@cn.fujitsu.com> <20091209082729.GA14114@andrew.cmu.edu>
In-Reply-To: <20091209082729.GA14114@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> @@ -1291,6 +1324,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>>>>>  	struct cgroupfs_root *new_root;
>>>>>  
>>>>>  	/* First find the desired set of subsystems */
>>>>> +	down_read(&subsys_mutex);
>>>> Hmm.. this can lead to deadlock. sget() returns success with sb->s_umount
>>>> held, so here we have:
>>>>
>>>> 	down_read(&subsys_mutex);
>>>>
>>>> 	down_write(&sb->s_umount);
>>>>
>>>> On the other hand, sb->s_umount is held before calling kill_sb(),
>>>> so when umounting we have:
>>>>
>>>> 	down_write(&sb->s_umount);
>>>>
>>>> 	down_read(&subsys_mutex);
>>> Unless I'm gravely mistaken, you can't have deadlock on an rwsem when
>>> it's being taken for reading in both cases? You would have to have at
>>> least one of the cases being down_write.
>>>
>> lockdep will warn on this..
> 
> Hm. Why did I not see this warning...?
> 

Because you haven't triggered it. ;)

The scripts below can trigger the warning (at least for me):

# cat test1.sh
#! /bin/sh
for ((; ;))
{
        mount -t cgroup -o devices xxx /cgroup1
        umount /cgroup1
}

# cat test2.sh
#! /bin/sh
for ((; ;))
{
        mount -t cgroup -o devices xxx /cgroup2
        umount /cgroup2
}


>> And it can really lead to deadlock, though not so obivously:
>>
>>   thread 1       thread 2        thread 3
>> -------------------------------------------
>> | read(A)        write(B)
>> |
>> |                                write(A)
>> |
>> |                read(A)
>> |
>> | write(B)
>> |
>>
>> t3 is waiting for t1 to release the lock, then t2 tries to
>> acquire A lock to read, but it has to wait because of t3,
>> and t1 has to wait t2.
>>
>> Note: a read lock has to wait if a write lock is already
>> waiting for the lock.
> 
> Okay, clever, the deadlock happens because of a behavioural optimization
> of the rwsems. Good catch on the whole issue.
> 
> How does this sound as a possible solution, in cgroup_get_sb:
> 
> 1) Take subsys_mutex
> 2) Call parse_cgroupfs_options()
> 3) Drop subsys_mutex
> 4) Call sget(), which gets sb->s_umount without subsys_mutex held
> 5) Take subsys_mutex
> 6) Call verify_cgroupfs_options()
> 7) Proceed as normal
> 
> In which verify_cgroupfs_options will be a new function that ensures the
> invariants that rebind_subsystems expects are still there; if not, bail
> out by jumping to drop_new_super just as if parse_cgroupfs_options had
> failed in the first place.
> 

The current code doesn't need this verify_cgroupfs_options, so why it
will become necessary? I think what we need is grab module refcnt in
parse_cgroupfs_options, and then we can drop subsys_mutex.

But why you are using a rw semaphore? I think a mutex is fine.
And why not just use cgroup_mutex to protect the subsys[] array?
The adding and spreading of subsys_mutex looks ugly to me.

> Another question: What's the justification for having an interface of
> seemingly symmetrical "initialize" and "destroy" functions, one of which
> has to take a lock and the other gets called with the lock already held?
> Seems like it's asking for trouble.
> 

Are you refering to get_sb() and kill_sb()? VFS is not my area, so I'm
not going to judge it. ;)

