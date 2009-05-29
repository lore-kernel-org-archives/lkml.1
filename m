Return-Path: <linux-kernel-owner+w=401wt.eu-S1762601AbZE2QJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601AbZE2QJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760776AbZE2QJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:09:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22595 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031AbZE2QJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:09:17 -0400
Message-ID: <4A200846.5050109@gmail.com>
Date: Fri, 29 May 2009 19:07:34 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 May 2009 16:07:36.0782 (UTC) FILETIME=[955426E0:01C9E077]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> Here's the 9th version of the writeback patches. Changes since v8:
> 
> - Fix a bdi_work on-stack allocation hang. I hope this fixes Ted's
>   issue.
> - Get rid of the explicit wait queues, we can just use wake_up_process()
>   since it's just for that one task.
> - Add separate "sync_supers" thread that makes sure that the dirty
>   super blocks get written. We cannot safely do this from bdi_forker_task(),
>   as that risks deadlocking on ->s_umount. Artem, I implemented this
>   by doing the wake ups from a timer so that it would be easier for you
>   to just deactivate the timer when there are no super blocks.
> 
> For ease of patching, I've put the full diff here:
> 
>   http://kernel.dk/writeback-v9.patch
> 
> and also stored this in a writeback-v9 branch that will not change,
> you can pull that into Linus tree from here:
> 
>   git://git.kernel.dk/linux-2.6-block.git writeback-v9

I'm working with the above branch. Got the following twice.
Not sure what triggers this, probably if I do nothing and
cpufreq starts doing its magic, this is triggered.

And I'm not sure it has something to do with your changes,
it is just that I saw this only with your tree. Please,
ignore if this is not relevant.

=======================================================
 scaling: [ INFO: possible circular locking dependency detected ]
2.6.30-rc7-block-2.6 #1                                          
-------------------------------------------------------          
K99cpuspeed/9923 is trying to acquire lock:                      
 (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff81051155>] __cancel_work_timer+0xd9/0x21d

but task is already holding lock:
 (dbs_mutex){+.+.+.}, at: [<ffffffffa0073aa8>] cpufreq_governor_dbs+0x23c/0x2cc [cpufreq_ondemand]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (dbs_mutex){+.+.+.}:
       [<ffffffff81063529>] __lock_acquire+0xa63/0xbeb
       [<ffffffff8106379f>] lock_acquire+0xee/0x112   
       [<ffffffff812f4eb0>] __mutex_lock_common+0x5a/0x419
       [<ffffffff812f5309>] mutex_lock_nested+0x30/0x35   
       [<ffffffffa00738f2>] cpufreq_governor_dbs+0x86/0x2cc [cpufreq_ondemand]
       [<ffffffff8125eaa4>] __cpufreq_governor+0x84/0xc2                      
       [<ffffffff8125ecae>] __cpufreq_set_policy+0x195/0x211                  
       [<ffffffff8125f6fb>] store_scaling_governor+0x1e7/0x223                
       [<ffffffff8126038f>] store+0x5f/0x83                                   
       [<ffffffff81125107>] sysfs_write_file+0xe4/0x119                       
       [<ffffffff810d24ae>] vfs_write+0xab/0x105                              
       [<ffffffff810d25cc>] sys_write+0x47/0x70                               
       [<ffffffff8100bc2b>] system_call_fastpath+0x16/0x1b                    
       [<ffffffffffffffff>] 0xffffffffffffffff                                

-> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
       [<ffffffff81063529>] __lock_acquire+0xa63/0xbeb
       [<ffffffff8106379f>] lock_acquire+0xee/0x112   
       [<ffffffff812f5561>] down_write+0x3d/0x49      
       [<ffffffff8125fc31>] lock_policy_rwsem_write+0x48/0x78
       [<ffffffffa007364c>] do_dbs_timer+0x5f/0x27f [cpufreq_ondemand]
       [<ffffffff81050869>] worker_thread+0x24b/0x367                 
       [<ffffffff810547c1>] kthread+0x56/0x83                         
       [<ffffffff8100cd3a>] child_rip+0xa/0x20                        
       [<ffffffffffffffff>] 0xffffffffffffffff                        

