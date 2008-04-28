Return-Path: <linux-kernel-owner+w=401wt.eu-S966858AbYD1VCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966858AbYD1VCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934949AbYD1VB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:01:57 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50222 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933541AbYD1VB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:01:56 -0400
Date: Tue, 29 Apr 2008 00:01:22 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428210122.GC2813@cs181133002.pp.htv.fi>
References: <20080428162421.GA16566@elte.hu> <20080428180457.GY2813@cs181133002.pp.htv.fi> <20080428195330.GE9907@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428195330.GE9907@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:53:30PM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Apr 28, 2008 at 06:24:21PM +0200, Ingo Molnar wrote:
> > > 
> > > fix build failure found via x86.git randconfig testing:
> > > 
> > >  drivers/built-in.o: In function `tda829x_attach':
> > >  : undefined reference to `tda827x_attach'
> > >  drivers/built-in.o: In function `tda829x_attach':
> > >  : undefined reference to `tda18271_attach'
> > > 
> > > build failure is due to this nasty dependency:
> > > 
> > >   CONFIG_DVB_CORE=m but CONFIG_TUNER_TDA8290=y.
> 
> > It might work around the problem in your specific configuration, but 
> > it's not the correct solution.
> > 
> > Please send your .config .
> 
> i dont have it anymore,

That's bad since it makes it harder for other people to reproduce the 
problem.

> but the key was what i wrote in the changelog 
> above:
> 
>   CONFIG_DVB_CORE=m
>   CONFIG_TUNER_TDA8290=y
> 
> if you look at the symbols above, their definition sites, and the 
> dependencies between them you'll see why that breaks the build. (There 
> might be more to it, this area has been a frequent source of problems.)

TUNER_TDA8290 is the only affected driver, your patch also adds wrong 
dependences to other driver.

And the underlying problem is that it has both an analog an a DVB tuner, 
and although forcing a dependency on DVB_CORE might make the randconfig 
crowd happy it's not the correct solution.

Mauro, where were we regarding this issue?

What about:

config TUNER_TDA8290
        tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
        depends on I2C
	depends on DVB_CORE || DVB_CORE=n
        select DVB_TDA827X if DVB_CORE
        select DVB_TDA18271 if DVB_CORE
        default m if VIDEO_TUNER_CUSTOMIZE
        help
          Say Y here to include support for Philips TDA8290+8275(a) tuner.

Or is there some twist I'm missing?

> > > -	depends on I2C && FW_LOADER
> > > +	depends on I2C && FW_LOADER && ((DVB_CORE = m && m) || (DVB_CORE = y))
> > >...
> > 
> > Your funny additions are equivalent to "&& DVB_CORE".
> 
> right you are, thanks - the above change was the best hack 4 hours of 
> sleep can buy ;-) Simplified patch below.

Still the old one...

But as described above, even the fixed one would be wrong.

> 	Ingo
> 
> ---------------------->
> Subject: dvb: build failure fix
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon Apr 28 18:17:58 CEST 2008
> 
> fix build failure:
> 
>  drivers/built-in.o: In function `tda829x_attach':
>  : undefined reference to `tda827x_attach'
>  drivers/built-in.o: In function `tda829x_attach':
>  : undefined reference to `tda18271_attach'
> 
> due to:
> 
>   CONFIG_DVB_CORE=m but CONFIG_TUNER_TDA8290=y.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/media/Kconfig |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux/drivers/media/Kconfig
> ===================================================================
> --- linux.orig/drivers/media/Kconfig
> +++ linux/drivers/media/Kconfig
> @@ -106,21 +106,21 @@ if VIDEO_TUNER_CUSTOMIZE
>  
>  config TUNER_XC2028
>  	tristate "XCeive xc2028/xc3028 tuners"
> -	depends on I2C && FW_LOADER
> +	depends on I2C && FW_LOADER && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	default m if VIDEO_TUNER_CUSTOMIZE
>  	help
>  	  Say Y here to include support for the xc2028/xc3028 tuners.
>  
>  config TUNER_MT20XX
>  	tristate "Microtune 2032 / 2050 tuners"
> -	depends on I2C
> +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	default m if VIDEO_TUNER_CUSTOMIZE
>  	help
>  	  Say Y here to include support for the MT2032 / MT2050 tuner.
>  
>  config TUNER_TDA8290
>  	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
> -	depends on I2C
> +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	select DVB_TDA827X
>  	select DVB_TDA18271
>  	default m if VIDEO_TUNER_CUSTOMIZE
> @@ -129,21 +129,21 @@ config TUNER_TDA8290
>  
>  config TUNER_TEA5761
>  	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
> -	depends on I2C && EXPERIMENTAL
> +	depends on I2C && EXPERIMENTAL && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	default m if VIDEO_TUNER_CUSTOMIZE
>  	help
>  	  Say Y here to include support for the Philips TEA5761 radio tuner.
>  
>  config TUNER_TEA5767
>  	tristate "TEA 5767 radio tuner"
> -	depends on I2C
> +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	default m if VIDEO_TUNER_CUSTOMIZE
>  	help
>  	  Say Y here to include support for the Philips TEA5767 radio tuner.
>  
>  config TUNER_SIMPLE
>  	tristate "Simple tuner support"
> -	depends on I2C
> +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	select TUNER_TDA9887
>  	default m if VIDEO_TUNER_CUSTOMIZE
>  	help
> @@ -151,7 +151,7 @@ config TUNER_SIMPLE
>  
>  config TUNER_TDA9887
>  	tristate "TDA 9885/6/7 analog IF demodulator"
> -	depends on I2C
> +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
>  	default m if VIDEO_TUNER_CUSTOMIZE
>  	help
>  	  Say Y here to include support for Philips TDA9885/6/7

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

