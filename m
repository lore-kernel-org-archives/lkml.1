Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZJMMlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZJMMlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZJMMlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:41:31 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45213 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbZJMMl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:41:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=hjEWt+oIT4dxx68LxFyuOuJbEUrt5RNj3djcq1o4eZxHkpT+cxyBWpXfy/dsWf4rX7
         CjDA1pzYCGkGXEZnMRvnyjMfl1Er3NGRefZunyo5sWpUyqbNrzYr6ywdHylfnj9r3nnM
         F/93a2DbbtUZGvUoJN/f7svMQSW/rmd26iyoY=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 11/28] nvram: Drop the bkl from nvram_llseek()
Date: Tue, 13 Oct 2009 14:40:45 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "Sven-Thorsten Dietrich" <sven@thebigcorporation.com>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
References: <20091010153314.827301943@linutronix.de> <200910112350.24870.arnd@arndb.de> <20091011221448.GA8146@nowhere>
In-Reply-To: <20091011221448.GA8146@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910131440.45623.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Frederic Weisbecker wrote:
> On Sun, Oct 11, 2009 at 11:50:24PM +0200, Arnd Bergmann wrote:
> >
> > There are various *_operations structures that have a .ioctl pointer.
> > While there are a lot of struct file_operations with a locked .ioctl
> > operation, stuff like block_device_operations does not hold the
> > BKL in .ioctl but in .locked_ioctl.
> 
> Oh right. Thanks for the tip.
> 

FWIW, I've done a grep through the current source tree, this should be
the full list of all .ioctl methods in struct file_operations, a total
of 141 instances in 2.6.32-rc4.

When we do a pushdown of the BKL into these functions, we can kill off
the file operation.

	Arnd <><

