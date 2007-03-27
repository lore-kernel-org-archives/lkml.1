Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbXC0EQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbXC0EQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 00:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933966AbXC0EQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 00:16:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37553 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965AbXC0EQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 00:16:04 -0400
Date: Mon, 26 Mar 2007 20:15:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Message-Id: <20070326201552.b8ad7dda.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	<20070322170122.ee2589a1.akpm@linux-foundation.org>
	<b040c32a0703231748s112beda6i3d51ebcd658005c4@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 17:48:29 -0700 "Ken Chen" <kenchen@google.com> wrote:

> It is really sad that we always call kmap and friends for every pipe
> buffer page on 64-bit arch that doesn't use HIGHMEM, or on
> configuration that doesn't turn on HIGHMEM.
> 
> The effect of calling kmap* is visible in the execution profile when
> pipe code is being stressed.  It is especially true on amd's x86-64
> platform where kmap() has to traverse through numa node index
> calculation in order to convert struct page * to kernel virtual
> address.  It is fairly pointless to perform that calculation repeatly
> on system with no highmem (i.e., 64-bit arch like x86-64).  This patch
> caches kernel pipe buffer page's kernel vaddr to speed up pipe buffer
> mapping functions.

LTP's vmsplice01 triggers the below:

VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 200k freed
Unable to find swap-space signature
Unable to handle kernel NULL pointer dereference at 0000000000000130 RIP: 
 [<ffffffff8029e1b6>] pipe_to_file+0x1f3/0x2a6
PGD 10389d067 PUD 10107b067 PMD 0 
Oops: 0000 [1] PREEMPT SMP 
last sysfs file: devices/pci0000:00/0000:00:1d.7/usb1/dev
CPU 3 
Modules linked in: pcmcia firmware_class yenta_socket rsrc_nonstatic pcmcia_core
Pid: 18708, comm: vmsplice01 Not tainted 2.6.21-rc5-mm1 #2
RIP: 0010:[<ffffffff8029e1b6>]  [<ffffffff8029e1b6>] pipe_to_file+0x1f3/0x2a6
RSP: 0018:ffff81010448dd48  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000ed0
RDX: ffff81010448dfd8 RSI: 0000000000000130 RDI: ffff810170149000
RBP: ffff81010448dda8 R08: 0000000000000004 R09: ffff810102657d40
R10: 0000000000001000 R11: 00000000002da01c R12: ffff810006c05240
R13: 0000000000000ed0 R14: ffff810103c56bb0 R15: 0000000000000ed0
FS:  00002af6b3d96b00(0000) GS:ffff810100090b90(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000130 CR3: 000000010384a000 CR4: 00000000000006e0
Process vmsplice01 (pid: 18708, threadinfo ffff81010448c000, task ffff8101045d58f0)
Stack:  000000000000000e ffff81010448ddc8 ffff810103c56b48 ffff810101168df0
 ffff81010edf9660 0000000003c56b48 0000000000000000 ffff810103c56bb0
 ffff810103c56b48 0000000000000000 0000000000000000 ffffffff804f8380
Call Trace:
 [<ffffffff8029e2d6>] __splice_from_pipe+0x6d/0x1ea
 [<ffffffff8029dfc3>] pipe_to_file+0x0/0x2a6
 [<ffffffff8029dfc3>] pipe_to_file+0x0/0x2a6
 [<ffffffff8029e554>] splice_from_pipe+0x54/0x75
 [<ffffffff8029e611>] generic_file_splice_write+0x8a/0xfc
 [<ffffffff8029dd8d>] do_splice_from+0x72/0x7e
 [<ffffffff8029f274>] sys_splice+0x105/0x216
 [<ffffffff802096fe>] system_call+0x7e/0x83


Code: f3 a4 bf 01 00 00 00 e8 0b a9 f8 ff 65 48 8b 04 25 10 00 00 

