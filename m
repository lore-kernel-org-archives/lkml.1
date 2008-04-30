Return-Path: <linux-kernel-owner+w=401wt.eu-S1765620AbYD3VgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765620AbYD3VgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbYD3Vfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:35:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbYD3Vfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:35:54 -0400
Date: Wed, 30 Apr 2008 18:35:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] drivers/media build fix for modular builds
Message-ID: <20080430183503.19b36166@gaivota>
In-Reply-To: <1209573069.4821.3.camel@marge.simson.net>
References: <20080429185009.716c3284@gaivota>
	<20080430074807.GA11224@elte.hu>
	<20080430.005212.46815036.davem@davemloft.net>
	<20080430081345.GA16519@elte.hu>
	<1209544030.30990.2.camel@marge.simson.net>
	<1209544951.15609.3.camel@marge.simson.net>
	<1209545784.31419.2.camel@marge.simson.net>
	<1209547231.4898.2.camel@marge.simson.net>
	<20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	<1209560592.5265.2.camel@marge.simson.net>
	<20080430122514.2a52942d@gaivota>
	<1209570490.5157.1.camel@marge.simson.net>
	<20080430131204.0ce73b3b@gaivota>
	<1209573069.4821.3.camel@marge.simson.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 18:31:09 +0200
Mike Galbraith <efault@gmx.de> wrote:

> 
> On Wed, 2008-04-30 at 13:12 -0300, Mauro Carvalho Chehab wrote:
> > On Wed, 30 Apr 2008 17:48:10 +0200
> > Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > 
> > > On Wed, 2008-04-30 at 12:25 -0300, Mauro Carvalho Chehab wrote:
> > > 
> > > > Please try this patch. It should avoid an OOPS, if attach fails.
> > > 
> > > Different oops.
> > > 
> > 
> > Detach order were wrong.
> > 
> > Try this, please.

Ok, I found a way to simulate the error here. Just doing:
	rm  /lib/modules/`uname -r`/kernel/drivers/media/common/tuners/*

Produced the same OOPS.

The fix is easy: just removing the unregister function call. dvb_register
happens only at videobuf-dvb, that happens only if no error during attach. So,
the proper deallocation code is just calling dvb_detach.

By removing this, and the tuner modules, now no oops is generated:

[ 5399.093624] TUNER: Unable to find symbol tda829x_probe()
[ 5399.093638] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
[ 5399.110946] DVB: Unable to find symbol tda9887_attach()
[ 5399.110955] tuner' 1-004b: Tuner attach for type = 74 failed.
[ 5399.119272] tuner' 1-004b: TUNER_SET_TYPE_ADDR
[ 5399.119284] tuner' 1-004b: Calling set_type_addr for type=54, addr=0xff, mode=0x0e, config=0x00
[ 5399.119294] tuner' 1-004b: set addr discarded for type 4, mask 0. Asked to change tuner at addr 0xff, with mask e
[ 5399.119307] tuner' 1-004b: VIDIOC_S_STD
[ 5399.119321] tuner' 1-004b: switching to v4l2
[ 5399.119330] tuner' 1-004b: VIDIOC_S_STD
[ 5399.120762] saa7133[0]: registered device video0 [v4l2]
[ 5399.120873] saa7133[0]: registered device vbi0
[ 5399.120942] saa7133[0]: registered device radio0
[ 5399.121320] tuner' 1-004b: TUNER_SET_STANDBY
[ 5399.145012] saa7134 ALSA driver for DMA sound loaded
[ 5399.145098] saa7133[0]/alsa: saa7133[0] at 0x8c000000 irq 20 registered as card -1
[ 5399.260248] tuner' 1-004b: VIDIOC_S_STD
[ 5399.187606] tuner' 1-004b: TUNER_SET_STANDBY
[ 5399.297878] DVB: Unable to find symbol tda827x_attach()
[ 5399.297886] saa7133[0]/dvb: no tda827x tuner found at addr: 61

I tried even to run userspace apps:

$ scandvb /home/v4l/dvb-apps/util/scan/dvb-t/uk-Storeton
scanning /home/v4l/dvb-apps/util/scan/dvb-t/uk-Storeton
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
main:2248: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No such file or directory

(to test dvb)

and:

$ cat /dev/video0
cat: /dev/video0: Invalid argument

(to test v4l)

There's one missing patch on your tree that will make it work again. I'm
enclosing it at the end of this email.

I've updated my -git tree with those patches. The same bug were also present on
em28xx-dvb and cx88-dvb (that have about the same code). 

The fixes for those bugs are available at my -git tree. I've already sent a
pull request for their merge.

Cheers,
Mauro.

---

fix drivers/media/common/tuners/ build bug

From: Ingo Molnar <mingo@elte.hu>

x86.git randconfig testing found a build failure on latest -git:

 drivers/built-in.o: In function `set_type':
 tuner-core.c:(.text+0x2a9a26): undefined reference to `tea5761_attach'
 tuner-core.c:(.text+0x2a9d05): undefined reference to `tda9887_attach'
 tuner-core.c:(.text+0x2a9d51): undefined reference to `xc2028_attach'
 tuner-core.c:(.text+0x2a9e22): undefined reference to `tda829x_attach'
 tuner-core.c:(.text+0x2a9e3f): undefined reference to `microtune_attach'
 drivers/built-in.o: In function `tuner_probe':
 tuner-core.c:(.text+0x2aa18a): undefined reference to `tda829x_probe'
 tuner-core.c:(.text+0x2aa302): undefined reference to `tea5761_autodetection'

with the following config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_10_21_40_CEST_2008.bad

the problem is caused by the drivers/media/common/tuners/ subdirectory
not being part of the kbuild hierarchy anymore, due to commit
7c91f0624 ("V4L/DVB(7767): Move tuners to common/tuners").

this seems similar to the problem also reported by Mike Galbraith.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>


diff -r e9da55df0051 -r 048bf1530198 linux/drivers/media/common/Makefile
--- a/linux/drivers/media/common/Makefile       Wed Apr 30 12:29:57 2008 -0300
+++ b/linux/drivers/media/common/Makefile       Wed Apr 30 11:57:12 2008 +0000
@@ -2,6 +2,7 @@
 saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
 ir-common-objs  := ir-functions.o ir-keymaps.o

+obj-y += tuners/
 obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
 obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o


Cheers,
Mauro