arch/blackfin/mach-bf561/coreb.c:	.ioctl   = coreb_ioctl,
arch/cris/arch-v10/drivers/ds1302.c:	.ioctl =	rtc_ioctl,
arch/cris/arch-v10/drivers/gpio.c:	.ioctl       = gpio_ioctl,
arch/cris/arch-v10/drivers/i2c.c:	.ioctl    = i2c_ioctl,
arch/cris/arch-v10/drivers/pcf8563.c:	.ioctl = pcf8563_ioctl,
arch/cris/arch-v10/drivers/sync_serial.c:	.ioctl   = sync_serial_ioctl,
arch/cris/arch-v32/drivers/cryptocop.c:	.ioctl =	cryptocop_ioctl
arch/cris/arch-v32/drivers/i2c.c:	.ioctl =    i2c_ioctl,
arch/cris/arch-v32/drivers/mach-a3/gpio.c:	.ioctl       = gpio_ioctl,
arch/cris/arch-v32/drivers/mach-fs/gpio.c:	.ioctl       = gpio_ioctl,
arch/cris/arch-v32/drivers/pcf8563.c:	.ioctl =	pcf8563_ioctl
arch/cris/arch-v32/drivers/sync_serial.c:	.ioctl   = sync_serial_ioctl,
arch/ia64/kernel/perfmon.c:	.ioctl    = pfm_ioctl,
arch/ia64/sn/kernel/sn2/sn_hwperf.c:	.ioctl = sn_hwperf_ioctl,
arch/m68k/bvme6000/rtc.c:	.ioctl =	rtc_ioctl,
arch/m68k/mvme16x/rtc.c:	.ioctl =	rtc_ioctl,
arch/powerpc/kernel/nvram_64.c:	.ioctl =	dev_nvram_ioctl,
arch/sh/boards/mach-landisk/gio.c:      .ioctl = gio_ioctl,     /* ioctl */
arch/um/drivers/harddog_kern.c:	.ioctl		= harddog_ioctl,
arch/um/drivers/hostaudio_kern.c:	.ioctl          = hostaudio_ioctl,
arch/um/drivers/mmapper_kern.c:	.ioctl		= mmapper_ioctl,
drivers/block/pktcdvd.c:	.ioctl	 = pkt_ctl_ioctl,
drivers/bluetooth/hci_vhci.c:	.ioctl		= vhci_ioctl,
drivers/char/apm-emulation.c:	.ioctl		= apm_ioctl,
drivers/char/applicom.c:	.ioctl = ac_ioctl,
drivers/char/ds1620.c:	.ioctl		= ds1620_ioctl,
drivers/char/dtlk.c:	.ioctl		= dtlk_ioctl,
drivers/char/nvram.c:	.ioctl		= nvram_ioctl,
drivers/char/generic_nvram.c:	.ioctl		= nvram_ioctl,
drivers/char/genrtc.c:	.ioctl		= gen_rtc_ioctl,
drivers/char/hpet.c:	.ioctl = hpet_ioctl,
drivers/char/i8k.c:	.ioctl		= i8k_ioctl,
drivers/char/ipmi/ipmi_devintf.c:	.ioctl		= ipmi_ioctl,
drivers/char/ipmi/ipmi_watchdog.c:	.ioctl   = ipmi_ioctl,
drivers/char/istallion.c:	.ioctl		= stli_memioctl,
drivers/char/lp.c:	.ioctl		= lp_ioctl,
drivers/char/nwflash.c:	.ioctl		= flash_ioctl,
drivers/char/raw.c:	.ioctl	=	raw_ioctl,
drivers/char/sonypi.c:	.ioctl		= sonypi_misc_ioctl,
drivers/char/stallion.c:	.ioctl		= stl_memioctl,
drivers/char/toshiba.c:	.ioctl		= tosh_ioctl,
drivers/gpu/drm/i810/i810_dma.c:	.ioctl = drm_ioctl,
drivers/gpu/drm/i810/i810_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/i830/i830_dma.c:	.ioctl = drm_ioctl,
drivers/gpu/drm/i830/i830_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/i915/i915_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/mga/mga_drv.c:		.ioctl = drm_ioctl,
drivers/gpu/drm/r128/r128_drv.c:		.ioctl = drm_ioctl,
drivers/gpu/drm/radeon/radeon_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/radeon/radeon_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/savage/savage_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/sis/sis_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/tdfx/tdfx_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/via/via_drv.c:		.ioctl = drm_ioctl,
drivers/gpu/drm/i810/i810_dma.c:	.ioctl = drm_ioctl,
drivers/gpu/drm/i810/i810_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/i830/i830_dma.c:	.ioctl = drm_ioctl,
drivers/gpu/drm/i830/i830_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/i915/i915_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/mga/mga_drv.c:		.ioctl = drm_ioctl,
drivers/gpu/drm/r128/r128_drv.c:		.ioctl = drm_ioctl,
drivers/gpu/drm/radeon/radeon_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/radeon/radeon_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/savage/savage_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/sis/sis_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/tdfx/tdfx_drv.c:		 .ioctl = drm_ioctl,
drivers/gpu/drm/via/via_drv.c:		.ioctl = drm_ioctl,
drivers/hwmon/fschmd.c:	.ioctl = watchdog_ioctl,
drivers/ide/ide-tape.c:	.ioctl		= idetape_chrdev_ioctl,
drivers/input/misc/hp_sdc_rtc.c:        .ioctl =	hp_sdc_rtc_ioctl,
drivers/isdn/capi/capi.c:	.ioctl		= capi_ioctl,
drivers/isdn/divert/divert_procfs.c:	.ioctl          = isdn_divert_ioctl,
drivers/isdn/i4l/isdn_common.c:	.ioctl		= isdn_ioctl,
drivers/isdn/mISDN/timerdev.c:	.ioctl		= mISDN_ioctl,
drivers/macintosh/ans-lcd.c:	.ioctl	= anslcd_ioctl,
drivers/macintosh/nvram.c:	.ioctl		= nvram_ioctl,
drivers/macintosh/via-pmu.c:	.ioctl		= pmu_ioctl,
drivers/media/dvb/dvb-core/dmxdev.c:	.ioctl = dvb_demux_ioctl,
drivers/media/dvb/dvb-core/dmxdev.c:	.ioctl = dvb_dvr_ioctl,
drivers/media/dvb/dvb-core/dvb_ca_en50221.c:	.ioctl = dvb_ca_en50221_io_ioctl,
drivers/media/dvb/dvb-core/dvb_net.c:	.ioctl = dvb_net_ioctl,
drivers/media/dvb/dvb-core/dvb_frontend.c:	.ioctl		= dvb_generic_ioctl,
drivers/media/dvb/firewire/firedtv-ci.c:	.ioctl		= dvb_generic_ioctl,
drivers/media/dvb/ttpci/av7110.c:	.ioctl		= dvb_generic_ioctl,
drivers/media/dvb/ttpci/av7110_av.c:	.ioctl		= dvb_generic_ioctl,
drivers/media/dvb/ttpci/av7110_av.c:	.ioctl		= dvb_generic_ioctl,
drivers/media/dvb/ttpci/av7110_ca.c:	.ioctl		= dvb_generic_ioctl,
drivers/message/i2o/i2o_config.c:	.ioctl = i2o_cfg_ioctl,
drivers/mtd/mtdchar.c:	.ioctl		= mtd_ioctl,
drivers/net/wan/cosa.c:	.ioctl		= cosa_chardev_ioctl,
drivers/parisc/eisa_eeprom.c:	.ioctl =	eisa_eeprom_ioctl,
drivers/pcmcia/pcmcia_ioctl.c:	.ioctl		= ds_ioctl,
drivers/rtc/rtc-m41t80.c:	.ioctl	= wdt_ioctl,
drivers/s390/char/tape_char.c:	.ioctl = tapechar_ioctl,
drivers/s390/char/vmwatchdog.c:	.ioctl   = &vmwdt_ioctl,
drivers/sbus/char/openprom.c:	.ioctl =	openprom_ioctl,
drivers/scsi/3w-9xxx.c:	.ioctl		= twa_chrdev_ioctl,
drivers/scsi/3w-xxxx.c:	.ioctl		= tw_chrdev_ioctl,
drivers/scsi/aacraid/linit.c:	.ioctl		= aac_cfg_ioctl,
drivers/scsi/dpt_i2o.c:	.ioctl		= adpt_ioctl,
drivers/scsi/gdth.c:    .ioctl   = gdth_ioctl,
drivers/scsi/megaraid.c:	.ioctl		= megadev_ioctl,
drivers/scsi/megaraid/megaraid_mm.c:	.ioctl	= mraid_mm_ioctl,
drivers/scsi/osst.c:	.ioctl =        osst_ioctl,
drivers/scsi/sg.c:	.ioctl = sg_ioctl,
drivers/staging/comedi/comedi_fops.c:	.ioctl = comedi_ioctl,
drivers/staging/poch/poch.c:	.ioctl = poch_ioctl,
drivers/staging/sep/sep_driver.c:	.ioctl = sep_ioctl,
drivers/staging/vme/devices/vme_user.c:        .ioctl = vme_user_ioctl,
drivers/usb/core/devio.c:	.ioctl =	usbdev_ioctl,
drivers/usb/mon/mon_bin.c:	.ioctl =	mon_bin_ioctl,
fs/autofs/root.c:	.ioctl		= autofs_root_ioctl,
fs/autofs4/root.c:	.ioctl		= autofs4_root_ioctl,
fs/coda/pioctl.c:	.ioctl		= coda_pioctl,
fs/coda/psdev.c:	.ioctl		= coda_psdev_ioctl,
fs/ecryptfs/file.c:	.ioctl = ecryptfs_ioctl,
fs/ecryptfs/file.c:	.ioctl = ecryptfs_ioctl,
fs/fat/dir.c:	.ioctl		= fat_dir_ioctl,
fs/fat/file.c:	.ioctl		= fat_generic_ioctl,
fs/hfsplus/dir.c:	.ioctl          = hfsplus_ioctl,
fs/hfsplus/inode.c:	.ioctl          = hfsplus_ioctl,
fs/ncpfs/dir.c:	.ioctl		= ncp_ioctl,
fs/ncpfs/file.c:	.ioctl		= ncp_ioctl,
fs/reiserfs/dir.c:	.ioctl = reiserfs_ioctl,
fs/reiserfs/file.c:	.ioctl = reiserfs_ioctl,
fs/smbfs/dir.c:	.ioctl		= smb_ioctl,
fs/smbfs/file.c:	.ioctl		= smb_ioctl,
fs/udf/dir.c:	.ioctl			= udf_ioctl,
fs/udf/file.c:	.ioctl			= udf_ioctl,
net/sunrpc/cache.c:     .ioctl          = cache_ioctl_procfs, /* for FIONREAD */
net/sunrpc/cache.c:     .ioctl          = cache_ioctl_pipefs, /* for FIONREAD */
net/sunrpc/rpc_pipe.c:	.ioctl		= rpc_pipe_ioctl,
sound/oss/dmasound/dmasound_core.c:	.ioctl		= mixer_ioctl,
sound/oss/dmasound/dmasound_core.c:	.ioctl		= sq_ioctl,
sound/oss/msnd_pinnacle.c:	.ioctl		= dev_ioctl,
sound/oss/sh_dac_audio.c:      .ioctl =	dac_audio_ioctl,
sound/oss/soundcard.c:	.ioctl		= sound_ioctl,
sound/oss/swarm_cs4297a.c:	.ioctl		= cs4297a_ioctl_mixdev,
sound/oss/swarm_cs4297a.c:	.ioctl		= cs4297a_ioctl,
sound/oss/vwsnd.c:	.ioctl =	vwsnd_audio_ioctl,
sound/oss/vwsnd.c:	.ioctl =	vwsnd_mixer_ioctl,
