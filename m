Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZIROfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZIROfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZIROfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:35:53 -0400
Received: from trinity.fluff.org ([89.16.178.74]:55948 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbZIROfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:35:52 -0400
Date: Fri, 18 Sep 2009 15:35:54 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jon Ringle <jon@ringle.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] i2c: Move i2c request_irq so that it occurs after iop3xx_i2c_enable
Message-ID: <20090918143554.GR24720@trinity.fluff.org>
References: <1253281871-28243-1-git-send-email-jon@ringle.org> <alpine.LNX.2.00.0909181631260.17028@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0909181631260.17028@wotan.suse.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 04:32:04PM +0200, Jiri Kosina wrote:
> On Fri, 18 Sep 2009, Jon Ringle wrote:
> 
> > If there is a pending i2c interrupt present before i2c-iop3xx initialization
> > then it must be cleared first before registering irq handler. Otherwise,
> > a hung system due to an unhandled interrupt loop may occur.
> 
> Hi Jon,
> 
> this doesn't really qualify for trivial tree. I am adding Jean Delvare to 
> CC.

I'm the correct one to add, will probably be doing a push over the weekend
so will add it to my i2c next tree.
 
> > Signed-off-by: Jon Ringle <jon@ringle.org>
> > 
> > ---
> >  drivers/i2c/busses/i2c-iop3xx.c |   16 ++++++++--------
> >  1 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-iop3xx.c b/drivers/i2c/busses/i2c-iop3xx.c
> > index a75c75e..e6dc46d 100644
> > --- a/drivers/i2c/busses/i2c-iop3xx.c
> > +++ b/drivers/i2c/busses/i2c-iop3xx.c
> > @@ -471,14 +471,6 @@ iop3xx_i2c_probe(struct platform_device *pdev)
> >  		ret = -ENXIO;
> >  		goto unmap;
> >  	}
> > -	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
> > -				pdev->name, adapter_data);
> > -
> > -	if (ret) {
> > -		ret = -EIO;
> > -		goto unmap;
> > -	}
> > -
> >  	memcpy(new_adapter->name, pdev->name, strlen(pdev->name));
> >  	new_adapter->owner = THIS_MODULE;
> >  	new_adapter->class = I2C_CLASS_HWMON | I2C_CLASS_SPD;
> > @@ -497,6 +489,14 @@ iop3xx_i2c_probe(struct platform_device *pdev)
> >  	iop3xx_i2c_reset(adapter_data);
> >  	iop3xx_i2c_enable(adapter_data);
> >  
> > +	ret = request_irq(irq, iop3xx_i2c_irq_handler, 0,
> > +				pdev->name, adapter_data);
> > +
> > +	if (ret) {
> > +		ret = -EIO;
> > +		goto unmap;
> > +	}
> > +
> >  	platform_set_drvdata(pdev, new_adapter);
> >  	new_adapter->algo_data = adapter_data;
> >  
> > -- 
> > tg: (74fca6a..) t/isc-31/i2c-request_irq-iop3xx_i2c_enable-reorder (depends on: b2.6.31.y)
> > 
> 
> -- 
> Jiri Kosina
> SUSE Labs, Novell Inc.

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

