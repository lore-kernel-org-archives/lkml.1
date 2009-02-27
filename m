Return-Path: <linux-kernel-owner+w=401wt.eu-S1761486AbZB0WJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486AbZB0WJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbZB0WJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:09:36 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:33629 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbZB0WJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:09:34 -0500
Date: Sat, 28 Feb 2009 00:09:23 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       sameo@openedhand.com
Subject: Re: [PATCH 2/2] mfd: twl4030: add twl4030-pwrbutton as our child
Message-ID: <20090227220923.GN16801@frodo>
Reply-To: me@felipebalbi.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <1235762883-20870-2-git-send-email-me@felipebalbi.com> <20090227123649.d2d6408c.akpm@linux-foundation.org> <200902271358.46863.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200902271358.46863.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 01:58:46PM -0800, David Brownell wrote:
> On Friday 27 February 2009, Andrew Morton wrote:
> > > --- a/drivers/mfd/twl4030-core.c
> > > +++ b/drivers/mfd/twl4030-core.c
> > > @@ -101,6 +101,12 @@
> > >  #define twl_has_usb()        false
> > >  #endif
> > >  
> > > +#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
> > > +     || defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
> > 
> > OK, this is "wrong".  The core shouldn't need to know about specific
> > clients.
> 
> This is a pretty standard idiom:  only create the device
> nodes a system actually uses.  Applied comprehensively,
> the kernel footprint shrinks ... supporting a device can
> require a lot of ancillary infrastructure, which may not
> need to be compiled in.
> 
> 
> > > +#define twl_has_pwrbutton()  true
> > > +#else
> > > +#define twl_has_pwrbutton()  false
> > > +#endif
> > >  
> > >  /* Triton Core internal information (BEGIN) */
> > >  
> > > @@ -526,6 +532,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
> > >               usb_transceiver = child;
> > >       }
> > >  
> > > +     if (twl_has_pwrbutton()) {
> > > +             child = add_child(1, "twl4030_pwrbutton",
> > > +                             NULL, 0, true, pdata->irq_base + 8 + 0, 0);
> > > +             if (IS_ERR(child))
> > > +                     return PTR_ERR(child);
> > > +     }
> > > +
> > >       if (twl_has_regulator()) {
> > >               /*
> > >               child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
> > 
> > The client module should register itself with the core, rather than the core
> > registering the client.
> > 
> > What has gone wrong here?
> 
> Not much I can see.  It's registering a platform_device,
> but only if it could be used on this system.  Quite a lot
> of OMAP3 boards don't hook up this power button.
> 
> Maybe it should also verify that *this* board supports
> a power button.  A boolean flag in the twl4030 platform
> data would suffice, for multi-board kernels.

something like the following should be enough then:

============== cut here ===================
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index c86bc3b..714073f 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -532,7 +532,7 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
                usb_transceiver = child;
        }
 
-       if (twl_has_pwrbutton()) {
+       if (twl_has_pwrbutton() && pdata->pwrbutton) {
                child = add_child(1, "twl4030_pwrbutton",
                                NULL, 0, true, pdata->irq_base + 8 + 0, 0);
                if (IS_ERR(child))
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 8137f66..277451e 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -293,6 +293,8 @@ struct twl4030_platform_data {
        struct regulator_init_data              *vaux3;
        struct regulator_init_data              *vaux4;
 
+       bool                                    pwrbutton;
+
        /* REVISIT more to come ... _nothing_ should be hard-wired */
 };
 

-- 
balbi
