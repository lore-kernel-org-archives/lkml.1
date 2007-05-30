Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXE3JKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXE3JKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXE3JKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:10:09 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:6409 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbXE3JKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:10:07 -0400
Date: Wed, 30 May 2007 11:10:03 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Dan Williams" <dan.j.williams@intel.com>
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Kyle McMartin" <kyle@parisc-linux.org>, linux-kernel@vger.kernel.org,
       James.Bottomley@steeleye.com, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>, geert@linux-m68k.org,
       zippel@linux-m68k.org, spyro@f2s.com, uclinux-v850@lsi.nec.co.jp,
       ysato@users.sourceforge.jp
Subject: Re: [patch] Introduce CONFIG_HAS_DMA.
Message-ID: <20070530111003.1d813d74@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <e9c3a7c20705250936n2689c1f3wce8ccb0ee4a22b9e@mail.gmail.com>
References: <20070223005945.GA13084@tuxdriver.com>
	<20070223034243.GA7988@osiris.ibm.com>
	<20070223061332.GB27126@osiris.ibm.com>
	<20070223135740.GA28270@athena.road.mcmartin.ca>
	<20070223143938.GA5815@tuxdriver.com>
	<20070226135743.GB7925@osiris.boeblingen.de.ibm.com>
	<e9c3a7c20705250936n2689c1f3wce8ccb0ee4a22b9e@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 09:36:31 -0700,
"Dan Williams" <dan.j.williams@intel.com> wrote:

> I went back and read the thread leading up to this patch and I am of
> the opinion that John's approach (adding more stubs to
> dma-mapping-broken.h:
> http://marc.info/?l=linux-kernel&m=117219377712232&w=2)  is needed in
> _addition_ to this Kconfig option.  In my particular case I have an
> API with a DMA and a non-DMA path written in such a way that the DMA
> path can be compiled away.  Without dma-mapping-broken.h support the
> API is unnecessarily forced to violate point 2 of
> Documentation/SubmittingPatches (#ifdefs are ugly).

IMO, well-placed #ifdefs are preferrable to dragging non-working code
around. Like:

- put the DMA path in a file only build for MY_STUFF_USE_DMA
- let MY_STUFF select MY_STUFF_USE_DMA if HAS_DMA
- have a header file that points to the implementation for
  MY_STUFF_USE_DMA and uses well defined stubs for !MY_STUFF_USE_DMA,
  like returning ICannotDoThat for check_if_can_do() (kind of like what
  include/linux/sysfs.h does, for example)

This contains the #ifdefs in a header, doesn't compile stuff that won't
work anyway on !HAS_DMA, and adds the ability to disable
MY_STUFF_USE_DMA even if HAS_DMA at a later time if someone wants it.

> In other words let CONFIG_HAS_DMA prevent pure DMA code from being
> built, but do not preclude "clever" implementations from calling
> broken code.

If it calls broken code, it may not be so "clever" after all :)

What I don't like about this is

- compiles stuff that is not needed on !HAS_DMA
- worse, compiles stuff that will not work on !HAS_DMA
- does not encourage to split code properly into a DMA and a non-DMA
  part
