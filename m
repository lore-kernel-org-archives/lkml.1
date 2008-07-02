Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYGBIzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYGBIzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYGBIzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:55:44 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54953 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbYGBIzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:55:43 -0400
Date: Wed, 2 Jul 2008 11:55:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.26-mmotm] rtc: BCD codeshrink
Message-ID: <20080702085519.GA4196@cs181140183.pp.htv.fi>
References: <200807012341.01684.david-b@pacbell.net> <20080702014502.c1052e84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080702014502.c1052e84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:45:02AM -0700, Andrew Morton wrote:
> On Tue, 1 Jul 2008 23:41:01 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > This updates <linux/bcd.h> to define the key routines as constant
> > functions, which the macros will then call.  Newer code can now
> > call bcd2bin() instead of SCREAMING BCD2BIN() TO THE FOUR WINDS.
> > 
> > This lets each driver shrink their codespace by using N function
> > calls to a single (global) copy of those routines, instead of N
> > inlined copies of these functions per driver.
> > 
> > These routines aren't used in speed-critical code.  Almost all
> > callers are in the RTC framework.  Typical per-driver savings is
> > near 300 bytes.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Acked-by:  Adrian Bunk <bunk@kernel.org>
> > ---
> >  include/linux/bcd.h |    9 +++++++--
> >  lib/Makefile        |    2 +-
> >  lib/bcd.c           |   14 ++++++++++++++
> >  3 files changed, 22 insertions(+), 3 deletions(-)
> > 
> > --- a/include/linux/bcd.h	2008-06-30 16:44:26.000000000 -0700
> > +++ b/include/linux/bcd.h	2008-06-30 21:38:24.000000000 -0700
> > @@ -10,8 +10,13 @@
> >  #ifndef _BCD_H
> >  #define _BCD_H
> >  
> > -#define BCD2BIN(val)	(((val) & 0x0f) + ((val)>>4)*10)
> > -#define BIN2BCD(val)	((((val)/10)<<4) + (val)%10)
> > +#include <linux/compiler.h>
> > +
> > +unsigned bcd2bin(unsigned char val) __attribute_const__;
> > +unsigned char bin2bcd(unsigned val) __attribute_const__;
> > +
> > +#define BCD2BIN(val)	bcd2bin(val)
> > +#define BIN2BCD(val)	bin2bcd(val)
> 
> It'd be good to nuke these things now.
>...
 
Unless David is faster I plan to do this after the patch went into 
Linus' tree.

E.g. rtc-ramtron-fm3130-rtc-support.patch in 2.6.26-rc5-mm3 adds a new 
user, and it should create less hassle if the actual removal of the 
#define's happens around 2.6.27-rc1 when everything is merged into 
Linus' tree.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

