Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388Ab0AICPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0AICPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786Ab0AICPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:15:52 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34802 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0AICPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:15:51 -0500
Date: Sat, 9 Jan 2010 02:15:41 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
In-Reply-To: <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie>
References: <201001090045.33784.rjw@sisk.pl> <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
> > new pm ops for i915), among other things, removed the .suspend and
> > .resume pointers from the struct drm_driver object in i915_drv.c,
> > which broke resume without KMS on my MSI Wind U100.
> > 
> > Fix this by reverting that part of commit cbda12d77ea59.
> 
> Hmm. I get the feeling that perhaps the of the drm_driver callbacks was 
> very muchintentional, and that the code presumably wants to be called 
> purely through the PCI layer, and not through the "drm class" logic at 
> all?
> 
> Your patch seems like it would always execute the silly class suspend even 
> though we explicitly don't want to. And a much nicer fix would seem to 
> register the thing properly as a PCI driver even if you don't then use 
> KMS.
> 
> So it looks to me like the problem is that drm_init() will register the 
> driver as a real PCI driver only if
> 
> 	driver->driver_features & DRIVER_MODESET
> 
> and otherwise it does that very odd "stealth mode manual scanning" thing 
> which doesn't register it as a proper PCI driver.
> 
> So could we instead make that "disable KSM" _just_ disable the mode 
> setting part, not disable the "I'm a real driver" part?
> 

This was mainly due to pre-existing fb drivers binding to the device, and 
the drm drivers having to work around that, with KMS since we have fb in 
the drm driver its correct to bind, pre-kms its just a mess I'd rather 
stay away from.

Dave.
