Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbXGVRVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbXGVRVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXGVRU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:20:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:27440 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXGVRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=dfHDlZTYBRAO08CJeeqlJ7hhPvHJtjQD18b3Z8pNHb1cCGyrKbknSIhFnWGz5rT45Ueyre3SjqSS4ppxU00zI/fg2XHp9rOHAM0VD/FP6QqDI57BIyXmDPhMqfBLyFJAKKGjGkTv26NjcdRd61bc19ATd/CMy/ShrQrQ6LeD9HQ=
Message-ID: <a781481a0707221020m3c3a397fifa9076aefc63148a@mail.gmail.com>
Date: Sun, 22 Jul 2007 22:50:55 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: wharms@bfs.de
Subject: Re: crash with 2.6.22.1 crash:ll_rw_blk.c blk_remove_plug()
Cc: "Jens Axboe" <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <46A38B1E.3090605@bfs.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_132208_30325174.1185124855326"
References: <469DD37C.8050200@bfs.de> <20070718103342.GI11657@kernel.dk>
	 <469DF233.5080902@bfs.de> <20070718110724.GN11657@kernel.dk>
	 <469E072E.7080400@bfs.de> <20070718123142.GV11657@kernel.dk>
	 <46A38B1E.3090605@bfs.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_132208_30325174.1185124855326
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Walter,

Thanks for reporting this.

On 7/22/07, walter harms <wharms@bfs.de> wrote:
> hello all,
> on my asus notebook tm620 there is a crash with 2.6.22 and 2.6.21

Did this happen when you were resuming from a suspend-to-ram/disk?
[ I ask because I see swsusp in the trace below, linux-pm added to Cc: ]

> ....
> Using IPI Shortcut mode
> WARNING: at block/ll_rw_blk.c:1575 blk_remove_plug()
>  [<c01ac87e>] blk_remove_plug+0x36/0x5a
>  [<c01ac8b6>] __generic_unplug_device+0x14/0x1f
>  [<c01ad587>] __make_request+0x39b/0x49c
>  [<c01abc8c>] generic_make_request+0x228/0x255
>  [<c01adb54>] submit_bio+0xa5/0xac
>  [<c013e233>] mempool_alloc+0x37/0xae
>  [<c01314dc>] submit+0xc2/0x11d
>  [<c0131585>] bio_read_page+0x24/0x27
>  [<c013188b>] swsusp_check+0x4f/0xaf
>  [<c012f6c2>] software_resume+0x5f/0x108
>  [<c037867e>] kernel_init+0xb0/0x212
>  [<c0103a16>] ret_from_fork+0x6/0x1c
>  [<c03785ce>] kernel_init+0x0/0x212
>  [<c03785ce>] kernel_init+0x0/0x212
>  [<c010465b>] kernel_thread_helper+0x7/0x10
>  =======================

Surprising, that's a WARN_ON(!irqs_disabled()) but IRQs are disabled
alright on that codepath. OTOH, __make_request() is heavily goto-driven,
uses the non-save/restore variants of spin_lock_irq, and does not even
balance locks / unlocks for some error paths ... gaah.

> Freeing unused kernel memory: 272k freed
> ....
>
> I attached two files with the kernel bootmessage
>
> 1. bug.txt.gz
>  kernel 2.6.22.1 created with netconsole, last lines were missing i added them by hand
>
> 2. out.txt.gz
>   simple a dmesg from kernel 2.6.18, works fine

I've reattached them in this mail, for linux-pm to see.

> additional observations:
> removing 'resume=/dev/hda1' from grub lets the crash disappear but the
> drive still does not work because
> ata_id[772]: main: HDIO_GET_IDENTITY failed for '/dev/.tmp-3-0'

If you're resuming from a suspend I don't see how you can avoid
giving the resume= parameter (unless you somehow specify some
default at build-time ...)

> there is a bug in the hd detection code:
> 2.6.22.1
> hda: 8032MB, CHS=1024/255/63
>  hda: hda1 hda2 hda3
>  hda: p2 exceeds device capacity
>  hda: p3 exceeds device capacity
>
> 2.6.18
> hda: 39070080 sectors (20003 MB), CHS=38760/16/63, UDMA(100)
> hda: cache flushes supported
>  hda: hda1 hda2 hda3
> Probing IDE interface ide1...
>
>
> here the output from fdisk:
>
>  fdisk -l
>
> Disk /dev/hda: 20.0 GB, 20003880960 bytes
> 255 heads, 63 sectors/track, 2432 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/hda1               1         131     1052226   82  Linux swap / Solaris
> /dev/hda2   *         132        1437    10490445   83  Linux
> /dev/hda3            1438        2432     7992337+  83  Linux
>
>
>
> is it possible that this leads to a chain of events causing the crash in ll_rw_blk.c ?
>
> if someone is interested in the .config please mail me directly, i have not
> subscribed the lkml.

Yes, please post your .config also.

Thanks,
Satyam

------=_Part_132208_30325174.1185124855326
Content-Type: application/x-gzip; name=bug.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4fse443
Content-Disposition: attachment; filename="bug.txt.gz"

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
JwAA
------=_Part_132208_30325174.1185124855326
Content-Type: application/x-gzip; name=out.txt.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4fsemif
Content-Disposition: attachment; filename="out.txt.gz"

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
+APMa86ZwUAAAA==
------=_Part_132208_30325174.1185124855326--
