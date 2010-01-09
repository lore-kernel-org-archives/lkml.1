Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580Ab0AICuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0AICuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 21:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546Ab0AICum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 21:50:42 -0500
Received: from outbound-mail-151.bluehost.com ([67.222.39.31]:33776 "HELO
	outbound-mail-151.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754538Ab0AICul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 21:50:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=onzzN9I/HA62+SB1tSe6P3MJj4j3/zgHjhhWnysy5pb9fD0+2EXaKYQnSZE6vtHfcsTGgGaFCka91gnBiv/6pEd3czItS0Rt+6MVYNvPhsiKtNSTYJII9ZqTW08LX9KH;
Date: Fri, 8 Jan 2010 18:50:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
Message-ID: <20100108185041.7aae6c01@jbarnes-piketon>
In-Reply-To: <alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie>
References: <201001090045.33784.rjw@sisk.pl>
	<alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
	<alpine.DEB.2.00.1001090214220.21286@skynet.skynet.ie>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jan 2010 02:15:41 +0000 (GMT)
Dave Airlie <airlied@linux.ie> wrote:

> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915:
> > > implement new pm ops for i915), among other things, removed
> > > the .suspend and .resume pointers from the struct drm_driver
> > > object in i915_drv.c, which broke resume without KMS on my MSI
> > > Wind U100.
> > > 
> > > Fix this by reverting that part of commit cbda12d77ea59.
> > 
> > Hmm. I get the feeling that perhaps the of the drm_driver callbacks
> > was very muchintentional, and that the code presumably wants to be
> > called purely through the PCI layer, and not through the "drm
> > class" logic at all?
> > 
> > Your patch seems like it would always execute the silly class
> > suspend even though we explicitly don't want to. And a much nicer
> > fix would seem to register the thing properly as a PCI driver even
> > if you don't then use KMS.
> > 
> > So it looks to me like the problem is that drm_init() will register
> > the driver as a real PCI driver only if
> > 
> > 	driver->driver_features & DRIVER_MODESET
> > 
> > and otherwise it does that very odd "stealth mode manual scanning"
> > thing which doesn't register it as a proper PCI driver.
> > 
> > So could we instead make that "disable KSM" _just_ disable the mode 
> > setting part, not disable the "I'm a real driver" part?
> > 
> 
> This was mainly due to pre-existing fb drivers binding to the device,
> and the drm drivers having to work around that, with KMS since we
> have fb in the drm driver its correct to bind, pre-kms its just a
> mess I'd rather stay away from.

Linus, can we ever drop those old paths?  Maybe after the new bits have
been around for awhile?  Users of really old userspace stacks would
lose 3D support, but they'd still have 2D, so it wouldn't be a complete
break.  The non-KMS paths sometimes break like this anyway without us
noticing (especially some of the weirder 3D paths)...

Just thinking out loud, we could really kill a lot of really bad code...

-- 
Jesse Barnes, Intel Open Source Technology Center
