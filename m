Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZF0QnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZF0QnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbZF0Qm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:42:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46086 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZF0Qm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:42:56 -0400
Date: Sat, 27 Jun 2009 17:42:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc1 crashes randomly on my Machine.
Message-ID: <20090627164258.GE8633@ZenIV.linux.org.uk>
References: <40a4ed590906252356i574f0da4jc3763cfc9f0f65f6@mail.gmail.com> <20090626071520.GC8633@ZenIV.linux.org.uk> <20090626073919.GD8633@ZenIV.linux.org.uk> <40a4ed590906270410o9e17587p68a2d688b551b667@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40a4ed590906270410o9e17587p68a2d688b551b667@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 01:10:46PM +0200, Zeno Davatz wrote:
> > which is at least not entirely implausible. ?So it seems to be a memory
> > corruption in .text, which might or might not affect the directly
> > preceding bytes (0xe9 <signed 32bit int> is a relative jump, so there's
> > no way to tell whether this 0xff had been the only byte affected - it
> > would be preceded by 3 0xff coming from small negative integer anyway).
> 
> I just done another pull from the Git repository of Linus and booted
> from the latest 2.6.31-rc1 and my Machine still hangs after boot up,
> with the following message at the end in /var/log/messages
> 
> Jun 27 03:01:52 zenogentoo Stack:
> Jun 27 03:01:52 zenogentoo c10d14f2 f2eb9f5c c10ab407 00000400
> b8033000 f6b43d80 f33cbe28 00000000
> Jun 27 03:01:52 zenogentoo <0> 00000000 f65c9000 00001000 00000000
> 00000000 00000000 f721a100 fffffffb
> Jun 27 03:01:52 zenogentoo <0> c10d13e5 f2eb9f64 c10f1522 f2eb9f98
> 00000400 b8033000 f6b43d80 f6b43d80
> Jun 27 03:01:52 zenogentoo Call Trace:
> Jun 27 03:01:52 zenogentoo [<c10d14f2>] ? seq_read+0x10d/0x3a5
> Jun 27 03:01:52 zenogentoo [<c10ab407>] ? mmap_region+0x1bf/0x41a
> Jun 27 03:01:52 zenogentoo [<c10d13e5>] ? seq_read+0x0/0x3a5
> Jun 27 03:01:52 zenogentoo [<c10f1522>] ? proc_reg_read+0x57/0x78
> Jun 27 03:01:52 zenogentoo [<c10bb257>] ? vfs_read+0x8b/0x141
> Jun 27 03:01:52 zenogentoo [<c10f14cb>] ? proc_reg_read+0x0/0x78
> Jun 27 03:01:52 zenogentoo [<c10bb3b6>] ? sys_read+0x3d/0x6b
> Jun 27 03:01:52 zenogentoo [<c1021290>] ? sysenter_do_call+0x12/0x2c
> Jun 27 03:01:52 zenogentoo Code: 0b fc f6 50 0b fc f6 01 00 00 00 00
> 00 00 00 60 0b fc f6 60 0b fc f6 00 00 00 00 00 00 00 00 00 00 00 00
> 08 00 00 00 00 00 00 00 <ff> ff ff ff ff ff ff ff 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> Jun 27 03:01:52 zenogentoo EIP: [<f6fc0b7c>] 0xf6fc0b7c SS:ESP 0068:f2eb9efc
> Jun 27 03:01:52 zenogentoo ---[ end trace 1b3422263ead727b ]---

Jumped to nowhere.  For one thing, 0xf6fc0b7c is nowhere near the addresses
where the kernel code would live.  For another, the contents of memory at
that address doesn't look code (a lot of 0, a lot of 0xff *and* several
32bit values that look like addresses nearby (0xf6fc0b50, 0xf6fc0b60).
IOW, some data structures; hell knows what it might have been, but we
have seq_read() seeing m->op->start that points somewhere strange.

Again, memory corruption of some kind.  We have file->private_data that
might have been screwed up, or it might have been right pointer, but
the struct seq_file it points had been overwritten with some crap, or
that might have happened to the methods table ->op of that seq_file points
to...

Having looked at what seq_read() has compiled to in your kernel... what's
the value of ECX in that oops?  That's where m->op ends up and a look at
that sucker might at least narrow it down.

Said that, at this point I'd
	* run memtest, just to exclude the hardware crapping itself; nastier
coincidences happened
	* try bisecting, if oopsen are easy to trigger.
