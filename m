Return-Path: <linux-kernel-owner+w=401wt.eu-S933549AbXJPHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbXJPHzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbXJPHyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:54:50 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:39946 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760876AbXJPHyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:54:45 -0400
Date: Tue, 16 Oct 2007 09:54:09 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Strange system hangs
In-Reply-To: <200709290614.02918.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0710160944470.21430@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
 <200709290614.02918.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1606215155-1192521249=:21430"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1606215155-1192521249=:21430
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 29 Sep 2007, Nick Piggin wrote:

> On Friday 28 September 2007 18:42, Krzysztof Oledzki wrote:
>> Hello,
>>
>> I am experiencing weird system hangs. Once about 2-5 weeks system freeze=
s
>> and stops accepting remote connections, so it is no longer possible to
>> connect to most important services: smtp (postfix), www (squid) or even
>> ssh. Such connection is accepted but then it hangs.
>>
>> What is strange, that previously established ssh session is usable. It i=
s
>> possible to work on such system until you do something stupid like "less
>> /var/log/all.log". Using strace I found that process blocks on:
>
> Is this a regression? If so, what's the most recent kernel that didn't sh=
ow
> the problem?
>
> The symptoms could be consistent with some place doing a
> balance_dirty_pages while holding a lock that is required for IO, but I c=
an't
> see a smoking gun (you've got contention on i_mutex, but that should be
> OK).

OK. It did it again :(, so I send additional debug information. Today I=20
discovered that "echo i > /proc/sysrq-trigger" makes my system being=20
usable.

> Can you see if there is any memory under writeback that isn't being
> completed (sysrq+M),

SysRq : Show Memory
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  11   Cold: hi:   62, btch:  15 usd=
:   8
CPU    1: Hot: hi:  186, btch:  31 usd: 170   Cold: hi:   62, btch:  15 usd=
:  23
Active:281859 inactive:140551 dirty:46161 writeback:0 unstable:0
  free:39081 slab:50571 mapped:3261 pagetables:356 bounce:0
DMA free:8704kB min:512kB low:640kB high:768kB active:48kB inactive:0kB pre=
sent:16256kB pages_scanned:12 all_unreclaimable? no
lowmem_reserve[]: 0 2015
Normal free:147620kB min:65016kB low:81268kB high:97524kB active:1127388kB =
inactive:562204kB present:2064260kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
DMA: 4*4kB 0*8kB 1*16kB 1*32kB 1*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*20=
48kB 2*4096kB =3D 8704kB
Normal: 15781*4kB 522*8kB 264*16kB 56*32kB 9*64kB 8*128kB 6*256kB 1*512kB 1=
*1024kB 2*2048kB 16*4096kB =3D 147620kB
Swap cache: add 5022, delete 4928, find 2281/2804, race 0+0
Free swap  =3D 2927208kB
Total swap =3D 2927608kB
Free swap:       2927208kB
524224 pages of RAM
0 pages of HIGHMEM
6345 reserved pages
249411 pages shared
94 pages swap cached
46161 pages dirty
0 pages writeback
3261 pages mapped
50571 pages slab
356 pages pagetables

> also a list the locks held after the hang might be
> helpful (compile in lockdep and sysrq+D)

SysRq : Show Locks Held

Showing all locks held in the system:
1 lock held by syslogd/2197:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by freshclam/2898:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by crond/3061:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by snmpd/3546:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by squid/3606:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by zabbix_agentd/3728:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by agetty/3791:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3793:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3794:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3795:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3796:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3797:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3798:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
1 lock held by agetty/3799:
  #0:  (&tty->atomic_read_lock){--..}, at: [<7829cdde>] read_chan+0x1b1/0x5=
4b
2 locks held by bash/3887:
  #0:  (sysrq_key_table_lock){....}, at: [<782a6ea9>] __handle_sysrq+0x17/0=
x109
  #1:  (tasklist_lock){..-?}, at: [<7813d883>] debug_show_all_locks+0x3b/0x=
12d
1 lock held by amavisd/7227:
  #0:  (&mm->mmap_sem){----}, at: [<781196ad>] do_page_fault+0x152/0x535
1 lock held by sadc/8202:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by emerge/8204:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by mkpir/8297:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6
1 lock held by screen/8365:
  #0:  (&inode->i_mutex){--..}, at: [<7814aabc>] generic_file_aio_write+0x4=
3/0xb6

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


> Is anything currently running? (sysrq+P

Empty.

> and even a full sysrq+T task list
> could be useful).

SysRq : Show State

                          free                        sibling
   task             PC    stack   pid father child younger older
init          S 7A1C1B4C     0     1      0 (NOTLB)
        7a1c1b60 00000016 00000002 7a1c1b4c 7a1c1b48 00000000 7840d6e3 7a1d=
2000
        0000000a 00000001 f7fbf490 f7fbe030 9c45a103 0001ff61 00005b8a f7fb=
f59c
        7a022980 f71bdd00 219904e6 00000003 00000000 00000000 7a1c1b70 2199=
186c
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7812cada>] process_timeout+0x0/0x5
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<781298c7>] local_bh_enable+0x110/0x130
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7837cb10>] dev_queue_xmit+0x10b/0x213
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78172a90>] __d_lookup+0xbb/0x10b
  [<78172a3f>] __d_lookup+0x6a/0x10b
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78172ac3>] __d_lookup+0xee/0x10b
  [<7816a323>] do_lookup+0x4f/0x143
  [<78171ebc>] dput+0x16/0xe4
  [<7816be16>] __link_path_walk+0xa1a/0xb5e
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7816c003>] link_path_walk+0xa9/0xb3
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<7816f30a>] sys_select+0xa0/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kthreadd      S F7FBEA60     0     2      0 (L-TLB)
        7a1c3fd0 00000016 7851aa94 f7fbea60 00000001 786b7ec8 f7fbef90 f7fb=
ef90
        0000000a 00000000 f7fbea60 edcd0030 e200f0d9 0001df92 00000d92 f7fb=
eb6c
        7a01a980 f7cafa40 00001890 00000246 7851aa80 00001890 7851aa60 0000=
1890
Call Trace:
  [<78134f4d>] kthreadd+0x61/0xfe
  [<78134eec>] kthreadd+0x0/0xfe
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
migration/0   S 7A022980     0     3      2 (L-TLB)
        7a1c9fa4 00000002 7811e4eb 7a022980 f7c7d550 7a1c9fa4 7811f199 7a1c=
7a00
        00000001 00000000 7a1c74d0 f7e84b60 78531ca2 0001ff5b 00001431 7a1c=
75dc
        7a01a980 e913a340 7a0229e8 00000046 7a01a980 7a01a980 7a01b2f4 7a01=
a980
Call Trace:
  [<7811e4eb>] resched_task+0x3b/0x59
  [<7811f199>] move_tasks+0x1f5/0x2bd
  [<781221cf>] migration_thread+0x14a/0x1cd
  [<78122085>] migration_thread+0x0/0x1cd
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ksoftirqd/0   S 7A1CBFB4     0     4      2 (L-TLB)
        7a1cbfc8 00000002 00000002 7a1cbfb4 7a1cbfb0 00000000 edcd1490 edcd=
1490
        00000009 00000000 7a1c6aa0 785143e0 f1a2fd1e 0001e9af 0000065e 7a1c=
6bac
        7a01a980 c053d340 202bebb7 00000003 00000000 00000000 7a018100 0000=
0000
Call Trace:
  [<78129a29>] ksoftirqd+0x55/0x134
  [<781299d4>] ksoftirqd+0x0/0x134
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
watchdog/0    S 7A01A980     0     5      2 (L-TLB)
        7a1cdfcc 00000006 7840d6e3 7a01a980 7a1cdfcc 7813e99c 00000002 0000=
0046
        00000001 00000000 7a1c6070 f7fbf490 35f147b4 0000000a 00002c3f 7a1c=
617c
        7a01a980 78514180 7a1c6530 ffffffff 78596a0c 01a85000 00000000 7814=
6910
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78146910>] watchdog+0x0/0x58
  [<78146958>] watchdog+0x48/0x58
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
migration/1   S 7A1D1F90     0     6      2 (L-TLB)
        7a1d1fa4 00000002 00000002 7a1d1f90 7a1d1f8c 00000000 7a1cfa40 7a1c=
fa40
        00000001 00000001 7a1cf510 f7fbe030 04d4c284 0001ff60 00001b5e 7a1c=
f61c
        7a022980 e8d34580 2198ea1b 00000003 00000000 00000000 7a0232f4 7a02=
2980
Call Trace:
  [<781221cf>] migration_thread+0x14a/0x1cd
  [<78122085>] migration_thread+0x0/0x1cd
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ksoftirqd/1   S 7A1D5FB4     0     7      2 (L-TLB)
        7a1d5fc8 00000002 00000002 7a1d5fb4 7a1d5fb0 00000000 00000046 0000=
