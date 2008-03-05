Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbYCEJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbYCEJs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764965AbYCEJr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:47:58 -0500
Received: from smtp2a.orange.fr ([80.12.242.138]:29586 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764877AbYCEJrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:47:55 -0500
X-ME-UUID: 20080305094752189.2E2717000089@mwinf2a04.orange.fr
Message-ID: <47CE6C41.3090303@cosmosbay.com>
Date: Wed, 05 Mar 2008 10:47:45 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: dmantipov@yandex.ru, linux-kernel@vger.kernel.org
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
References: <1389671204703217@webmail34.yandex.ru> <20080305.000014.245410231.davem@davemloft.net>
In-Reply-To: <20080305.000014.245410231.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Antipov Dmitry <dmantipov@yandex.ru>
> Date: Wed, 05 Mar 2008 10:46:57 +0300
>
>   
>> Despite of this obvious fact, recently I've tried to compare pipe
>> performance on Linux and FreeBSD systems. Unfortunately, Linux
>> results are poor - ~2x slower than FreeBSD. The detailed description
>> of the test case, preparation, environment and results are located
>> at http://213.148.29.37/PipeBench, and everyone are pleased to look
>> at, reproduce, criticize, etc.
>>     
>
> FreeBSD does page flipping into the pipe receiver, so rerun your test
> case but have either the sender or the receiver make changes to
> their memory buffer in between the read/write calls.
>
> FreeBSD's scheme is only good for benchmarks, rather then real life.
>
>
>
>   
page flipping might explain differences for big transferts, but note the 
difference with small buffers (64, 128, 256, 512 bytes)

I tried the 'pipe' prog on a fresh linux-2.6.24.2, on a dual Xeon 5120 
machine, and we can notice that four cpus are used (but only two threads 
are running on this benchmark)

Cpu0  :  3.7% us, 38.7% sy,  0.0% ni, 57.7% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  :  4.0% us, 36.5% sy,  0.0% ni, 58.5% id,  1.0% wa,  0.0% hi,  0.0% si
Cpu2  :  3.7% us, 25.9% sy,  0.0% ni, 70.4% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu3  :  2.0% us, 25.3% sy,  0.0% ni, 72.7% id,  0.0% wa,  0.0% hi,  0.0% si

# vmstat 1 10
procs -----------memory---------- ---swap-- -----io---- --system-- 
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy 
id wa
 2  0      0 1356432 125788 416796    0    0     3     1    5     2  1  
2 97  0
 1  0      0 1356432 125788 416796    0    0     0     0   18 336471  5 
35 61  0
 1  0      0 1356680 125788 416796    0    0     0     0   16 330420  6 
34 60  0
 1  0      0 1356680 125788 416796    0    0     0     0   16 319826  6 
34 61  0
 1  0      0 1356680 125788 416796    0    0     0     0   16 311708  5 
34 61  0
 2  0      0 1356680 125788 416796    0    0     0     0   17 331712  4 
35 61  0
 1  0      0 1356680 125788 416796    0    0     0     4   17 333001  6 
32 62  0
 1  0      0 1356680 125788 416796    0    0     0     0   15 336755  7 
31 62  0
 2  0      0 1356680 125788 416796    0    0     0     0   16 323086  5 
34 61  0
 1  0      0 1356680 125788 416796    0    0     0     0   12 373822  4 
33 63  0


# opreport -l /boot/vmlinux-2.6.24.2 |head -n 30
CPU: Core 2, speed 1866.8 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a 
unit mask of 0x00 (Unhalted core cycles) count 100000
samples  %        symbol name
52137     9.3521  kunmap_atomic
50983     9.1451  mwait_idle_with_hints
50448     9.0492  system_call
49727     8.9198  task_rq_lock
24531     4.4003  pipe_read
19820     3.5552  pipe_write
16176     2.9016  dnotify_parent
15455     2.7723  file_update_time
15216     2.7294  find_busiest_group
12449     2.2331  __copy_from_user_ll_nozero
12291     2.2047  set_next_entity
12023     2.1566  resched_task
11728     2.1037  __switch_to
11294     2.0259  update_curr
10749     1.9281  touch_atime
9334      1.6743  kmap_atomic_prot
9084      1.6295  __wake_up_sync
8321      1.4926  try_to_wake_up
7522      1.3493  pick_next_entity
7216      1.2944  cpu_idle
6780      1.2162  vfs_read
6727      1.2067  vfs_write
6570      1.1785  __copy_to_user_ll
6407      1.1493  syscall_exit
6283      1.1270  restore_nocheck
6064      1.0877  weighted_cpuload
6045      1.0843  rw_verify_area

This benchmarek mostly stress scheduler AFAIK, not really pipe() code...

Lot of context switches...







