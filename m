Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547Ab0AIACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab0AIACw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386Ab0AIACv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:02:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928Ab0AIACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:02:50 -0500
Date: Fri, 8 Jan 2010 16:01:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Eric Anholt <eric@anholt.net>, Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] DRM / i915: Fix resume regression on MSI Wind U100 w/o
 KMS
In-Reply-To: <201001090045.33784.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1001081548320.7821@localhost.localdomain>
References: <201001090045.33784.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Rafael J. Wysocki wrote:
>
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit cbda12d77ea590082edb6d30bd342a67ebc459e0 (drm/i915: implement
> new pm ops for i915), among other things, removed the .suspend and
> .resume pointers from the struct drm_driver object in i915_drv.c,
> which broke resume without KMS on my MSI Wind U100.
> 
> Fix this by reverting that part of commit cbda12d77ea59.

Hmm. I get the feeling that perhaps the of the drm_driver callbacks was 
very muchintentional, and that the code presumably wants to be called 
purely through the PCI layer, and not through the "drm class" logic at 
all?

Your patch seems like it would always execute the silly class suspend even 
though we explicitly don't want to. And a much nicer fix would seem to 
register the thing properly as a PCI driver even if you don't then use 
KMS.

So it looks to me like the problem is that drm_init() will register the 
driver as a real PCI driver only if

	driver->driver_features & DRIVER_MODESET

and otherwise it does that very odd "stealth mode manual scanning" thing 
which doesn't register it as a proper PCI driver.

So could we instead make that "disable KSM" _just_ disable the mode 
setting part, not disable the "I'm a real driver" part?

		Linus
