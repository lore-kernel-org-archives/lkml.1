Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbYHIJY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbYHIJY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 05:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYHIJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 05:24:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:22650 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYHIJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 05:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AKTv5F4WbDNdlNYGZTv9yVEwnrnJCd359D25YOOYWx/b/f3ZrGzwsNTNFjEBGLjx2R
         WtSdNy36Q1Kvp4DJXPN48BvSf/6NPUZIhqkqRGH3exAbQhIE5zjHuqr3MEQyBuv5d2Vv
         xzpB/gJRHXR6IjqKDFJdoNZZmpaxsFwxfbAak=
Date: Sat, 9 Aug 2008 13:24:41 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, petero2@telia.com,
       jens.axboe@oracle.com
Subject: pktcdvd: BKL pushdown fallout (was Re: writable packet CD mounting
	in 2.6.26.x?)
Message-ID: <20080809092441.GA5111@martell.zuzino.mipt.ru>
References: <87ej52vtxq.fsf@hades.wkstn.nix> <20080808031437.GA14249@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808031437.GA14249@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 07:14:37AM +0400, Alexey Dobriyan wrote:
> On Wed, Aug 06, 2008 at 08:12:49PM +0100, Nix wrote:
> > It seems to be impossible to mount packet-written CD-RWs writably in
> > 2.6.26.x, even as root. Things worked in 2.6.25.x.
> > 
> > hades:/tmp# ls -l /dev/pktcdvd
> > total 0
> > brw-rw-rw- 1 root root  254,  0 2008-08-05 00:45 cdrw
> > crw-r--r-- 1 root root   10, 63 2008-08-05 00:44 control
> > brw-rw-rw- 1 root cdrom 254,  0 2008-08-05 00:45 pktcdvd0
> > 
> > 
> > hades:/tmp# mount -o rw /dev/pktcdvd/cdrw /mnt/pcdrw
> > mount: block device /dev/pktcdvd/cdrw is write-protected, mounting read-only
> > 
> > hades:/tmp# mount -o rw /dev/pktcdvd/pktcdvd0 /mnt/pcdrw
> > mount: block device /dev/pktcdvd/pktcdvd0 is write-protected, mounting read-only
> > 
> > The strace says that we get -EROFS always, now:
> > 
> > mount("/dev/pktcdvd/cdrw", "/mnt/pcdrw", "udf"..., MS_NOSUID|MS_NODEV|MS_NOEXEC|0x200000, NULL) = -1 EROFS (Read-only file system)
> > 
> > 
> > Anyone got any ideas? There are no suspicious-looking changes in
> > pktcdvd.c itself, so maybe this lies deeper in the block layer. Or
> > perhaps I'm mounting it wrong in some obscure way.
> 
> Reproduced. There must be some kick-ass code in pktcdvd driver. :^)
> 
> 
> # mount -t udf -o rw /dev/pktcdvd/0  tmp/
> mount: block device /dev/pktcdvd/0 is write-protected, mounting read-only
> 								^^^^^^^^^
> Segmentation fault
> 
> 
> Linux version 2.6.27-rc2 (ad@x200) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP PREEMPT Wed Aug 6 14:43:05 MSD 2008
> pktcdvd: writer pktcdvd0 mapped to sr0


> BUG: unable to handle kernel NULL pointer dereference at 0000000c

	file = NULL

> IP: [<f8b6d639>] :pktcdvd:pkt_ioctl+0x19/0xd0
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT SMP 
> Modules linked in: udf crc_itu_t isofs zlib_inflate pktcdvd usbhid fan sbp2 loop uvcvideo compat_ioctl32 videodev v4l1_compat pcmcia sr_mod cdrom snd_hda_intel snd_pcm tifm_7xx1 yenta_socket snd_timer tifm_core i2c_i801 psmouse ehci_hcd rsrc_nonstatic pcmcia_core snd ohci1394 uhci_hcd ata_piix soundcore serio_raw usbcore i2c_core ieee1394 r8169 snd_page_alloc battery ac thermal button evdev [last unloaded: pktcdvd]
> 
> Pid: 22816, comm: mount Tainted: G        W (2.6.27-rc2 #1)
> EIP: 0060:[<f8b6d639>] EFLAGS: 00210282 CPU: 0
> EIP is at pkt_ioctl+0x19/0xd0 [pktcdvd]
> EAX: 00000000 EBX: f8b6d620 ECX: c32dfda0 EDX: 00005310
> ESI: 00005310 EDI: 00000000 EBP: c32dfda0 ESP: c32dfc54
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process mount (pid: 22816, ti=c32df000 task=f70d6520 task.ti=c32df000)
> Stack: 0000ffff f8b6d620 f73cf400 00000000 f7420aec c01d147f 00000001 f7420a80 
>        fffffdfd 00005310 f7420aec c01d17cf 00005310 c32dfda0 c32dfcb4 010e2000 
>        00010101 00000000 00000000 f73cf400 ffffffff ffff00bb 0000ffff 00000000 
> Call Trace:
>  [<f8b6d620>] pkt_ioctl+0x0/0xd0 [pktcdvd]
>  [<c01d147f>] blkdev_driver_ioctl+0x2f/0x80
>  [<c01d17cf>] blkdev_ioctl+0x2ff/0x830
>  [<c0196f05>] set_blocksize+0x85/0x90
>  [<f8b70979>] pkt_open+0x59/0x4e0 [pktcdvd]
>  [<c01d2267>] exact_lock+0x7/0x10
>  [<c022edb8>] kobj_lookup+0x158/0x170
>  [<c01dc563>] string+0x23/0xa0
>  [<c01dca3b>] vsnprintf+0x45b/0x5e0
>  [<c01db519>] strsep+0x19/0x30
>  [<f8bb551c>] udf_parse_options+0x6c/0x2f0 [udf]
>  [<c0197d3e>] ioctl_by_bdev+0x2e/0x50
>  [<f8bb1dea>] udf_get_last_session+0x1a/0x40 [udf]
>  [<f8bb7c19>] udf_fill_super+0x849/0x910 [udf]
>  [<c01a97fe>] disk_name+0x3e/0xc0
>  [<c0173511>] get_sb_bdev+0x101/0x130
>  [<c0157dac>] kstrdup+0x3c/0x70
>  [<f8bb5441>] udf_get_sb+0x21/0x30 [udf]
>  [<f8bb73d0>] udf_fill_super+0x0/0x910 [udf]
>  [<c0173063>] vfs_kern_mount+0x43/0x90
>  [<c017310d>] do_kern_mount+0x3d/0xe0
>  [<c0188de1>] do_new_mount+0x81/0xc0
>  [<c0188f97>] do_mount+0x177/0x1d0
>  [<c0186c33>] copy_mount_options+0x43/0x150
>  [<c0179933>] getname+0xb3/0xe0
>  [<c0189067>] sys_mount+0x77/0xc0

Not suprisingly, indeed.

	udf_get_last_session
	ioctl_by_bdev(bdev, CDROMMULTISESSION,
	ioctl with file = NULL

pkt_ioctl is ->unlocked_ioctl, so can't tolerate NULL file.

Introduced in 5b6155ee70e9c4d2ad7e6f514c8eee06e2711c3a aka BKL pushdown.