0000
        0000000a 00000001 7a1ceae0 f7fbe030 07b31f2a 0001ff3a 0004c80b 7a1c=
ebec
        7a022980 e913a340 21966ac7 00000003 00000000 00000000 7a020100 0000=
0001
Call Trace:
  [<78129a29>] ksoftirqd+0x55/0x134
  [<781299d4>] ksoftirqd+0x0/0x134
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
watchdog/1    S 7A022980     0     8      2 (L-TLB)
        7a1d7fcc 00000006 7840d6e3 7a022980 7a1d7fcc 7813e99c 00000002 0000=
0046
        00000001 00000001 7a1ce0b0 7a1ceae0 372914ac 0000000a 00003a96 7a1c=
e1bc
        7a022980 78514180 7a1ce570 ffffffff 78596a0c 01a8d000 00000001 7814=
6910
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78146910>] watchdog+0x0/0x58
  [<78146958>] watchdog+0x48/0x58
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
events/0      S F7FBDFA0     0     9      2 (L-TLB)
        f7fbdfb4 00000086 00000002 f7fbdfa0 f7fbdf9c 00000000 f7ea1a80 0000=
0000
        0000000a 00000000 f7ea1550 785143e0 959db3cd 0001ff61 0000158b f7ea=
165c
        7a01a980 c053d840 21990475 00000003 00000000 00000000 f7f940c0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
events/1      S F7FB9FA0     0    10      2 (L-TLB)
        f7fb9fb4 00000086 00000002 f7fb9fa0 f7fb9f9c 00000000 f7ea1050 0000=
0000
        0000000a 00000001 f7ea0b20 f7fbe030 992e5f8c 0001ff61 000013bc f7ea=
0c2c
        7a022980 e913a340 219904b2 00000003 00000000 00000000 f7c4df40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
khelper       S 00000000     0    11      2 (L-TLB)
        f7fbbfb4 00000086 00000046 00000000 00000000 f7c4defc f7ea0620 0000=
0000
        00000009 00000001 f7ea00f0 f7cc8130 6fcbad27 0001df91 000011c4 f7ea=
01fc
        7a022980 f6b15840 00000046 f7c4dee8 00000286 f7c4dee8 f7c4dec0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kblockd/0     S F7E3BFA0     0    64      2 (L-TLB)
        f7e3bfb4 00000086 00000002 f7e3bfa0 f7e3bf9c 00000000 f7e85090 0000=
0000
        0000000a 00000000 f7e84b60 785143e0 6ff1ad71 0001ff61 00001779 f7e8=
4c6c
        7a01a980 e913a340 219901fd 00000003 00000000 00000000 f7e951c0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kblockd/1     S F7E3DFA0     0    65      2 (L-TLB)
        f7e3dfb4 00000086 00000002 f7e3dfa0 f7e3df9c 00000000 00000000 0000=
0000
        0000000a 00000001 f7e85590 f7fbe030 593eee3f 0001ff61 00001932 f7e8=
569c
        7a022980 d3e4acc0 2199007e 00000002 00000000 00000000 f7e95140 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kacpid        S 00000000     0    66      2 (L-TLB)
        f7e3ffb4 00000086 00000046 00000000 00000000 f7c76cfc f7c7c620 0000=
0000
        00000001 00000000 f7c7c0f0 f7fbf490 3bbce431 0000000a 0000072f f7c7=
c1fc
        7a01a980 78514180 00000046 f7c76ce8 00000286 f7c76ce8 f7c76cc0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kacpi_notify  S 00000000     0    67      2 (L-TLB)
        f7e41fb4 00000086 00000046 00000000 00000000 f7c76bfc f7c7d050 0000=
0000
        00000001 00000000 f7c7cb20 f7fbf490 3bbd4590 0000000a 00000720 f7c7=
cc2c
        7a01a980 78514180 00000046 f7c76be8 00000286 f7c76be8 f7c76bc0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ata/0         S 00000000     0   147      2 (L-TLB)
        f7e21fb4 00000086 00000046 00000000 00000000 f7c4bd7c f7e23a40 0000=
0000
        0000000a 00000000 f7e23510 f7cd0030 a23c198a 0000000b 0002d0fb f7e2=
361c
        7a01a980 78514180 00000046 f7c4bd68 00000286 f7c4bd68 f7c4bd40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ata/1         S 00000000     0   148      2 (L-TLB)
        f7e19fb4 00000086 00000046 00000000 00000000 f7c4bcfc f7e2a620 0000=
0000
        0000000a 00000001 f7e2a0f0 f7fbf490 7e41e2a8 0000000b 00005ba5 f7e2=
a1fc
        7a022980 78514180 00000046 f7c4bce8 00000286 f7c4bce8 f7c4bcc0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ata_aux       S F7E43FA0     0   149      2 (L-TLB)
        f7e43fb4 00000086 00000002 f7e43fa0 f7e43f9c 00000000 f7e1a5a0 0000=
0000
        00000001 00000000 f7e1a070 785143e0 3dbcad9d 0000000a 00000e19 f7e1=
a17c
        7a01a980 78514180 fffb6d29 00000003 00000000 00000000 f7c4bc40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ksuspend_usbd S F7E29FA0     0   150      2 (L-TLB)
        f7e29fb4 00000086 00000002 f7e29fa0 f7e29f9c 00000000 f7e84660 0000=
0000
        00000001 00000000 f7e84130 785143e0 3dbd4cb7 0000000a 00001042 f7e8=
423c
        7a01a980 78514180 fffb6d29 00000003 00000000 00000000 f7c4bb40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
khubd         S 00000000     0   153      2 (L-TLB)
        f7e05f54 00000086 00000046 00000000 00000000 78538a34 f7e225e0 0000=
0000
        0000000a 00000000 f7e220b0 f7fbf490 d1ac4454 0000000b 00005717 f7e2=
21bc
        7a01a980 78514180 00000046 78538a20 00000286 78538a20 00000000 f7d3=
6200
Call Trace:
  [<78316b2e>] hub_thread+0x98f/0x9f9
  [<7840d732>] _spin_unlock_irq+0x2b/0x41
  [<7840ae59>] __sched_text_start+0x701/0x810
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7831619f>] hub_thread+0x0/0x9f9
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kseriod       S 00000000     0   155      2 (L-TLB)
        7a1fdf9c 00000002 00000046 00000000 00000000 7853bcd4 f7e0a660 0000=
0000
        0000000a 00000000 f7e0a130 f7fbf490 0dfac2e3 0000000c 00003730 f7e0=
a23c
        7a01a980 78514180 00000046 7853bcc0 00000216 7853bcc0 f7d50580 7832=
efe5
Call Trace:
  [<7832efe5>] serio_thread+0x0/0x2bb
  [<7832f255>] serio_thread+0x270/0x2bb
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7832efe5>] serio_thread+0x0/0x2bb
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kswapd0       S F7E59F44     0   187      2 (L-TLB)
        f7e59f58 00000086 00000002 f7e59f44 f7e59f40 00000000 7a1fb010 0000=
0000
        00000009 00000001 7a1faae0 f7fbe030 1a81a860 0001e6a0 00e7fbcc 7a1f=
abec
        7a022980 abc7dd40 1ff863fd 00000003 00000000 00000000 00000001 ffff=
ffff
Call Trace:
  [<78150a2e>] kswapd+0xb0/0x40f
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7815097e>] kswapd+0x0/0x40f
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
aio/0         S 00000000     0   188      2 (L-TLB)
        f7e5dfb4 00000086 00000046 00000000 00000000 f7ed547c 7a1fba40 0000=
0000
        00000001 00000000 7a1fb510 f7fbea60 42056d94 0000000a 00000dba 7a1f=
b61c
        7a01a980 78514180 00000046 f7ed5468 00000286 f7ed5468 f7ed5440 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
aio/1         S 00000000     0   189      2 (L-TLB)
        f7e5ffb4 00000086 00000046 00000000 00000000 f7ed53fc 7a1f25a0 0000=
0000
        00000001 00000001 7a1f2070 f7fbf490 4205dc87 0000000a 000009cd 7a1f=
217c
        7a022980 78514180 00000046 f7ed53e8 00000286 f7ed53e8 f7ed53c0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
cryptd        S F7E7FFA8     0   190      2 (L-TLB)
        f7e7ffbc 00000082 00000002 f7e7ffa8 f7e7ffa4 00000000 787ce0d8 f7fb=
5590
        00000001 00000000 f7fb5590 785143e0 42116cfc 0000000a 000076c7 f7fb=
569c
        7a01a980 78514180 fffb6d71 00000003 00000000 00000000 00000000 0000=
