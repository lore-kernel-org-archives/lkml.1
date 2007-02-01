Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXBAHQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXBAHQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161233AbXBAHQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:16:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161232AbXBAHQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:16:27 -0500
Date: Wed, 31 Jan 2007 23:16:22 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
       "linux-aio@kvack.org" <linux-aio@kvack.org>
Subject: Re: Kernel BUG at fs/aio.c:509
Message-Id: <20070131231622.4ccdb2c1.akpm@osdl.org>
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC7CC3A1@mssmsx411>
References: <B41635854730A14CA71C92B36EC22AAC7CC3A1@mssmsx411>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 09:13:51 +0300 "Ananiev, Leonid I" <leonid.i.ananiev@intel.com> wrote:

> While repeatedly running 'aiostress -O -o 2' test I've got in
> /var/log/messages:
> 
> BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
> Call Trace:
>  [<ffffffff802573c3>] invalidate_inode_pages2_range+0x236/0x26b
>  [<ffffffff802af77b>] ext3_direct_IO+0x16c/0x19e
>  [<ffffffff802adc1d>] ext3_get_block+0x0/0xe2
>  [<ffffffff802518c0>] generic_file_direct_IO+0xb9/0xcf
>  [<ffffffff8025193d>] generic_file_direct_write+0x67/0x10e
>  [<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
>  [<ffffffff802082c0>] __switch_to+0x26f/0x27e
>  [<ffffffff8047b8e9>] thread_return+0x0/0xd8
>  [<ffffffff80252497>] generic_file_aio_write+0x67/0xc7
>  [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
>  [<ffffffff802ab2e2>] ext3_file_write+0x16/0x8f
>  [<ffffffff802ab2cc>] ext3_file_write+0x0/0x8f
>  [<ffffffff80283f61>] aio_rw_vect_retry+0x72/0x14f
>  [<ffffffff80284ad9>] aio_run_iocb+0xe6/0x187
>  [<ffffffff802853e2>] io_submit_one+0x296/0x2e3
>  [<ffffffff80285979>] sys_io_submit+0x9b/0x108
>  [<ffffffff80229b49>] default_wake_function+0x0/0xe
>  [<ffffffff8020983e>] system_call+0x7e/0x83

That warning got removed from -rc7.  It's harmless, in most cases.  We think.

It's a bit of a worry that aio-on-ext3 is triggering it.  That's
unexpected.

> ----------- [cut here ] --------- [please bite here ] ---------
> Kernel BUG at fs/aio.c:509
> invalid opcode: 0000 [1] SMP 
> CPU 1 
> Modules linked in: firmware_class
> Pid: 11362, comm: aiostress Not tainted 2.6.19 #1

Oh.  2.6.19.  Did you try 2.6.19.latest?

> RIP: 0010:[<ffffffff802841ea>]  [<ffffffff802841ea>]
> __aio_put_req+0x27/0x162
> RSP: 0018:ffff81000c167e88  EFLAGS: 00010096
> RAX: 00000000ffffffff RBX: ffff8100184f8dc0 RCX: 000000001d44f000
> RDX: 000000000000000d RSI: ffff8100184f8dc0 RDI: ffff81001d44ee80
> RBP: ffff81001d44ee80 R08: 6db6db6db6db6db7 R09: ffff810001000000
> R10: 0000000000000000 R11: 0000000000000046 R12: ffff810037341c80
> R13: ffff81001d44ee80 R14: 0000000000606998 R15: 0000000000000000
> FS:  00002ab979b0ee90(0000) GS:ffff810037e896c0(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002aea207c3950 CR3: 000000001009c000 CR4: 00000000000006e0
> Process aiostress (pid: 11362, threadinfo ffff81000c166000, task
> ffff81003f49f5a0)
> Stack:  ffff8100184f8dc0 ffff81001d44ee80 ffff810037341c80
> ffffffff80284ff6
>  ffff8100184f8dc0 ffff8100184f8dc0 0000000000000000 ffffffff80285409
>  0000000000607fb0 ffff81001d44ee80 0000000000606998 0000000000000001
> Call Trace:
>  [<ffffffff80284ff6>] aio_put_req+0x21/0x59
> ffffffff80284ff1:       e8 cd f1 ff ff          callq  ffffffff802841c3
> <__aio_put_req>
>  [<ffffffff80285409>] io_submit_one+0x2bd/0x2e3
>  [<ffffffff80285979>] sys_io_submit+0x9b/0x108
>  [<ffffffff80229b49>] default_wake_function+0x0/0xe
>  [<ffffffff8020983e>] system_call+0x7e/0x83
> 
> 
> Code: 0f 0b 68 76 e6 4a 80 c2 fd 01 85 c0 74 07 31 c0 e9 21 01 00 
> RIP  [<ffffffff802841ea>] __aio_put_req+0x27/0x162
>  RSP <ffff81000c167e88>
> NMI Watchdog detected LOCKUP on CPU 1
> CPU 1 
> Modules linked in: firmware_class
> Pid: 11362, comm: aiostress Not tainted 2.6.19 #1
> RIP: 0010:[<ffffffff8047d3f5>]  [<ffffffff8047d3f5>]
> _spin_lock_irq+0x8/0x10
> RSP: 0018:ffff81000c167c10  EFLAGS: 00000086
> RAX: ffff81003e0f0001 RBX: ffff81001d44ee80 RCX: 00002ab979b0ef40
> RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff81001d44eeb8
> RBP: ffff81001d44ee80 R08: 0000000000000286 R09: 0000000000000018
> R10: 0000000000000286 R11: 0000000000000046 R12: 0000000000000001
> R13: 000000000000000b R14: ffffffff804a5904 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff810037e896c0(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002aea207c3950 CR3: 000000001009c000 CR4: 00000000000006e0
> Process aiostress (pid: 11362, threadinfo ffff81000c166000, task
> ffff81003f49f5a0)
> Stack:  ffffffff80284050 0000000000000286 ffffffff802441cc
> 0000000000000018
> ffffffff8047cebe 0000000000000246 ffff81001d44ee80 0000000000000000
> ffffffff80285880 ffff81003e0f12c0 ffff81003e0f12c0 ffff81003f49f5a0
> Call Trace:
> [<ffffffff80284050>] aio_cancel_all+0x12/0x87
> 0x12:       e8 9d 93 1f 00          callq  ffffffff8047d3ed
> <_spin_lock_irq>
> [<ffffffff802441cc>] lock_hrtimer_base+0x26/0x4c
> [<ffffffff8047cebe>] __down_read+0x12/0x9a
> [<ffffffff80285880>] exit_aio+0x2e/0x8c
> [<ffffffff8022d904>] mmput+0x19/0x98
> [<ffffffff80232be9>] do_exit+0x1f7/0x825
> [<ffffffff80321799>] vgacon_set_cursor_size+0x36/0xd1
> [<ffffffff8020b228>] kernel_math_error+0x0/0x90
> [<ffffffff8020baf4>] do_invalid_op+0xad/0xb7
> [<ffffffff802841ea>] __aio_put_req+0x27/0x162
> [<ffffffff80252308>] __generic_file_aio_write_nolock+0x2d6/0x3fe
> [<ffffffff802082c0>] __switch_to+0x26f/0x27e
> [<ffffffff8047d5fd>] error_exit+0x0/0x84
> [<ffffffff802841ea>] __aio_put_req+0x27/0x162
> [<ffffffff80284ff6>] aio_put_req+0x21/0x59
> [<ffffffff80285409>] io_submit_one+0x2bd/0x2e3
> [<ffffffff80285979>] sys_io_submit+0x9b/0x108
> [<ffffffff80229b49>] default_wake_function+0x0/0xe
> [<ffffffff8020983e>] system_call+0x7e/0x83
> Code: 83 3f 00 7e f9 eb f2 c3 53 48 89 fb e8 06 7b db ff f0 ff 0b 
> <1>Fixing recursive fault but reboot is needed!
> ========================================================================
> =======================
> 
> It stable happens after 2-5 aiosterss runs on 2.6.20-rc6 as well as on
> 2.6.19 in 4 processor Xeon.
> 
> fs/aio.c:509 line is  BUG_ON(req->ki_users < 0);
> It may be an effect of return 1 from invalidate_inode_pages2_range() one
> second earlier as you can see in log.
> To investigate a root cause of ret=0 in invalidate_inode_pages2_range()
> I have added printk() calls.
> As a result I can say that
>          invalidate_inode_pages2_range() reports BUG: warning at
> mm/truncate.c:398  occurs becouse of
>          invalidate_complete_page2()    		returns 0; it
> returns 0 because of
>          try_to_release_page()                        returns 0; it
> returns 0 because of
>          ext3_releasepage()                            returns 0; it
> returns 0 because of
>          journal_try_to_free_buffers()             returns 0; it returns
> 0 because of
>          try_to_free_buffers()                         returns 0; it
> returns 0 because of
>          drop_buffers()                                  returns 0; it
> returns 0 because of
>          buffer_busy(bh)                                returns 1; it
> returns 0 because of
>          buffer_head count is 1 (bh->b_count==1) as additional printk
> reports.
> 
> Leonid
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
