Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbZB0V7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbZB0V7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZB0V6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:58:51 -0500
Received: from n27.bullet.mail.mud.yahoo.com ([68.142.206.222]:25618 "HELO
	n27.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754801AbZB0V6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:58:50 -0500
X-Yahoo-Newman-Id: 840783.8505.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ylRrwMYgGFGPbF7M9lsKC6CL/GkgP72itYu0vxsXrw4GBh5LAeE4VdpjqQcsDxFR9TT/PTqK2mwjM7BxcKANaVQj02CIMvZRnaERTYSzm1lqTPmkgl+VCirqV+K8qGkS1axUjzUaKvSNqwoDipX8RCFD0dwVoHxISpy/ho0xwMA=  ;
X-YMail-OSG: hHa3x.AVM1n.T8uEYNN9YrPd8spFaeEkeflhH98462Q7sePavqLOcl3zDCLAEMx1IoxfspQGQpNaoMgKNBqvG9gXrDXWB79N2nk6MD.0a5y2kOZ3RMjlCw4bRM.i7AmLYeYX5iDfRzmXq8il0R7ckVe3
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mfd: twl4030: add twl4030-pwrbutton as our child
Date: Fri, 27 Feb 2009 13:58:46 -0800
User-Agent: KMail/1.9.10
Cc: Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <1235762883-20870-2-git-send-email-me@felipebalbi.com> <20090227123649.d2d6408c.akpm@linux-foundation.org>
In-Reply-To: <20090227123649.d2d6408c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902271358.46863.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 February 2009, Andrew Morton wrote:
> > --- a/drivers/mfd/twl4030-core.c
> > +++ b/drivers/mfd/twl4030-core.c
> > @@ -101,6 +101,12 @@
> >  #define twl_has_usb()        false
> >  #endif
> >  
> > +#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
> > +     || defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
> 
> OK, this is "wrong".  The core shouldn't need to know about specific
> clients.

This is a pretty standard idiom:  only create the device
nodes a system actually uses.  Applied comprehensively,
the kernel footprint shrinks ... supporting a device can
require a lot of ancillary infrastructure, which may not
need to be compiled in.


> > +#define twl_has_pwrbutton()  true
> > +#else
> > +#define twl_has_pwrbutton()  false
> > +#endif
> >  
> >  /* Triton Core internal information (BEGIN) */
> >  
> > @@ -526,6 +532,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
> >               usb_transceiver = child;
> >       }
> >  
> > +     if (twl_has_pwrbutton()) {
> > +             child = add_child(1, "twl4030_pwrbutton",
> > +                             NULL, 0, true, pdata->irq_base + 8 + 0, 0);
> > +             if (IS_ERR(child))
> > +                     return PTR_ERR(child);
> > +     }
> > +
> >       if (twl_has_regulator()) {
> >               /*
> >               child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
> 
> The client module should register itself with the core, rather than the core
> registering the client.
> 
> What has gone wrong here?

Not much I can see.  It's registering a platform_device,
but only if it could be used on this system.  Quite a lot
of OMAP3 boards don't hook up this power button.

Maybe it should also verify that *this* board supports
a power button.  A boolean flag in the twl4030 platform
data would suffice, for multi-board kernels.

- Dave
 



