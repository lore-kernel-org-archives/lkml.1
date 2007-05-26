Return-Path: <linux-kernel-owner+w=401wt.eu-S1760046AbXEZOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046AbXEZOjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXEZOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:39:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXEZOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:39:07 -0400
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>
In-Reply-To: <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net>
	 <20070524130921.8dbd3777.akpm@linux-foundation.org>
	 <s5hiragopsx.wl%tiwai@suse.de>
	 <20070525102806.77ee9c0c.akpm@linux-foundation.org>
	 <s5h1wh4si5l.wl%tiwai@suse.de>
	 <Pine.LNX.4.61.0705261248150.7344@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 May 2007 11:38:13 -0300
Message-Id: <1180190293.21547.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sáb, 2007-05-26 às 12:51 +0200, Jan Engelhardt escreveu:
> On May 25 2007 23:33, Takashi Iwai wrote:
> >
> >Yeah, I'll check it again if reposted.  Jan, could you split ALSA
> >portins at the next time?
> 
> How much split? This time, I made four out of it.
> 
> >This will make testing and merging much
> >easier for me...
> >
> >But, above all, I'm not convinced much by that patch, especially
> >because it introduces new kconfigs just for menuconfig.
> >For example, CONFIG_SND_PCI_DRIVERS doesn't appear in any Makefiles.
> 
> Neither is/was CONFIG_DVB IIRC. The world does not stop turning just
> because there are now extra options. If you want the functionality
> of menuconfigs without introducing some variable to store their state,
> well, I think that's going to be a bigger kconf patch. (Just think of
> compatibility of the .config format.)

I suspect that kconf is not properly handing the newer way for
menuconfig. Maybe this is the same stuff that happened on ALSA.

We have some stuff like this:

menuconfig VIDEO_CAPTURE_DRIVERS
        bool "Video capture adapters"
        depends on VIDEO_DEV

if VIDEO_CAPTURE_DRIVERS

config VIDEO_VIVI
        tristate "Virtual Video Driver"
        depends on VIDEO_V4L2 && !SPARC32 && !SPARC64 && PCI
        select VIDEO_BUF

endif #VIDEO_CAPTURE_DRIVERS

config VIDEO_BUF
        depends on PCI
        tristate

Before adding menuconfig, VIDEO_VIVI were dependent on VIDEO_DEV. After
the patch, what happens is that:
if 
	VIDEO_DEV='m' and VIDEO_CAPTURE_DRIVERS='y' and VIDEO_VIVI='m'
then
	VIDEO_BUF='y'

But, as video-buf is dependent on video-core (compiled as a module,
since VIDEO_DEV='m'), it is generating compilation errors.

To fix it, I needed to add an explicit dependency on VIDEO_VIVI (and
also on VIDEO_SAA7146_VV):

http://linuxtv.org/hg/v4l-dvb?cmd=changeset;node=5cd49ffd9004;style=gitweb

I didn't looked inside kconf, but it seems that it is not checking that,
as VIDEO_CAPTURE_DRIVERS depends on VIDEO_DEV, all drivers inside the
"if" should also depend on VIDEO_DEV.
 
Cheers,
Mauro

