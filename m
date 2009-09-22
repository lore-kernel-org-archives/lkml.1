Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZIVKEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZIVKEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZIVKE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:04:29 -0400
Received: from 1wt.eu ([62.212.114.60]:49183 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZIVKE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:04:28 -0400
Date: Tue, 22 Sep 2009 12:04:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org
Subject: Soft lockups when using an SCSI tape device
Message-ID: <20090922100431.GA30218@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

at work we've been bothered for a while with a backup tool
trigerring kernel panics. The machine is a 64-bit Core2Duo,
it runs CentOS 5.x with an updated kernel (right now we're
on a slightly patched 2.6.27.29), but many kernels since
2.6.22 have been showing the same issue.

As it happened today and I was here, I took a photo of the
panic and rewrote it down. Here it is :

INFO: task mt: 22922 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message
mt            D 0000000000000000     0 22922  22917
 ffff880003a99c88 0000000000000082 0000000000000000 ffff880031a40f00
 ffff880003a58000 ffff88007f862d00 ffff880003a58230 ffffffff80829000
 ffffffff8082f780 000000013f3aec8a 000000000000000f ffffffff804e8af2
Call Trace:
 [<ffffffff804e8af2>] scsi_request_fn+0x222/0x350
 [<ffffffff80629105>] schedule_timeout+0x95/0xd0
 [<ffffffff804e7ed0>] scsi_execute_async+0x2f0/0x3c0
 [<ffffffff806286a5>] wait_for_common+0xa5/0x160
 [<ffffffff80233890>] default_wake_function+0x0/0x10
 [<ffffffff80505b76>] st_do_scsi+0x1f6/0x2c0
 [<ffffffff80505260>] st_sleep_done+0x0/0x90
 [<ffffffff80507719>] do_load_unload+0xb9/0x180
 [<ffffffff8050a571>] st_ioctl+0x941/0x10e0
 [<ffffffff80283a44>] handle_mm_fault+0x234/0x740
 [<ffffffff802a988f>] vfs_ioctl+0x2f/0xa0
 [<ffffffff802a996f>] do_vfs_ioctl+0x6f/0x2b0
 [<ffffffff802a9c41>] sys_ioctl+0x91/0xb0
 [<ffffffff8020c28b>] system_call_fastpath+0x16/0x1b

Kernel panic - not syncing: softlockup: blocked tasks

It's important to note that the tape was ejected, the panic apparently
occured on return of the mt eject command.

# uname -a
Linux carbone.exosec.local 2.6.27-wt9-carbone #1 SMP Mon Aug 3 09:50:14 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux

We have SOFTLOCKUP enabled :
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1

I have found the exact place where the lock is held. It's in
drivers/scsi/scsi_lib.c:request_fn() line 1603:

  1600   out:
  1601          /* must be careful here...if we trigger the ->remove() function
  1602           * we cannot be holding the q lock */
 >1603<         spin_unlock_irq(q->queue_lock);
  1604          put_device(&sdev->sdev_gendev);
  1605          spin_lock_irq(q->queue_lock);
  1606  }
  1607  

As I understand it, someone else holds the queue lock. Note
that I also have CONFIG_TRACE_IRQFLAGS_SUPPORT=y, and I must
admit that I got lost into the tentacles of the macros and
inlines called from spin_unlock_irq(). I don't have PREEMPT
though.

I have reviewed the changes to st.c since this kernel and do
not see anything obviously relevant. I've found a few apparently
similar issues on the net, one of which is here :

  http://article.gmane.org/gmane.linux.debian.devel.bugs.general/613223

I don't know where to look for right now. I'd like some advices,
maybe some options to pass to the kernel at boot, soem config
options to change (as long as they don't affect performance
much nor require frequent reboots, since it's a production
server).

I can send the full config if needed, although I'm not sure it
would help.

Thanks in advance,
Willy