-> #0 (&(&dbs_info->work)->work){+.+...}:
       [<ffffffff8106341d>] __lock_acquire+0x957/0xbeb
       [<ffffffff8106379f>] lock_acquire+0xee/0x112   
       [<ffffffff81051189>] __cancel_work_timer+0x10d/0x21d
       [<ffffffff810512a6>] cancel_delayed_work_sync+0xd/0xf
       [<ffffffffa0073abb>] cpufreq_governor_dbs+0x24f/0x2cc [cpufreq_ondemand]
       [<ffffffff8125eaa4>] __cpufreq_governor+0x84/0xc2                       
       [<ffffffff8125ec98>] __cpufreq_set_policy+0x17f/0x211                   
       [<ffffffff8125f6fb>] store_scaling_governor+0x1e7/0x223                 
       [<ffffffff8126038f>] store+0x5f/0x83                                    
       [<ffffffff81125107>] sysfs_write_file+0xe4/0x119                        
       [<ffffffff810d24ae>] vfs_write+0xab/0x105                               
       [<ffffffff810d25cc>] sys_write+0x47/0x70                                
       [<ffffffff8100bc2b>] system_call_fastpath+0x16/0x1b                     
       [<ffffffffffffffff>] 0xffffffffffffffff                                 

other info that might help us debug this:

3 locks held by K99cpuspeed/9923:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff8112505b>] sysfs_write_file+0x38/0x119
 #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff8125fc31>] lock_policy_rwsem_write+0x48/0x78
 #2:  (dbs_mutex){+.+.+.}, at: [<ffffffffa0073aa8>] cpufreq_governor_dbs+0x23c/0x2cc [cpufreq_ondemand]

stack backtrace:
Pid: 9923, comm: K99cpuspeed Not tainted 2.6.30-rc7-block-2.6 #1
Call Trace:
 [<ffffffff81062750>] print_circular_bug_tail+0x71/0x7c
 [<ffffffff8106341d>] __lock_acquire+0x957/0xbeb
 [<ffffffff8106379f>] lock_acquire+0xee/0x112
 [<ffffffff81051155>] ? __cancel_work_timer+0xd9/0x21d
 [<ffffffff81051189>] __cancel_work_timer+0x10d/0x21d
 [<ffffffff81051155>] ? __cancel_work_timer+0xd9/0x21d
 [<ffffffff812f5218>] ? __mutex_lock_common+0x3c2/0x419
 [<ffffffffa0073aa8>] ? cpufreq_governor_dbs+0x23c/0x2cc [cpufreq_ondemand]
 [<ffffffff81061e66>] ? mark_held_locks+0x4d/0x6b
 [<ffffffffa0073aa8>] ? cpufreq_governor_dbs+0x23c/0x2cc [cpufreq_ondemand]
 [<ffffffff810512a6>] cancel_delayed_work_sync+0xd/0xf
 [<ffffffffa0073abb>] cpufreq_governor_dbs+0x24f/0x2cc [cpufreq_ondemand]
 [<ffffffff810580f1>] ? up_read+0x26/0x2b
 [<ffffffff8125eaa4>] __cpufreq_governor+0x84/0xc2
 [<ffffffff8125ec98>] __cpufreq_set_policy+0x17f/0x211
 [<ffffffff8125f6fb>] store_scaling_governor+0x1e7/0x223
 [<ffffffff812604dc>] ? handle_update+0x0/0x33
 [<ffffffff812f5569>] ? down_write+0x45/0x49
 [<ffffffff8126038f>] store+0x5f/0x83
 [<ffffffff81125107>] sysfs_write_file+0xe4/0x119
 [<ffffffff810d24ae>] vfs_write+0xab/0x105
 [<ffffffff810d25cc>] sys_write+0x47/0x70
 [<ffffffff8100bc2b>] system_call_fastpath+0x16/0x1b

