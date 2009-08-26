Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZHZRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZHZRNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbZHZRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:13:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbZHZRNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:13:16 -0400
Date: Wed, 26 Aug 2009 10:12:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>,
       mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: Linux 2.6.31-rc7
In-Reply-To: <21d7e9970908252158q30d7e4fay587458b79cd0c36d@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0908260943590.3218@localhost.localdomain>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>  <4A941E8B.8080902@plzk.org>  <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>  <4A94599F.9020508@plzk.org>  <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain> 
 <1251239637.26348.20.camel@gaiman.anholt.net>  <20090826015127.GA1402@zhen-devel.sh.intel.com>  <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>  <21d7e9970908252047g6db2fb2aj69280efa5eebe681@mail.gmail.com>  <alpine.LFD.2.01.0908252056170.3218@localhost.localdomain>
 <21d7e9970908252158q30d7e4fay587458b79cd0c36d@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Aug 2009, Dave Airlie wrote:
> 
> 3. Here's the thing, we do detect something has changed, we detect we no
> longer have a monitor connected on the mac mini because the routing
> for the DDC pins is insane and need special treatment in the driver.

That's the second thing - DDC in general seems to be _very_ flaky on intel 
chips.

And I don't mean that in a "Mac Mini" kind of sense. I'm seeing in on 
other machines. Here's my old EeePC 701:

	[drm] Initialized drm 1.1.0 20060810
	i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
	i915 0000:00:02.0: setting latency timer to 64
	i2c-adapter i2c-1: unable to read EDID block.
	i915 0000:00:02.0: LVDS-1: no EDID data
	[drm] DAC-6: set mode 640x480 0
	i2c-adapter i2c-1: unable to read EDID block.
	i915 0000:00:02.0: LVDS-1: no EDID data
	[drm] TV-11: set mode NTSC 480i 0
	allocated 800x480 fb: 0x007df000, bo f735b540
	[drm] LVDS-8: set mode 800x480 15
	Console: switching to colour frame buffer device 100x30

and quite frankly, I suspect you've never ever actually googled for "no 
EDID data", because if you had, you'd have seen that this is quite common.

And yes, the response of KMS seems to be "ok, I failed at EDID, so I'll 
just assume something isn't there". And then usually it picks LVDS 
instead, if it finds a VBT table for it. Which happens to work fine on 
most laptops, but it's still just a random heuristic.

And yes, for all I know it's because the display really doesn't do any 
EDID.

And that really kind of is the point - it doesn't even matter whether the 
problem is the Intel driver doing something wrong on the EDID front (which 
it has done quite often - ranging from just looking at the wrong port, to 
not setting the right bits to make bit-banging i2c work AT ALL), or 
whether the problem is that the hardware is wired up oddly (Mac Mini) or 
whether it's the hardware simply not doign EDID at all (maybe my EeePC? Or 
a really old VGA monitor, or whatever).

In all three cases the end result is "no EDID", but regardless of that, 
the correct action is basically _never_ to say "ok, I'll just assume that 
the display is on connector XYZ regardless of what the state of the 
graphics chip is".

> so yes I think do better at failing is what is needed, its still
> failing but its more user friendly fail.

Yes. If something fails ("oops, I can't seem EDID for any connector"), I 
wish KMS would fail way better than just default to some crazy setup. The 
failure mode should be to at least drive whatever the BIOS enabled.

			Linus
