Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZJLFuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZJLFuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZJLFuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:50:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:65228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZJLFuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,544,1249282800"; 
   d="scan'208";a="558672590"
Subject: Re: fio rand read/write regression with 2.6.32-rc3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4e5e476b0910110123s54debc6as435c9cc0d5e8340c@mail.gmail.com>
References: <1255153724.25078.68.camel@ymzhang>
	 <20091010080117.GN9228@kernel.dk> <1255168333.25078.82.camel@ymzhang>
	 <4e5e476b0910110123s54debc6as435c9cc0d5e8340c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Oct 2009 13:50:16 +0800
Message-Id: <1255326616.3684.27.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 10:23 +0200, Corrado Zoccolo wrote:
> On Sat, Oct 10, 2009 at 11:52 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> > On Sat, 2009-10-10 at 10:01 +0200, Jens Axboe wrote:
> >> On Sat, Oct 10 2009, Zhang, Yanmin wrote:
> >> > Comparing with 2.6.23-rc1's result, fio rand read write has regression
> >> > on my 2*4 core stoakley machine (8GB memory) with a JBOD of 12 disks.
> >> >
> >> > Every disk has 8 1-GB files. Start 8 sub-processes per disk and every
> >> > process random chooses a file on the disk to do 36 times of file read or
> >> > write on the file and then choose another file.
> >> >
> >> >
> >> > fio_mmap_rand_read_4k regresion is about 35%.
> >>
> >> Heh, I seem to recollect I told Linus that this would cost is 30-40%
> >> performance. So not totally crazy.
> >>
> >> So yes, this isn't hugely unexpected. If you send me your fio job files,
> >> I'll try and see what I can do about it.
> > See the attachment.
> >
> Hi Yanmin,
> the fio test you sent just performs random read, no write seems involved here.
﻿
Sorry for not sending all the job files because they are similiar and big.
You could change the job file to run rand write and readwrite.

> I suspect that you should be able to observe the same regression if
> you just run on a single disk. Can you confirm?
> Is your disk a SATA2 rotational disk with NCQ?
It's a JOBD with 12 SAS disks.

Another machine's JBOD has 13 SCSI disks.

Based on your suggestion, I tested it on a single SAS disk (create 8 1-GB file and
start 8 processes) and get 30% regression. On a single SCSI disk, there is also about
30% regression. On a single SATA (SATA link up 1.5 Gbps) disk with NCQ, the regression
is about 20%.

Perhaps the job file causes fio to deliver too many I/O requests, sometimes kernel
print out some blocking info like below:

Apr  8 23:54:19 lkp-tulsa01-x8664 kernel: INFO: task kjournald:6261 blocked for more than 120 seconds.
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel: kjournald     D ffff88002f228180     0  6261      2
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel:  ffff88027ab09910 0000000000000046 0000000000000000 ffff88027cc20440
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel:  ffff88027f0c66a0 ffff88027ab09bb0 0000000100000e56 000000007cc20440
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel:  ffff88027a915480 ffffffff803678a9 0000000000000000 0000000100000000
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel: Call Trace:
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel:  [<ffffffff803678a9>] ? __make_request+0x310/0x40b
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel:  [<ffffffff802b5571>] ? sync_buffer+0x0/0x3f
Apr  8 23:54:19 lkp-tulsa01-x8664 kernel:  [<ffffffff805aeadf>] ? schedule+0x9/0x1d


