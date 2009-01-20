Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbZATUBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbZATUBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZATUBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:01:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZATUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:01:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=bSrUbEV5S4x9OC4pNdyyS01OZ8+QWWyMpTcOb3EIbnnonOYQgjFcK2xlm6V5ncVVT
	UI23kl/yPfS355W3HsMMw==
Message-ID: <49762D5D.6050705@google.com>
Date: Tue, 20 Jan 2009 12:00:29 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 0/8] Deferred dput() and iput() -- reducing lock contention
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com> <49718304.90404@cosmosbay.com>
In-Reply-To: <49718304.90404@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GMailtapped-By: 172.28.16.144
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Mike Waychison a écrit :
>> We've noticed that at times it can become very easy to have a system begin to
>> livelock on dcache_lock/inode_lock (specifically in atomic_dec_and_lock()) when
>> a lot of dentries are getting finalized at the same time (massive delete and
>> large fdtable destructions are two paths I've seen cause problems).
>>
>> This patchset is an attempt to try and reduce the locking overheads associated
>> with final dput() and final iput().  This is done by batching dentries and
>> inodes into per-process queues and processing them in 'parallel' to consolidate
>> some of the locking.
>>
>> Besides various workload testing, I threw together a load (at the end of this
>> email) that causes massive fdtables (50K sockets by default) to get destroyed
>> on each cpu in the system.  It also populates the dcache for procfs on those
>> tasks for good measure.  Comparing lock_stat results (hardware is a Sun x4600
>> M2 populated with 8 4-core 2.3GHz packages (32 CPUs) + 128GiB RAM):
>>
> 
> Hello Mike
> 
> Seems quite a large/intrusive infrastructure for a well known problem.
> I even wasted some time on it.
> But it seems nobody cared too much or people were too busy.
> 
> https://kerneltrap.org/mailarchive/linux-netdev/2008/12/11/4397594
> 
> (patch 6 should be discarded as followups show it was wrong
> [PATH 6/7] fs: struct file move from call_rcu() to SLAB_DESTROY_BY_RCU)
> 
> 
> sockets / pipes dont need dcache_lock or inode_lock at all, I am 
> sure Google machines also uses sockets :)

Yup :)  I'll try to take a look at your patches this week.  At a 
minimum, the removal of the locks seems highly desirable.

> 
> Your test/bench program is quite biased (populating dcache for procfs, using
> 50k filedesc on 32 cpu, not very realistic IMHO).

Yup, extremely biased.  It was meant to hurt the dput/iput path 
specifically and I used it as a way to compare apples to apples 
with/without the changes.  It is still representative of a real-world 
workload we see though (our frontend servers when they are restarted 
have many tcp sockets, easily more than 50K each).

> 
> I had a workload with processes using 1.000.000 file descriptors,
> (mainly sockets) and got some latency problems when they had to exit().
> This problem was addressed by one cond_resched() added in close_files()
> (commit 944be0b224724fcbf63c3a3fe3a5478c325a6547 )
> 

Yup.  We pulled that change into our tree a while back for the same 
reason.  It doesn't help the lock contention issue though.
