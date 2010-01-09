Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607Ab0AIAcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0AIAcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358Ab0AIAcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:32:18 -0500
Received: from outbound-mail-305.bluehost.com ([67.222.53.251]:57791 "HELO
	outbound-mail-305.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754219Ab0AIAcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:32:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cXHiP6uB2H6I+1BnevaCYhFwU2j0NQNSjdkFGnj75mLm7rUDaQNeJzdXhw6779ns5rUPgoxUYb2UUdIYmPO5uFy08mmNnHAqhmeBB3FASE6JX7Hdgn48cQwyEO2CqP67;
Date: Fri, 8 Jan 2010 16:32:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
Message-ID: <20100108163217.341da699@jbarnes-piketon>
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

This is the minimal fix I think (totally untested):

diff --git a/drivers/gpu/drm/i915/i915_drv.c
b/drivers/gpu/drm/i915/i915_drv.c index a0a2cad..1364c3e 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -541,6 +541,11 @@ static int __init i915_init(void)
                driver.driver_features &= ~DRIVER_MODESET;
 #endif
 
+       if (!(driver.driver_features & DRIVER_MODESET)) {
+               driver.suspend = i915_suspend;
+               driver.resume = i915_resume;
+       }
+
        return drm_init(&driver);
 }
 


-- 
Jesse Barnes, Intel Open Source Technology Center
