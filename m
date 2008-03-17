Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYCQVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYCQVKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYCQVKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 17:10:33 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:50103 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbYCQVKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 17:10:32 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <alpine.LFD.1.00.0803161618480.3020@woody.linux-foundation.org> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org> <200803162054.04757.bzolnier@gmail.com> <20080316225921.CAA082DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803161618480.3020@woody.linux-foundation.org>
Comments: In-reply-to Linus Torvalds <torvalds@linux-foundation.org>
   message dated "Sun, 16 Mar 2008 16:27:52 -0700."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 17 Mar 2008 22:09:00 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080317210901.0135A93C911@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JbMaS-0005qa-5n.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JbMaS-0005qa-5n 9ca8fece23fed455e08c023286af0af3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


torvalds@linux-foundation.org said:
> Can you try to sprinkle printk's around to see where it actually ends up
> stopping?

> Since all special commands should now go through the taskfile interface
> (Bartlomiej - correct?), I guess just a printk() at the top of
> do_rw_taskfile() should at least get the ball rolling. Even something that
> just prints out task->data_phase and tf->command would start to unravel at
> least what the last command is before it hangs.. 

Tossing a prink in like so:
ide_startstop_t do_rw_taskfile (ide_drive_t *drive, ide_task_t *task)
{
        ide_hwif_t *hwif        = HWIF(drive);
        struct ide_taskfile *tf = &task->tf;
        ide_handler_t *handler = NULL;

        printk("do_rw_taskfile(task->data_phase=%i, tf->command=%i\n",task->data_phase,tf->command);

        if (task->data_phase == TASKFILE_MULTI_IN ||



Yields:
Mar 17 21:57:29 tippex smartd[5810]: smartd version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Mar 17 21:57:29 tippex smartd[5810]: Home page is http://smartmontools.sourceforge.net/
Mar 17 21:57:29 tippex smartd[5810]: Opened configuration file /etc/smartd.conf
Mar 17 21:57:29 tippex do_rw_taskfile(task->data_phase=32, tf->command=37
Mar 17 21:57:29 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 17 21:57:29 tippex smartd[5810]: Configuration file /etc/smartd.conf parsed.
Mar 17 21:57:29 tippex smartd[5810]: Device: /dev/hda, opened
Mar 17 21:57:29 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 17 21:57:29 tippex smartd[5810]: Device: /dev/hda, found in smartd database.
Mar 17 21:57:29 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 17 21:57:30 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 17 21:57:30 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 17 21:57:30 tippex do_rw_taskfile(task->data_phase=1, tf->command=236
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, can't monitor Current Pending Sector count - no Attribute 197
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, can't monitor Offline Uncorrectable Sector count  - no Attribute 198
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, can't monitor Temperature, ignoring -W Directive
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, appears to lack SMART Self-Test log; disabling -l selftest (override with -T permissive Directive)
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, appears to lack SMART Error log; disabling -l error (override with -T permissive Directive)
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, is SMART capable. Adding to "monitor" list.
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, opened
Mar 17 21:57:30 tippex smartd[5810]: Device: /dev/hda, found in smartd database.
Mar 17 21:57:30 tippex do_rw_taskfile(task->data_phase=0, tf->command=176
Mar 17 21:57:30 tippex do_rw_taskfile(task->data_phase=1, tf->command=176
Mar 17 21:58:00 tippex hda: lost interrupt


And the usual freeze. This is on -rc5 with Barts latest suggestion.

next?

/A

