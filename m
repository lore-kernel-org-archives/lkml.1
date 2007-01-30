Return-Path: <linux-kernel-owner+w=401wt.eu-S965411AbXA3H2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965411AbXA3H2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 02:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXA3H2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 02:28:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46371 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965411AbXA3H2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 02:28:00 -0500
Date: Mon, 29 Jan 2007 23:27:27 -0800
From: Andrew Morton <akpm@osdl.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Miles Lane <miles.lane@gmail.com>,
       Anton Altaparmakov <aia21@cantab.net>
Subject: Re: 2.6.20-rc6-mm1
Message-Id: <20070129232727.96e580ac.akpm@osdl.org>
In-Reply-To: <45BC7A26.1080303@gmail.com>
References: <20070127234928.64d8e437.akpm@osdl.org>
	<45BC7A26.1080303@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jan 2007 11:25:42 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Andrew Morton napsal(a):
> > Temporarily at
> > 
> > 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> 
> I'm still seeing this during bootup:
> BUG: at /home/l/latest/xxx/arch/i386/mm/highmem.c:52 kmap_atomic()
>   [<c0104ffb>] show_trace_log_lvl+0x1a/0x30
>   [<c01056b5>] show_trace+0x12/0x14
>   [<c010573c>] dump_stack+0x16/0x18
>   [<c011b24f>] kmap_atomic+0x16c/0x20e
>   [<c01b279e>] ntfs_end_buffer_async_read+0x18e/0x2ed
>   [<c0183352>] end_bio_bh_io_sync+0x26/0x3f
>   [<c0184dd4>] bio_endio+0x37/0x62
>   [<c01cda43>] __end_that_request_first+0x224/0x444
>   [<c01cdc6b>] end_that_request_chunk+0x8/0xa
>   [<c024507d>] scsi_end_request+0x1f/0xc7
>   [<c02451e6>] scsi_io_completion+0x7b/0x33a
>   [<c024aa5d>] sd_rw_intr+0x23/0x1ab
>   [<c02415ed>] scsi_finish_command+0x42/0x47
>   [<c0245a38>] scsi_softirq_done+0x64/0xcf
>   [<c01cf9e6>] blk_done_softirq+0x54/0x62
>   [<c0127bc5>] __do_softirq+0x75/0xde
>   [<c0127c69>] do_softirq+0x3b/0x3d
>   [<c0127ee6>] irq_exit+0x3b/0x3d
>   [<c0106804>] do_IRQ+0x51/0x8d
>   [<c0104a5f>] common_interrupt+0x23/0x28
>   [<c010241a>] cpu_idle+0x80/0xc3
>   [<c010140d>] rest_init+0x23/0x36
>   [<c045ea59>] start_kernel+0x3a5/0x43c
>   [<00000000>] 0x0
>   =======================
> 
> I.e. KM_BIO_SRC_IRQ through softirq path.
> 

argh.

ntfs_end_buffer_async_read() doesn't know whether it will be called from
hardirq or from softirq context: it depends upon the underlying driver.

In this case, if the CPU running ntfs_end_buffer_async_read() is
interrupted by IO completion against a different disk controller and that
completion handler uses KM_BIO_SRC_IRQ (as it is allowed to do), it will
trash ntfs_end_buffer_async_read()'s atomic kmap and unpleasing things will
ensue.

I guess a suitable fix here is to protect that kmap with
local_irq_save/restore.

I wonder where else we have that bug?
