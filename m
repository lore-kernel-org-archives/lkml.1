Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZLIGQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZLIGQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbZLIGQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:16:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50810 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZLIGQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:16:42 -0500
Message-ID: <4B1F3F13.2080809@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 14:09:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: LKML <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu> <4B1E0283.70108@cn.fujitsu.com> <20091209055016.GA12342@andrew.cmu.edu> <4B1F3EB9.6080502@cn.fujitsu.com>
In-Reply-To: <4B1F3EB9.6080502@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "To" and "Cc"..

Li Zefan wrote:
> Ben Blum wrote:
>> On Tue, Dec 08, 2009 at 03:38:43PM +0800, Li Zefan wrote:
>>>> @@ -1291,6 +1324,7 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>>>>  	struct cgroupfs_root *new_root;
>>>>  
>>>>  	/* First find the desired set of subsystems */
>>>> +	down_read(&subsys_mutex);
>>> Hmm.. this can lead to deadlock. sget() returns success with sb->s_umount
>>> held, so here we have:
>>>
>>> 	down_read(&subsys_mutex);
>>>
>>> 	down_write(&sb->s_umount);
>>>
>>> On the other hand, sb->s_umount is held before calling kill_sb(),
>>> so when umounting we have:
>>>
>>> 	down_write(&sb->s_umount);
>>>
>>> 	down_read(&subsys_mutex);
>> Unless I'm gravely mistaken, you can't have deadlock on an rwsem when
>> it's being taken for reading in both cases? You would have to have at
>> least one of the cases being down_write.
>>
> 
> lockdep will warn on this..
> 
> And it can really lead to deadlock, though not so obivously:
> 
>   thread 1       thread 2        thread 3
> -------------------------------------------
> | read(A)        write(B)
> |
> |                                write(A)
> |
> |                read(A)
> |
> | write(B)
> |
> 
> t3 is waiting for t1 to release the lock, then t2 tries to
> acquire A lock to read, but it has to wait because of t3,
> and t1 has to wait t2.
> 
> Note: a read lock has to wait if a write lock is already
> waiting for the lock.
> 
>> In fairness to readability, perhaps subsys_mutex should instead be
>> subsys_rwsem? It seemed to me to be that calling it "mutex" was
>> conventional anyway.
>>

