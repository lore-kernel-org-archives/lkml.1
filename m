Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZHQVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZHQVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 17:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZHQVQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 17:16:26 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:50135 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbZHQVQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 17:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Cc9h81eg5azEKGZlwUMpyNIs6sXOgcZSKlcdMqiXIKtrDDcAlKfitcLFDQDTxz2T+W
         92Su4wV5DdpWRswOmHhdUZ8bL+057JWCkE5kSmndQCHFTOvX0a5CwTPYEqvi8/BKANZ3
         f41Ih6swlcERCTTP4srYu/4prB6nv05Lu9j9E=
MIME-Version: 1.0
In-Reply-To: <20090817201750.GA21562@redhat.com>
References: <20090817201750.GA21562@redhat.com>
Date: Mon, 17 Aug 2009 17:16:25 -0400
Message-ID: <170fa0d20908171416o1e6da4d0xab02cd765a924306@mail.gmail.com>
Subject: Re: md deadlock (2.6.31-rc5-git2)
From: Mike Snitzer <snitzer@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 4:17 PM, Dave Jones <davej@redhat.com> wrote:
>
> This kernel is a bit old (it's what we froze on for Fedora 12 alpha,
> and we haven't started building install images with anything newer yet),
> but I don't recall seeing anything similar posted recently..
>
> While creating a series of md arrays, I got the mdadm process to just lock up.
> Looking in dmesg showed that it had warned about it too ..
...
> INFO: task mdadm:2249 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> mdadm         D 0000000000000003  4664  2249    333 0x00000080
>  ffff880023c81938 0000000000000086 0000000000000000 0000000000000001
>  ffff88002bb124a0 0000000000000007 0000000000000006 ffff88003f417028
>  ffff88002bb12890 000000000000fa20 ffff88002bb12890 00000000001d5bc0
> Call Trace:
>  [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
>  [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
>  [<ffffffff814fb166>] __mutex_lock_common+0x21e/0x3bf
>  [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
>  [<ffffffff814fb42a>] mutex_lock_nested+0x4f/0x6b
>  [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
>  [<ffffffff813f35ce>] do_md_run+0x886/0x92f
>  [<ffffffff814fb356>] ? mutex_lock_interruptible_nested+0x4f/0x6a
>  [<ffffffff813f5f30>] md_ioctl+0x11b6/0x142b
>  [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
>  [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
>  [<ffffffff81263f12>] __blkdev_driver_ioctl+0x36/0x95
>  [<ffffffff81264895>] blkdev_ioctl+0x8d6/0x925
>  [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
>  [<ffffffff8122bae6>] ? __rcu_read_unlock+0x34/0x4a
>  [<ffffffff8122ca90>] ? avc_has_perm_noaudit+0x3c9/0x3ef
>  [<ffffffff8122cb21>] ? avc_has_perm+0x6b/0x91
>  [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
>  [<ffffffff8116e5b4>] block_ioctl+0x4a/0x62
>  [<ffffffff81150e03>] vfs_ioctl+0x31/0xaa
>  [<ffffffff811513c5>] do_vfs_ioctl+0x4aa/0x506
>  [<ffffffff81151486>] sys_ioctl+0x65/0x9c
>  [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
> 2 locks held by mdadm/2249:
>  #0:  (&new->reconfig_mutex#2){+.+.+.}, at: [<ffffffff813edcab>] mddev_lock+0x2a/0x40
>  #1:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
> INFO: task mdadm:2249 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> mdadm         D 0000000000000003  4664  2249    333 0x00000080
>  ffff880023c81938 0000000000000086 0000000000000000 0000000000000001
>  ffff88002bb124a0 0000000000000007 0000000000000006 ffff88003f417028
>  ffff88002bb12890 000000000000fa20 ffff88002bb12890 00000000001d5bc0
> Call Trace:
>  [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
>  [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
>  [<ffffffff814fb166>] __mutex_lock_common+0x21e/0x3bf
>  [<ffffffff8116ed21>] ? revalidate_disk+0x5e/0x9d
>  [<ffffffff814fb42a>] mutex_lock_nested+0x4f/0x6b
>  [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d
>  [<ffffffff813f35ce>] do_md_run+0x886/0x92f
>  [<ffffffff814fb356>] ? mutex_lock_interruptible_nested+0x4f/0x6a
>  [<ffffffff813f5f30>] md_ioctl+0x11b6/0x142b
>  [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
>  [<ffffffff81095fab>] ? mark_lock+0x3c/0x253
>  [<ffffffff81263f12>] __blkdev_driver_ioctl+0x36/0x95
>  [<ffffffff81264895>] blkdev_ioctl+0x8d6/0x925
>  [<ffffffff8101aa23>] ? native_sched_clock+0x2d/0x62
>  [<ffffffff8122bae6>] ? __rcu_read_unlock+0x34/0x4a
>  [<ffffffff8122ca90>] ? avc_has_perm_noaudit+0x3c9/0x3ef
>  [<ffffffff8122cb21>] ? avc_has_perm+0x6b/0x91
>  [<ffffffff81096546>] ? trace_hardirqs_on_caller+0x139/0x175
>  [<ffffffff8116e5b4>] block_ioctl+0x4a/0x62
>  [<ffffffff81150e03>] vfs_ioctl+0x31/0xaa
>  [<ffffffff811513c5>] do_vfs_ioctl+0x4aa/0x506
>  [<ffffffff81151486>] sys_ioctl+0x65/0x9c
>  [<ffffffff81012f42>] system_call_fastpath+0x16/0x1b
> 2 locks held by mdadm/2249:
>  #0:  (&new->reconfig_mutex#2){+.+.+.}, at: [<ffffffff813edcab>] mddev_lock+0x2a/0x40
>  #1:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8116ed21>] revalidate_disk+0x5e/0x9d

This was fixed with commit: c8c00a6915a2e3d10416e8bdd3138429beb96210
