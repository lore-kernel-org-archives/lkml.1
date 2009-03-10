Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbZCJX7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbZCJX7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZCJX7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:59:34 -0400
Received: from smtp6.welho.com ([213.243.153.40]:53819 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZCJX7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:59:32 -0400
Date: Wed, 11 Mar 2009 01:59:29 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       johnpol@2ka.mipt.ru, david-b@pacbell.net
Subject: Re: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Message-ID: <20090310235929.GN10127@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
	johnpol@2ka.mipt.ru, david-b@pacbell.net
References: <1236614530-11153-1-git-send-email-daniel@caiaq.de> <20090309191419.98699220.akpm@linux-foundation.org> <20090310091800.GC3263@buzzloop.caiaq.de> <20090310150059.ce64548a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090310150059.ce64548a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 03:00:59PM -0700, Andrew Morton wrote:
> On Tue, 10 Mar 2009 10:18:00 +0100
> Daniel Mack <daniel@caiaq.de> wrote:
> 
> > On Mon, Mar 09, 2009 at 07:14:19PM -0700, Andrew Morton wrote:
> > > > --- a/drivers/w1/masters/w1-gpio.c
> > > > +++ b/drivers/w1/masters/w1-gpio.c
> > > > @@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
> > > >  {
> > > >  	struct w1_gpio_platform_data *pdata = data;
> > > >  
> > > > -	return gpio_get_value(pdata->pin);
> > > > +	return gpio_get_value(pdata->pin) ? 1 : 0;
> > > >  }
> > > >  
> > > >  static int __init w1_gpio_probe(struct platform_device *pdev)
> > > 
> > > We recently merged a patch (I forget where) which fixed one
> > > gpio_get_value() implementation so that it always returns 0 or 1.
> > > 
> > > From which I deduce that the correct fix for <whatever problem you're
> > > seeing> is to fix <whichever driver that is>?
> > 
> > I agree those functions should return 0 and 1 only, but my patch fixes
> > the w1-gpio driver for all platforms at once, so people can use it.
> > 
> > On the other hand, I will submit a patch which modifies PXA's
> > gpio_get_value() and see what the maintainers say, but I can't go thru
> > all the implemenations of all architectures to do this.
> > 
> > So for the time being, the above patch helps many users of that driver.
> > 
> 
> Problem is, the patch will just conceal bugs.
> 
> How about this?
> 
> --- a/drivers/w1/masters/w1-gpio.c~a
> +++ a/drivers/w1/masters/w1-gpio.c
> @@ -38,8 +38,12 @@ static void w1_gpio_write_bit_val(void *
>  static u8 w1_gpio_read_bit(void *data)
>  {
>  	struct w1_gpio_platform_data *pdata = data;
> +	u8 ret;
>  
> -	return gpio_get_value(pdata->pin);
> +	ret = gpio_get_value(pdata->pin);
> +	if (WARN_ONCE(ret > 1, "gpio_get_value(): invalid return: %u\n", ret))
> +		ret = !!ret
> +	return ret;
>  }
>  
>  static int __init w1_gpio_probe(struct platform_device *pdev)

I think if you want to go that route you should add such check into
gpiolib rather than some random driver.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
