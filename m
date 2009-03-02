Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZCBV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZCBV12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZCBV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:27:18 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:37736 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753325AbZCBV1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:27:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=axuAjO7SDNNp1enzamHwOEdG4kF0lxKXrcmnZIvnyyli2/VTQsmK42HVvE9nE/Gv56XaDYh6EbamfdS30r2NJ0K4TFgFWXNVTh8SvQ7DjT5wkkdoLFkWu4MbrF0ojpmRQqNxFCrfMouC0KsI84TsndoaCQK0SKDyGGBnzyqkBL0=  ;
X-YMail-OSG: UZGqresVM1lGEJqjbDc1avyZyLGIZHr386k1JQzQ6E8ht5VpJ3ZPscrl7iV6JoYZyNQzZ3Y2dntVIhrq4D7BNsA5OY.VgjyJDxuujHxS8W.nYDrETlf2QFYR8Ro6ySWrz5m7D6QB.xR8VLKf8vm8nkQbDWDz5LZ9vadqk9HOpuUUkF1OivfVjW12hqdmL1J6cH19cl6EXxxSBFMiNFvzcsOwmkOAmYFBdNm2vQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Date: Mon, 2 Mar 2009 13:27:13 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261348.30617.david-b@pacbell.net> <20090302215956.3f355eee@mjolnir.ossman.eu>
In-Reply-To: <20090302215956.3f355eee@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021327.14285.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Pierre Ossman wrote:
> On Thu, 26 Feb 2009 13:48:30 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Add optional glue between MMC and regulator stacks, using a new
> > regulator interface to learn what voltages are available.
> > 
> > This is intended to be selected and driven by MMC host adapters.
> > It only handles reusable parts of the regulator-to-MMC glue; the
> > adapter drivers will have access to details that affect how this
> > is used.  Examples include when to use multiple voltage rails or
> > configure (internal or external) level shifters.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> > Changes from previous version:  adapter must select this, and
> > callers now pass in the regulator.  mmc_regulator_set_ocr()
> > is still not tested, mmc_regulator_get_ocrmask() passed sanity
> > testing.
> > 
> > Pierre:  Mark may have a need for this soonish.  The omap_hsmmc
> > code will want it at some point.
> > 
> 
> I have no insight into the regulator stuff, so I'm going to have to
> trust you on this. :)

Works for me.  ;)


> Some nitpicking though:
> 
> > --- a/drivers/mmc/core/Kconfig
> > +++ b/drivers/mmc/core/Kconfig
> > @@ -14,3 +14,10 @@ config MMC_UNSAFE_RESUME
> >  	  This option is usually just for embedded systems which use
> >  	  a MMC/SD card for rootfs. Most people should say N here.
> >  
> > +config MMC_REGULATOR
> > +	bool
> > +	depends on REGULATOR
> > +	help
> > +	  Select this if your MMC host adapter driver wants helper
> > +	  utilities for accessing power rails.
> > +
> 
> Is there a need for a special Kconfig for this? Can't we just build
> these two whenever REGULATOR is defined? Or always, provided the
> regulator API is present even when the code isn't.

The first patch had a "default y" there, nobody commented.
I'll simplify that, and use #ifdef CONFIG_REGULATOR instead.

 
> > +/**
> > + * mmc_regulator_set_ocr - set regulator to match host->ios voltage
> > + * @host: mmc host whose supply voltage will be changed
> > + * @supply: regulator to use
> > + *
> > + * MMC host drivers may use this to enable or disable a regulator using
> > + * a particular supply voltage.  This would normally be called from the
> > + * set_ios() method.
> > + */
> > +int mmc_regulator_set_ocr(struct mmc_host *host, struct regulator *supply)
> > +{
> 
> Why not pass the vdd directly? Saves a few dereferences if nothing else.

This call syntax is simpler, which is usually a win.
Passing a third parameter would create fault paths
of the "pass *wrong* parameter" flavor.

In terms of object code, when I've looked at such things
the dereferences generally cost the same as a ref to a
parameter, but passing an extra parameter isn't free.

- Dave
