Return-Path: <linux-kernel-owner+w=401wt.eu-S937885AbYD1V0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937885AbYD1V0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936545AbYD1V0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:26:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbYD1V0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:26:31 -0400
Date: Mon, 28 Apr 2008 18:25:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428182501.5bb87058@gaivota>
In-Reply-To: <20080428210122.GC2813@cs181133002.pp.htv.fi>
References: <20080428162421.GA16566@elte.hu>
	<20080428180457.GY2813@cs181133002.pp.htv.fi>
	<20080428195330.GE9907@elte.hu>
	<20080428210122.GC2813@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 00:01:22 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Apr 28, 2008 at 09:53:30PM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > On Mon, Apr 28, 2008 at 06:24:21PM +0200, Ingo Molnar wrote:
> > > > 
> > > > fix build failure found via x86.git randconfig testing:
> > > > 
> > > >  drivers/built-in.o: In function `tda829x_attach':
> > > >  : undefined reference to `tda827x_attach'
> > > >  drivers/built-in.o: In function `tda829x_attach':
> > > >  : undefined reference to `tda18271_attach'
> > > > 
> > > > build failure is due to this nasty dependency:
> > > > 
> > > >   CONFIG_DVB_CORE=m but CONFIG_TUNER_TDA8290=y.
> > 
> > > It might work around the problem in your specific configuration, but 
> > > it's not the correct solution.
> > > 
> > > Please send your .config .
> > 
> > i dont have it anymore,
> 
> That's bad since it makes it harder for other people to reproduce the 
> problem.
> 
> > but the key was what i wrote in the changelog 
> > above:
> > 
> >   CONFIG_DVB_CORE=m
> >   CONFIG_TUNER_TDA8290=y
> > 
> > if you look at the symbols above, their definition sites, and the 
> > dependencies between them you'll see why that breaks the build. (There 
> > might be more to it, this area has been a frequent source of problems.)
> 
> TUNER_TDA8290 is the only affected driver, your patch also adds wrong 
> dependences to other driver.
> 
> And the underlying problem is that it has both an analog an a DVB tuner, 
> and although forcing a dependency on DVB_CORE might make the randconfig 
> crowd happy it's not the correct solution.
> 
> Mauro, where were we regarding this issue?
> 
> What about:
> 
> config TUNER_TDA8290
>         tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
>         depends on I2C
> 	depends on DVB_CORE || DVB_CORE=n
>         select DVB_TDA827X if DVB_CORE
>         select DVB_TDA18271 if DVB_CORE
>         default m if VIDEO_TUNER_CUSTOMIZE
>         help
>           Say Y here to include support for Philips TDA8290+8275(a) tuner.
> 
> Or is there some twist I'm missing?


This will fix compilation, but some drivers will be broken, since tda8275 is
needed even for some analog-only drivers.

It would be better to do a "select DVB_CORE", although this is also ugly.

I'm pinging Mkrufky. He is the one that touched a lot on those drivers. Maybe
he can come up with a better solution.

Cheers,
Mauro
