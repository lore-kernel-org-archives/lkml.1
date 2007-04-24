Return-Path: <linux-kernel-owner+w=401wt.eu-S1161632AbXDXFoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161632AbXDXFoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161633AbXDXFoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:44:46 -0400
Received: from [70.254.190.220] ([70.254.190.220]:51787 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161632AbXDXFop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:44:45 -0400
Date: Tue, 24 Apr 2007 05:44:42 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: BUG: Null pointer dereference in fs/open.c
In-Reply-To: <20070423221726.ccfa982c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704240527030.25153@server.thyself>
References: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
 <20070423010032.c89e8d32.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231356480.25153@server.thyself>
 <Pine.LNX.4.64.0704231633210.25153@server.thyself>
 <Pine.LNX.4.64.0704240347470.25153@server.thyself>
 <20070423215810.5a24ed9a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704240507110.25153@server.thyself>
 <20070423221726.ccfa982c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Andrew Morton wrote:
> On Tue, 24 Apr 2007 05:10:04 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:
>
>>> --- a/drivers/block/pktcdvd.c~packet-fix-error-handling
>>> +++ a/drivers/block/pktcdvd.c
>>> @@ -777,7 +777,8 @@ static int pkt_generic_packet(struct pkt
>>> 		rq->cmd_flags |= REQ_QUIET;
>>>
>>> 	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
>>> -	ret = rq->errors;
>>> +	if (rq->errors)
>>> +		ret = -EIO;
>>> out:
>>> 	blk_put_request(rq);
>>> 	return ret;
>>> _
>>
>> This patch fixes (or conceals?) the oops.
>>
>
> Fixes.  But does the packet driver actually work OK for you?  Writes
> files and stuff like that?
>
Short answer, no.

Long answer:
# pktsetup 0 /dev/hdc
[11508.006818] =============================================
[11508.028248] [ INFO: possible recursive locking detected ]
[11508.044413] 2.6.21-rc7-git5 #23
[11508.053818] ---------------------------------------------
[11508.069989] vol_id/4315 is trying to acquire lock:
[11508.084332]  (&bdev->bd_mutex){--..}, at: [<c019a82f>] 
do_open+0x4f/0x2c0
[11508.104867]
[11508.104868] but task is already holding lock:
[11508.122359]  (&bdev->bd_mutex){--..}, at: [<c019a82f>] 
do_open+0x4f/0x2c0
[11508.142862]
[11508.142863] other info that might help us debug this:
[11508.162460] 2 locks held by vol_id/4315:
[11508.174212]  #0:  (&bdev->bd_mutex){--..}, at: [<c019a82f>] 
do_open+0x4f/0x2c0
[11508.196066]  #1:  (&ctl_mutex#2){--..}, at: [<c04c221c>] 
mutex_lock+0x1c/0x20
[11508.217720]
[11508.217721] stack backtrace:
[11508.230821]  [<c010521a>] show_trace_log_lvl+0x1a/0x30
[11508.246255]  [<c0105952>] show_trace+0x12/0x20
[11508.259619]  [<c0105a46>] dump_stack+0x16/0x20
[11508.272974]  [<c013e410>] __lock_acquire+0xbc0/0x1040
[11508.288157]  [<c013e900>] lock_acquire+0x70/0x90
[11508.302035]  [<c04c229e>] mutex_lock_nested+0x7e/0x2e0
[11508.317475]  [<c019a82f>] do_open+0x4f/0x2c0
[11508.330314]  [<c019ab19>] __blkdev_get+0x79/0x90
[11508.344189]  [<c019ab45>] blkdev_get+0x15/0x20
[11508.357554]  [<c03298f7>] pkt_open+0xb7/0xd80
[11508.370651]  [<c019a865>] do_open+0x85/0x2c0
[11508.383491]  [<c019acc3>] blkdev_open+0x33/0x70
[11508.397107]  [<c0173ce4>] __dentry_open+0xf4/0x220
[11508.411509]  [<c0173eb5>] nameidata_to_filp+0x35/0x40
[11508.426684]  [<c0173f09>] do_filp_open+0x49/0x50
[11508.440567]  [<c0173f57>] do_sys_open+0x47/0xd0
[11508.454188]  [<c017401c>] sys_open+0x1c/0x20
[11508.467023]  [<c01041c6>] sysenter_past_esp+0x5f/0x99
[11508.482202]  =======================
[11508.520800] pktcdvd: pkt_get_last_written failed

# mkudffs /dev/pktcdvd/0
[11539.953560] pktcdvd: pkt_get_last_written failed
trying to change type of multiple extents

I get the same error with /dev/hdd as well (hdc and hdd are both dvd 
burners, hdd has a cd-rw and hdc had a dvd-rw)


William Heimbigner
icxcnika@mar.tar.cc
