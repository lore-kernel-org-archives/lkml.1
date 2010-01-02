Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039Ab0ABUi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0ABUi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 15:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894Ab0ABUi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 15:38:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0ABUi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 15:38:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Subject: Re: s2disk hang update
Date: Sat, 2 Jan 2010 21:38:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Mel Gorman <mel@csn.ul.ie>, hugh.dickins@tiscali.co.uk,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
In-Reply-To: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001022138.42575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 January 2010, Alan Jenkins wrote:
> Hi,

Hi,

> I've been suffering from s2disk hangs again.  This time, the hangs
> were always before the hibernation image was written out.
> 
> They're still frustratingly random.  I just started trying to work out
> whether doubling PAGES_FOR_IO makes them go away, but they went away
> on their own again.
> 
> I did manage to capture a backtrace with debug info though.  Here it
> is for 2.6.33-rc2.  (It has also happened on rc1).  I was able to get
> the line numbers (using gdb, e.g.  "info line
> *stop_machine_create+0x27"), having built the kernel with debug info.
> 
> [top of trace lost due to screen height]
> ? sync_page	(filemap.c:183)
> ? wait_on_page_bit	(filemap.c:506)
> ? wake_bit_function	(wait.c:174)
> ? shrink_page_list	(vmscan.c:696)
> ? __delayacct_blkio_end	(delayacct.c:94)
> ? finish_wait	(list.h:142)
> ? congestion_wait	(backing-dev.c:761)
> ? shrink_inactive_list	(vmscan.c:1193)
> ? scsi_request_fn	(spinlock.h:306)
> ? blk_run_queue	(blk-core.c:434)
> ? shrink_zone	(vmscan.c:1484)
> ? do_try_to_free_pages	(vmscan.c:1684)
> ? try_to_free_pages	(vmscan.c:1848)
> ? isolate_pages_global	(vmscan.c:980)
> ? __alloc_pages_nodemask	(page_alloc.c:1702)
> ? __get_free_pages	(page_alloc.c:1990)
> ? copy_process	(fork.c:237)
> ? do_fork	(fork.c:1443)
> ? rb_erase
> ? __switch_to
> ? kthread
> ? kernel_thread
> ? kthread
> ? kernel_thread_helper
> ? kthreadd
> ? kthreadd
> ? kernel_thread_helper
> 
> INFO: task s2disk:2174 blocked for more than 120 seconds

This looks like we have run out of memory while creating a new kernel thread
and we have blocked on I/O while trying to free some space (quite obviously,
because the I/O doesn't work at this point).

I think it should help if you increase PAGES_FOR_IO, then.

Rafael
