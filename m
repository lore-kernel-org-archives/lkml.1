Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbYCZQxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbYCZQxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbYCZQwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:52:40 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:39611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbYCZQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aTujpfMm6qETJ2oWkhvghqk+zLX6joW8yVItr3oq4CJxxJKuprUjfzI6UTkzKCFbLweedmBhfi2oOUenKGX1lo4USX0MTPrzqLGcze77D/sYu0XJddPXf40Tv7+1yqOcB2HzVNIQ0epzi7Vm3QzmbNXUA4SxCJ43t15mUhTjX84=
Message-ID: <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
Date: Wed, 26 Mar 2008 19:52:34 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, domen.puncer@telargo.com, lethal@linux-sh.org,
       tony@atomide.com, rmk+kernel@arm.linux.org.uk, paul@pwsan.com
In-Reply-To: <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	 <20080326155203.GA15405@doriath.ww600.siemens.net>
	 <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/26, Haavard Skinnemoen <haavard.skinnemoen@atmel.com>:
> On Wed, 26 Mar 2008 18:52:03 +0300
>  Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>
>  > +struct clk {
>  > +     struct list_head node;
>  > +     struct clk      *parent;
>  > +
>  > +     const char      *name;
>  > +     struct module   *owner;
>  > +
>  > +     int             users;
>  > +     unsigned long   rate;
>  > +     int             delay;
>  > +
>  > +     int (*can_get)  (struct clk *, struct device *);
>  > +     int (*set_parent) (struct clk *, struct clk *);
>  > +     int (*enable)   (struct clk *);
>  > +     void (*disable) (struct clk *);
>  > +     unsigned long (*getrate) (struct clk*);
>  > +     int (*setrate)  (struct clk *, unsigned long);
>  > +     long (*roundrate) (struct clk *, unsigned long);
>  > +
>  > +     void            *priv;
>  > +};
>
>
> Hmm...this is exactly twice as big as the struct I'm currently using,
>  it doesn't contain all the fields I need, and it's undocumented.

I've added a more sofisticated arch convertion patch (the clocklib for
ARM PXA chips).

Basically mode becomes enable/disable (however it may be better to merge back
those pointers into one function). And dev and index go to priv data.

The documentation will come later.

>
>  I have quite a few clocks, so the increased memory consumption is quite
>  significant. What are the advantages of this?

At maximum 55, IIUC. I counted 32 or so additional bytes in the struct
(over avr32-specific one). That would count up to 1.5 K overhead. Is
that really too much for current kernels?


OTOH this would bring unification of platform code, allow
configurations when a non-platform driver would provide it's own
clocks (think about multi-function companion chips when there is a
"core" which manages "clocks" for it's "periferal" devices. Currently
if one tries to implement such driver, he is forced to either bind it
to platform code, or to implement non-standard
my_device_clock_enable()-like functions.

Also you aren't forced to use this API. simply don't select
HAVE_CLOCK_LIB and leave
all things as they are. E.g. gpiolib is now merged, however not all
gpio-providing platforms
are using it.

-- 
With best wishes
Dmitry
