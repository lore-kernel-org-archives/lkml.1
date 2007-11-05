Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXKEAO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXKEAO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXKEAOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:14:18 -0500
Received: from probity.mcc.ac.uk ([130.88.200.94]:65428 "EHLO
	probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXKEAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:14:17 -0500
Message-ID: <472E6095.5050401@gentoo.org>
Date: Mon, 05 Nov 2007 00:15:17 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070908)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org> <4729F8F1.4040103@gmail.com> <472B946F.4030004@gentoo.org> <472BCC18.7070503@gmail.com> <472CD3F3.7050701@gentoo.org> <472D0D4A.70404@gmail.com>
In-Reply-To: <472D0D4A.70404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> However, there's still remaining issues.  What does happen if you raise
> allocation length and buffersize of the test program to 16?  ie. Change
> 0x0a in cmd[] to 0x10 and increase buffer[10] to buffer[16].

Eek. The process hangs in D state for a good 60 seconds or so.
Caught a trace with sysrq.

<6>a.out         D 00200202     0  7015   3217
<4>       b801fc7c 00200082 b029d5cb 00200202 b04a4c00 b04a4c00 b046ee58 
b0472040
<4>       b24fa000 b24fa140 b17fc040 00000000 b264e000 b801fb80 b264e000 
b01f266c
<4>       b278f800 00200202 b0285eb7 7fffffff 7fffffff b801fc7c b801fc7c 
b035327c
<4>Call Trace:
<4> [<b029d5cb>] ata_scsi_translate+0xd7/0x105
<4> [<b01f266c>] elv_next_request+0xe3/0xf2
<4> [<b0285eb7>] scsi_dispatch_cmd+0x172/0x1aa
<4> [<b035327c>] schedule_timeout+0x13/0x8d
<4> [<b0128830>] del_timer+0x48/0x4e
<4> [<b0352abc>] wait_for_common+0xb2/0x118
<4> [<b011bc10>] default_wake_function+0x0/0x8
<4> [<b01f50d6>] blk_execute_rq+0xa6/0xbc
<4> [<b01f412b>] blk_end_sync_rq+0x0/0x23
<4> [<b0181a14>] bio_add_pc_page+0x23/0x28
<4> [<b0182116>] bio_copy_user+0x116/0x221
<4> [<b0181e5b>] bio_phys_segments+0xe/0x14
<4> [<b01f4253>] blk_rq_bio_prep+0x28/0xa4
<4> [<b01f452a>] blk_rq_append_bio+0x11/0x3a
<4> [<b01f46a0>] blk_rq_map_user+0xfc/0x17f
<4> [<b01f8173>] sg_io+0x20e/0x2f0
<4> [<b01f8408>] scsi_cmd_ioctl+0x1b3/0x34b

When it unhung, this appeared in the logs
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd a0/01:00:00:10:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 16 in
          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
ata2.00: status: { DRDY }
ata2: port is slow to respond, please be patient (Status 0xd0)
ata2: device not ready (errno=-16), forcing hardreset
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete

And the app itself outputted:
result 0
check sense data:
72 0b 00 00 00 00 00 0e 09 0c 00 00 00 03 00 00 00 00 00

Daniel
