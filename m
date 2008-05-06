Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbYEFTOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbYEFTOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759752AbYEFTOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:14:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759027AbYEFTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:14:34 -0400
Date: Tue, 6 May 2008 16:13:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080506161346.183f367c@gaivota>
In-Reply-To: <48206C73.80509@s5r6.in-berlin.de>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
	<20080504160904.GF19717@sgi.com>
	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
	<200805060902.25835.alistair@devzero.co.uk>
	<20080506073134.424780a3@gaivota>
	<48206C73.80509@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2008 16:34:27 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mauro Carvalho Chehab wrote:
> > the Kconfig logic for V4L/DVB is complex. It tries to address two
> > different issues:
> > 	- an easy board selection for the end-user (just selecting CX88 should
> > allow his board to work);
> > 	- an advanced selection for embedded set-top-boxes, where you can
> > select just what you really need.
> > 
> > Due to that, there are several "select" clauses, that don't consider the
> > "depends on". So, it is very easy to break it, unfortunately.
> 
> No, it is not easy to break, it /is/ broken.

True, unfortunately.

> But it is /trivial/ to fix.  If A selects B, you have to copy all of B's
> dependencies to A or select these dependencies by A.
> 
> So it's totally simple to do it right.  The only nuisance is that you
> always have to update B's dependencies and selections whenever A's
> dependencies are changed.

This is easy to maintain, if you have just a few selects, but this is not the
case of V4L drivers. Look some examples:

IVTV driver:

config VIDEO_IVTV
        tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
        depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && EXPERIMENTAL
        select I2C_ALGOBIT
        select FW_LOADER
        select VIDEO_IR
        select MEDIA_TUNER
        select VIDEO_TVEEPROM
        select VIDEO_CX2341X
        select VIDEO_CX25840
        select VIDEO_MSP3400
        select VIDEO_SAA711X
        select VIDEO_SAA717X
        select VIDEO_SAA7127
        select VIDEO_TVAUDIO
        select VIDEO_CS53L32A
        select VIDEO_M52790
        select VIDEO_WM8775
        select VIDEO_WM8739
        select VIDEO_VP27SMPX
        select VIDEO_UPD64031A
        select VIDEO_UPD64083

config VIDEO_FB_IVTV
        tristate "Conexant cx23415 framebuffer support"
        depends on VIDEO_IVTV && FB && EXPERIMENTAL
        select FB_CFB_FILLRECT
        select FB_CFB_COPYAREA
        select FB_CFB_IMAGEBLIT


(btw, on above, IVTV is missing INPUT)

This is Cx88 driver:

config VIDEO_CX88
        tristate "Conexant 2388x (bt878 successor) support"
        depends on VIDEO_DEV && PCI && I2C && INPUT
        select I2C_ALGOBIT
        select FW_LOADER
        select VIDEO_BTCX
        select VIDEOBUF_DMA_SG
        select MEDIA_TUNER
        select VIDEO_TVEEPROM
        select VIDEO_IR
        select VIDEO_WM8775 if VIDEO_HELPER_CHIPS_AUTO

config VIDEO_CX88_ALSA
        tristate "Conexant 2388x DMA audio support"
        depends on VIDEO_CX88 && SND && EXPERIMENTAL
        select SND_PCM

config VIDEO_CX88_BLACKBIRD
        tristate "Blackbird MPEG encoder support (cx2388x + cx23416)"
        depends on VIDEO_CX88
        select VIDEO_CX2341X

config VIDEO_CX88_DVB
        tristate "DVB/ATSC Support for cx2388x based TV cards"
        depends on VIDEO_CX88 && DVB_CORE
        select VIDEOBUF_DVB
        select DVB_PLL if !DVB_FE_CUSTOMISE
        select DVB_MT352 if !DVB_FE_CUSTOMISE
        select DVB_ZL10353 if !DVB_FE_CUSTOMISE
        select DVB_OR51132 if !DVB_FE_CUSTOMISE
        select DVB_CX22702 if !DVB_FE_CUSTOMISE
        select DVB_LGDT330X if !DVB_FE_CUSTOMISE
        select DVB_NXT200X if !DVB_FE_CUSTOMISE
        select DVB_CX24123 if !DVB_FE_CUSTOMISE
        select DVB_ISL6421 if !DVB_FE_CUSTOMISE
        select MEDIA_TUNER_SIMPLE if !DVB_FE_CUSTOMISE
        select DVB_S5H1411 if !DVB_FE_CUSTOMISE

(here, FW_LOADER is at the wrong sub-driver - it should be at CX88_DVB - and
HOTPLUG dependency is missing)

Ok, most of those select's have the same set of dependencies. Yet, it is really
hard to maintain. The result is that almost every new driver has some missing
dependencies.

Those two drivers are just two examples where I found some bugs today. Most of
the drivers have dozens of select. 

You may argue to not use select, but it is really hard to avoid, since each of
those main drivers (cx88, ivtv, bttv, etc) supports a large number of different
devices, that needs different chips. Most V4L/DVB devices has an internal I2C
bus that gives the flexibility for the board manufacturers to add/replace the
internal components at the i2c bus. So, the Kernel uses abstraction layers that
allows that the same driver to use different internal components.

What the Kbuild system does is to autoselect, by default, all drivers that
might be needed, in order to support all variants. At runtime (if module), only
the drivers effectively needed will be loaded. Advanced users have the option
of manually select the needed drivers, if they are 100% sure of what their
device needs (generally, this is valuable only for embedded systems).

Cheers,
Mauro
