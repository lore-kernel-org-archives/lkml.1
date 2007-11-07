Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbXKGN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbXKGN2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbXKGN2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:28:14 -0500
Received: from morrison.andev.ch ([213.133.123.55]:65377 "EHLO
	morrison.andev.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694AbXKGN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:28:13 -0500
Date: Wed, 7 Nov 2007 14:28:08 +0100
From: Petar Bogdanovic <list+2007@smokva.net>
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, list+2007@smokva.net
Subject: Re: dd/mke2fs on loopback hangs
Message-ID: <20071107132808.GA10032@pintail.smokva.net>
Mail-Followup-To: Milan Broz <mbroz@redhat.com>,
	linux-kernel@vger.kernel.org, list+2007@smokva.net
References: <20071106131310.GA8628@pintail.smokva.net> <4730D6F3.8030500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730D6F3.8030500@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:04:51PM +0100, Milan Broz wrote:
> Petar Bogdanovic wrote:
> > I experience some strange problems with my loopback-on-ext3-setup.
> > After creating a plain `zeroed' dummy-file and doing a /dev/loop/0 on
> > it, every dd or mke2fs hangs while doing certain write()s. Here are the
> > steps just in order to show, how simple the setup is:
> ...
> 
> > P.S:	$ uname -a
> > 	Linux pintail 2.6.23-ARCH #1 SMP PREEMPT Sat Oct 27 09:04:14 UTC
> > 	2007 i686 Intel(R) Pentium(R) M processor 1.70GHz GenuineIntel
> > 	GNU/Linux
> 
> Hi Petar,
> 
> I saw similar bug report for dm-crypt over loop but reproducible even
> on stand-alone loop devices -  see http://bugzilla.kernel.org/show_bug.cgi?id=8020
> 
> The problem was caused by loop io stalling in balance_dirty_pages.
> 
> Per BDI dirty limit patchset (included in 2.6.24-rc) fixed it.
> 
> Anyway, you should attach output of process states when system stops
> responding (output of "echo t >/proc/sysrq-trigger" ) here to allow
> some analysis.

Thanks Milane! :)

Here are the process states:

dd `hanging' on a 1GB zeroed loopback:

=======================
dd            D eb52fcc0     0 10152   9657
eb52fcd4 00200086 00000002 eb52fcc0 eb52fcb8 00000000 c047aee0 c047de80 
eb52fcc4 ed192550 c180ce80 00000000 00152450 00000000 0000000f 00000000 
00000000 00000000 eb52fce4 0015246d 000055bd eb52fd0c c035fb0a 00000001 
Call Trace:
[<c035fb0a>] schedule_timeout+0x4a/0xc0
[<c0135240>] process_timeout+0x0/0x10
[<c035f4be>] io_schedule_timeout+0x1e/0x30
[<c0166976>] congestion_wait+0x56/0x80
[<c0140200>] autoremove_wake_function+0x0/0x40
[<c0161701>] balance_dirty_pages_ratelimited_nr+0x141/0x220
[<c015cc1a>] generic_file_buffered_write+0x37a/0x6b0
[<c01489f8>] tick_program_event+0x38/0x60
[<c015d204>] __generic_file_aio_write_nolock+0x2b4/0x530
[<c013165b>] irq_exit+0x5b/0x90
[<c015d5a7>] generic_file_aio_write_nolock+0x47/0xb0
[<c0168b07>] unmap_vmas+0x537/0x610
[<c017df15>] do_sync_write+0xd5/0x120
[<c0140200>] autoremove_wake_function+0x0/0x40
[<c017de40>] do_sync_write+0x0/0x120
[<c017e7cf>] vfs_write+0xbf/0x140
[<c017ee61>] sys_write+0x41/0x70
[<c0104482>] sysenter_past_esp+0x6b/0xa1
=======================


and mke2fs `hanging' on a 30GB sparse file loopback:

=======================
mke2fs        D e6bcdcc0     0 10767   9657
e6bcdcd4 00200086 00000002 e6bcdcc0 e6bcdcb8 00000000 c047aee0 c047de80 
e6bcdcc4 dfe1f540 c180ce80 00000000 0017c1f9 00000000 0000000f 00000000 
00000000 00000000 e6bcdce4 0017c259 000055c4 e6bcdd0c c035fb0a 00000001 
Call Trace:
[<c035fb0a>] schedule_timeout+0x4a/0xc0
[<c0135240>] process_timeout+0x0/0x10
[<c035f4be>] io_schedule_timeout+0x1e/0x30
[<c0166976>] congestion_wait+0x56/0x80
[<c0140200>] autoremove_wake_function+0x0/0x40
[<c0161701>] balance_dirty_pages_ratelimited_nr+0x141/0x220
[<c015cc1a>] generic_file_buffered_write+0x37a/0x6b0
[<c015d204>] __generic_file_aio_write_nolock+0x2b4/0x530
[<c0124233>] __check_preempt_curr_fair+0x53/0xa0
[<c0128dd7>] check_preempt_curr_fair+0x57/0x90
[<c015d5a7>] generic_file_aio_write_nolock+0x47/0xb0
[<c01030b1>] __switch_to+0xa1/0x150
[<c017df15>] do_sync_write+0xd5/0x120
[<c0140200>] autoremove_wake_function+0x0/0x40
[<c017de40>] do_sync_write+0x0/0x120
[<c017e7cf>] vfs_write+0xbf/0x140
[<c017db1c>] vfs_llseek+0x3c/0x50
[<c017ee61>] sys_write+0x41/0x70
[<c0104482>] sysenter_past_esp+0x6b/0xa1
[<c0360000>] __mutex_lock_interruptible_slowpath+0x120/0x340
=======================


If you need more output, just tell me.


Thanks & with kind regards,

Petar
