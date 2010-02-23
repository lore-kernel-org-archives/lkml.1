Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0BWHYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:24:01 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:38861 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0BWHX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D8Rrrg6cRyxU1qsgDimMxVfSpJiI95yXVFO080Elcv9B9iOYBT5eSFrZ5PWd0YoMrx
         6dxIab+r8g91iJTJ8Y4l1zEvPehmaz/nTLQmOfLiqKZHXftB2s3nn9eF6xMWXi1mLgFt
         vmCJw3MnX43IoWKgu6DpHsSdPct6zkEi2aQOw=
Subject: Re: [PATCH 10/15] MTD: nand: make reads using MTD_OOB_RAW affect
 only ECC validation
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       stanley.miao@windriver.com, Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1266874466.4971.10.camel@maxim-laptop>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
	 <1266863982-5258-11-git-send-email-maximlevitsky@gmail.com>
	 <alpine.LFD.2.00.1002222219430.4136@localhost.localdomain>
	 <1266874087.4971.4.camel@maxim-laptop>
	 <alpine.LFD.2.00.1002222229091.4136@localhost.localdomain>
	 <1266874466.4971.10.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 09:23:54 +0200
Message-ID: <1266909834.4613.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 23:34 +0200, Maxim Levitsky wrote: 
> On Mon, 2010-02-22 at 22:29 +0100, Thomas Gleixner wrote: 
> > On Mon, 22 Feb 2010, Maxim Levitsky wrote:
> > > On Mon, 2010-02-22 at 22:20 +0100, Thomas Gleixner wrote: 
> > > > On Mon, 22 Feb 2010, Maxim Levitsky wrote:
> > > > 
> > > > > This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
> > > > > to the data buffer, however you would still need to specify the dummy oob buffer.
> > > > > 
> > > > > This is only used in one place, but makes it hard to read data+oob without ECC
> > > > > test, thus I removed that behavier, and fixed the user.
> > > > > 
> > > > > Now MTD_OOB_RAW behaves just like MTD_OOB_PLACE, but doesn't do ECC validation
> > > > 
> > > > Is this tested against existing user space tools like nanddump ? Can I
> > > > still get the raw data from flash ?
> > > 
> > > Thats the point.
> > > Userspace doesn't/can't use that mode.
> > > It is not exposed through mtdchar.
> > > Userspace reads the page, and then reads the oob.
> > > 
> > > It does use MTD_OOB_RAW, but without data buffer, and this path I don't
> > > change.
> > > 
> > > The only user of this, is the nand itself, when it reads bad block
> > > table.
> > > 
> > > I confess that I didn't run test that I ported this code correctly.
> > > But I did logically verified many times that the new code works just
> > > like old one.
Note that only this patch is in question, and only . Rest are tested
with my driver, 

While doing some testing, I tried to use ubi, but it appears to try 256
byte writes (subpage write I guess), and it fails _without_ my patches:


[  723.478676] UBI: attached mtd0 to ubi0
[  723.478686] UBI: MTD device name:            "NAND simulator partition 0"
[  723.478701] UBI: MTD device size:            8 MiB
[  723.478711] UBI: number of good PEBs:        1024
[  723.478720] UBI: number of bad PEBs:         0
[  723.478730] UBI: max. allowed volumes:       44
[  723.478739] UBI: wear-leveling threshold:    4096
[  723.478749] UBI: number of internal volumes: 1
[  723.478758] UBI: number of user volumes:     0
[  723.478767] UBI: available PEBs:             1010
[  723.478777] UBI: total number of reserved PEBs: 14
[  723.478787] UBI: number of PEBs reserved for bad PEB handling: 10
[  723.478800] UBI: max/mean erase counter: 0/0
[  723.478809] UBI: image sequence number: 0
[  723.480508] UBI: background thread "ubi_bgt0d" started, PID 4556
[  757.904206] UBI DBG (pid 4580): ubi_cdev_ioctl: create volume
[  757.904231] UBI DBG (pid 4580): ubi_create_volume: search for vacant volume ID
[  757.904246] UBI DBG (pid 4580): ubi_create_volume: create device 0, volume 0, 7756800 bytes, type 3, name aaa
[  757.906376] UBI error: ubi_io_write: error -5 while writing 256 bytes to PEB 0:256, written 0 bytes
[  757.906398] Pid: 4580, comm: ubimkvol Tainted: P           2.6.33-rc8-wl #25
[  757.906412] Call Trace:
[  757.906431]  [<ffffffffa0d8b1f2>] ubi_io_write+0x252/0x270 [ubi]
[  757.906447]  [<ffffffffa0d8b283>] ubi_io_write_vid_hdr+0x73/0x190 [ubi]
[  757.906464]  [<ffffffffa0d89f58>] ubi_eba_write_leb+0x198/0x7b0 [ubi]
[  757.906481]  [<ffffffff81350c90>] ? _raw_spin_unlock+0x30/0x60
[  757.906497]  [<ffffffffa0d892b1>] ? leb_write_unlock+0xa1/0xf0 [ubi]
[  757.906515]  [<ffffffffa0d82483>] ubi_change_vtbl_record+0x103/0x1c0 [ubi]
[  757.906534]  [<ffffffff81234474>] ? device_create_file+0x14/0x20
[  757.906552]  [<ffffffffa0d837ee>] ubi_create_volume+0x4ce/0x710 [ubi]
[  757.906569]  [<ffffffff8103418b>] ? release_console_sem+0x1eb/0x240
[  757.906586]  [<ffffffffa0d86589>] ubi_cdev_ioctl+0x2e9/0xb50 [ubi]
[  757.906603]  [<ffffffff810bf399>] ? __dentry_open+0x149/0x330
[  757.906619]  [<ffffffff810d0658>] vfs_ioctl+0x38/0xd0
[  757.906632]  [<ffffffff810d082a>] do_vfs_ioctl+0x8a/0x5b0
[  757.906645]  [<ffffffff8105e69d>] ? trace_hardirqs_on+0xd/0x10
[  757.906658]  [<ffffffff810d0d9a>] sys_ioctl+0x4a/0x80
[  757.906672]  [<ffffffff81002cab>] system_call_fastpath+0x16/0x1b
[  757.906753] UBI DBG (pid 4580): ubi_dbg_dump_flash: dumping 256 bytes of data from PEB 0, offset 256
[  757.906772] 00000000: 55 42 49 21 01 01 00 05 7f ff ef ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  UBI!............................
[  757.906797] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 65 b3 bd 2d  ............................e..-
[  757.906821] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.906846] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.906874] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.906898] 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.906920] 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.906943] 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.906977] UBI warning: ubi_eba_write_leb: failed to write VID header to LEB 2147479551:0, PEB 0
[  757.907016] UBI: run torture test for PEB 0
[  757.908132] UBI: PEB 0 passed torture test, do not mark it a bad
[  757.908211] UBI: try another PEB
[  757.908227] UBI error: ubi_io_write: error -5 while writing 256 bytes to PEB 0:256, written 0 bytes
[  757.908243] Pid: 4580, comm: ubimkvol Tainted: P           2.6.33-rc8-wl #25
[  757.908256] Call Trace:
[  757.908268]  [<ffffffffa0d8b1f2>] ubi_io_write+0x252/0x270 [ubi]
[  757.908284]  [<ffffffffa0d8b283>] ubi_io_write_vid_hdr+0x73/0x190 [ubi]
[  757.908300]  [<ffffffffa0d89f58>] ubi_eba_write_leb+0x198/0x7b0 [ubi]
[  757.908314]  [<ffffffff81350c90>] ? _raw_spin_unlock+0x30/0x60
[  757.908329]  [<ffffffffa0d892b1>] ? leb_write_unlock+0xa1/0xf0 [ubi]
[  757.908345]  [<ffffffffa0d82483>] ubi_change_vtbl_record+0x103/0x1c0 [ubi]
[  757.908359]  [<ffffffff81234474>] ? device_create_file+0x14/0x20
[  757.908374]  [<ffffffffa0d837ee>] ubi_create_volume+0x4ce/0x710 [ubi]
[  757.908388]  [<ffffffff8103418b>] ? release_console_sem+0x1eb/0x240
[  757.908404]  [<ffffffffa0d86589>] ubi_cdev_ioctl+0x2e9/0xb50 [ubi]
[  757.908418]  [<ffffffff810bf399>] ? __dentry_open+0x149/0x330
[  757.908431]  [<ffffffff810d0658>] vfs_ioctl+0x38/0xd0
[  757.908443]  [<ffffffff810d082a>] do_vfs_ioctl+0x8a/0x5b0
[  757.908455]  [<ffffffff8105e69d>] ? trace_hardirqs_on+0xd/0x10
[  757.908467]  [<ffffffff810d0d9a>] sys_ioctl+0x4a/0x80
[  757.908479]  [<ffffffff81002cab>] system_call_fastpath+0x16/0x1b
[  757.908543] UBI DBG (pid 4580): ubi_dbg_dump_flash: dumping 256 bytes of data from PEB 0, offset 256
[  757.908560] 00000000: 55 42 49 21 01 01 00 05 7f ff ef ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  UBI!............................
[  757.908582] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 d8 79 d1 e3  .............................y..
[  757.908605] 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.908628] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.908650] 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.908673] 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.908695] 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.908718] 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................................
[  757.908752] UBI warning: ubi_eba_write_leb: failed to write VID header to LEB 2147479551:0, PEB 0
[  757.908788] UBI: run torture test for PEB 0
[  757.909892] UBI: PEB 0 passed torture test, do not mark it a bad
[  757.909971] UBI: try another PEB
[  757.909987] UBI error: ubi_io_write: error -5 while writing 256 bytes to PEB 0:256, written 0 bytes
[  757.910214] Pid: 4580, comm: ubimkvol Tainted: P           2.6.33-rc8-wl #25



What I did so far:


sudo modprobe nandsim
sudo modprobe ubi
sudo ubiformat /dev/mtd0
sudo ubiattach /dev/ubi_ctrl -m0 -d 0
sudo ubimkvol -m -N test /dev/ubi0



Then I suppose I can mount /dev/ubi0 with ubifs, right?
(If there were no errors of course)


Best regards,
Maxim Levitsky

