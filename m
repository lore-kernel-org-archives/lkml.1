Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbYKUMwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbYKUMwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYKUMwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:52:04 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:50689 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYKUMwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:52:03 -0500
Message-ID: <4926AEDB.10007@cosmosbay.com>
Date: Fri, 21 Nov 2008 13:51:39 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mingo@elte.hu, cl@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       efault@gmx.de, a.p.zijlstra@chello.nl
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com>	<20081121083044.GL16242@elte.hu>	<49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net>
In-Reply-To: <20081121.010508.40225532.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 21 Nov 2008 13:51:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Fri, 21 Nov 2008 09:51:32 +0100
> 
>> Now, I wish sockets and pipes not going through dcache, not tbench affair
>> of course but real workloads...
>>
>> running 8 processes on a 8 way machine doing a 
>>
>> for (;;)
>> 	close(socket(AF_INET, SOCK_STREAM, 0));
>>
>> is slow as hell, we hit so many contended cache lines ...
>>
>> ticket spin locks are slower in this case (dcache_lock for example
>> is taken twice when we allocate a socket(), once in d_alloc(), another one
>> in d_instantiate())
> 
> As you of course know, this used to be a ton worse.  At least now
> these things are unhashed. :)

Well, this is dust compared to what we currently have.

To allocate a socket we :
0) Do the usual file manipulation (pretty scalable these days)
   (but recent drop_file_write_access() and co slow down a bit)
1) allocate an inode with new_inode()
    This function :
     - locks inode_lock,
     - dirties nr_inodes counter
     - dirties inode_in_use list  (for sockets, I doubt it is usefull)
     - dirties superblock s_inodes.
     - dirties last_ino counter
 All these are in different cache lines of course.
2) allocate a dentry
   d_alloc() takes dcache_lock,
   insert dentry on its parent list (dirtying sock_mnt->mnt_sb->s_root)
   dirties nr_dentry
3) d_instantiate() dentry  (dcache_lock taken again)
4) init_file() -> atomic_inc on sock_mnt->refcount (in case we want to umount this vfs ...)



At close() time, we must undo the things. Its even more expensive because
of the _atomic_dec_and_lock() that stress a lot, and because of two cache 
lines that are touched when an element is deleted from a list.

for (i = 0; i < 1000*1000; i++)
	close(socket(socket(AF_INET, SOCK_STREAM, 0));

Cost if run one one cpu :

real    0m1.561s
user    0m0.092s
sys     0m1.469s

If run on 8 CPUS :

real    0m27.496s
user    0m0.657s
sys     3m39.092s


CPU: Core 2, speed 3000.11 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100
000
samples  cum. samples  %        cum. %     symbol name
164211   164211        10.9678  10.9678    init_file
155663   319874        10.3969  21.3647    d_alloc
147596   467470         9.8581  31.2228    _atomic_dec_and_lock
92993    560463         6.2111  37.4339    inet_create
73495    633958         4.9088  42.3427    kmem_cache_alloc
46353    680311         3.0960  45.4387    dentry_iput
46042    726353         3.0752  48.5139    tcp_close
42784    769137         2.8576  51.3715    kmem_cache_free
37074    806211         2.4762  53.8477    wake_up_inode
36375    842586         2.4295  56.2772    tcp_v4_init_sock
35212    877798         2.3518  58.6291    inotify_d_instantiate
33199    910997         2.2174  60.8465    sysenter_past_esp
31161    942158         2.0813  62.9277    d_instantiate
31000    973158         2.0705  64.9983    generic_forget_inode
28020    1001178        1.8715  66.8698    vfs_dq_drop
19007    1020185        1.2695  68.1393    __copy_from_user_ll
17513    1037698        1.1697  69.3090    new_inode
16957    1054655        1.1326  70.4415    __init_timer
16897    1071552        1.1286  71.5701    discard_slab
16115    1087667        1.0763  72.6464    d_kill
15542    1103209        1.0381  73.6845    __percpu_counter_add
13562    1116771        0.9058  74.5903    __slab_free
13276    1130047        0.8867  75.4771    __fput
12423    1142470        0.8297  76.3068    new_slab
11976    1154446        0.7999  77.1067    tcp_v4_destroy_sock
10889    1165335        0.7273  77.8340    inet_csk_destroy_sock
10516    1175851        0.7024  78.5364    alloc_inode
9979     1185830        0.6665  79.2029    sock_attach_fd
7980     1193810        0.5330  79.7359    drop_file_write_access
7609     1201419        0.5082  80.2441    alloc_fd
7584     1209003        0.5065  80.7506    sock_init_data
7164     1216167        0.4785  81.2291    add_partial
7107     1223274        0.4747  81.7038    sys_close
6997     1230271        0.4673  82.1711    mwait_idle

