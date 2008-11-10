Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYKJRQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYKJRQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYKJRQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:16:16 -0500
Received: from voyager.telenet.dn.ua ([195.39.211.35]:48823 "EHLO
	voyager.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYKJRQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:16:15 -0500
Message-ID: <49186C5A.5020809@telenet.dn.ua>
Date: Mon, 10 Nov 2008 19:16:10 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Thunderbird 2.0.0.17 (X11/20081011)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk>
In-Reply-To: <20081110135618.GI26778@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Nov 10 2008, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>>
>>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
>> Funny, I was going to ask the same question.  ;)  The reason Jens wants
>> you to try this patch is that nfsd may be farming off the I/O requests
>> to different threads which are then performing interleaved I/O.  The
>> above patch tries to detect this and allow cooperating processes to get
>> disk time instead of waiting for the idle timeout.
> 
> Precisely :-)
> 
> The only reason I haven't merged it yet is because of worry of extra
> cost, but I'll throw some SSD love at it and see how it turns out.
> 

Sorry, but I get "oops" same moment nfs read transfer starts.
I can get directory list via nfs, read files locally (not
carefully tested, though)

Dumps captured via netconsole, so these may not be completely accurate
but hopefully will give a hint.

Linux 2.6.27.5

======================================
[  618.526302] BUG: unable to handle kernel
NULL pointer dereference
at 0000000000000000
[  618.526676] IP:
[<ffffffff81111f16>] rb_erase+0x124/0x290
[  618.526738] PGD 11b96c067
PUD 11b96d067
PMD 0

[  618.526856] Oops: 0000 [1]
SMP

[  618.527020] CPU 1

[  618.527285] Modules linked in:
nfsd
auth_rpcgss
exportfs
netconsole
ipv6
nfs
lockd
nfs_acl
sunrpc
cypress_m8
usbserial
it87
hwmon_vid
hwmon
ppdev
ehci_hcd
ohci_hcd
sg
r8169
thermal
parport_pc
processor
parport
thermal_sys

[  618.528868] Pid: 2184, comm: md1_raid5 Not tainted 2.6.27.5 #2
[  618.528918] RIP: 0010:[<ffffffff81111f16>]
[<ffffffff81111f16>] rb_erase+0x124/0x290
[  618.529087] RSP: 0018:ffff88011d9c9a58  EFLAGS: 00010046
[  618.529136] RAX: ffff88011d3d7c01 RBX: ffff88011d3d7c00 RCX: 0000000000000000
[  618.529187] RDX: 000000002d59fabb RSI: ffff88011e44d430 RDI: 0000000000000000
[  618.529238] RBP: ffff88011e44d430 R08: 0000000000000000 R09: ffff88011c08d8b8
[  618.529289] R10: 000000002d59fdbb R11: 000000002d59fbbb R12: ffff88011e44d400
[  618.529339] R13: ffff88011e44d430 R14: ffff88011e44d400 R15: 0000000000800000
[  618.529390] FS:  00007f6c86182750(0000) GS:ffff88011f86abc0(0000) knlGS:0000000000000000
[  618.529480] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  618.529530] CR2: 0000000000000000 CR3: 000000011b9c6000 CR4: 00000000000006e0
[  618.529580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  618.529631] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  618.529682] Process md1_raid5 (pid: 2184, threadinfo ffff88011d9c8000, task ffff88011fa5d8e0)
[  618.529773] Stack:
ffff88011d3d7660
ffff88011d3d7660
ffffffff8110a0b9
ffff88011d3d7630

[  618.529895]  ffffffff8110a0ff
ffff88011d3d7630
ffff88011e44d400
ffff880119a1cc48

[  618.530085]  ffff88011d3d7630
ffff88011e44d400
ffff880119a1cc48
ffff88011d3d7678