0000
Call Trace:
  [<7820a221>] cryptd_thread+0x95/0xa5
  [<7820a18c>] cryptd_thread+0x0/0xa5
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scsi_eh_0     S 7A1EA030     0   320      2 (L-TLB)
        f7ca1f80 00000092 f7e0f058 7a1ea030 7840d6e3 f7e0f000 f7cef000 7813=
e99c
        0000000a 00000000 7a1ea030 f7fbf490 7ebe3537 0000000b 00005ddb 7a1e=
a13c
        7a01a980 78514180 00000292 f7cef000 f7e0f000 00000000 00000282 f7e0=
f000
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<782e9a32>] scsi_error_handler+0x3b/0x28d
  [<782e99f7>] scsi_error_handler+0x0/0x28d
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scsi_eh_1     S F7CA5F6C     0   322      2 (L-TLB)
        f7ca5f80 00000092 00000002 f7ca5f6c f7ca5f68 00000000 00000000 7813=
e99c
        00000003 00000000 f7cf94d0 785143e0 7e3733ad 0000000b 0000c8a9 f7cf=
95dc
        7a01a980 78514180 fffb8236 00000003 00000000 00000000 00000282 f7cb=
d800
Call Trace:
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<782e9a32>] scsi_error_handler+0x3b/0x28d
  [<782e99f7>] scsi_error_handler+0x0/0x28d
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scsi_eh_2     S F7E0B590     0   339      2 (L-TLB)
        f7ca7f80 00000092 7a1d8058 f7e0b590 7840d6e3 7a1d8000 00000000 7813=
e99c
        00000006 00000000 f7e0b590 f7fbf490 9835b106 0000000b 004284a4 f7e0=
b69c
        7a01a980 78514180 00000292 00000282 7a1d8000 00000000 00000282 7a1d=
8000
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<782e9a32>] scsi_error_handler+0x3b/0x28d
  [<782e99f7>] scsi_error_handler+0x0/0x28d
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
scsi_eh_3     S F7CD0030     0   341      2 (L-TLB)
        f7ca3f80 00000092 f7cbd058 f7cd0030 7840d6e3 f7cbd000 00000000 7813=
e99c
        00000008 00000000 f7cd0030 f7fbf490 a28957bc 0000000b 003e72b9 f7cd=
013c
        7a01a980 78514180 00000292 00000282 f7cbd000 00000000 00000282 f7cb=
d000
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<782e9a32>] scsi_error_handler+0x3b/0x28d
  [<782e99f7>] scsi_error_handler+0x0/0x28d
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kpsmoused     S 00000000     0   407      2 (L-TLB)
        f7d75fb4 00000086 00000046 00000000 00000000 f7d1767c f7d005e0 0000=
0000
        00000009 00000000 f7d000b0 f7fbf490 d3b0a6af 0000000b 0000087a f7d0=
01bc
        7a01a980 78514180 00000046 f7d17668 00000286 f7d17668 f7d17640 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kcryptd/0     S 00000000     0   412      2 (L-TLB)
        f7d77fb4 00000086 00000046 00000000 00000000 f7d170fc f7e33090 0000=
0000
        00000009 00000000 f7e32b60 f7fbf490 e6cc0d2f 0000000b 000007f4 f7e3=
2c6c
        7a01a980 78514180 00000046 f7d170e8 00000286 f7d170e8 f7d170c0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kcryptd/1     S F7D71FA0     0   413      2 (L-TLB)
        f7d71fb4 00000086 00000002 f7d71fa0 f7d71f9c 00000000 f7d01010 0000=
0000
        00000008 00000001 f7d00ae0 f7fbe030 e6cc9219 0000000b 000010ad f7d0=
0bec
        7a022980 78514180 fffb8914 00000003 00000000 00000000 f7d5cf40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kmpathd/0     S 00000000     0   414      2 (L-TLB)
        f7d73fb4 00000086 00000046 00000000 00000000 f7d5cd7c f7cf85a0 0000=
0000
        00000009 00000000 f7cf8070 f7fbf490 e6cd348c 0000000b 00000786 f7cf=
817c
        7a01a980 78514180 00000046 f7d5cd68 00000286 f7d5cd68 f7d5cd40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kmpathd/1     S F7D6DFA0     0   415      2 (L-TLB)
        f7d6dfb4 00000086 00000002 f7d6dfa0 f7d6df9c 00000000 f7cf8fd0 0000=
0000
        00000008 00000001 f7cf8aa0 f7fbe030 e6cda902 0000000b 00000f2f f7cf=
8bac
        7a022980 78514180 fffb8914 00000003 00000000 00000000 f7d5ccc0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ksnapd        S 00000000     0   416      2 (L-TLB)
        f7d31fb4 00000086 00000046 00000000 00000000 f7d5c9fc f7d01a40 0000=
0000
        00000008 00000000 f7d01510 f7fbf490 e72c4b66 0000000b 0000070f f7d0=
161c
        7a01a980 78514180 00000046 f7d5c9e8 00000286 f7d5c9e8 f7d5c9c0 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kedac         S F7D7BF80     0   419      2 (L-TLB)
        f7d7bf94 00000086 00000002 f7d7bf80 f7d7bf7c 00000000 7840d6e3 7a1d=
2000
        0000000a 00000001 f7e0ab60 f7fbe030 acabac43 0001ff61 00000d5e f7e0=
ac6c
        7a022980 e913a340 219905f9 00000003 00000000 00000000 f7d7bfa4 2199=
09e0
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<78363dd9>] edac_kernel_thread+0x0/0xf3
  [<7812cada>] process_timeout+0x0/0x5
  [<78363dd9>] edac_kernel_thread+0x0/0xf3
  [<78363ea0>] edac_kernel_thread+0xc7/0xf3
  [<78363dd9>] edac_kernel_thread+0x0/0xf3
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
md4_raid5     S F7E2AB20     0   434      2 (L-TLB)
        7a255f84 00000006 7a21a920 f7e2ab20 7840d727 00000000 00000000 7a22=
4d5c
        0000000a 00000000 f7e2ab20 f6928030 63aadcb9 0001ff61 00002f44 f7e2=
ac2c
        7a01a980 e913a340 00000000 00000000 f7e2ab20 f7e2b050 7fffffff 7fff=
ffff
Call Trace:
  [<7840d727>] _spin_unlock_irq+0x20/0x41
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<78354f55>] md_thread+0xab/0xdc
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78354eaa>] md_thread+0x0/0xdc
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
md15_raid10   S 7A1F3A00     0   437      2 (L-TLB)
        7a253f84 00000006 7a1f34d0 7a1f3a00 785cde94 7a1f34d0 7840d6e3 785c=
de80
        0000000a 00000000 7a1f34d0 f6928a60 39bb729c 0001ff61 000011b8 7a1f=
35dc
        7a01a980 f58bf040 785cde80 7812ccc1 00000000 00000216 7a253f94 2199=
11f1
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7812cada>] process_timeout+0x0/0x5
  [<78354f55>] md_thread+0xab/0xdc
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78354eaa>] md_thread+0x0/0xdc
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
md0_raid1     S F7C7DA80     0   439      2 (L-TLB)
        f719ff84 00000086 f7c7d550 f7c7da80 785cde94 f7c7d550 7840d6e3 785c=
de80
        0000000a 00000000 f7c7d550 f6928030 706bbe1a 0001ff61 00002cc3 f7c7=
d65c
        7a01a980 e913a340 785cde80 7812ccc1 00000000 00000296 f719ff94 2199=
158a
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7812cada>] process_timeout+0x0/0x5
  [<78354f55>] md_thread+0xab/0xdc
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78354eaa>] md_thread+0x0/0xdc
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kjournald     S 00000000     0   441      2 (L-TLB)
        f717dfa8 00000082 00000046 00000000 00000000 f7199d3c f7c74608 f7c7=
45e0
        0000000a 00000000 f7c740b0 f6928030 575613ff 0001ff61 000092f3 f7c7=
41bc
        7a01a980 f6e31800 00000046 00000246 f7199c14 f7199c00 f7199c14 f719=
9c00
Call Trace:
  [<781aeb09>] kjournald+0x16d/0x1ec
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781ae99c>] kjournald+0x0/0x1ec
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kjournald     S F6DD5F94     0   584      2 (L-TLB)
        f6dd5fa8 00000082 00000002 f6dd5f94 f6dd5f90 00000000 f7fb4688 f7fb=
4660
        0000000a 00000001 f7fb4130 f7fbe030 545ba352 0001ff61 0000700b f7fb=
423c
        7a022980 e632d2c0 2199002b 00000003 00000000 00000000 f68c8814 f68c=
8800
Call Trace:
  [<781aeb09>] kjournald+0x16d/0x1ec
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781ae99c>] kjournald+0x0/0x1ec
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kjournald     S F588DF94     0   585      2 (L-TLB)
        f588dfa8 00000082 00000002 f588df94 f588df90 00000000 f7cd19e8 f7cd=
