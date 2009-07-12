Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZGLNSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZGLNSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 09:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbZGLNR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 09:17:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37228 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZGLNR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 09:17:57 -0400
Date: Sun, 12 Jul 2009 14:17:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Message-ID: <20090712131732.GA4406@flint.arm.linux.org.uk>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de> <200907111530.44736.david-b@pacbell.net> <20090712083510.GA24424@pengutronix.de> <20090712084734.GA944@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090712084734.GA944@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 09:47:34AM +0100, Russell King wrote:
> Your approach is perfectly fine, and safe.  You're not adding any
> additional bloat which isn't already there.  If it were adding any
> bloat (which it isn't), it certainly is not "in chunks of up to a
> page per patch".

Here is the effect of applying the am79c961 patch:

   text    data     bss     dec     hex filename
2553829   76608   78560 2708997  295605 vmlinux.patched
2553285   76608   78560 2708453  2953e5 vmlinux

that's an extra 500 bytes, but wait a moment before criticising that.
Let's look at where these came from:

before:
  1 .text.head    00000240  c0008000  c0008000  00010000  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .init         00016dc0  c0008240  c0008240  00010240  2**5
                  CONTENTS, ALLOC, LOAD, CODE
  3 .text         002455a4  c001f000  c001f000  00027000  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  4 __ksymtab     00004198  c0265000  c0265000  0026d000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA

after:
  1 .text.head    00000240  c0008000  c0008000  00010000  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  2 .init         00016dc0  c0008240  c0008240  00010240  2**5
                  CONTENTS, ALLOC, LOAD, CODE
  3 .text         002457c4  c001f000  c001f000  00027000  2**5
                  CONTENTS, ALLOC, LOAD, READONLY, CODE
  4 __ksymtab     00004198  c0265000  c0265000  0026d000  2**2
                  CONTENTS, ALLOC, LOAD, READONLY, DATA

Notice that the VMA of __ksymtab hasn't changed, which follows on from
the text section.  What's happened is that we've merely moved some text
from the .init section to the .text section, and in this case we haven't
changed the overall file size, nor the number of pages used for each
section.

To nack these patches based upon every patch adding one page to the kernel
size is clearly overstating the effect.  The effect is that in some
configurations, it moves some text out of .init into .text, and can
increase the size of the kernel kept in memory after boot time.  It's
certainly no where near "one page per patch" though, and the overall
size of the kernel may only change +/- one page through doing this -
eg, you might move enough text out of .init so that shrinks by one
page without making .text expand by a page.

I don't think this is a strong enough reason to reject any of these
patches.  David's approach is an enhancement whereas your patches
are a bug fix.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
