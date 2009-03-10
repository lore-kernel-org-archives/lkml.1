Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZCJONi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZCJONi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZCJONZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:13:25 -0400
Received: from smtp4.welho.com ([213.243.153.38]:41141 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbZCJONY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:13:24 -0400
Date: Tue, 10 Mar 2009 16:13:20 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] drivers/w1/masters/w1-gpio.c: fix read_bit()
Message-ID: <20090310141320.GK10127@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	David Brownell <david-b@pacbell.net>
References: <1236614530-11153-1-git-send-email-daniel@caiaq.de> <20090309191419.98699220.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090309191419.98699220.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 07:14:19PM -0700, Andrew Morton wrote:
> On Mon,  9 Mar 2009 17:02:10 +0100 Daniel Mack <daniel@caiaq.de> wrote:
> 
> > W1 master implementations are expected to return 0 or 1 from their
> > read_bit() function. However, not all platforms do return these values
> > from gpio_get_value() - namely PXAs won't. Hence the w1 gpio-master
> > needs to break the result down to 0 or 1 itself.
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > Cc: Ville Syrjala <syrjala@sci.fi>
> > Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> > ---
> >  drivers/w1/masters/w1-gpio.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
> > index 9e1138a..a411702 100644
> > --- a/drivers/w1/masters/w1-gpio.c
> > +++ b/drivers/w1/masters/w1-gpio.c
> > @@ -39,7 +39,7 @@ static u8 w1_gpio_read_bit(void *data)
> >  {
> >  	struct w1_gpio_platform_data *pdata = data;
> >  
> > -	return gpio_get_value(pdata->pin);
> > +	return gpio_get_value(pdata->pin) ? 1 : 0;
> >  }
> >  
> >  static int __init w1_gpio_probe(struct platform_device *pdev)
> 
> We recently merged a patch (I forget where) which fixed one
> gpio_get_value() implementation so that it always returns 0 or 1.
> 
> From which I deduce that the correct fix for <whatever problem you're
> seeing> is to fix <whichever driver that is>?

The documentation should be fixed to match if that's the desired
behaviour. From Documentation/gpio.txt:
 /* GPIO INPUT:  return zero or nonzero */
 int gpio_get_value(unsigned gpio);

Maybe the gpio_get_value() return value should be changed to bool to
make things clear.

w1 itself is a bit odd as the documentation says that read_bit() must
return 0 or 1, but the core uses it like this 'read_bit() & 0x1'. Not
sure what the idea is here. Perhaps read_bit() returns the contents of
some shift register on some masters. But if the documentation is to be
trusted the '& 0x1' should be moved to the master drivers that need it.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
