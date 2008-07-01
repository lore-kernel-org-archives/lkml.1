Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbYGANOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbYGANOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYGANOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:14:25 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:34948 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYGANOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:14:23 -0400
X-Greylist: delayed 4731 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jul 2008 09:14:23 EDT
Date: Tue, 1 Jul 2008 15:14:19 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] drivers/input/ff-core.c needs <linux/sched.h>
In-Reply-To: <20080701130517.GA29863@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0807011512400.21227@anakin>
References: <Pine.LNX.4.64.0807011300110.21227@anakin>
 <20080701084316.ZZRA012@mailhub.coreip.homeip.net> <20080701130517.GA29863@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008, Adrian Bunk wrote:
> On Tue, Jul 01, 2008 at 08:46:54AM -0400, Dmitry Torokhov wrote:
> > On Tue, Jul 01, 2008 at 01:55:25PM +0200, Geert Uytterhoeven wrote:
> > > commit 656acd2bbc4ce7f224de499ee255698701396c48
> > > Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Date:   Thu Jun 26 11:30:02 2008 -0400
> > > 
> > >     Input: fix locking in force-feedback core
> > > 
> > >     The newly added event_lock spinlock in the input core disallows sleeping
> > >     and therefore using mutexes in event handlers. Convert force-feedback 
> > >     core to rely on event_lock instead of mutex to protect slots allocated  
> > >     for fore-feedback effects. The original mutex is still used to serialize
> > >     uploading and erasing of effects.
> > > 
> > > causes the following regression on m68k:
> > > 
> > > | linux/drivers/input/ff-core.c: In function 'input_ff_upload':
> > > | linux/drivers/input/ff-core.c:172: error: dereferencing pointer to incomplete type
> > > | linux/drivers/input/ff-core.c: In function 'erase_effect':
> > > | linux/drivers/input/ff-core.c:197: error: dereferencing pointer to incomplete type
> > > | linux/drivers/input/ff-core.c:204: error: dereferencing pointer to incomplete type
> > > | make[4]: *** [drivers/input/ff-core.o] Error 1
> > > 
> > 
> > Argh! Sorry about it.
> > 
> > > As the incomplete type is `struct task_struct', including <linux/sched.h> fixes
> > > it.
> > 
> > Not linux/spinlock.h? I wonder if I need to include linux/spinlock.h and

Nope, tried that first...

> > linux/mutex.h directly from linux/input.h... What is the current
> > policy on headers - do they need to include everything to be
> > functional or it is responsibility of the user?
> 
> Theoretically it's the responsibility of the header to include 
> everything it needs.

Indeed. But due to Include Hell that's not always possible.

> In practice we are after -rc8 and even thinking of this kind of #include 
> changes under include/linux/ makes me nervous - like the fact that the 
> ff-core.c problem occured _only_ on m68k our headers are too fragile for 
> expecting such changes to simply work.
> 
> Can we go with Geert's patch for 2.6.26 and if you want to fix it 
> properly you can send a patch for 2.6.27?

And let the proper patch boil in linux-next for a while...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
