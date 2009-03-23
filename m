Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbZCWU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbZCWU3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758884AbZCWU3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:29:01 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:34912 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592AbZCWU27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:28:59 -0400
Date: Mon, 23 Mar 2009 13:28:37 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shai@scalex86.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rfc] [patch 1/2 ] Process private hash tables for private
	futexes
Message-ID: <20090323202837.GE7278@localdomain>
References: <20090321044637.GA7278@localdomain> <49C4AE64.4060400@cosmosbay.com> <20090322045414.GD7278@localdomain> <49C5F3FD.9010606@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C5F3FD.9010606@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 09:17:01AM +0100, Eric Dumazet wrote:
>Ravikiran G Thirumalai a écrit :
>>>
>>> Did you tried to change FUTEX_HASHBITS instead, since current value is really really
>>> ridiculous ?
>> 
>> We tried it in the past and I remember on a 16 core machine, we had to
>> use 32k hash slots to avoid false sharing.
>> 
>> 
>> Yes, dynamically changing the hash table is better (looking at the patch you
>> have posted), but still there are no locality guarantees here.  A process
>> pinned to node X may still end up accessing remote memory locations while
>> accessing the hash table.  A process private table on the other hand should
>> not have this problem. I think using a global hash for entirely process local
>> objects is bad design wise here.
>> 
>> 
>
>
>Bad design, or bad luck... considering all kernel already use such global tables
>(dentries, inodes, tcp, ip route cache, ...).

Not necessarily.  The dentry/inode/route caches need to be shared by
processes so a global cache makes sense there -- the private futexes need to
be only shared between threads of the process rather than the entire world.

>
>Problem is to size this hash table, being private or not. You said hou had
>to have a 32768 slots to avoid false sharing on a 16 core machine. This seems
>strange to me, given we use jhash. What is the size of the cache line on your
>platforms ???

It is large and true these bad effects get magnified with larger cache lines.
However, this does forewarn other architectures of problems such as these.
Access to the below virtual addresses were seen to cause cache trashing
between nodes on a vSMP system.  The eip corresponds to the  spin_lock
on a 2.6.27 kernel at 'futex_wake' (see end of email).
Obviously these addresses correspond to the spinlock on the hash buckets,
and this was a threaded FEA solver workload on a 32 core machine.
As can be seen, this is a problem even on a machine with 64b cacheline.


>
>Say we have 32768 slots for the global hash table, and 256 slots for a private one,
>you probably can have a program running slowly with this private 256 slots table,
>if this program uses all available cores.

True, as I replied to akpm in this thread, if a workload happens to be one
multi-threaded process with a zillion threads, the workload will have bigger
overheads due to the sharing of process address space and mmap_sem.  Atleast
that has been our experience so far.  Private futex hashes solve the
problem on hand.

>
>If we use large private hash table, the setup cost is higher (need to initialize
>all spinlocks and plist heads at each program startup), unless we use a dedicate
>kmem_cache to keep a pool of preinitialized priv hash tables...
>


Hmm!  How about
a) Reduce hash table size for private futex hash and increase hash table
   size for the global hash?

OR, better,

b) Since it is multiple spinlocks on the same cacheline which is a PITA
   here, how about keeping the global table, but just add a dereference
   to each hash slot, and interleave the adjacent hash buckets between
   nodes/cpus? So even without needing to  lose out memory from padding,
   we avoid false sharing on cachelines due to unrelated futexes hashing
   onto adjacent hash buckets?

Thanks,
Kiran


Cache misses at futex_wake due to access to the following addresses:
-------------------------------------------------------------------
fffff819cc180
fffff819cc1d0
fffff819cc248
fffff819cc310
fffff819cc3b0
fffff819cc400
fffff819cc568
fffff819cc5b8
fffff819cc658
fffff819cc770
fffff819cc798
fffff819cc838
fffff819cc8d8
fffff819cc9c8
fffff819cc9f0
fffff819cca90
fffff819ccae0
fffff819ccb08
fffff819ccd38
fffff819ccd88
fffff819ccdb0
fffff819cce78
fffff819ccf18
fffff819ccfb8
fffff819cd030
fffff819cd058
fffff819cd148
fffff819cd210
fffff819cd260
fffff819cd288
fffff819cd2b0
fffff819cd300
fffff819cd350
fffff819cd3f0
fffff819cd440
fffff819cd558
fffff819cd580
fffff819cd620
fffff819cd738
fffff819cd7b0
fffff819cd7d8
fffff819cd828
fffff819cd8c8
fffff819cd8f0
fffff819cd968
fffff819cd9b8
fffff819cd9e0
fffff819cda08
fffff819cda58
fffff819cdad0
fffff819cdbc0
fffff819cdc10
fffff819cdc60
fffff819cddf0
fffff819cde68
fffff819cdfa8
fffff819cdfd0
fffff819ce020
fffff819ce048
fffff819ce070
fffff819ce098
fffff819ce0c0
fffff819ce0e8
fffff819ce110
fffff819ce1d8
fffff819ce200
fffff819ce228
fffff819ce250
fffff819ce3b8
fffff819ce430
fffff819ce480
fffff819ce5e8
fffff819ce660
fffff819ce728
fffff819ce750
fffff819ce868