[  618.530154] Call Trace:
[  618.530252]  [<ffffffff8110a0b9>] ? rb_erase_init+0x9/0x17
[  618.530303]  [<ffffffff8110a0ff>] ? cfq_prio_tree_add+0x38/0xa8
[  618.530354]  [<ffffffff8110b12b>] ? cfq_add_rq_rb+0xb5/0xc8
[  618.530404]  [<ffffffff8110b198>] ? cfq_insert_request+0x5a/0x356
[  618.530457]  [<ffffffff811000a1>] ? elv_insert+0x14b/0x218
[  618.530510]  [<ffffffff810ab757>] ? bio_phys_segments+0xf/0x15
[  618.530561]  [<ffffffff811028dc>] ? __make_request+0x3b9/0x3eb
[  618.530612]  [<ffffffff8110120c>] ? generic_make_request+0x30b/0x346
[  618.530665]  [<ffffffff811baae4>] ? raid5_end_write_request+0x0/0xb8
[  618.530716]  [<ffffffff811b8ace>] ? ops_run_io+0x16a/0x1c1
[  618.530767]  [<ffffffff811ba524>] ? handle_stripe5+0x9b5/0x9d6
[  618.530818]  [<ffffffff811bbef8>] ? handle_stripe+0xc3a/0xc6a
[  618.530870]  [<ffffffff81253782>] ? thread_return+0x3a/0xaa
[  618.530921]  [<ffffffff811bc2be>] ? raid5d+0x396/0x3cd
[  618.530972]  [<ffffffff81253bc8>] ? schedule_timeout+0x1e/0xad
[  618.531023]  [<ffffffff811c715f>] ? md_thread+0xdd/0xf9
[  618.531075]  [<ffffffff81044f9c>] ? autoremove_wake_function+0x0/0x2e
[  618.531127]  [<ffffffff811c7082>] ? md_thread+0x0/0xf9
[  618.531177]  [<ffffffff81044e80>] ? kthread+0x47/0x73
[  618.531228]  [<ffffffff8102f867>] ? schedule_tail+0x28/0x60
[  618.531279]  [<ffffffff8100cda9>] ? child_rip+0xa/0x11
[  618.531330]  [<ffffffff81044e39>] ? kthread+0x0/0x73
[  618.531380]  [<ffffffff8100cd9f>] ? child_rip+0x0/0x11
[  618.531428]
[  618.531474]
[  618.531521] Code:
eb
0a
48
89
4b
08
eb
04
48
89
4d
00
41
ff
c8
0f
85
7f
01
00
00
e9
5d
01
00
00
48
8b
7b
10
48
39
cf
0f
85
a5
00
00
00
48
8b
7b
08

8b
07
a8
01
75
1a
48
83
c8
01
48
89
ee
48
89
07
48
83
23
fe

[  618.532199] RIP
[<ffffffff81111f16>] rb_erase+0x124/0x290
[  618.532510]  RSP <ffff88011d9c9a58>
[  618.532510] CR2: 0000000000000000
[  618.532510] ---[ end trace db64b81474e1505e ]---

======================================

[  334.271949] BUG: unable to handle kernel
NULL pointer dereference
at 0000000000000010
[  334.272213] IP:
[<ffffffff81111bbf>] __rb_rotate_left+0x7/0x5b
[  334.27 PGD 11c15d067
PUD 11c140067
PMD 0

[  334.272508] Oops: 0000 [1]
SMP

[  334.272508] CPU 1

[  334.272508] Modules linked in:
nfsd
auth_rpcgss
exportfs
netconsole
ipv6
nfs
lockd
nfs_acl
sunrpc
cypress_m8
usbserial
it87
hwmon_vid
hwmon
ppdev
parport_pc
ehci_hcd
ohci_hcd
thermal
parport
sg
processor
r8169
thermal_sys

[  334.272508] Pid: 2185, comm: md1_raid5 Not tainted 2.6.27.5 #2
[  334.272508] RIP: 0010:[<ffffffff81111bbf>]
[<ffffffff81111bbf>] __rb_rotate_left+0x7/0x5b
[  334.272508] RSP: 0018:ffff88011d591a48  EFLAGS: 00010082
[  334.272508] RAX: ffff88011cc20a20 RBX: ffff88011cc20a20 RCX: 0000000000000000
[  334.272508] RDX: 0000000000000000 RSI: ffff88011f8bae30 RDI: ffff88011cc20a20
[  334.272508] RBP: ffff88011cc20a20 R08: ffff88011cc20a20 R09: ffff88011ac6b3f8
[  334.272508] R10: 000000002d5a237b R11: 000000002d5a30bb R12: ffff88011cc20a20
[  334.272508] R13: 0000000000000000 R14: ffff88011f8bae30 R15: 0000000000800010
[  334.272508] FS:  00007fb5925496f0(0000) GS:ffff88011f86abc0(0000) knlGS:0000000000000000
[  334.272508] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  334.272508] CR2: 0000000000000010 CR3: 000000011c18c000 CR4: 00000000000006e0
[  334.272508] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  334.272508] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  334.272508] Process md1_raid5 (pid: 2185, threadinfo ffff88011d590000, task ffff88011fb12860)
[  334.272508] Stack:
ffffffff81111d20
ffff88011cc209f0
ffff88011cc20a20
ffff88011f8bae00