19c0
        0000000a 00000000 f7cd1490 785143e0 f0b5365d 0001ff24 00001614 f7cd=
159c
        7a01a980 f7cafa40 219507da 00000003 00000000 00000000 f58c1814 f58c=
1800
Call Trace:
  [<781aeb09>] kjournald+0x16d/0x1ec
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781ae99c>] kjournald+0x0/0x1ec
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kjournald     S 00000000     0   586      2 (L-TLB)
        f6fdbfa8 00000082 00000046 00000000 00000000 f58c113c 7a1dcfb8 7a1d=
cf90
        00000009 00000000 7a1dca60 f7cb80b0 53c6eaba 0000000d 00001d05 7a1d=
cb6c
        7a01a980 f68e9ac0 00000046 00000246 f58c1014 f58c1000 f58c1014 f58c=
1000
Call Trace:
  [<781aeb09>] kjournald+0x16d/0x1ec
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781ae99c>] kjournald+0x0/0x1ec
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kjournald     S 00000000     0   587      2 (L-TLB)
        f587bfa8 00000082 00000046 00000000 00000000 f64c993c f7c6da28 f7c6=
da00
        0000000a 00000001 f7c6d4d0 f7ea0b20 f44b1328 0001e632 0000149c f7c6=
d5dc
        7a022980 e632d2c0 00000046 00000246 f64c9814 f64c9800 f64c9814 f64c=
9800
Call Trace:
  [<781aeb09>] kjournald+0x16d/0x1ec
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781ae99c>] kjournald+0x0/0x1ec
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kjournald     S 00000000     0   588      2 (L-TLB)
        f58c9fa8 00000082 00000046 00000000 00000000 f64c913c 7a1dc588 7a1d=
c560
        00000008 00000000 7a1dc030 f7cb80b0 5d289ec0 0000000d 00001bb0 7a1d=
c13c
        7a01a980 f68e9ac0 00000046 00000246 f64c9014 f64c9000 f64c9014 f64c=
9000
Call Trace:
  [<781aeb09>] kjournald+0x16d/0x1ec
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781ae99c>] kjournald+0x0/0x1ec
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
syslogd       D 00000000     0  2197      1 (NOTLB)
        f6267c74 00000082 00000000 00000000 7813e7a9 f7cc8130 7840d6e3 785c=
de80
        00000007 00000000 f7cc8130 f7c74ae0 abd727e3 0001ff61 00002fdc f7cc=
823c
        7a01a980 f6b15840 785cde80 7812ccc1 00000000 00000292 f6267c84 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<7814a8cf>] __generic_file_aio_write_nolock+0x335/0x4df
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<7816402f>] do_sync_readv_writev+0xc1/0xfe
  [<78139494>] getnstimeofday+0x30/0xbc
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78163ee4>] rw_copy_check_uvector+0x50/0xaa
  [<781646b4>] do_readv_writev+0x99/0x164
  [<78199b90>] ext3_file_write+0x0/0x92
  [<781647bc>] vfs_writev+0x3d/0x48
  [<78164b9e>] sys_writev+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
klogd         S F5F37DB8     0  2211      1 (NOTLB)
        f5f37dcc 00000086 00000002 f5f37db8 f5f37db4 00000000 00000000 f6f7=
7f54
        00000007 00000000 f7c6caa0 785143e0 579dd14b 0001ff41 000c175e f7c6=
cbac
        7a01a980 f62ada40 2196e5cc 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78370f09>] sock_aio_write+0xcb/0xd7
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781649e7>] vfs_read+0xcf/0x10a
  [<781648aa>] vfs_write+0x9e/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
acpid         S F5C35BE8     0  2265      1 (NOTLB)
        f5c35bfc 00000082 00000002 f5c35be8 f5c35be4 00000000 78528e74 f7cc=
1550
        00000001 00000000 f7cc1550 785143e0 87711dce 0000000f 0000efdb f7cc=
165c
        7a01a980 f6b150c0 fffbc622 00000003 00000000 00000000 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<783cbaf6>] unix_poll+0x1a/0x9a
  [<7816e77e>] do_sys_poll+0x258/0x327
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d732>] _spin_unlock_irq+0x2b/0x41
  [<7840af41>] __sched_text_start+0x7e9/0x810
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<783cc862>] unix_dgram_sendmsg+0x3b3/0x431
  [<7840d33a>] _read_lock+0x33/0x3e
  [<7840d699>] _read_unlock+0x25/0x3b
  [<783cc862>] unix_dgram_sendmsg+0x3b3/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<781383ba>] up_read+0x14/0x26
  [<781197d3>] do_page_fault+0x278/0x535
  [<78103e68>] restore_nocheck+0x12/0x15
  [<7811955b>] do_page_fault+0x0/0x535
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816e881>] sys_poll+0x34/0x37
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S F31C9B4C     0  2823      1 (NOTLB)
        f31c9b60 00000096 00000002 f31c9b4c f31c9b48 00000000 7840d6e3 7a1d=
2000
        00000007 00000001 f7e32130 f7fbe030 65ed4f6c 0001ff60 000151f2 f7e3=
223c
        7a022980 f64f1800 2198f07d 00000003 00000000 00000000 f31c9b70 2199=
178d
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7812cada>] process_timeout+0x0/0x5
  [<7816ec1d>] do_select+0x399/0x3e7
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7838b171>] __nf_ct_refresh_acct+0xcf/0x10a
  [<7816f1be>] __pollwait+0x0/0xac
  [<7838b171>] __nf_ct_refresh_acct+0xcf/0x10a
  [<7838eaf9>] tcp_packet+0xa0f/0xa3e
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<783bb722>] inet_sock_destruct+0x179/0x1bb
  [<783b147b>] tcp_v4_rcv+0x51a/0x787
  [<783994b1>] ip_local_deliver+0x1bd/0x1c8
  [<78398c10>] ip_local_deliver_finish+0x0/0x14c
  [<783992bb>] ip_rcv+0x498/0x4d1
  [<7839896c>] ip_rcv_finish+0x0/0x2a4
  [<78139494>] getnstimeofday+0x30/0xbc
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<782be370>] e1000_clean_tx_irq+0xbc/0x2c5
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7812e2a3>] group_send_sig_info+0x12/0x56
  [<7812e378>] kill_pid_info+0x61/0x7b
  [<7812f183>] sys_kill+0x108/0x125
  [<7816f30a>] sys_select+0xa0/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
clamd         S 00000000     0  2889      1 (NOTLB)
        f32d1e58 00000086 00000002 00000000 00010822 00000000 00000000 ee9a=
69ac
        00000001 00000001 f7cb80b0 db4c8030 6f522ff7 0001e655 00010e05 f7cb=
81bc
        7a022980 f68e9ac0 00000000 00000000 f7cb80b0 f7cb85e0 7fffffff f5e2=
d380
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<783787ab>] skb_recv_datagram+0x13f/0x1c4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783ccdf1>] unix_accept+0x51/0xde
  [<7837262e>] sys_accept+0xb2/0x187
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<781671ca>] sys_fstat64+0x1e/0x23
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
freshclam     D 00000000     0  2898      1 (NOTLB)
        f2f43cc4 00000082 00000000 00000000 7813e7a9 f6928030 7840d6e3 785c=
de80
        00000008 00000000 f6928030 f7cc8130 abd6f807 0001ff61 00003332 f692=
813c
        7a01a980 f58bfa40 785cde80 7812ccc1 00000000 00000296 f2f43cd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7840d727>] _spin_unlock_irq+0x20/0x41
  [<7840d732>] _spin_unlock_irq+0x2b/0x41
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
named         S F0989D0C     0  2959      1 (NOTLB)
        f0989d20 00200092 00000002 f0989d0c f0989d08 00000000 00000000 f6f7=
7f54
        0000000a 00000000 f7e13490 785143e0 0e816649 0001e659 00013c17 f7e1=
359c
        7a01a980 f58bf2c0 1ff3b86f 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<78171ebc>] dput+0x16/0xe4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<78169ed9>] path_release+0xa/0x20
  [<78166c60>] cp_new_stat64+0xfc/0x10e
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
crond         D 00000000     0  3061      1 (NOTLB)
        f1367cc4 00000082 00000000 00000000 7813e7a9 f7e02b20 7840d6e3 7a1d=
2000
        00000008 00000001 f7e02b20 edcd0a60 abd708dc 0001ff61 0000367c f7e0=
2c2c
        7a022980 f58bfcc0 7a1d2000 7812ccc1 00000000 00000296 f1367cd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
mdadm         S F1ADDB4C     0  3110      1 (NOTLB)
        f1addb60 00000096 00000002 f1addb4c f1addb48 00000000 7840d6e3 785c=
de80
        00000007 00000000 f6928a60 785143e0 39bb937f 0001ff61 000020e3 f692=
8b6c
        7a01a980 f58bf040 2198fe6a 00000003 00000000 00000000 f1addb70 2199=
