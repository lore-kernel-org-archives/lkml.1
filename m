Return-Path: <linux-kernel-owner+w=401wt.eu-S934970AbZJNQzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934970AbZJNQzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934954AbZJNQzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:55:31 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49616 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934537AbZJNQza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=In7XB/UbkpAX4UIlOiL+ub8e7C8cYBww/StC0M387zTGf9/0h9vFZDoTj06a4KPo9K
         BEoz/VHcwd86whO0CjmkBBSA4g22wVcKwqbHGFRXXGGjtH1eEl9dyZ05a4ywllbyFxgh
         oDb2EqVGCnS5UQYDf9HtZhulvjs7H6vdFLW6Q=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Date: Wed, 14 Oct 2009 18:54:49 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-tip-commits@vger.kernel.org
References: <20091010153349.237173041@linutronix.de> <20091014171249.57dcdcfc@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0910141816020.9428@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910141816020.9428@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910141854.49418.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, Thomas Gleixner wrote:
> on Wed, 14 Oct 2009, Alan Cox wrote:
> > You can't simply assume the mutex is enough - you have to either push it
> > down or review *every* possible called point below the lock_kernel take.
> > 
> > In this case the open method of the misc devices below sometimes uses the
> > BKL.
> 
> The BKL got pushed down into the open methods of misc dev users and we
> do not need to take it twice in a row, right ?
> 

I worked on the original pushdown back then and believed it to be
complete. New drivers have come in and some obviously unneeded
instances got cleared of the BKL usage. The ones with an open method
that does not take the BKL are:

arch/mips/basler/excite/excite_iodev.c
arch/x86/kernel/apm_32.c
drivers/buetooth/hci_vhci.c
drivers/char/nvram.c
drivers/char/rtc.c
drivers/gpu/vga/vgaarb.c
drivers/hwmon/fschmd.c
drivers/hwmon/lis3lv02d.c
drivers/infiniband/core/ucma.c
drivers/isdn/mISDN/timerdev.c
drivers/s390/char/vmcp.c
fs/cachefiles/daemon.c
fs/dlm/user.c
fs/fuse/cuse.c
kernel/power/user.c
net/rfkill/core.c

As well as some drivers from staging and watchdog. I believe the
BKL usage in watchdog drivers was removed shortly after the pushdown.

	Arnd <><

drivers/staging/android/binder.c
drivers/staging/dream/qdsp5/audio_aac.c
drivers/staging/dream/qdsp5/audio_evrc.c
drivers/staging/dream/qdsp5/audio_in.c
drivers/staging/dream/qdsp5/audio_out.c
drivers/staging/dream/qdsp5/snd.c
drivers/staging/dream/smd/smd_qmi.c
drivers/staging/panel/panel.c
drivers/watchdog/acquirewdt.c
drivers/watchdog/adx_wdt.c
drivers/watchdog/alim7101_wdt.c
drivers/watchdog/at32ap700x_wdt.c
drivers/watchdog/at91sam9_wdt.c
drivers/watchdog/fin_wdt.c
drivers/watchdog/coh901327_wdt.c
drivers/watchdog/ep93xx_wdt.c
drivers/watchdog/gef_wdt.c
drivers/watchdog/geodewdt.c
drivers/watchdog/i6300esb.c
drivers/watchdog/b700wwdt.c
drivers/watchdog/ibmasr.c
drivers/watchdog/iop_wdt.c
drivers/watchdog/it8_wdt.c
drivers/watchdog/ixp4xx_wdt.c
drivers/watchdog/machzwd.c
drivers/watchdog/mpc5200_wdt.c
drivers/watchdog/mpcore_wdt.c
drivers/watchdog/mv64x60_wdt.c
drivers/watchdog/omap_wdt.c
drivers/watchdog/pc87413_wdt.c
drivers/watchdog/pcwd.c
drivers/watchdog/pcwd_pci.c
drivers/watchdog/pcwd_usb.c
drivers/watchdog/pnx4008_wdt.c
drivers/watchdog/rc32434_wdt.c
drivers/watchdog/s3c2410_wdt.c
drivers/watchdog/sb_wdog.c
drivers/watchdog/sbc7240_wdt.c
drivers/watchdog/sbc_epx_c3.c
drivers/watchdog/c1200wdt.c
drivers/watchdog/sch311x_wdt.c
drivers/watchdog/shwdt.c
drivers/watchdog/smsc37b787_wdt.c
drivers/watchdog/stmp3xxx_wdt.c
drivers/watchdog/txx9wdt.c
drivers/watchdog/w83697hf_wdt.c
drivers/watchdog/w83877f_wdt.c
drivers/watchdog/wafer5823wdt.c
drivers/watchdog/wdrtas.c
drivers/watchdog/wdt.c
drivers/watchdog/wdt977.c
drivers/watchdog/wdt_pci.c
drivers/watchdog/wm8350_wdt.c
