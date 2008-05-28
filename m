Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYE1W36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYE1W36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYE1W3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:29:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbYE1W3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:29:50 -0400
Date: Wed, 28 May 2008 15:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux@rainbow-software.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, pavel@ucw.cz
Subject: Re: Oops during hibernation - two times the same one
Message-Id: <20080528152919.a5f264cd.akpm@linux-foundation.org>
In-Reply-To: <200805290009.37281.rjw@sisk.pl>
References: <200805282323.20679.linux@rainbow-software.org>
	<200805290009.37281.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 00:09:36 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, 28 of May 2008, Ondrej Zary wrote:
> > Hello,
> > I'm using hibernation on my desktop machine every day instead of power off. It 
> > mostly works but sometimes aborts with "no space left on device" error. 
> > Closing some programs and trying again usually fixes it - but recently, I got 
> > two oopses instead. I'm sending them because they're the same, only some 
> > details are different. Does anyone know what might be wrong?
> 
> Thanks for the report, but I have no idea of what could go wrong.
> 
> Rafael
> 
>  
> > ------------[ cut here ]------------
> > Kernel BUG at c015610b [verbose debug info unavailable]

Looks like this is

	BUG_ON(inode->i_state == I_CLEAR);

Please do enable CONFIG_DEBUG_BUGVERBOSE.  Turning off this stuff
doesn't gain much.

> > invalid opcode: 0000 [#1]
> > Modules linked in: snd_sb16 ppdev snd_opl3_synth snd_seq_midi_emul 
> > snd_opl3_lib snd_hwdep snd_sb16_dsp snd_sb_common snd_mpu401_uart snd_rawmidi 
> > 3c509 de2104x sr_mod cdrom [last unloaded: snd_sb16]
> > 
> > Pid: 8634, comm: bash Not tainted (2.6.25.3-pentium #3)
> > EIP: 0060:[<c015610b>] EFLAGS: 00210246 CPU: 0
> > EIP is at iput+0x19/0x61
> > EAX: c02db808 EBX: cf402c08 ECX: 0001ec9e EDX: 00000000
> > ESI: cf402ba0 EDI: cf987c00 EBP: 00000000 ESP: c9a4deb4
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process bash (pid: 8634, ti=c9a4c000 task=c3975000 task.ti=c9a4c000)
> > Stack: 00000000 c0163eb5 cf402bac ffffffe4 c142b000 c0329881 cf80b6a0 c012e212
> >        00000001 c38de7ac 00200286 00001000 00000000 00000001 00000000 00000000
> >        c142b000 00000000 00000000 0001ec82 0001ec82 00200246 0001ec82 fffffa5d
> > Call Trace:
> >  [<c0163eb5>] __blkdev_put+0xc2/0xda
> >  [<c012e212>] swsusp_write+0x307/0x311
> >  [<c012c81b>] hibernate+0xb4/0x131
> >  [<c012b9ad>] state_store+0x41/0xa3
> >  [<c012b96c>] state_store+0x0/0xa3
> >  [<c01babcb>] kobj_attr_store+0x18/0x1c
> >  [<c0173dd0>] sysfs_write_file+0xab/0xd8
> >  [<c0173d25>] sysfs_write_file+0x0/0xd8
> >  [<c0148a58>] vfs_write+0x7f/0xec
> >  [<c0148e9c>] sys_write+0x3c/0x63
> >  [<c01039d2>] syscall_call+0x7/0xb
> >  [<c02d0000>] i8042_probe+0x4c4/0x4db
> >  =======================
> > Code: 08 01 00 00 77 ff ff ff eb e5 e8 90 ad 17 00 31 c0 c3 53 85 c0 89 c3 74 
> > 58 8b 80 8c 00 00 00 83 bb 08 01 00 00 40 8b 40 20 75 04 <0f> 0b eb fe 85 c0 
> > 74 0b 8b 50 10 85 d2 74 04 89 d8 ff d2 8d 43
> > EIP: [<c015610b>] iput+0x19/0x61 SS:ESP 0068:c9a4deb4

Beats me.  Somehow the swap device's blockdev inode got I_CLEAR set
while swsusp_write() was playing with it.  Or during.

I guess we could add I_CLEAR checks on resume_bdev into
kernel/power/swap.c in various places.

Had there been any swapoffs before or during this suspend?

Does the above BUG only occur when swsusp encountered an out-of-space
error?  If so, perhaps something has gone wrong on the error-handling
path, but I didn't spot it.