e8c9
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7812cada>] process_timeout+0x0/0x5
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7840d727>] _spin_unlock_irq+0x20/0x41
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d732>] _spin_unlock_irq+0x2b/0x41
  [<7840af41>] __sched_text_start+0x7e9/0x810
  [<7840ae59>] __sched_text_start+0x701/0x810
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7811e3ba>] __wake_up+0x32/0x43
  [<7840b09e>] preempt_schedule+0x46/0x58
  [<7834dc68>] md_wakeup_thread+0x26/0x28
  [<78354e25>] md_ioctl+0x1261/0x12e6
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d727>] _spin_unlock_irq+0x20/0x41
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7840bd93>] __mutex_unlock_slowpath+0x105/0x127
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78352e61>] md_open+0x51/0x58
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<781335c2>] call_rcu+0x64/0x69
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816f30a>] sys_select+0xa0/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
portmap       S F1571BE8     0  3161      1 (NOTLB)
        f1571bfc 00000082 00000002 f1571be8 f1571be4 00000000 00000000 0000=
0000
        00000007 00000001 7a1dd490 f7fbe030 e696d8aa 00000013 000281e5 7a1d=
d59c
        7a022980 f6e31080 fffc0fae 00000003 00000000 00000000 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<783b435a>] udp_poll+0x10/0xdb
  [<7816e77e>] do_sys_poll+0x258/0x327
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7840d1f4>] _spin_lock_bh+0x38/0x43
  [<783b57a5>] udp_sendmsg+0x4a7/0x5b9
  [<783ba7cb>] inet_sendmsg+0x3b/0x45
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<78377ed6>] verify_iovec+0x3e/0x70
  [<783719e4>] sys_sendmsg+0x194/0x1f9
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7814cb18>] free_hot_cold_page+0x13b/0x167
  [<7814cb24>] free_hot_cold_page+0x147/0x167
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814cb58>] __pagevec_free+0x14/0x1a
  [<7814ecc5>] release_pages+0x126/0x12e
  [<78159060>] anon_vma_unlink+0x13/0x53
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816e881>] sys_poll+0x34/0x37
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
rpciod/0      S 00000000     0  3216      2 (L-TLB)
        ec88dfb4 00000086 00000046 00000000 00000000 f6343c7c 7a1eb9c0 0000=
0000
        0000000a 00000000 7a1eb490 89333550 78dbc731 0001e655 0000401b 7a1e=
b59c
        7a01a980 c053d840 00000046 f6343c68 00000286 f6343c68 f6343c40 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
rpciod/1      S 00000000     0  3217      2 (L-TLB)
        ec8e7fb4 00000086 00000046 00000000 00000000 f5a6867c f69299c0 0000=
0000
        0000000a 00000001 f6929490 a79ec0b0 2e2b55c5 00000834 0000ce3a f692=
959c
        7a022980 a71d7340 00000046 f5a68668 00000286 f5a68668 f5a68640 7813=
2a2b
Call Trace:
  [<78132a2b>] worker_thread+0x0/0xc5
  [<78132ab3>] worker_thread+0x88/0xc5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
lockd         S 00000001     0  3218      2 (L-TLB)
        ec865f18 00000082 7813534c 00000001 784d6071 f7e02628 00000000 0000=
0000
        00000001 00000000 f7e020f0 f7ca8a60 e69b3708 00000013 0000a1e7 f7e0=
21fc
        7a01a980 f68e90c0 f7e02620 f7e020f0 781299b4 f0fecd7c 7fffffff f0fe=
c000
Call Trace:
  [<7813534c>] add_wait_queue+0x12/0x30
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<783ffbab>] svc_recv+0x249/0x3ca
  [<7812027d>] default_wake_function+0x0/0xc
  [<781e6643>] lockd+0xe8/0x1fd
  [<78121e77>] schedule_tail+0x0/0xb6
  [<78103e68>] restore_nocheck+0x12/0x15
  [<781e655b>] lockd+0x0/0x1fd
  [<781e655b>] lockd+0x0/0x1fd
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
ntpd          S EC959B4C     0  3269      1 (NOTLB)
        ec959b60 00200096 00000002 ec959b4c ec959b48 00000000 f7cb05a0 0020=
0046
        0000000a 00000000 f7cb0070 785143e0 a27c1eef 0001ff61 0000aea1 f7cb=
017c
        7a01a980 f7cafa40 2199054d 00000003 00000000 00000000 7fffffff ec95=
9f9c
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783b435a>] udp_poll+0x10/0xdb
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<783760ad>] skb_dequeue+0x39/0x3f
  [<783786ed>] skb_recv_datagram+0x81/0x1c4
  [<783b5b8f>] udp_recvmsg+0x57/0x1cd
  [<78372cc9>] sock_common_recvmsg+0x3e/0x54
  [<78371763>] sock_recvmsg+0xcf/0xe8
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7837221d>] sys_recvmsg+0x11d/0x1cf
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<7840d732>] _spin_unlock_irq+0x2b/0x41
  [<78103986>] do_notify_resume+0x511/0x5f3
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816f340>] sys_select+0xd6/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sqlgrey       S 00000000     0  3323      1 (NOTLB)
        ec79fb60 00200096 786b7ed0 00000000 7837cbf7 00200046 00000000 0000=
0000
        00000004 00000001 f7cb0aa0 f7fbf490 b29583a6 0001f67f 00068968 f7cb=
0bac
        7a022980 f68e90c0 7813e99c 00000000 00200046 ec975398 7fffffff ec79=
ff9c
Call Trace:
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<783b133f>] tcp_v4_rcv+0x3de/0x787
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<7839949e>] ip_local_deliver+0x1aa/0x1c8
  [<78398c10>] ip_local_deliver_finish+0x0/0x14c
  [<783992bb>] ip_rcv+0x498/0x4d1
  [<7839896c>] ip_rcv_finish+0x0/0x2a4
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7837c73c>] process_backlog+0xef/0xfa
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7837c9d8>] net_rx_action+0x162/0x18f
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781298c7>] local_bh_enable+0x110/0x130
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816f340>] sys_select+0xd6/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smartd        S EA68DD0C     0  3487      1 (NOTLB)
        ea68dd20 00000092 00000002 ea68dd0c ea68dd08 00000000 00000000 f6f7=
7f54
        00000009 00000000 ec907490 785143e0 ad75944f 0001e66c 00034dc2 ec90=
759c
        7a01a980 f6e11040 1ff502a1 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783cc30c>] unix_wait_for_peer+0x75/0x9a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783cc80c>] unix_dgram_sendmsg+0x35d/0x431
  [<78371838>] sock_sendmsg+0xbc/0xd4
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813facb>] lock_release_non_nested+0xec/0x14d
  [<783cdc63>] unix_dgram_connect+0x8d/0x157
  [<783cdd00>] unix_dgram_connect+0x12a/0x157
  [<783cdc63>] unix_dgram_connect+0x8d/0x157
  [<78371b64>] sys_sendto+0x11b/0x13b
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<783cdd00>] unix_dgram_connect+0x12a/0x157
  [<7837135e>] sys_connect+0x72/0x9c
  [<78371bbb>] sys_send+0x37/0x3b
  [<78372830>] sys_socketcall+0x12d/0x242
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
snmpd         D 00000000     0  3546      1 (NOTLB)
        ea333cc4 00200082 00000000 00000000 7813e7a9 f7c74ae0 7840d6e3 785c=
de80
        00000007 00000000 f7c74ae0 89333550 abd756a0 0001ff61 00002ebd f7c7=
4bec
        7a01a980 f6e31800 785cde80 7812ccc1 00000000 00200296 ea333cd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squid         S E9A41F20     0  3604      1 (NOTLB)
        e9a41f34 00200082 00000002 e9a41f20 e9a41f1c 00000000 e9e6da40 e9e6=
da40
        00000005 00000000 e9e6d510 785143e0 74bc2237 00000016 00014e53 e9e6=
d61c
        7a01a980 f6e31d00 fffc3aae 00000003 00000000 00000000 ffffffff 0000=
0001
Call Trace:
  [<781276ea>] do_wait+0x8eb/0x9e6
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7812027d>] default_wake_function+0x0/0xc
  [<78127816>] sys_wait4+0x31/0x34
  [<78127840>] sys_waitpid+0x27/0x2b
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squid         D 00000000     0  3606   3604 (NOTLB)
        e9a65cc4 00000082 00000000 00000000 7813e7a9 f7cb9510 7840d6e3 7a1d=
2000
        00000007 00000001 f7cb9510 edcd1490 abd7ba4d 0001ff61 000021db f7cb=
961c
        7a022980 f6ce25c0 7a1d2000 7812ccc1 00000000 00000296 e9a65cd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sshd          S E9239B4C     0  3663      1 (NOTLB)
        e9239b60 00200096 00000002 e9239b4c e9239b48 00000000 00000000 0000=
