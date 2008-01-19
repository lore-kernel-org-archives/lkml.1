Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbYASSae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbYASSae (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbYASSaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:30:25 -0500
Received: from mga07.intel.com ([143.182.124.22]:39484 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750947AbYASSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:30:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,221,1199692800"; 
   d="scan'208";a="369169236"
Message-ID: <479241B0.8010500@linux.intel.com>
Date: Sat, 19 Jan 2008 10:30:08 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] LatencyTop: make reason (blk_execute_rq+0x7a/0xd) known
References: <47922B2A.7070709@gmail.com>
In-Reply-To: <47922B2A.7070709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> Hi Arjan,
> 
> One of the top reasons in latencytop is
> Unknown reason (blk_execute_rq+0x7a/0xd)          152.3 msec        
> 49.0 msec
> 
> Its from hddtemp, hald-addon-storage, ...
> 
> I wrote a simple systemtap script [1] to find out where its called from,
> and its definitely from the ioctl (see below).
> 
> 1820322406
> hddtemp(3999):                                                                                                      
> <- latency of 153260223 ns
> Returning from: 0xffffffff80311ab0 : blk_execute_rq+0x0/0xd0 []
> Returning to  : 0xffffffff80315580 : sg_io+0x200/0x3c0 []
>  0xffffffff80315a02 : scsi_cmd_ioctl+0x2c2/0x410 []
>  0xffffffff80417153 : ip_queue_xmit+0x2b3/0x420 []
>  0xffffffff880c3be9 : sd_ioctl+0x99/0xf0 [sd_mod]
>  0xffffffff80313839 : blkdev_driver_ioctl+0x39/0x40 []
>  0xffffffff80313ab8 : blkdev_ioctl+0x278/0x710 []
>  0xffffffff803e540d : release_sock+0x8d/0xa0 []
>  0xffffffff803e54b3 : lock_sock_nested+0x93/0xa0 []
>  0xffffffff8029a4ff : d_alloc+0x6f/0x1a0 []
>  0xffffffff802f102f : security_d_instantiate+0x1f/0x30 []
>  0xffffffff803e540d : release_sock+0x8d/0xa0 []
>  0xffffffff8043c8c8 : inet_accept+0x88/0xc0 []
>  0xffffffff803e408e : move_addr_to_user+0x5e/0x70 []
>  0xffffffff802f0bb1 : security_socket_post_accept+0x11/0x20 []
>  0xffffffff803e472e : sys_accept+0x13e/0x1d0 []
>  0xffffffff802af12b : block_ioctl+0x1b/0x20 []
>  0xffffffff8029482b : do_ioctl+0x1b/0x70 []
>  0xffffffff80294a6d : vfs_ioctl+0x1ed/0x290 []
>  0xffffffff80296281 : sys_select+0x41/0x1b0 []
>  0xffffffff80294b92 : sys_ioctl+0x82/0xa0 []
>  0xffffffff8020c18e : system_call+0x7e/0x83 []
> 
> 
> I suggest adding an annotation to make this reason known to latencytop
> by annotating sd_ioctl/scsi_cmd_ioctl, see my patch below.
> After my patch, instead of blk_execute_rq the real reason is showed:
> 
> Cause                                               Maximum          Average
> SCSI device ioctl                                  34.2 msec        
> 14.4 msec

great! I'll put this into my patchkit!

> 
> I noticed there's a similar annotation in sr.c for cdrom_ioctl, but sr.c
> also has annotations for scsi_nonblockable_ioctl, and scsi_ioctl.
> If they are needed for sd_block_ioctl too, maybe
> scsi_nonblockable_ioctl/scsi_ioctl should have the annotation themselves.

yeah I'll take a look at this; some of the annotations are still a bit iffy in their placement

> 
> I also noticed some unsigned overflows, my top latency was sometimes a
> very large number (18................................), which
> was probably -1, or some other negative number.  I haven't found a way
> to reproduce it yet (it happens very rarely).

I've not seen this; I'll take another peak at the code.

> P.S.: LatencyTop could have a feature to ask for more details on unknown
> latency reasons, and it would generate a systemtap script itself, that
> would show the backtraces to help figure out whats going on.

I've considered having an option inside the code itself that would print a
backtrace for, say, an unknown latency larger than 100msec
but the code got ugly (the accounting gets done in the scheduler path,
where you can't printk).
I'll try again ;-)
