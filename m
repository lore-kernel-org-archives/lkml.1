Return-Path: <linux-kernel-owner+w=401wt.eu-S1765457AbYAaHvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765457AbYAaHvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYAaHux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:50:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:58504 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbYAaHus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:50:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C+LXchz/VzIs/xyVKDBHuaSNsCcWfW2F/ACUbOCU2upMRhHnZWVdUUqg/yZVRm1GZYYVRr9igJQLtstrzBdX+uVX5dHyQINc/gUvKZgBaDerFHEb/EpJH8/lBlZLS42vFzed7wB+5MYWpuqJGvaeik5xz52uuO1DN117rKb1eYQ=
Message-ID: <ab418ea90801302349u945788jeed1f42021801dbf@mail.gmail.com>
Date: Thu, 31 Jan 2008 15:49:47 +0800
From: "Nai Xia" <nai.xia@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: kernel BUG at ide-cd.c:1726 in 2.6.24-03863-g0ba6c33 && -g8561b089
Cc: "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       bbpetkov@yahoo.de, flo@rfc822.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, j-nomura@ce.jp.nec.com,
       linux-ide@vger.kernel.org
In-Reply-To: <adamyqmafl3.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129.151353.48534987.k-ueda@ct.jp.nec.com>
	 <adar6g0e0g2.fsf@cisco.com>
	 <20080129.182356.70224412.k-ueda@ct.jp.nec.com>
	 <20080130.202659.104027826.k-ueda@ct.jp.nec.com>
	 <adamyqmafl3.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My dmesg relevant info is quite similar:

[    6.875041] Freeing unused kernel memory: 320k freed
[    8.143120] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
[    8.144439]
[    8.144439] sector 10824201199534213, nr/cnr 0/0
[    8.144439] bio cf029280, biotail cf029280, buffer 00000000, data
00000000, len 158
[    8.144439] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    8.144439] backup: data_len=158  bi_size=158
[    8.160756] ide-cd: rq still having bio: dev hdc: type=2, flags=114c8
[    8.160756]
[    8.160756] sector 2669858, nr/cnr 0/0
[    8.160756] bio cf029300, biotail cf029300, buffer 00000000, data
00000000, len 158
[    8.160756] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
[    8.160756] backup: data_len=158  bi_size=158
[   14.851101] eth0: link up
[   27.121883] eth0: no IPv6 routers present


And by the way, Kiyoshi,
This can be reproduced in a typical setup vmware workstation 6.02 with
a vritual IDE cdrom,
in case you wanna catch that with your own eyes. :-)
Thanks for your trying hard to correct this annoying bug.

Best Regards,

Nai


On 1/31/08, Roland Dreier <rdreier@cisco.com> wrote:
> > Could you try the patch below and give me all boot messages again?
>
> Sure, no problem, see below for full log (I updated to the latest git,
> which seems to have some other unrelated problems with things timing
> out earlier in the boot, but it does get to the ide-cd init); here's
> the relevant looking debug info:
>
>     [  163.990058] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
>     [  163.990060]
>     [  163.990061] sector 1987647, nr/cnr 0/0
>     [  163.990063] bio ffff8101c418c200, biotail ffff8101c418c200, buffer
> 0000000000000000, data 0000000000000000, len 158
>     [  163.990064] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
>     [  163.990069] backup: data_len=158  bi_size=158
>     [  163.994021] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
>     [  163.994023]
>     [  163.994024] sector 1987647, nr/cnr 0/0
>     [  163.994025] bio ffff8101c418c200, biotail ffff8101c418c200, buffer
> 0000000000000000, data 0000000000000000, len 158
>     [  163.994027] cdb: 12 01 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
>     [  163.994032] backup: data_len=158  bi_size=158
>
>  > This patch displays debug messages against requests still having bio,
>  > then tries to unlink all bios from the rq before the rq is completed.
>  > So your system may be able to continue to work correctly
>  > after displaying debug messages.
>
> By the way, even with your first debug patch, I had no problem using
> the box once it booted.  I didn't try the CD-ROM but everything else
> seemed fine.
>
> Also, I saw the same issue on a different box (Dell SC1435 with
> serverworks IDE):
>
>     [    1.367648] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
>     [    1.371649] ide: Assuming 33MHz system bus speed for PIO modes;
> override with idebus=xx
>     [    2.612417] SvrWks HT1000: IDE controller (0x1166:0x0214 rev 0x00) at
>  PCI slot 0000:00:02.1
>     [    2.612439] SvrWks HT1000: not 100% native mode: will probe irqs
> later
>     [    2.616427]     ide0: BM-DMA at 0x08c0-0x08c7, BIOS settings:
> hda:DMA, hdb:pio
>     [    2.623505] Probing IDE interface ide0...
>     [    4.037070] hda: PHILIPS DVD-ROM SDR089, ATAPI CD/DVD-ROM drive
>     [    4.041801] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
>     [    4.058447] hda: UDMA/33 mode selected
>     [    4.061278] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>     [    4.632739] hda: ATAPI 24X DVD-ROM drive, 2048kB Cache
>     ...
>     [    8.631615] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
>     [    8.631615]
>     [    8.631615] sector 2867855, nr/cnr 0/0
>     [    8.631615] bio ffff81021fba3f40, biotail ffff81021fba3f40, buffer
> 0000000000000000, data 0000000000000000, len 158
>     [    8.631615] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
>     [    8.660505] ide-cd: rq still having bio: dev hda: type=2, flags=114c8
>     [    8.660505]
>     [    8.660505] sector 2867855, nr/cnr 0/0
>     [    8.660505] bio ffff81021fba3f40, biotail ffff81021fba3f40, buffer
> 0000000000000000, data 0000000000000000, len 62
>     [    8.660505] cdb: 12 00 00 00 fe 00 00 00 00 00 00 00 00 00 00 00
>
> Let me know if you'd like debug info from that too.
>
>