0000
        00000006 00000000 e9b7e0f0 785143e0 61b30795 0001ff2d 000245bd e9b7=
e1fc
        7a01a980 f62ad540 219595ea 00000003 00000000 00000000 7fffffff e923=
9f9c
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<7816e4d2>] free_poll_entry+0xe/0x16
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<782be370>] e1000_clean_tx_irq+0xbc/0x2c5
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7840d727>] _spin_unlock_irq+0x20/0x41
  [<7816f340>] sys_select+0xd6/0x188
  [<78103e68>] restore_nocheck+0x12/0x15
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd S 7A1F2AA0     0  3722      1 (NOTLB)
        e9369f34 00200082 7854ec14 7a1f2aa0 00000001 786b7e90 7a1f2fd0 7a1f=
2fd0
        00000001 00000001 7a1f2aa0 f7fb4b60 0ec74ab6 00000017 0000b6ef 7a1f=
2bac
        7a022980 e9314540 00000000 00200246 7854ec00 00000001 00000e8c 0000=
0001
Call Trace:
  [<781276ea>] do_wait+0x8eb/0x9e6
  [<781197d3>] do_page_fault+0x278/0x535
  [<7812027d>] default_wake_function+0x0/0xc
  [<78127816>] sys_wait4+0x31/0x34
  [<78127840>] sys_waitpid+0x27/0x2b
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd S E93D1F2C     0  3724   3722 (NOTLB)
        e93d1f40 00200092 00000002 e93d1f2c e93d1f28 00000000 7813e99c 7a02=
391c
        00000008 00000001 ec8de0f0 f7fbe030 aa5c0061 0001ff61 0004acea ec8d=
e1fc
        7a022980 e9314cc0 219905d2 00000003 00000000 00000000 e93d1f58 0000=
0001
Call Trace:
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840c5af>] do_nanosleep+0x48/0x73
  [<78137d84>] hrtimer_nanosleep+0x39/0xdc
  [<78137879>] hrtimer_wakeup+0x0/0x18
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78137e70>] sys_nanosleep+0x49/0x59
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd S 00000070     0  3725   3722 (NOTLB)
        e8ccbe44 00200086 00000001 00000070 7a01b3e0 00000002 00000000 ead5=
e140
        00000001 00000000 e90b8b60 e9e6cae0 0f7701b8 00000017 000051d5 e90b=
8c6c
        7a01a980 e913a0c0 fffc44d7 00000003 00000000 00000070 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<78153c96>] __handle_mm_fault+0x29a/0x83b
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78153d89>] __handle_mm_fault+0x38d/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd S E8CCDE30     0  3726   3722 (NOTLB)
        e8ccde44 00200086 00000002 e8ccde30 e8ccde2c 00000000 00000000 ead5=
e140
        00000001 00000000 e9e6cae0 785143e0 0fa415f1 00000017 0001181a e9e6=
cbec
        7a01a980 e93147c0 fffc44d7 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<78153c96>] __handle_mm_fault+0x29a/0x83b
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78153d89>] __handle_mm_fault+0x38d/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd S 00000000     0  3727   3722 (NOTLB)
        e8cede44 00200086 00000000 00000000 7813e7a9 00000000 00000000 ead5=
e140
        00000001 00000001 f7cb8ae0 e9e6c0b0 0fbbed36 00000017 0003651f f7cb=
8bec
        7a022980 f62ad040 f7cb9010 f7cb8ae0 781299b4 e8cedea0 7fffffff 7fff=
ffff
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<78153c96>] __handle_mm_fault+0x29a/0x83b
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78153d89>] __handle_mm_fault+0x38d/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
zabbix_agentd D E8CEFCB0     0  3728   3722 (NOTLB)
        e8cefcc4 00200082 00000002 e8cefcb0 e8cefcac 00000000 7840d6e3 7a1d=
2000
        00000008 00000001 e9e6c0b0 f7fbe030 abd7fd2c 0001ff61 00002173 e9e6=
c1bc
        7a022980 e913a340 219905eb 00000003 00000000 00000000 e8cefcd4 2199=
064e
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<7814a8cf>] __generic_file_aio_write_nolock+0x335/0x4df
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7814ce3d>] get_page_from_freelist+0x293/0x35e
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<78153e4d>] __handle_mm_fault+0x451/0x83b
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781197d3>] do_page_fault+0x278/0x535
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<7811955b>] do_page_fault+0x0/0x535
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S E8849EC8     0  3791      1 (NOTLB)
        e8849edc 00000086 00000002 e8849ec8 e8849ec4 00000000 00000000 0000=
0000
        00000007 00000001 f7fb4b60 f7fbe030 6d0455f6 00000017 0018bcb8 f7fb=
4c6c
        7a022980 f6b15d40 fffc4afe 00000003 00000000 00000000 7fffffff f539=
f000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 00000000     0  3793      1 (NOTLB)
        e8d19edc 00000086 00000000 00000000 f53a5c8c ea120a60 00000000 0000=
0000
        00000007 00000001 ea120a60 f7e12030 70e57c7e 00000017 0010cf04 ea12=
0b6c
        7a022980 e9314040 ea120f98 ea120a60 00000000 00000000 7fffffff f53a=
5800
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 00000000     0  3794      1 (NOTLB)
        e8d61edc 00000086 00000000 00000000 f56dcc8c f7e12030 00000000 0000=
0000
        00000007 00000001 f7e12030 ec8deb20 70f48c60 00000017 000f0fe2 f7e1=
213c
        7a022980 f62adcc0 f7e12568 f7e12030 00000000 00000000 7fffffff f56d=
c800
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 00000000     0  3795      1 (NOTLB)
        e8d23edc 00000086 00000000 00000000 f52fcc8c ec8deb20 00000000 0000=
0000
        00000007 00000001 ec8deb20 ec8ff590 71036a29 00000017 000eddc9 ec8d=
ec2c
        7a022980 e913a840 ec8df058 ec8deb20 00000000 00000000 7fffffff f52f=
c800
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 00000000     0  3796      1 (NOTLB)
        e8903edc 00000086 00000000 00000000 f583748c ec8ff590 00000000 0000=
0000
        00000007 00000001 ec8ff590 e8eea130 71118e5d 00000017 000e2434 ec8f=
f69c
        7a022980 f6f5b080 ec8ffac8 ec8ff590 00000000 00000000 7fffffff f583=
7000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S E8921EC8     0  3797      1 (NOTLB)
        e8921edc 00000086 00000002 e8921ec8 e8921ec4 00000000 00000000 0000=
0000
        00000007 00000001 e8eea130 f7fbe030 713eaf24 00000017 00023594 e8ee=
a23c
        7a022980 e913a5c0 fffc4b41 00000003 00000000 00000000 7fffffff f724=
2000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 00000000     0  3798      1 (NOTLB)
        e8923edc 00000086 00000000 00000000 f5d5048c ec906030 00000000 0000=
0000
        00000007 00000001 ec906030 ea024070 712da585 00000017 000ebb02 ec90=
613c
        7a022980 e913aac0 ec906568 ec906030 00000000 00000000 7fffffff f5d5=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
agetty        S 00000000     0  3799      1 (NOTLB)
        e8925edc 00000086 00000000 00000000 f6f2348c ea024070 00000000 0000=
0000
        00000007 00000001 ea024070 e8eea130 713c7990 00000017 000ed40b ea02=
417c
        7a022980 f6e31580 ea0245a8 ea024070 00000000 00000000 7fffffff f6f2=
3000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cf28>] read_chan+0x2fb/0x54b
  [<78297ed7>] tty_ldisc_try+0x2e/0x32
  [<7812027d>] default_wake_function+0x0/0xc
  [<7829cc2d>] read_chan+0x0/0x54b
  [<7829a215>] tty_read+0x67/0xaf
  [<7829a1ae>] tty_read+0x0/0xaf
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sshd          S E3429DC4     0  3835   3663 (NOTLB)
        e3429dd8 00000082 00000002 e3429dc4 e3429dc0 00000000 00000000 e127=
99ac
        00000007 00000000 7a1eaa60 785143e0 1e0f5b36 00000025 00001291 7a1e=
ab6c
        7a01a980 e8d34d00 fffd3160 00000003 00000000 00000000 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sshd          S E6C59B4C     0  3838   3835 (NOTLB)
        e6c59b60 00000096 00000002 e6c59b4c e6c59b48 00000000 e90b8688 e90b=
8668
        0000000a 00000000 e90b8130 785143e0 28faff08 0001ff23 0001a008 e90b=
823c
        7a01a980 f71bd580 2194e9e6 00000003 00000000 00000000 7fffffff e6c5=