[  334.272508]  ffff88011f8bae30
ffff88011f8bae00
ffffffff8110a164
ffff88011cc209f0

[  334.272508]  ffff88011cc20a20
ffff88011f8bae30
ffff88011cc209f0
ffff88011f8bae00

[  334.272508] Call Trace:
[  334.272508]  [<ffffffff81111d20>] ? rb_insert_color+0xb2/0xda
[  334.272508]  [<ffffffff8110a164>] ? cfq_prio_tree_add+0x9d/0xa8
[  334.272508]  [<ffffffff8110b12b>] ? cfq_add_rq_rb+0xb5/0xc8
[  334.272508]  [<ffffffff8110b198>] ? cfq_insert_request+0x5a/0x356
[  334.272508]  [<ffffffff811000a1>] ? elv_insert+0x14b/0x218
[  334.272508]  [<ffffffff810ab757>] ? bio_phys_segments+0xf/0x15
[  334.272508]  [<ffffffff811028dc>] ? __make_request+0x3b9/0x3eb
[  334.272508]  [<ffffffff8110120c>] ? generic_make_request+0x30b/0x346
[  334.272508]  [<ffffffff811baae4>] ? raid5_end_write_request+0x0/0xb8
[  334.272508]  [<ffffffff811b8ace>] ? ops_run_io+0x16a/0x1c1
[  334.272508]  [<ffffffff811ba524>] ? handle_stripe5+0x9b5/0x9d6
[  334.272508]  [<ffffffff811bbef8>] ? handle_stripe+0xc3a/0xc6a
[  334.272508]  [<ffffffff810296e5>] ? pick_next_task_fair+0x8d/0x9c
[  334.272508]  [<ffffffff81253782>] ? thread_return+0x3a/0xaa
[  334.272508]  [<ffffffff811bc2be>] ? raid5d+0x396/0x3cd
[  334.272508]  [<ffffffff81253bc8>] ? schedule_timeout+0x1e/0xad
[  334.272508]  [<ffffffff811c715f>] ? md_thread+0xdd/0xf9
[  334.272508]  [<ffffffff81044f9c>] ? autoremove_wake_function+0x0/0x2e
[  334.272508]  [<ffffffff811c7082>] ? md_thread+0x0/0xf9
[  334.272508]  [<ffffffff81044e80>] ? kthread+0x47/0x73
[  334.272508]  [<ffffffff8102f867>] ? schedule_tail+0x28/0x60
[  334.272508]  [<ffffffff8100cda9>] ? child_rip+0xa/0x11
[  334.272508]  [<ffffffff81044e39>] ? kthread+0x0/0x73
[  334.272508]  [<ffffffff8100cd9f>] ? child_rip+0x0/0x11
[  334.272508]
[  334.272508]
[  334.272508] Code:
00
31
c0
eb
19
ff
c0
48
89
ee
48
c7
c7
e8
39
44
81
89
43
08
e8
3a
33
14
00
b8
01
00
00
00
5a
5b
5d
c3
90
90
48
8b
4f
08
4c
8b
07

8b
51
10
49
83
e0
fc
48
85
d2
48
89
57
08
74
0c
48
8b
02
83

[  334.272508] RIP
[<ffffffff81111bbf>] __rb_rotate_left+0x7/0x5b
[  334.272508]  RSP <ffff88011d591a48>
[  334.272508] CR2: 0000000000000010
[  334.272508] ---[ end trace f1bde8b7b9263879 ]---
======================================

-- 
Thanks,
Vitaly
