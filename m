Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYENGBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYENGBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYENGBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:01:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYENGBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:01:43 -0400
Date: Wed, 14 May 2008 03:01:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, Michael Krufky <mkrufky@linuxtv.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: Re: [patch] video: build fix for drivers/media/video/pvrusb2/
Message-ID: <20080514030120.7521b9a9@gaivota>
In-Reply-To: <Pine.LNX.4.64.0805131101070.20885@cnc.isely.net>
References: <20080511072137.GA16772@elte.hu>
	<37219a840805110534r4865623y6f9510554e2716ac@mail.gmail.com>
	<20080512235445.3a56cea0@gaivota>
	<37219a840805122103u2a74b050h95c006f99ff8690f@mail.gmail.com>
	<20080513124630.111c465b@gaivota>
	<Pine.LNX.4.64.0805131050210.20885@cnc.isely.net>
	<Pine.LNX.4.64.0805131101070.20885@cnc.isely.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 11:02:05 -0500 (CDT)
Mike Isely <isely@isely.net> wrote:

> On Tue, 13 May 2008, Mike Isely wrote:
> 
> > On Tue, 13 May 2008, Mauro Carvalho Chehab wrote:
> > 
> > > On Tue, 13 May 2008 00:03:02 -0400
> > > "Michael Krufky" <mkrufky@linuxtv.org> wrote:
> > > 
> > > > 
> > > > That sounds like it would be OK, although something like this would
> > > > probably be better:
> > > > 
> > > >  config VIDEO_PVRUSB2
> > > >        tristate "Hauppauge WinTV-PVR USB2 support"
> > > > -       depends on VIDEO_V4L2 && I2C
> > > > +       depends on VIDEO_V4L2 && I2C && (DVB_CORE if VIDEO_PVRUSB2_DVB)
> > > >        select FW_LOADER
> > > >        select MEDIA_TUNER
> > > >        select VIDEO_TVEEPROM
> > > 
> > > This doesn't look to be a good idea, since VIDEO_PVRUSB2_DVB depends on
> > > VIDEO_PVRUSB2. So, you'll create a circular dependency. The syntax I've
> > > proposed seems cleaner. Of course, it needs to be tested. IMO, all hybrid
> > > devices should be dependent of VIDEO_MEDIA. This will help to avoid this kind
> > > of issue.
> > > 
> > > > I don't know if that syntax works for "depends on" , but it does work
> > > > for select.
> > > > 
> > > > if "depends on FOO if BAR" doesnt work, would adding "select DVB_CORE
> > > > if VIDEO_PVRUSB2_DVB" solve the problem?
> > > 
> > > Also, this leads into a circular reference.
> > 
> > Mauro:
> > 
> > Where is the loop that results in a circular reference?  No part of V4L 
> > or DVB depends (or otherwise has any reliance) on VIDEO_PVRUSB2.  All 
> > Mike Krufky is trying to set up is that VIDEO_PVRUSB2 should only depend 
> > on DVB_CORE if the DVB part of the driver (i.e. VIDEO_PVRUSB2_DVB) has 
> > been enabled.  Without VIDEO_PVRUSB2_DVB selected, then DVB_CORE is not 
> > required by the driver.
> > 
> > I've been quiet about this issue because I'm not a kconfig expert, but 
> > you've lost me with this conclusion.
> > 
> >   -Mike
> 
> Never mind.  I think I see it, and will figure out the rest off-line.

The solution were not as easy as I've originally imagined. VIDEO_MEDIA logic
were broken. So, all tuners were still broken.

I needed to fix VIDEO_MEDIA logic first, to obey to this truth table:

CONFIG_VIDEO_DEV        CONFIG_DVB_CORE         CONFIG_VIDEO_MEDIA
        N                       N                       N
        N                       M                       M
        N                       Y                       Y
        M                       N                       M
        M                       M                       M
        M                       Y                       M
        Y                       N                       Y
        Y                       M                       M
        Y                       Y                       Y

After this change, a simple dependency add solved the reported issue:

 config VIDEO_PVRUSB2
	tristate "Hauppauge WinTV-PVR USB2 support"
	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_MEDIA  # Avoids pvrusb = Y / DVB = M

I've tested the logic. seems fine now.

I did a quick review at the other modules that has hybrid support (cx88,
saa7134, em28xx, bttv) and they seemed ok to my eyes. Yet, I didn't test.

---

There are other configurations that seem to be broken. For example, if
V4L_CORE=m and DVB_CORE=y, a V4L driver should be 'M'. So, a tuner should also
be 'M', otherwise, it will break compilation. a DVB support for that card will
also be 'M', at the drivers I've reviewed.

However, a DVB-only driver can be 'Y', but can select a tuner. This will cause
a breakage.

I'll try to simulate some of those issues and see what happens.

Anyway, I've added severak Kbuild fixes at my -git tree:

http://www.kernel.org/git/?p=linux/kernel/git/mchehab/v4l-dvb.git

I intend to send the fixes I have later today. Now, I need to sleep ;)

Cheers,
Mauro
