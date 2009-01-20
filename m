Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbZATPmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbZATPmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZATPmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:42:35 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:38829 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbZATPmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:42:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAEF9dUlMQWt2/2dsb2JhbACBbMkghXM
Date: Tue, 20 Jan 2009 10:42:28 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: akpm@linux-foundation.org, ltt-dev@lists.casi.polymtl.ca,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC PATCH] block: Fix bio merge induced high I/O
	latency
Message-ID: <20090120154228.GE22421@Krystal>
References: <20090117004439.GA11492@Krystal> <20090117162657.GA31965@Krystal> <20090117190437.GZ30821@kernel.dk> <20090118211234.GA4913@Krystal> <20090119182654.GT30821@kernel.dk> <20090120021055.GA6990@Krystal> <20090120073709.GC30821@kernel.dk> <20090120122855.GF30821@kernel.dk> <20090120142223.GD22421@Krystal> <20090120142457.GO30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090120142457.GO30821@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:38:19 up 19 days, 15:36,  2 users,  load average: 0.16, 0.45,
	0.49
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (jens.axboe@oracle.com) wrote:
> On Tue, Jan 20 2009, Mathieu Desnoyers wrote:
> > * Jens Axboe (jens.axboe@oracle.com) wrote:
> > > On Tue, Jan 20 2009, Jens Axboe wrote:
> > > > On Mon, Jan 19 2009, Mathieu Desnoyers wrote:
> > > > > * Jens Axboe (jens.axboe@oracle.com) wrote:
> > > > > > On Sun, Jan 18 2009, Mathieu Desnoyers wrote:
> > > > > > > I looked at the "ls" behavior (while doing a dd) within my LTTng trace
> > > > > > > to create a fio job file.  The said behavior is appended below as "Part
> > > > > > > 1 - ls I/O behavior". Note that the original "ls" test case was done
> > > > > > > with the anticipatory I/O scheduler, which was active by default on my
> > > > > > > debian system with custom vanilla 2.6.28 kernel. Also note that I am
> > > > > > > running this on a raid-1, but have experienced the same problem on a
> > > > > > > standard partition I created on the same machine.
> > > > > > > 
> > > > > > > I created the fio job file appended as "Part 2 - dd+ls fio job file". It
> > > > > > > consists of one dd-like job and many small jobs reading as many data as
> > > > > > > ls did. I used the small test script to batch run this ("Part 3 - batch
> > > > > > > test").
> > > > > > > 
> > > > > > > The results for the ls-like jobs are interesting :
> > > > > > > 
> > > > > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > > > > noop                       41             10563
> > > > > > > anticipatory               63              8185
> > > > > > > deadline                   52             33387
> > > > > > > cfq                        43              1420
> > > > > > 
> > > > > 
> > > > > Extra note : I have a HZ=250 on my system. Changing to 100 or 1000 did
> > > > > not make much difference (also tried with NO_HZ enabled).
> > > > > 
> > > > > > Do you have queuing enabled on your drives? You can check that in
> > > > > > /sys/block/sdX/device/queue_depth. Try setting those to 1 and retest all
> > > > > > schedulers, would be good for comparison.
> > > > > > 
> > > > > 
> > > > > Here are the tests with a queue_depth of 1 :
> > > > > 
> > > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > > noop                       43             38235
> > > > > anticipatory               44              8728
> > > > > deadline                   51             19751
> > > > > cfq                        48               427
> > > > > 
> > > > > 
> > > > > Overall, I wouldn't say it makes much difference.
> > > > 
> > > > 0,5 seconds vs 1,5 seconds isn't much of a difference?
> > > > 
> > > > > > raid personalities or dm complicates matters, since it introduces a
> > > > > > disconnect between 'ls' and the io scheduler at the bottom...
> > > > > > 
> > > > > 
> > > > > Yes, ideally I should re-run those directly on the disk partitions.
> > > > 
> > > > At least for comparison.
> > > > 
> > > > > I am also tempted to create a fio job file which acts like a ssh server
> > > > > receiving a connexion after it has been pruned from the cache while the
> > > > > system if doing heavy I/O. "ssh", in this case, seems to be doing much
> > > > > more I/O than a simple "ls", and I think we might want to see if cfq
> > > > > behaves correctly in such case. Most of this I/O is coming from page
> > > > > faults (identified as traps in the trace) probably because the ssh
> > > > > executable has been thrown out of the cache by
> > > > > 
> > > > > echo 3 > /proc/sys/vm/drop_caches
> > > > > 
> > > > > The behavior of an incoming ssh connexion after clearing the cache is
> > > > > appended below (Part 1 - LTTng trace for incoming ssh connexion). The
> > > > > job file created (Part 2) reads, for each job, a 2MB file with random
> > > > > reads each between 4k-44k. The results are very interesting for cfq :
> > > > > 
> > > > > I/O scheduler        runt-min (msec)   runt-max (msec)
> > > > > noop                       586           110242
> > > > > anticipatory               531            26942
> > > > > deadline                   561           108772
> > > > > cfq                        523            28216
> > > > > 
> > > > > So, basically, ssh being out of the cache can take 28s to answer an
> > > > > incoming ssh connexion even with the cfq scheduler. This is not exactly
> > > > > what I would call an acceptable latency.
> > > > 
> > > > At some point, you have to stop and consider what is acceptable
> > > > performance for a given IO pattern. Your ssh test case is purely random
> > > > IO, and neither CFQ nor AS would do any idling for that. We can make
> > > > this test case faster for sure, the hard part is making sure that we
> > > > don't regress on async throughput at the same time.
> > > > 
> > > > Also remember that with your raid1, it's not entirely reasonable to
> > > > blaim all performance issues on the IO scheduler as per my previous
> > > > mail. It would be a lot more fair to view the disk numbers individually.
> > > > 
> > > > Can you retry this job with 'quantum' set to 1 and 'slice_async_rq' set
> > > > to 1 as well?
> > > > 
> > > > However, I think we should be doing somewhat better at this test case.
> > > 
> > > Mathieu, does this improve anything for you?
> > > 
> > 
> > I got this message when running with your patch applied :
> > cfq: forced dispatching is broken (nr_sorted=4294967275), please report this
> > (message appeared 10 times in a job run)
> 
> Woops, missed a sort inc. Updated version below, or just ignore the
> warning.
> 
> > Here is the result :
> > 
> > ssh test done on /dev/sda directly
> > 
> > queue_depth=31 (default)
> > /sys/block/sda/queue/iosched/slice_async_rq = 2 (default)
> > /sys/block/sda/queue/iosched/quantum = 4 (default)
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > cfq (default)             523              6637
> > cfq (patched)             564              7195
> > 
> > Pretty much the same.
> 
> Can you retry with depth=1 as well? There's not much to rip back out, if
> everything is immediately sent to the device.
> 

echo 1 > /sys/block/sda/queue/iosched/quantum 
echo 1 > /sys/block/sda/queue/iosched/slice_async_rq
echo 1 > /sys/block/sda/device/queue_depth

ssh test done on /dev/sda directly

oops, something wrong in the new patch ?


[  302.077063] BUG: unable to handle kernel paging request at 00000008
[  302.078732] IP: [<ffffffff8040a1e5>] cfq_remove_request+0x35/0x1d0           
[  302.078732] PGD 43ac76067 PUD 43b1f3067 PMD 0                                
[  302.078732] Oops: 0002 [#1] PREEMPT SMP                                      
[  302.078732] LTT NESTING LEVEL : 0                                            
[  302.078732] last sysfs file: /sys/block/sda/stat                             
[  302.078732] Dumping ftrace buffer:                                           
[  302.078732]    (ftrace buffer empty)                                         
[  302.078732] CPU 0                                                            
[  302.078732] Modules linked in: e1000e loop ltt_tracer ltt_trace_control ltt_e
[  302.078732] Pid: 3748, comm: cron Not tainted 2.6.28 #53                     
[  302.078732] RIP: 0010:[<ffffffff8040a1e5>]  [<ffffffff8040a1e5>] cfq_remove_0
[  302.078732] RSP: 0018:ffff8804388a38a8  EFLAGS: 00010087                     
[  302.078732] RAX: 0000000000200200 RBX: ffff880437d92000 RCX: 000000002bcde392
[  302.078732] RDX: 0000000000100100 RSI: ffff880437d92fd0 RDI: ffff880437d92fd0
[  302.078732] RBP: ffff8804388a38d8 R08: ffff88043e8ce608 R09: 000000002bcdb78a
[  302.078732] R10: 000000002bcdbb8a R11: 0000000000000808 R12: ffff88043e8ce5d8
[  302.078732] R13: ffff880437d92fd0 R14: ffff88043e433800 R15: ffff88043e8ce5d8
[  302.078732] FS:  00007fd9637ea780(0000) GS:ffffffff808de7c0(0000) knlGS:00000
[  302.078732] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b                
[  302.078732] CR2: 0000000000100108 CR3: 000000043ad52000 CR4: 00000000000006e0
[  302.078732] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  302.078732] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  302.078732] Process cron (pid: 3748, threadinfo ffff8804388a2000, task ffff8)
[  302.078732] Stack:                                                           
[  302.078732]  ffff88043e8ce5e8 ffff880437d92fd0 ffff88043e8ce5d8 ffff88043d550
[  302.078732]  ffff88043e433800 ffff88043e433800 ffff8804388a3908 ffffffff8040d
[  302.078732]  ffff88043e8ce5d8 ffff88043e433800 ffff880437d92fd0 ffff88043e8c8
[  302.078732] Call Trace:                                                      
[  302.078732]  [<ffffffff8040a3bd>] cfq_dispatch_insert+0x3d/0x70              
[  302.078732]  [<ffffffff8040a43c>] cfq_add_rq_rb+0x4c/0xb0                    
[  302.078732]  [<ffffffff8040ab6f>] cfq_insert_request+0x24f/0x420             
[  302.078732]  [<ffffffff803fac30>] elv_insert+0x160/0x2f0                     
[  302.078732]  [<ffffffff803fae3b>] __elv_add_request+0x7b/0xd0                
[  302.078732]  [<ffffffff803fe02d>] __make_request+0xfd/0x4f0                  
[  302.078732]  [<ffffffff803fc39c>] generic_make_request+0x40c/0x550           
[  302.078732]  [<ffffffff8029ccab>] ? mempool_alloc+0x5b/0x150                 
[  302.078732]  [<ffffffff802f54c8>] ? __find_get_block+0xc8/0x210              
[  302.078732]  [<ffffffff803fc582>] submit_bio+0xa2/0x150                      
[  302.078732]  [<ffffffff802fa75e>] ? bio_alloc_bioset+0x5e/0x100              
[  302.078732]  [<ffffffff802f4d26>] submit_bh+0xf6/0x130                       
[  302.078732]  [<ffffffff8032fbc4>] __ext3_get_inode_loc+0x224/0x340           
[  302.078732]  [<ffffffff8032fd40>] ext3_iget+0x60/0x420                       
[  302.078732]  [<ffffffff80336e68>] ext3_lookup+0xa8/0x100                     
[  302.078732]  [<ffffffff802e3d46>] ? d_alloc+0x186/0x1f0                      
[  302.078732]  [<ffffffff802d92a6>] do_lookup+0x206/0x260                      
[  302.078732]  [<ffffffff802db4f6>] __link_path_walk+0x756/0xfe0               
[  302.078732]  [<ffffffff80262cd4>] ? get_lock_stats+0x34/0x70                 
[  302.078732]  [<ffffffff802dc16b>] ? do_path_lookup+0x9b/0x200                
[  302.078732]  [<ffffffff802dbf9e>] path_walk+0x6e/0xe0                        
[  302.078732]  [<ffffffff802dc176>] do_path_lookup+0xa6/0x200                  
[  302.078732]  [<ffffffff802dad36>] ? getname+0x1c6/0x230                      
[  302.078732]  [<ffffffff802dd02b>] user_path_at+0x7b/0xb0                     
[  302.078732]  [<ffffffff8067d3a7>] ? _spin_unlock_irqrestore+0x47/0x80        
[  302.078732]  [<ffffffff80259ad3>] ? hrtimer_try_to_cancel+0x53/0xb0          
[  302.078732]  [<ffffffff80259b52>] ? hrtimer_cancel+0x22/0x30                 
[  302.078732]  [<ffffffff802d414d>] vfs_stat_fd+0x2d/0x60                      
[  302.078732]  [<ffffffff802d422c>] sys_newstat+0x2c/0x50                      
[  302.078732]  [<ffffffff80265901>] ? trace_hardirqs_on_caller+0x1b1/0x210     
[  302.078732]  [<ffffffff8067cd0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f        
[  302.078732]  [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b             
[  302.078732] Code: 41 54 53 48 83 ec 08 0f 1f 44 00 00 4c 8b bf c0 00 00 00 4 
[  302.078732] RIP  [<ffffffff8040a1e5>] cfq_remove_request+0x35/0x1d0          
[  302.078732]  RSP <ffff8804388a38a8>                                          
[  302.078732] CR2: 0000000000100108                                            
[  302.078732] ---[ end trace 925e67a354a83fdc ]---                             
[  302.078732] note: cron[3748] exited with preempt_count 1                    



> > 
> > Here is the test done on raid1 :
> > queue_depth=31 (default)
> > /sys/block/sd{a,b}/queue/iosched/slice_async_rq = 2 (default)
> > /sys/block/sd{a,b}/queue/iosched/quantum = 4 (default)
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > cfq (default, raid1)       523            28216
> > cfq (patched, raid1)       540            16454
> > 
> > With nearly same order of magnitude worse-case.
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index e8525fa..30714de 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1765,6 +1765,36 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  }
>  
>  /*
> + * Pull dispatched requests from 'cfqq' back into the scheduler
> + */
> +static void cfq_pull_dispatched_requests(struct cfq_data *cfqd,
> +					 struct cfq_queue *cfqq)
> +{
> +	struct request_queue *q = cfqd->queue;
> +	struct request *rq;
> +
> +	list_for_each_entry_reverse(rq, &q->queue_head, queuelist) {
> +		if (rq->cmd_flags & REQ_STARTED)
> +			break;
> +
> +		if (RQ_CFQQ(rq) != cfqq)
> +			continue;
> +
> +		/*
> +		 * Pull off the dispatch list and put it back into the cfqq
> +		 */
> +		list_del(&rq->queuelist);
> +		cfqq->dispatched--;
> +		if (cfq_cfqq_sync(cfqq))
> +			cfqd->sync_flight--;
> +
> +		cfq_add_rq_rb(rq);
> +		q->nr_sorted++;
> +		list_add_tail(&rq->queuelist, &cfqq->fifo);
> +	}
> +}
> +
> +/*
>   * Check if new_cfqq should preempt the currently active queue. Return 0 for
>   * no or if we aren't sure, a 1 will cause a preempt.
>   */
> @@ -1820,8 +1850,14 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>   */
>  static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> +	struct cfq_queue *old_cfqq = cfqd->active_queue;
> +
>  	cfq_log_cfqq(cfqd, cfqq, "preempt");
> -	cfq_slice_expired(cfqd, 1);
> +
> +	if (old_cfqq) {
> +		__cfq_slice_expired(cfqd, old_cfqq, 1);
> +		cfq_pull_dispatched_requests(cfqd, old_cfqq);
> +	}
>  
>  	/*
>  	 * Put the new queue at the front of the of the current list,
> 
> -- 
> Jens Axboe
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
