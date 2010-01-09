Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604Ab0AIAVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0AIAVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520Ab0AIAVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:21:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab0AIAVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:21:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o KMS
Date: Sat, 9 Jan 2010 01:21:37 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Eric Anholt <eric@anholt.net>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
References: <201001090045.33784.rjw@sisk.pl> <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001090121.37368.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 January 2010, Linus Torvalds wrote:
> 
> On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
> >
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

Hmm.  Do you mean set DRIVER_MODESET unconditionally before calling drm_init()
and only reset it later if necessary?

Rafael
