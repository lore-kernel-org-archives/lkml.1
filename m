Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZEHHMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZEHHMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZEHHMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:12:19 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:53309 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300AbZEHHMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:12:17 -0400
X-Greylist: delayed 727 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 03:12:16 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200905080700.n48704BR031273@turbo.physics.adelaide.edu.au>
Subject: 2.9.29.2: ide-tape: panic when probing device at boot
To: linux-kernel@vger.kernel.org
Date: Fri, 8 May 2009 16:30:04 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am experiencing a reproducable kernel panic during (I think) IDE probing
of an ide-connected tape unit in 2.6.29.2.  Under 2.6.24.2 things seem to
work ok, although some strange behaviour in recent weeks has me thinking
that the tape drive might have a problem.  In any case though, having
2.6.29.2 panic while 2.6.24.2 doesn't seems a bit strange.

For reference, the "strange behaviour" amounts to a whole stack of
the following messages appearing in syslog.
 WARNING: at include/asm/dma-mapping_32.h:45 dma_map_sg()
 Pid: 0, comm: swapper Not tainted 2.6.24.2 #1
  [<c02f38fe>] ide_build_sglist+0x85/0xd8
  [<c02f398b>] ide_build_dmatable+0x3a/0x158
  [<c0126d3d>] autoremove_wake_function+0x13/0x33
  [<c02f3cb4>] ide_dma_setup+0x26/0x8d
  [<c02fbbb5>] idetape_issue_packet_command+0x143/0x21d
  [<c016ff58>] mpage_end_io_read+0x0/0x50
  [<c02fc4b1>] idetape_do_request+0x2aa/0x2b2
  [<c02ef0a9>] ide_wait_stat+0x46/0x73
  [<c02ee332>] start_request+0x126/0x142
  [<c02ee5f3>] ide_do_request+0x287/0x2be
  [<c02eea27>] ide_intr+0xe0/0x101
  [<c02f37d0>] ide_dma_intr+0x0/0x9c
  [<c01345a1>] handle_IRQ_event+0x1a/0x3f
  [<c013512b>] handle_level_irq+0x50/0x85
  [<c0105325>] do_IRQ+0x74/0x8b
  [<c0103d0b>] common_interrupt+0x23/0x28
  [<c0102018>] default_idle+0x0/0x39
  [<c010203f>] default_idle+0x27/0x39
  [<c0102098>] cpu_idle+0x44/0x60
  [<c04ea769>] start_kernel+0x195/0x199
  [<c04ea32b>] unknown_bootoption+0x0/0x139
Eventually DMA gets disabled on all IDE devices, seemingly as a side effect
of this.

The tape drive concerned is a Sony "AIT-turbo" drive connected as
/dev/hdb.  The IDE interface is a VIA VT82C586A/B/VT82C686/A/B/VT823x/A/C.
The system hard drive is /dev/hda.  Unfortunately my resources are limited
here at present and the best I could get in terms of a panic report is the
following snippet.  Please excuse errors - I had to copy the details to
paper the old fashioned way and then type them in since I didn't have a
digital camera handy.  The extent of the dump is limited at the top by the
number of lines on the console (60).  The call trace stops prematurely
because I couldn't afford to keep the machine down any longer than I did (it
is a production server).

I guess at this point I'm interested to know whether this is indicative of a
kernel problem or whether there really is something potentially wrong with
this drive.  I'm happy to run additional tests if it will help (although a
full bisect is probably not practical given the age of the machine and the
fact that it is a production machine).  In particular, if the last half of
the call trace is deemed interesting I could get that in due course.

Please CC me to ensure I don't miss any replies.

Regards
  jonathan

Kernel oops under 2.6.29.2:

Process swapper (pid: 1 ti=df83e000 task=df822cc0 task.ti=df83e000)

Stack:                                             v-- or 7
  dfaa9000 dfb87000 df83fb7c c02f3ebe 00000000 fda29be0 dfb87800 dfa29be0
  000004ec df8e3de0 c02ebcec ffffffff ffffffff 00000000 dfb87800 dfa29be0
  dfb87000 c02e6e2a df8ae128 df8ae128 dfa29be0 dfa29be0 df8ae128 00000000

Call trace:
[<c02f3e6e>] idetape_do_request+0x1e5/0x1ec
[<c02e6cec>] start_request+0xfd/0x120
[<c02e6e2a>] do_ide_request+0xfa/0x13c
[<c0259ec8>] blk_start_queueing+0x15/0x1e
[<c0258c08>] elv_insert+0x68/0x14f
[<c025c7c0>] blk_execute_rq_nowait+0x4d/0x65
[<c025c84b>] blk_execute_rq+0x73/0x94
[<c025c750>] blk_end_sync_rq+0x0/0x23
[<c02ebc4e>] ide_queue_pc_tail+0x6b/0x7d
[<c02f54ce>] ide_tape_get_inquiry_results+0x28/0xc5
[<c03af803>] schedule_timeout+0x13/0x84
[<c0264870>] kobject_get+0xf/0x13
[<c02f57c9>] ide_tape_setup+0x99/0x1e6
:

Code: b6 53 89 cb 83 7c 24 08 00 74 07 e8 88 fb ff ff eb 05 08 f3 fa ff ff  
89 d8 5b c3 57 89 c7 56 53 86 70 18 90 d3 8b 80 9c 01 00 00<80>38 03 75 10
80 3a 03 75 0b 68 a3 0d 4a c0 e8 9c 4e e2 ff 58

EIP: [<c02f43a527>] idetape_issue_pc+0x10/0de SS:ESP 0068:df83fa20

---[ end trace b172b6d3ec773d8b ]---

Kernel panic - not syncing: Attempted to kill init!
