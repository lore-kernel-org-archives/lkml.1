Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYLZRgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYLZRgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 12:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYLZRgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 12:36:14 -0500
Received: from verein.lst.de ([213.95.11.210]:42461 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYLZRgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 12:36:14 -0500
Date: Fri, 26 Dec 2008 18:36:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: axboe@oracle.com, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: oops in __bounce_end_io_read under kvm
Message-ID: <20081226173606.GA14933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been gettings oopsens from a a virtio_blk callchain when running
xfsqa under kvm on a virtio devices frequently but not easily
reproducibly.  The VM has 1.2 GB of memory and thus highmem
enabled, but I don't really understand why we bounce buffer in the
guest.

The callstack looks like this:


[  898.476526] BUG: unable to handle kernel paging request at fffba200
[  898.480159] IP: [<c01a7c24>] __bounce_end_io_read+0xd4/0x130
[  898.480159] *pde = 00008067 *pte = 00000000 
[  898.480159] Oops: 0002 [#1] SMP 
[  898.480159] last sysfs file: /sys/class/net/lo/operstate
[  898.480159] Modules linked in:
[  898.480159] 
[  898.480159] Pid: 2062, comm: xfs_repair Not tainted (2.6.28-rc9-xfs #23) 
[  898.480159] EIP: 0060:[<c01a7c24>] EFLAGS: 00010086 CPU: 0
[  898.480159] EIP is at __bounce_end_io_read+0xd4/0x130
[  898.480159] EAX: fffba000 EBX: 00000000 ECX: 00000380 EDX: 00000e00
[  898.480159] ESI: ea5fb200 EDI: fffba200 EBP: f4f8fda0 ESP: f4f8fd74
[  898.480159]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  898.480159] Process xfs_repair (pid: 2062, ti=f4f8e000 task=f6ad0070 task.ti=f4f8e000)
[  898.480159] Stack:
[  898.480159]  00000380 00000000 f6bf3718 f706a8d8 f706ae20 00000000 f7066578 00000086
[  898.480159]  c01a7ca0 00000000 00000000 f4f8fda8 c01a7cb0 f4f8fdb4 c01dad1d f706a8d8
[  898.480159]  f4f8fdd8 c05117e9 f4f8fdd8 00000046 00000001 00000046 f706a8d8 00001000
[  898.480159] Call Trace:
[  898.480159]  [<c01a7ca0>] ? bounce_end_io_read+0x0/0x20
[  898.480159]  [<c01a7cb0>] ? bounce_end_io_read+0x10/0x20
[  898.480159]  [<c01dad1d>] ? bio_endio+0x1d/0x40
[  898.480159]  [<c05117e9>] ? req_bio_endio+0x89/0xe0
[  898.480159]  [<c05118b2>] ? __end_that_request_first+0x72/0x2b0
[  898.480159]  [<c05119d5>] ? __end_that_request_first+0x195/0x2b0
[  898.480159]  [<c0511caf>] ? __blk_end_request+0x1f/0x50
[  898.480159]  [<c059dffd>] ? blk_done+0x4d/0x90
[  898.480159]  [<c063e11a>] ? vring_interrupt+0x2a/0x40
[  898.480159]  [<c063e622>] ? vp_interrupt+0x72/0xb0
[  898.480159]  [<c0184999>] ? handle_IRQ_event+0x29/0x60
[  898.480159]  [<c01862d2>] ? handle_fasteoi_irq+0x62/0xd0
[  898.480159]  [<c012117e>] ? do_IRQ+0x8e/0xc0
[  898.480159]  [<c011fb74>] ? common_interrupt+0x28/0x30
[  898.480159]  [<c052007b>] ? kobject_move+0x10b/0x120
[  898.480159]  [<c013932f>] ? paravirt_get_lazy_mode+0xf/0x20
[  898.480159]  [<c01385b3>] ? kvm_leave_lazy_mmu+0x63/0x80
[  898.480159]  [<c01a3451>] ? mprotect_fixup+0x2b1/0x400
[  898.480159]  [<c01a36ec>] ? sys_mprotect+0x14c/0x1d0
[  898.480159]  [<c011effe>] ? syscall_call+0x7/0xb
[  898.480159]  [<c0110000>] ? kvm_mmu_pte_write+0x270/0x970
[  898.480159] Code: 4e fc ff 8b 55 ec 8b 04 1a 31 d2 e8 d7 6a f9 ff 8b
4d ec 8b 54 19 04 89 c7 89 d1 c1 e9 02 89 4d d4 8b 4d ec 03 7c 19 08 8b
4d d4 <f3> a5 89 d1 83 e1 03 74 02 f3 a4 31 d2 e8 fa 68 f9 ff f7 45 f0 
