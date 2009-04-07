Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZDGGQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZDGGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZDGGQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:16:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZDGGQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:16:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=VMYJ7I1VkQThpLhaG5k5CGNdZ2J+GCNbdcyPRsjSS+O+8HeEHhQCVfPT1g1VGg2ZhJ
         Uqx9xP5pOap8gYm+GQ/TjsrgNwalOHraUzXQClKaI3bpMcgR3sabeoAeyPfMwqQpaUF2
         3baGnCy5SLTRxbAfDF2JpEnQj2rHWPsTyihrY=
Date: Tue, 7 Apr 2009 08:16:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] ide-cd: reverse NOT_READY sense key logic
Message-ID: <20090407061633.GA4532@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238922962-19727-1-git-send-email-petkovbb@gmail.com> <200904062259.15556.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200904062259.15556.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 10:59:15PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 05 April 2009, Borislav Petkov wrote:
> > Make the case of flushing the drive's cache explicit.
> > 
> > There should be no functional change resulting from this patch.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-cd.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > index 2989aa8..2aa13d8 100644
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -341,15 +341,15 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
> >  
> >  	switch (sense_key) {
> >  	case NOT_READY:
> > -		if (blk_fs_request(rq) == 0 || rq_data_dir(rq) == READ) {
> > +		if (blk_fs_request(rq) && rq_data_dir(rq) == WRITE) {
> > +			if (ide_cd_breathe(drive, rq))
> > +				return 1;
> > +		} else {
> >  			cdrom_saw_media_change(drive);
> >  
> >  			if (blk_fs_request(rq) && !quiet)
> 
> Didn't we want to remove this blk_fs_request() while at it?

Originally I thought so too but I did some testing with booting with the cdrom
drive tray open and it did quite spam the logs:

[    2.395573] ide-cd driver 5.00
[    2.395888] khelper used greatest stack depth: 6612 bytes left
[    2.396742] ide-cd: hdc: ATAPI 40X DVD-ROM CD-R/RW drive, 2048kB Cache
[    2.396957] Uniform CD-ROM driver Revision: 3.20
[    2.397248] ide-cd: hdc: tray open
[    2.398805] ide-cd: hdc: tray open
[    2.399770] ide-cd: hdc: tray open
[    2.400650] 8139too Fast Ethernet driver 0.9.28
[    2.400718] 8139too 0000:03:0a.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.401393] eth0: RealTek RTL8139 at 0xe0806f00, 00:0c:6e:aa:a2:81, IRQ 17
[    2.401445] eth0:  Identified 8139 chip type 'RTL-8101'
[    2.401514] netconsole: local port 6665
[    2.401561] netconsole: local IP 192.168.45.26
[    2.401608] netconsole: interface eth0
[    2.401654] netconsole: remote port 6666
[    2.401700] netconsole: remote IP 192.168.45.14
[    2.401747] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    2.401796] netconsole: device eth0 not up yet, forcing it
[    2.401928] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[    2.402043] netconsole: carrier detect appears untrustworthy, waiting 4 seconds
[    6.406042] console [netcon0] enabled
[    6.435024] netconsole: network logging started
[    6.435077] usbmon: debugfs is not available
[    6.435245] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    6.438098] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.438158] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.438316] mice: PS/2 mouse device common for all mice
[    6.438547] cpuidle: using governor ladder
[    6.438609] cpuidle: using governor menu
[    6.438800] Advanced Linux Sound Architecture Driver Version 1.0.19.
[    6.439525] Yamaha DS-1 PCI 0000:03:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.440022] Yamaha DS-1 PCI 0000:03:07.0: firmware: using built-in firmware yamaha/ds1_dsp.fw
[    6.440093] Yamaha DS-1 PCI 0000:03:07.0: firmware: using built-in firmware yamaha/ds1_ctrl.fw
[    6.457531] input: AT Translated Set 2 keyboard as /class/input/input0
[    6.634147] ALSA device list:
[    6.634206]   #0: Yamaha DS-1 (YMF724) at 0xdfef8000, irq 16
[    6.634802] TCP cubic registered
[    6.634853] NET: Registered protocol family 17
[    6.634918] Using IPI No-Shortcut mode
[    7.253175] input: PS/2 Logitech Mouse as /class/input/input1
[    7.279277] register_blkdev: cannot get major 3 for hd
[    7.297104] kjournald starting.  Commit interval 5 seconds
[    7.297124] EXT3-fs: mounted filesystem with ordered data mode.
[    7.297146] VFS: Mounted root (ext3 filesystem) readonly on device 3:1.
[    7.297222] Freeing unused kernel memory: 240k freed
[    9.748854] mount used greatest stack depth: 6220 bytes left
[   10.823537] ide-cd: hdc: tray open
[   10.828431] ide-cd: hdc: tray open
[   10.829755] ide-cd: hdc: tray open
[   10.830731] ide-cd: hdc: tray open
[   10.837324] cdrom_id used greatest stack depth: 6200 bytes left
[   10.867196] ide-cd: hdc: tray open
[   10.876886] ide-cd: hdc: tray open
[   10.878511] ide-cd: hdc: tray open
[   10.879802] ide-cd: hdc: tray open
[   13.741320] Adding 976744k swap on /dev/hda2.  Priority:-1 extents:1 across:976744k

so maybe this was the reason for filtering out the pc requests - scream
only if it really matters. For example this is what happens when you
eject the drive while playing a dvd:

[  543.636691] mplayer used greatest stack depth: 5948 bytes left
[  652.373673] ide-cd: hdc: tray open
[  652.374723] end_request: I/O error, dev hdc, sector 23640
[  652.374735] Buffer I/O error on device hdc, logical block 2955
[  652.374747] Buffer I/O error on device hdc, logical block 2956
[  652.374756] Buffer I/O error on device hdc, logical block 2957
[  652.374762] Buffer I/O error on device hdc, logical block 2958
[  652.374828] Buffer I/O error on device hdc, logical block 2959
[  652.374835] Buffer I/O error on device hdc, logical block 2960
[  652.374842] Buffer I/O error on device hdc, logical block 2961
[  652.374905] Buffer I/O error on device hdc, logical block 2962
[  652.374912] Buffer I/O error on device hdc, logical block 2963
[  652.374919] Buffer I/O error on device hdc, logical block 2964
[  652.376255] ide-cd: hdc: tray open
[  652.377559] end_request: I/O error, dev hdc, sector 23896
[  652.378237] ide-cd: hdc: tray open
[  652.379527] end_request: I/O error, dev hdc, sector 23640
[  652.379865] ide-cd: hdc: tray open
[  652.380490] end_request: I/O error, dev hdc, sector 23640
[  652.380747] ide-cd: hdc: tray open
[  652.381492] end_request: I/O error, dev hdc, sector 23648
[  652.381749] ide-cd: hdc: tray open
[  652.382541] end_request: I/O error, dev hdc, sector 23648
...

The question now is: does it really matter to say something when all
those udev helpers and the SMART daemon try to query the device during
booting and it is NOT_READY? I'm tending towards a solution where we
don't say anything - after you close the tray you still get rescanned
together with receiving a bunch of udev events into the queue so I'm not
worried about those requests at all. The way it is done now is IMHO the
most reasonable solution wrt to verbosity based on error gravity. This
is why I left it in.

And since it is the original behavior I didn't add anything to the
commit messages but it probably could be a good idea the acknowledge
the existence of that blk_fs_request(rq) check there with a comment or
similar.

-- 
Regards/Gruss,
    Boris.