9f9c
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cb0e>] normal_poll+0x0/0x11f
  [<78298d67>] tty_poll+0x56/0x63
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7839dedc>] ip_output+0x270/0x2ac
  [<7839c7d5>] ip_finish_output+0x0/0x212
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7839b270>] dst_output+0x0/0x7
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783a3340>] tcp_sendmsg+0x91c/0xa0d
  [<7840d1f4>] _spin_lock_bh+0x38/0x43
  [<783a3340>] tcp_sendmsg+0x91c/0xa0d
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<78370f09>] sock_aio_write+0xcb/0xd7
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816f340>] sys_select+0xd6/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
bash          S EA120030     0  3839   3838 (NOTLB)
        e3c81f34 00000082 7854ec14 ea120030 00000001 786b7e90 ea120560 ea12=
0560
        00000009 00000000 ea120030 e7428030 3ac85a37 00000028 00019fc2 ea12=
013c
        7a01a980 f71bd800 00000000 00000246 7854ec00 00000001 ffffffff 0000=
0001
Call Trace:
  [<781276ea>] do_wait+0x8eb/0x9e6
  [<7812027d>] default_wake_function+0x0/0xc
  [<78127816>] sys_wait4+0x31/0x34
  [<78127840>] sys_waitpid+0x27/0x2b
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
bash          S E7428030     0  3866   3839 (NOTLB)
        e5f65f34 00000082 7854ec14 e7428030 00000001 786b7e90 e7428560 e742=
8560
        00000008 00000000 e7428030 f7c6c070 8cd13ab9 0001ff22 0001ae9d e742=
813c
        7a01a980 f71bda80 00000000 00000246 7854ec00 00000001 ffffffff 0000=
0001
Call Trace:
  [<781276ea>] do_wait+0x8eb/0x9e6
  [<7812027d>] default_wake_function+0x0/0xc
  [<78127816>] sys_wait4+0x31/0x34
  [<78127840>] sys_waitpid+0x27/0x2b
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sshd          S 00000127     0  3878   3663 (NOTLB)
        e3d2bdd8 00000082 00000000 00000127 00000000 00000000 00000000 e4c4=
c0ac
        00000007 00000001 e21fa0b0 e21fb510 5abe5861 0000002b 00001417 e21f=
a1bc
        7a022980 f71bd080 e21fa5e0 e21fa0b0 00000000 e21fa0b0 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78160ec2>] kmem_cache_free+0x9a/0xa1
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sshd          S 00000000     0  3880   3878 (NOTLB)
        e406fb60 00000096 00000046 00000000 00000002 00000001 e21fba68 e21f=
ba48
        0000000a 00000000 e21fb510 e4632130 adc501bc 0001ff61 00010239 e21f=
b61c
        7a01a980 e93142c0 e91624c0 e1acb80c 7813e99c e91624c0 7fffffff e406=
ff9c
Call Trace:
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<7829cb0e>] normal_poll+0x0/0x11f
  [<78298d67>] tty_poll+0x56/0x63
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7839dedc>] ip_output+0x270/0x2ac
  [<7839c7d5>] ip_finish_output+0x0/0x212
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7839b270>] dst_output+0x0/0x7
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7840d6ef>] _spin_unlock_irqrestore+0x40/0x58
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783a3340>] tcp_sendmsg+0x91c/0xa0d
  [<7840d1f4>] _spin_lock_bh+0x38/0x43
  [<783a3340>] tcp_sendmsg+0x91c/0xa0d
  [<78120273>] try_to_wake_up+0x393/0x39d
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<78370f09>] sock_aio_write+0xcb/0xd7
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816f340>] sys_select+0xd6/0x188
  [<78103dc6>] sysenter_past_esp+0x8f/0x99
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
bash          S E401D550     0  3881   3880 (NOTLB)
        e401ff34 00000082 7854ec14 e401d550 00000001 786b7e90 e401da80 e401=
da80
        00000009 00000000 e401d550 e8eeab60 53749886 0000002c 0001b062 e401=
d65c
        7a01a980 e4743d40 00000000 00000246 7854ec00 00000001 ffffffff 0000=
0001
Call Trace:
  [<781276ea>] do_wait+0x8eb/0x9e6
  [<7812027d>] default_wake_function+0x0/0xc
  [<78127816>] sys_wait4+0x31/0x34
  [<78127840>] sys_waitpid+0x27/0x2b
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
bash          R running     0  3887   3881 (NOTLB)
unlinkd       S 00000218     0  1139   3606 (NOTLB)
        c1d17e58 00000086 00000002 00000218 7a0233e0 00000002 00000000 8933=
2b20
        00000007 00000001 89332b20 f7cd1490 861dbffc 0001e62a 00045f0d 8933=
2c2c
        7a022980 f6e11a40 1ff0a94d 00000003 00000000 00000218 f5a60c00 f7cb=
5b78
Call Trace:
  [<7816943d>] pipe_wait+0x53/0x73
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78169b7d>] pipe_read+0x2af/0x321
  [<78174b7c>] file_update_time+0x22/0x6a
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<78164176>] do_sync_read+0x0/0x10a
  [<781649a0>] vfs_read+0x88/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pdflush       S ACC9FF9C     0   944      2 (L-TLB)
        acc9ffb0 00000092 00000002 acc9ff9c acc9ff98 00000000 9c505590 9c50=
5590
        00000007 00000001 7a1fa0b0 f7fbe030 6ce9b6b3 0001e655 0000065b 7a1f=
a1bc
        7a022980 f68e9340 1ff37b50 00000003 00000000 00000000 acc9ffc8 7814=
e33a
Call Trace:
  [<7814e33a>] pdflush+0x0/0x1a6
  [<7814e3e8>] pdflush+0xae/0x1a6
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S 00000000     0  6000   2823 (NOTLB)
        929dfe44 00000086 00000000 00000000 7813e7a9 00000000 00000000 f532=
f940
        0000000a 00000001 e8eeb590 f7e03550 a54ef8a7 0001e62a 000028bb e8ee=
b69c
        7a022980 d3e4a040 e8eebac0 e8eeb590 781299b4 fffffe00 7fffffff 7fff=
ffff
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<781332be>] __rcu_process_callbacks+0xe3/0x172
  [<781332a7>] __rcu_process_callbacks+0xcc/0x172
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squidauth.pl  S 95039DC4     0  6285   3606 (NOTLB)
        95039dd8 00000082 00000002 95039dc4 95039dc0 00000000 00000000 c310=
76ac
        00000005 00000001 7f498aa0 f7fbe030 84d480c7 0001e4d0 00001b01 7f49=
8bac
        7a022980 f6e117c0 1fd9ea3c 00000003 00000000 00000000 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7814aada>] generic_file_aio_write+0x61/0xb6
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squidauth.pl  S 00000127     0  6286   3606 (NOTLB)
        bc6c7dd8 00000082 00000000 00000127 00000000 00000000 00000000 d18f=
63ac
        00000007 00000001 e7429490 f7e2b550 15274906 0001df92 0004a752 e742=
959c
        7a022980 f68e9d40 e74299c0 e7429490 00000000 e7429490 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7814aada>] generic_file_aio_write+0x61/0xb6
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78165177>] __fput+0x10a/0x134
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
squidauth.pl  S 00000127     0  6287   3606 (NOTLB)
        e31d5dd8 00000082 00000000 00000127 00000000 00000000 00000000 9cb7=
6cac
        00000007 00000001 f7e2b550 7f498aa0 152ad54d 0001df92 00038c47 f7e2=
b65c
        7a022980 c053dac0 f7e2ba80 f7e2b550 00000000 f7e2b550 7fffffff 0000=
0000
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<783ccb1d>] unix_stream_recvmsg+0x1f2/0x475
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78370fdd>] sock_aio_read+0xc8/0xd4
  [<7814aada>] generic_file_aio_write+0x61/0xb6
  [<7816423d>] do_sync_read+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78165177>] __fput+0x10a/0x134
  [<781649b4>] vfs_read+0x9c/0x10a
  [<78164da8>] sys_read+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pdflush       S F6A75F9C     0  6288      2 (L-TLB)
        f6a75fb0 00000092 00000002 f6a75f9c f6a75f98 00000000 00000292 edcd=
0560
        0000000a 00000001 edcd0030 f7fbe030 bc332535 0001ff60 00002604 edcd=
013c
        7a022980 f6e31800 2198f62b 00000003 00000000 00000000 f6a75fc8 7814=
e33a
Call Trace:
  [<7814e33a>] pdflush+0x0/0x1a6
  [<7814e3e8>] pdflush+0xae/0x1a6
  [<781350d5>] kthread+0x38/0x5f
  [<7813509d>] kthread+0x0/0x5f
  [<78104a8f>] kernel_thread_helper+0x7/0x10
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S 85DD5E30     0  6350   2823 (NOTLB)
        85dd5e44 00000086 00000002 85dd5e30 85dd5e2c 00000000 00000000 f532=
