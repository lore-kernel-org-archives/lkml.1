Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbYGOSJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbYGOSJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbYGOSJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:09:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbYGOSJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:09:45 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied
	from	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rene.herman@keyaccess.nl, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <200807151853.01143.oliver@neukum.org>
References: <487C0A12.9060906@keyaccess.nl>
	 <200807150823.35628.oliver@neukum.org>
	 <1216132854.27455.247.camel@shinybook.infradead.org>
	 <200807151853.01143.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 11:09:28 -0700
Message-Id: <1216145368.27455.318.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:52 +0200, Oliver Neukum wrote:
> Am Dienstag 15 Juli 2008 16:40:54 schrieb David Woodhouse:
> > On Tue, 2008-07-15 at 08:23 +0200, Oliver Neukum wrote:
> > > Am Dienstag 15 Juli 2008 08:03:15 schrieb David Woodhouse:
> > > > Mostly it follows the documented recommendation, since most of the
> > > > touched drivers are USB drivers and you end up re-enumerating and
> > > > starting from scratch on resume anyway. And the remainder are so old
> > > > that they don't have suspend/resume support anyway. Remember, we're only
> > > > really updating the older drivers; newer drivers tend to use
> > > > request_firmware() already, and have done for years.
> > > 
> > > As for USB that was before persistance. It now allows you to even
> > > support a loss of power without reprobing, provided
> > > 
> > > a) the devices does not change IDs
> > > b) you have firmware around when reset_resume() is called
> > 
> > c) the driver in question actually _has_ a reset_resume() method
> > 
> > The old, unloved drivers which I've touched as part of this patch set
> > did not. In general the newer, loved drivers use request_firmware()
> > already.
> > 
> 
> Generally we love all drivers and welcome new additions.
> Which did you touch? I lost track.

Ignoring the simple bits to make fw->data const? See
http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=shortlog&h=d71792ac
or    git-diff --stat 59890f74..d71792ac | grep -v firmware/

21 drivers, mostly older USB drivers and including four sound drivers
which were already using request_firmware() optionally. The HEAD of my
tree contains a few more updates in drivers/scsi and drivers/net, but
out of respect for Dave's and Jeff's objections I left those out of the
pull request for now. Hopefully the noise will die down when the sky
doesn't _actually_ fall on our heads, and we can merge the remaining
changes into 2.6.28.

 drivers/atm/Makefile                               |    6 +-
 drivers/atm/ambassador.c                           |  140 +-
 drivers/atm/ambassador.h                           |   11 -
 drivers/atm/atmsar11.data                          | 2063 -----
 drivers/atm/atmsar11.regions                       |    6 -
 drivers/atm/atmsar11.start                         |    4 -
 drivers/char/dsp56k.c                              |   84 +-
 drivers/char/ip2/fip_firm.h                        | 2149 -----
 drivers/char/ip2/ip2base.c                         |    5 +-
 drivers/char/ip2/ip2main.c                         |   47 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c  |   16 +-
 .../media/dvb/ttusb-budget/dvb-ttusb-dspbootcode.h | 1644 ----
 drivers/media/video/cpia2/cpia2_core.c             |   46 +-
 drivers/media/video/cpia2/cpia2patch.h             |  233 -
 drivers/media/video/dabfirmware.h                  | 1415 ----
 drivers/media/video/dabusb.c                       |   44 +-
 drivers/media/video/usbvideo/vicam.c               |  317 +-
 drivers/net/tokenring/smctr.c                      |   56 +-
 drivers/net/tokenring/smctr.h                      |    2 -
 drivers/net/tokenring/smctr_firmware.h             |  978 ---
 drivers/net/usb/kaweth.c                           |   43 +-
 drivers/net/usb/kawethfw.h                         |  557 --
 drivers/usb/misc/emi26.c                           |   96 +-
 drivers/usb/misc/emi26_fw.h                        | 5779 -------------
 drivers/usb/misc/emi62.c                           |  130 +-
 drivers/usb/misc/emi62_fw_m.h                      | 8853 --------------------
 drivers/usb/misc/emi62_fw_s.h                      | 8837 -------------------
 drivers/usb/serial/Kconfig                         |   24 +-
 drivers/usb/serial/io_edgeport.c                   |  183 +-
 drivers/usb/serial/io_fw_boot.h                    |  556 --
 drivers/usb/serial/io_fw_boot2.h                   |  546 --
 drivers/usb/serial/io_fw_down.h                    | 1229 ---
 drivers/usb/serial/io_fw_down2.h                   | 1133 ---
 drivers/usb/serial/io_fw_down3.h                   |  847 --
 drivers/usb/serial/io_ti.c                         |   73 +-
 drivers/usb/serial/keyspan.c                       |   78 +-
 drivers/usb/serial/keyspan.h                       |   84 -
 drivers/usb/serial/keyspan_mpr_fw.h                |  286 -
 drivers/usb/serial/keyspan_pda.S                   | 1124 ---
 drivers/usb/serial/keyspan_pda.c                   |   51 +-
 drivers/usb/serial/keyspan_pda_fw.h                |   99 -
 drivers/usb/serial/keyspan_usa18x_fw.h             |  447 -
 drivers/usb/serial/keyspan_usa19_fw.h              |  285 -
 drivers/usb/serial/keyspan_usa19qi_fw.h            |  284 -
 drivers/usb/serial/keyspan_usa19qw_fw.h            |  448 -
 drivers/usb/serial/keyspan_usa19w_fw.h             |  446 -
 drivers/usb/serial/keyspan_usa28_fw.h              |  466 -
 drivers/usb/serial/keyspan_usa28x_fw.h             |  447 -
 drivers/usb/serial/keyspan_usa28xa_fw.h            |  449 -
 drivers/usb/serial/keyspan_usa28xb_fw.h            |  448 -
 drivers/usb/serial/keyspan_usa49w_fw.h             |  464 -
 drivers/usb/serial/keyspan_usa49wlc_fw.h           |  476 --
 drivers/usb/serial/ti_fw_3410.h                    |  885 --
 drivers/usb/serial/ti_fw_5052.h                    |  885 --
 drivers/usb/serial/ti_usb_3410_5052.c              |   40 +-
 drivers/usb/serial/whiteheat.c                     |   77 +-
 drivers/usb/serial/whiteheat_fw.h                  | 1669 ----
 drivers/usb/serial/xircom_pgs.S                    | 1192 ---
 drivers/usb/serial/xircom_pgs_fw.h                 |  103 -
 sound/isa/Kconfig                                  |    9 -
 sound/isa/sb/sb16_csp.c                            |   22 -
 sound/isa/sb/sb16_csp_codecs.h                     |  949 ---
 sound/pci/Kconfig                                  |   30 -
 sound/pci/korg1212/korg1212-firmware.h             |  987 ---
 sound/pci/korg1212/korg1212.c                      |   18 -
 sound/pci/maestro3.c                               |  171 -
 sound/pci/ymfpci/ymfpci_image.h                    | 1565 ----
 sound/pci/ymfpci/ymfpci_main.c                     |   63 -

-- 
dwmw2

