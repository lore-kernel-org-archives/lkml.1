Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730Ab0ABPEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0ABPEA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609Ab0ABPD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:03:59 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:35031 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0ABPD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Dazk7/LBnlqboz689kSKXixJ1Bbjiyni5uO427ZWzDlaL7BNAfy7YNlgDcBHkFa68g
         u0M5ytzgaAnIDhN+s+66VnwEtcC9Pd9Fp6kHpqSohTE9AXLA/63lCqGwZxyd+6BLROPb
         piRNOXI+aa6wLFUXs7bkxfoLzZCWqRWAG3Yco=
MIME-Version: 1.0
Date: Sat, 2 Jan 2010 15:03:56 +0000
Message-ID: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
Subject: s2disk hang update
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: hugh.dickins@tiscali.co.uk, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been suffering from s2disk hangs again.  This time, the hangs
were always before the hibernation image was written out.

They're still frustratingly random.  I just started trying to work out
whether doubling PAGES_FOR_IO makes them go away, but they went away
on their own again.

I did manage to capture a backtrace with debug info though.  Here it
is for 2.6.33-rc2.  (It has also happened on rc1).  I was able to get
the line numbers (using gdb, e.g.  "info line
*stop_machine_create+0x27"), having built the kernel with debug info.

[top of trace lost due to screen height]
? sync_page	(filemap.c:183)
? wait_on_page_bit	(filemap.c:506)
? wake_bit_function	(wait.c:174)
? shrink_page_list	(vmscan.c:696)
? __delayacct_blkio_end	(delayacct.c:94)
? finish_wait	(list.h:142)
? congestion_wait	(backing-dev.c:761)
? shrink_inactive_list	(vmscan.c:1193)
? scsi_request_fn	(spinlock.h:306)
? blk_run_queue	(blk-core.c:434)
? shrink_zone	(vmscan.c:1484)
? do_try_to_free_pages	(vmscan.c:1684)
? try_to_free_pages	(vmscan.c:1848)
? isolate_pages_global	(vmscan.c:980)
? __alloc_pages_nodemask	(page_alloc.c:1702)
? __get_free_pages	(page_alloc.c:1990)
? copy_process	(fork.c:237)
? do_fork	(fork.c:1443)
? rb_erase
? __switch_to
? kthread
? kernel_thread
? kthread
? kernel_thread_helper
? kthreadd
? kthreadd
? kernel_thread_helper

INFO: task s2disk:2174 blocked for more than 120 seconds
...
Call Trace:
? __switch_to
? schedule_timeout
? check_preempt_wakeup
? wait_for_common
? default_wake_function
? kthread_create:133
? worker_thread
? schedule
? create_workqueue_thread
? worker_thread
? __create_workqueue_key (workqueue.c:1006)
? stop_machine_create (stop_machine.c:121)
? disable_nonboot_cpus (cpu.c:370)
? hibernation_snapshot
? snapshot_ioctl
...
? sys_ioctl


Thanks for everything
Alan
