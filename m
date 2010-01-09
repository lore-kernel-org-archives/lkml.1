Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120Ab0AIAG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab0AIAG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903Ab0AIAG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:06:58 -0500
Received: from outbound-mail-149.bluehost.com ([67.222.38.39]:41078 "HELO
	outbound-mail-149.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750781Ab0AIAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:06:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q6BDHImPxLHtweAUbEVOx6QneWhPMzUbTkO/ZDtjDtItV4wP85cq4zu656hUj6i9j6ivMUzONpzihhz7Ea6A5fjBsJMR6PjWR5CVU32g7GAb2V3FjkEd7RMpZ6j1AJAb;
Date: Fri, 8 Jan 2010 16:06:59 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
Message-ID: <20100108160659.65ac0605@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
References: <201001090045.33784.rjw@sisk.pl>
	<alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 16:01:46 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
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
> Hmm. I get the feeling that perhaps the of the drm_driver callbacks
> was very muchintentional, and that the code presumably wants to be
> called purely through the PCI layer, and not through the "drm class"
> logic at all?
> 
> Your patch seems like it would always execute the silly class suspend
> even though we explicitly don't want to. And a much nicer fix would
> seem to register the thing properly as a PCI driver even if you don't
> then use KMS.
> 
> So it looks to me like the problem is that drm_init() will register
> the driver as a real PCI driver only if
> 
> 	driver->driver_features & DRIVER_MODESET
> 
> and otherwise it does that very odd "stealth mode manual scanning"
> thing which doesn't register it as a proper PCI driver.
> 
> So could we instead make that "disable KSM" _just_ disable the mode 
> setting part, not disable the "I'm a real driver" part?

Yeah, but that would be more invasive.  In the KMS case the driver
(which is registered as PCI) does a lot of the initialization that the
core takes care of in the non-KMS case, and some of it happens later at
ioctl time.  I'm afraid of that code since it seems like whenever you
change something obvious it subtly breaks an old userland.

-- 
Jesse Barnes, Intel Open Source Technology Center
