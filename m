Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZGAUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZGAUEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZGAUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:04:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZGAUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:04:27 -0400
Date: Wed, 1 Jul 2009 13:02:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: yinghai@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, mikpe@it.uu.se, matthew@wil.cx,
       grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] fix round_up/down
Message-Id: <20090701130218.29887c54.akpm@linux-foundation.org>
In-Reply-To: <1246477175.28915.52.camel@Joe-Laptop.home>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<19016.44061.600652.676183@pilspetsen.it.uu.se>
	<4A490804.3040609@zytor.com>
	<4A494478.7020304@kernel.org>
	<4A494E3C.70304@kernel.org>
	<4A495C0D.2020807@zytor.com>
	<4A4966EF.6010809@kernel.org>
	<alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
	<4A496D4B.3040608@kernel.org>
	<19017.53428.834539.389495@pilspetsen.it.uu.se>
	<4A4A25B1.5010102@zytor.com>
	<4A4A6888.30001@kernel.org>
	<4A4A6B1C.7030405@zytor.com>
	<4A4A701F.3050700@kernel.org>
	<4A4A81C9.9070008@zytor.com>
	<4A4A88A2.7010509@kernel.org>
	<alpine.LFD.2.01.0906301456170.3605@localhost.localdomain>
	<4A4A921F.7080100@kernel.org>
	<alpine.LFD.2.01.0906301559390.3605@localhost.localdomain>
	<alpine.LFD.2.01.0906301603280.3605@localhost.localdomain>
	<4A4A9C2F.80808@kernel.org>
	<4A4A9D8E.5080500@zytor.com>
	<4A4BB9C2.8020304@kernel.org>
	<4A4BBA12.8070507@kernel.org>
	<1246477175.28915.52.camel@Joe-Laptop.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Jul 2009 12:39:35 -0700
Joe Perches <joe@perches.com> wrote:

> On Wed, 2009-07-01 at 12:33 -0700, Yinghai Lu wrote:
> > --- linux-2.6.orig/include/linux/kernel.h
> > +++ linux-2.6/include/linux/kernel.h
> []
> >  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > +#define rounddown(x, y) (((x) / (y)) * (y))
> []
> > +#define round_up(x,y) ((((x)-1) | __round_mask(x,y))+1)
> > +#define round_down(x,y) ((x) & ~__round_mask(x,y))
> 
> Isn't this just asking for trouble?

Yes, I think so.  round_up() versus roundup() is a bit subtle!

> How about a better name?
> Maybe masked_roundup, or roundup_ala_zorro...

Yes.  roundup() wasn't a well-chosen identifier, really.  But I guess
it's compatible with the faster bitwise-based rounding operation so
it's OK to have a special fast version of roundup() for the cases we're
rounding up to a power-of-2.


umm, how about roundup_pow2()?  Sucks?


Also, it it lower-case or all-caps?  I think it should be all-caps.  Because

a) it is a macro, and it can ONLY be implemented as a macro, so
   there's no point in pretending that it might be a C function and that the
   caller needn't care.

b) several of these macros evaluate their args multiple times and
   hence will produce buggy or inefficeint code when passed expressions
   with side-effects.  So we should warn people that these things are macros.

   We should also fix that, dammit.  The proposed new rounddown()
   above has this failing as well.


