Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYGANFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYGANFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYGANFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:05:38 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:36104 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYGANFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:05:37 -0400
Date: Tue, 1 Jul 2008 16:05:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] drivers/input/ff-core.c needs <linux/sched.h>
Message-ID: <20080701130517.GA29863@cs181140183.pp.htv.fi>
References: <Pine.LNX.4.64.0807011300110.21227@anakin> <20080701084316.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080701084316.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 08:46:54AM -0400, Dmitry Torokhov wrote:
> On Tue, Jul 01, 2008 at 01:55:25PM +0200, Geert Uytterhoeven wrote:
> > commit 656acd2bbc4ce7f224de499ee255698701396c48
> > Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Date:   Thu Jun 26 11:30:02 2008 -0400
> > 
> >     Input: fix locking in force-feedback core
> > 
> >     The newly added event_lock spinlock in the input core disallows sleeping
> >     and therefore using mutexes in event handlers. Convert force-feedback 
> >     core to rely on event_lock instead of mutex to protect slots allocated  
> >     for fore-feedback effects. The original mutex is still used to serialize
> >     uploading and erasing of effects.
> > 
> > causes the following regression on m68k:
> > 
> > | linux/drivers/input/ff-core.c: In function 'input_ff_upload':
> > | linux/drivers/input/ff-core.c:172: error: dereferencing pointer to incomplete type
> > | linux/drivers/input/ff-core.c: In function 'erase_effect':
> > | linux/drivers/input/ff-core.c:197: error: dereferencing pointer to incomplete type
> > | linux/drivers/input/ff-core.c:204: error: dereferencing pointer to incomplete type
> > | make[4]: *** [drivers/input/ff-core.o] Error 1
> > 
> 
> Argh! Sorry about it.
> 
> > As the incomplete type is `struct task_struct', including <linux/sched.h> fixes
> > it.
> 
> Not linux/spinlock.h? I wonder if I need to include linux/spinlock.h and
> linux/mutex.h directly from linux/input.h... What is the current
> policy on headers - do they need to include everything to be
> functional or it is responsibility of the user?

Theoretically it's the responsibility of the header to include 
everything it needs.

In practice we are after -rc8 and even thinking of this kind of #include 
changes under include/linux/ makes me nervous - like the fact that the 
ff-core.c problem occured _only_ on m68k our headers are too fragile for 
expecting such changes to simply work.

Can we go with Geert's patch for 2.6.26 and if you want to fix it 
properly you can send a patch for 2.6.27?

> Dmitry

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