f940
        00000007 00000001 a163eaa0 f7fbe030 bcc842a9 0001e62a 000024c3 a163=
ebac
        7a022980 f62ad2c0 1ff0acdf 00000003 00000000 00000000 7fffffff 7fff=
ffff
Call Trace:
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a0b90>] inet_csk_accept+0x9e/0x214
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<783bb524>] inet_accept+0x1f/0xa4
  [<78371564>] sock_attach_fd+0x53/0xb5
  [<7837262e>] sys_accept+0xb2/0x187
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<783727bc>] sys_socketcall+0xb9/0x242
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103e68>] restore_nocheck+0x12/0x15
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S F7E03550     0  6922   2823 (NOTLB)
        d7bdfb60 00000096 786b7ed0 f7e03550 00000001 00000046 00000000 0000=
0000
        0000000a 00000001 f7e03550 edcd0a60 6a543cc5 0001e655 0008e72a f7e0=
365c
        7a022980 f6e11cc0 7813e99c 00000000 00000046 f5829698 7fffffff d7bd=
ff9c
Call Trace:
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<783b133f>] tcp_v4_rcv+0x3de/0x787
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<783b1465>] tcp_v4_rcv+0x504/0x787
  [<7839949e>] ip_local_deliver+0x1aa/0x1c8
  [<78398c10>] ip_local_deliver_finish+0x0/0x14c
  [<783992bb>] ip_rcv+0x498/0x4d1
  [<7839896c>] ip_rcv_finish+0x0/0x2a4
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7837c73c>] process_backlog+0xef/0xfa
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7837c9d8>] net_rx_action+0x162/0x18f
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781298c7>] local_bh_enable+0x110/0x130
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7838108c>] neigh_resolve_output+0x1f2/0x224
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<7812938d>] _local_bh_enable+0xb1/0xbe
  [<781197d3>] do_page_fault+0x278/0x535
  [<7816f340>] sys_select+0xd6/0x188
  [<78103e68>] restore_nocheck+0x12/0x15
  [<7811955b>] do_page_fault+0x0/0x535
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       D 00000000     0  7227   2823 (NOTLB)
        d1953e2c 00000082 00000000 00000000 7813e7a9 edcd0a60 7840d6e3 7a1d=
2000
        00000007 00000001 edcd0a60 f7cb14d0 abd73b81 0001ff61 000032a5 edcd=
0b6c
        7a022980 e632d2c0 7a1d2000 7812ccc1 00000000 00000292 d1953e3c 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<78152ded>] do_wp_page+0x3c4/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<78138305>] down_read_trylock+0x47/0x4e
  [<7811976d>] do_page_fault+0x212/0x535
  [<7811955b>] do_page_fault+0x0/0x535
  [<7840d96a>] error_code+0x72/0x78
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
amavisd       S 00000002     0  7836   2823 (NOTLB)
        98947b60 00000096 00000000 00000002 7840ae59 00000000 00000000 0000=
0000
        0000000a 00000000 ec8feb60 89333550 bca917ba 0001e62a 00001d50 ec8f=
ec6c
        7a01a980 e8d34a80 1ff0ab63 00000003 00000000 00000000 7fffffff 9894=
7f9c
Call Trace:
  [<7840ae59>] __sched_text_start+0x701/0x810
  [<7840b667>] schedule_timeout+0x13/0x8d
  [<783a2023>] tcp_poll+0x1c/0x129
  [<7816ec1d>] do_select+0x399/0x3e7
  [<7816f1be>] __pollwait+0x0/0xac
  [<7812027d>] default_wake_function+0x0/0xc
  [<7812027d>] default_wake_function+0x0/0xc
  [<7813e986>] trace_hardirqs_on+0x10c/0x14c
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<781298c7>] local_bh_enable+0x110/0x130
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7837cbf7>] dev_queue_xmit+0x1f2/0x213
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<781299b4>] local_bh_enable_ip+0xcd/0xed
  [<7816ef17>] core_sys_select+0x2ac/0x2c9
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d623>] _spin_unlock+0x25/0x3b
  [<78152de2>] do_wp_page+0x3b9/0x406
  [<7840d1b1>] _spin_lock+0x33/0x3e
  [<781541bf>] __handle_mm_fault+0x7c3/0x83b
  [<781197d3>] do_page_fault+0x278/0x535
  [<7816f340>] sys_select+0xd6/0x188
  [<78103e68>] restore_nocheck+0x12/0x15
  [<7811955b>] do_page_fault+0x0/0x535
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sadc          D 00000000     0  8202      1 (NOTLB)
        ccff9cc4 00000082 00000000 00000000 7813e7a9 edcd1490 7840d6e3 7a1d=
2000
        00000007 00000001 edcd1490 e9e6c0b0 abd7dbb9 0001ff61 0000216c edcd=
159c
        7a022980 c053d340 7a1d2000 7812ccc1 00000000 00000296 ccff9cd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<7814cb18>] free_hot_cold_page+0x13b/0x167
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781648dd>] vfs_write+0xd1/0x10c
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
emerge        D B7BF9CB0     0  8204   3061 (NOTLB)
        b7bf9cc4 00200082 00000002 b7bf9cb0 b7bf9cac 00000000 7840d6e3 785c=
de80
        00000007 00000000 89333550 785143e0 abd783fe 0001ff61 00002d5e 8933=
365c
        7a01a980 c053d840 219905ed 00000003 00000000 00000000 b7bf9cd4 2199=
064e
Call Trace:
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<7813f8ca>] __lock_acquire+0xaf0/0xb84
  [<7814ce3d>] get_page_from_freelist+0x293/0x35e
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<78153e4d>] __handle_mm_fault+0x451/0x83b
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<781197d3>] do_page_fault+0x278/0x535
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<7811955b>] do_page_fault+0x0/0x535
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
mkpir         D 00000000     0  8297   3061 (NOTLB)
        9c507cc4 00000082 00000000 00000000 7813e7a9 9c505590 7840d6e3 7a1d=
2000
        00000007 00000001 9c505590 f7cb9510 abd79872 0001ff61 00002bf0 9c50=
569c
        7a022980 f68e9340 7a1d2000 7812ccc1 00000000 00000296 9c507cd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<781a8658>] journal_stop+0x1ce/0x1da
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78148be7>] file_read_actor+0x0/0xde
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<78165177>] __fput+0x10a/0x134
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
screen        S 8DBAFF98     0  8364   3866 (NOTLB)
        8dbaffac 00000086 00000002 8dbaff98 8dbaff94 00000000 00000000 7812=
850a
        00000007 00000000 f7c6c070 785143e0 455dd02b 0001ff61 00005ab9 f7c6=
c17c
        7a01a980 e913ad40 2198ff2e 00000003 00000000 00000000 ffffffff 0000=
0000
Call Trace:
  [<7812850a>] do_setitimer+0x16e/0x30b
  [<7812f315>] sys_pause+0x11/0x17
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
screen        D 00000000     0  8365   8364 (NOTLB)
        eca0fcc4 00000082 00000000 00000000 7813e7a9 f7cb14d0 7840d6e3 7a1d=
2000
        00000007 00000001 f7cb14d0 9c505590 abd76c82 0001ff61 00003101 f7cb=
15dc
        7a022980 d3e4acc0 7a1d2000 7812ccc1 00000000 00000296 eca0fcd4 2199=
064e
Call Trace:
  [<7813e7a9>] mark_held_locks+0x39/0x53
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812ccc1>] __mod_timer+0x92/0x9c
  [<7840b6c4>] schedule_timeout+0x70/0x8d
  [<7840d6e3>] _spin_unlock_irqrestore+0x34/0x58
  [<7812cada>] process_timeout+0x0/0x5
  [<7840b0ce>] io_schedule_timeout+0x1e/0x28
  [<78151eca>] congestion_wait+0x50/0x64
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7814dd9f>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
  [<7814a483>] generic_file_buffered_write+0x4ee/0x605
  [<7814a8cf>] __generic_file_aio_write_nolock+0x335/0x4df
  [<78128f60>] current_fs_time+0x41/0x46
  [<7814aa1a>] __generic_file_aio_write_nolock+0x480/0x4df
  [<7813e99c>] trace_hardirqs_on+0x122/0x14c
  [<7814aad1>] generic_file_aio_write+0x58/0xb6
  [<78199bb4>] ext3_file_write+0x24/0x92
  [<78164133>] do_sync_write+0xc7/0x10a
  [<7813518d>] autoremove_wake_function+0x0/0x35
  [<7840c019>] __mutex_lock_slowpath+0x25f/0x267
  [<7816406c>] do_sync_write+0x0/0x10a
  [<78164896>] vfs_write+0x8a/0x10c
  [<78164e0f>] sys_write+0x41/0x67
  [<78103d96>] sysenter_past_esp+0x5f/0x99
  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> Are any IO errors occurring at all?
No.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1606215155-1192521249=:21430--
