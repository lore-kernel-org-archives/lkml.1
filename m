Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbXDXFKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbXDXFKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXDXFKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:10:08 -0400
Received: from [70.254.190.220] ([70.254.190.220]:53231 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753655AbXDXFKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:10:06 -0400
Date: Tue, 24 Apr 2007 05:10:04 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: Null pointer dereference in fs/open.c
In-Reply-To: <20070423215810.5a24ed9a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704240507110.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
 <20070423010032.c89e8d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231356480.25153@server.thyself>
 <Pine.LNX.4.64.0704231633210.25153@server.thyself>
 <Pine.LNX.4.64.0704240347470.25153@server.thyself>
 <20070423215810.5a24ed9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Andrew Morton wrote:
> On Tue, 24 Apr 2007 04:09:18 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:
>
>> This bug occurs in linux-2.6.20 and 2.6.21-rc7-git5, and does not occur in
>> linux-2.6.19-git22.
>>
>> After running "pktsetup 0 /dev/hdd", I get (timestamps removed):
>>
>> pktcdvd: pkt_get_last_written failed
>> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000e
>> printing eip:
>> c0173f69
>> *pde = 00000000
>> Oops: 0000 [#1]
>> PREEMPT
>> Modules linked in: snd_ca0106 snd_ac97_codec ac97_bus 8139cp 8139too iTCO_wdt
>> CPU:    0
>> EIP:    0060:[<c0173f69>]    Not tainted VLI
>> EFLAGS: 00010203   (2.6.21-rc7-git5 #22)
>> EIP is at do_sys_open+0x59/0xd0
>> eax: 00000002   ebx: 40000020   ecx: 00000001   edx: 00000002
>> esi: df1e3000   edi: 00000003   ebp: de17bfa4   esp: de17bf84
>> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>> Process vol_id (pid: 4273, ti=de17b000 task=df4143f0 task.ti=de17b000)
>> Stack: 00000000 c013d2a5 ffffff9c 00000002 c059cea3 bfb6bf64 00008000 b7f60ff4
>>         de17bfb0 c017401c 00000000 de17b000 c01041c6 bfb6bf64 00008000 00000000
>>         00008000 b7f60ff4 bfb6a798 00000005 0000007b 0000007b 00000000 00000005
>> Call Trace:
>>   [<c010521a>] show_trace_log_lvl+0x1a/0x30
>>   [<c01052d9>] show_stack_log_lvl+0xa9/0xd0
>>   [<c010551c>] show_registers+0x21c/0x3a0
>>   [<c01057a4>] die+0x104/0x260
>>   [<c04c5947>] do_page_fault+0x277/0x610
>>   [<c04c408c>] error_code+0x74/0x7c
>>   [<c017401c>] sys_open+0x1c/0x20
>>   [<c01041c6>] sysenter_past_esp+0x5f/0x99
>>   =======================
>> Code: ff 85 c0 89 c7 78 77 8b 45 08 89 d9 89 f2 89 04 24 8b 45 e8 e8 69 ff
>> ff ff 3d 00 f0 ff ff 89 45 ec 77 71 8b 55 ec bb 20 00 00 40 <8b> 42 0c 8b
>> 48 30 89 4d f0 0f b7 51 66 81 e2 00 f0 00 00 81 fa
>> EIP: [<c0173f69>] do_sys_open+0x59/0xd0 SS:ESP 0068:de17bf84
>
> Try this:
>
> --- a/drivers/block/pktcdvd.c~packet-fix-error-handling
> +++ a/drivers/block/pktcdvd.c
> @@ -777,7 +777,8 @@ static int pkt_generic_packet(struct pkt
> 		rq->cmd_flags |= REQ_QUIET;
>
> 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
> -	ret = rq->errors;
> +	if (rq->errors)
> +		ret = -EIO;
> out:
> 	blk_put_request(rq);
> 	return ret;
> _

This patch fixes (or conceals?) the oops.

>
>
> The packet driver was assuming that request.errors is an errno, but it
> isn't - it's some sort of diagnostic bitfield thing.  Now why would the
> packet driver have though that?  Let's go read the comments:
>
> 	unsigned short nr_hw_segments;
>
> 	unsigned short ioprio;
>
> 	void *special;
> 	char *buffer;
>
> 	int tag;
> 	int errors;
>
> 	int ref_count;
>
>
> Well there's your root cause right there.
>
>
> I don't know why this wasn't oopsing in eariler kernels.  Perhaps something
> else is broken.  Please test this urgently.
>
>
> There's a locking problem in there too.  `pktsetup 0 /dev/scd0' gives me
>
> [   77.720000] pktcdvd: writer pktcdvd0 mapped to sr0
> [   77.860000]
> [   77.860000] =============================================
> [   77.860000] [ INFO: possible recursive locking detected ]
> [   77.860000] 2.6.21-rc7 #19
> [   77.860000] ---------------------------------------------
> [   77.860000] vol_id/2508 is trying to acquire lock:
> [   77.860000]  (&bdev->bd_mutex){--..}, at: [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]
> [   77.860000] but task is already holding lock:
> [   77.860000]  (&bdev->bd_mutex){--..}, at: [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]
> [   77.860000] other info that might help us debug this:
> [   77.860000] 2 locks held by vol_id/2508:
> [   77.860000]  #0:  (&bdev->bd_mutex){--..}, at: [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  #1:  (&ctl_mutex#2){--..}, at: [<f8dc6986>] pkt_open+0x1a/0xcbc [pktcdvd]
> [   77.860000]
> [   77.860000] stack backtrace:
> [   77.860000]  [<c01323c1>] __lock_acquire+0x11e/0xb3b
> [   77.860000]  [<c02efe4e>] __mutex_unlock_slowpath+0x109/0x113
> [   77.860000]  [<c0132166>] trace_hardirqs_on+0x11e/0x141
> [   77.860000]  [<c0132e34>] lock_acquire+0x56/0x6e
> [   77.860000]  [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  [<c02f01a5>] mutex_lock_nested+0xf4/0x24f
> [   77.860000]  [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  [<c024020c>] kobj_lookup+0xda/0x104
> [   77.860000]  [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  [<c018184a>] __blkdev_get+0x5b/0x66
> [   77.860000]  [<c0181867>] blkdev_get+0x12/0x14
> [   77.860000]  [<f8dc69f9>] pkt_open+0x8d/0xcbc [pktcdvd]
> [   77.860000]  [<c0170949>] __d_lookup+0x66/0xed
> [   77.860000]  [<c0170949>] __d_lookup+0x66/0xed
> [   77.860000]  [<c01ce919>] _atomic_dec_and_lock+0xd/0x2c
> [   77.860000]  [<c01ce919>] _atomic_dec_and_lock+0xd/0x2c
> [   77.860000]  [<c01ce919>] _atomic_dec_and_lock+0xd/0x2c
> [   77.860000]  [<c015f655>] cache_alloc_refill+0x4a/0x444
> [   77.860000]  [<c0240165>] kobj_lookup+0x33/0x104
> [   77.860000]  [<c0132166>] trace_hardirqs_on+0x11e/0x141
> [   77.860000]  [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  [<c02f007f>] __mutex_lock_slowpath+0x222/0x235
> [   77.860000]  [<c02f02ed>] mutex_lock_nested+0x23c/0x24f
> [   77.860000]  [<c0131f85>] mark_held_locks+0x46/0x62
> [   77.860000]  [<c02f02ed>] mutex_lock_nested+0x23c/0x24f
> [   77.860000]  [<c02f02ed>] mutex_lock_nested+0x23c/0x24f
> [   77.860000]  [<c0132166>] trace_hardirqs_on+0x11e/0x141
> [   77.860000]  [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  [<c02f02f8>] mutex_lock_nested+0x247/0x24f
> [   77.860000]  [<c01815e2>] do_open+0x5a/0x267
> [   77.860000]  [<c024020c>] kobj_lookup+0xda/0x104
> [   77.860000]  [<c018160f>] do_open+0x87/0x267
> [   77.860000]  [<c0181977>] blkdev_open+0x0/0x4d
> [   77.860000]  [<c018199c>] blkdev_open+0x25/0x4d
> [   77.860000]  [<c0160b77>] __dentry_open+0xb8/0x16e
> [   77.860000]  [<c0160ca7>] nameidata_to_filp+0x24/0x33
> [   77.860000]  [<c0160ce8>] do_filp_open+0x32/0x39
> [   77.860000]  [<c02f1232>] _spin_unlock+0x14/0x1c
> [   77.860000]  [<c0160ab5>] get_unused_fd+0xaa/0xb4
> [   77.860000]  [<c01619da>] do_sys_open+0x42/0xbe
> [   77.860000]  [<c0161a8f>] sys_open+0x1c/0x1e
> [   77.860000]  [<c0103c58>] syscall_call+0x7/0xb
> [   77.860000]  =======================
> [   77.900000] pktcdvd: pkt_get_last_written failed
>
> What the heck _is_ in request.errors?
>
> Should the packet driver even be looking at it?
>

I got a similar recursive lock warning too, though I hadn't included it in 
the last message:

[10349.402613] =============================================
[10349.423972] [ INFO: possible recursive locking detected ]
[10349.440138] 2.6.21-rc7-git5 #23
[10349.449541] ---------------------------------------------
[10349.465685] vol_id/4312 is trying to acquire lock:
[10349.480033]  (&bdev->bd_mutex){--..}, at: [<c019a82f>] do_open+0x4f/0x2c0
[10349.500561]
[10349.500566] but task is already holding lock:
[10349.518079]  (&bdev->bd_mutex){--..}, at: [<c019a82f>] do_open+0x4f/0x2c0
[10349.538590]
[10349.538591] other info that might help us debug this:
[10349.558186] 2 locks held by vol_id/4312:
[10349.569934]  #0:  (&bdev->bd_mutex){--..}, at: [<c019a82f>] do_open+0x4f/0x2c0
[10349.591767]  #1:  (&ctl_mutex#2){--..}, at: [<c04c221c>] mutex_lock+0x1c/0x20
[10349.613389]
[10349.613390] stack backtrace:
[10349.626463]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
[10349.641904]  [<c0105952>] show_trace+0x12/0x20
[10349.655234]  [<c0105a46>] dump_stack+0x16/0x20
[10349.668594]  [<c013e410>] __lock_acquire+0xbc0/0x1040
[10349.683752]  [<c013e900>] lock_acquire+0x70/0x90
[10349.697626]  [<c04c229e>] mutex_lock_nested+0x7e/0x2e0
[10349.713067]  [<c019a82f>] do_open+0x4f/0x2c0
[10349.725905]  [<c019ab19>] __blkdev_get+0x79/0x90
[10349.739783]  [<c019ab45>] blkdev_get+0x15/0x20
[10349.753121]  [<c03298f7>] pkt_open+0xb7/0xd80
[10349.766221]  [<c019a865>] do_open+0x85/0x2c0
[10349.779030]  [<c019acc3>] blkdev_open+0x33/0x70
[10349.792652]  [<c0173ce4>] __dentry_open+0xf4/0x220
[10349.807048]  [<c0173eb5>] nameidata_to_filp+0x35/0x40
[10349.822232]  [<c0173f09>] do_filp_open+0x49/0x50
[10349.836107]  [<c0173f57>] do_sys_open+0x47/0xd0
[10349.849729]  [<c017401c>] sys_open+0x1c/0x20
[10349.862566]  [<c01041c6>] sysenter_past_esp+0x5f/0x99
[10349.877749]  =======================
[10350.141702] pktcdvd: pkt_get_last_written failed

William Heimbigner
icxcnika@mar.tar.cc
