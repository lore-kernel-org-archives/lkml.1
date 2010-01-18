Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612Ab0ARR0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0ARR0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377Ab0ARR0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:26:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39085 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab0ARR0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:26:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Im4JqitSz0ilDdDfNeq7Oh2VbwghtxL0Qm4hHq0AUZ+0eNwJUzlWR7SeuNKlQilF80
         vo6Aqayl8J5+c3rakptnjwCQ9ruL/EC1xt3/9zRzAUWITZvPMQGtbUjtvA+QognZkluo
         IgO2ltCHnD/RRT+uyPI023Ho2bOCzK2g/OcDA=
Subject: Re: [PATCH] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20100118163212.GA32045@rakim.wolfsonmicro.main>
References: <1263830523.3632.22.camel@realization>
	 <20100118163212.GA32045@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 18:26:10 +0100
Message-ID: <1263835570.3632.33.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun, 2010-01-18 at 16:32 +0000, Mark Brown wrote:
> On Mon, Jan 18, 2010 at 05:02:03PM +0100, Alberto Panizzo wrote:
> 
> > +int mc13783_state_powermisc_pwgt;
> > +int mc13783_reg_rmw_powermisc(struct mc13783 *mc13783, u32 mask, u32 val)
> 
> You're missing some statics here and some whitespace to separate the
> function from the variable.

Ok, mc13783_state_powermisc_pwgt will be static (and u32..)

> 
> > +	/* Update the stored state for Power Gates.
> > +	 * As from specs the meaning is inverted (0: en, 1: dis) */
> > +	if (mask & MC13783_REG_POWERMISC_PWGTSPI_M)
> > +		mc13783_state_powermisc_pwgt =
> > +			(mc13783_state_powermisc_pwgt & ~mask) |
> > +			((val ^ mask) & MC13783_REG_POWERMISC_PWGTSPI_M);
> 
> Could this code be written in a clearer fashion?  The bit manipluation
> isn't entirely obvious, especially given the multiple masks in use...

Something like this?
        if (mask & MC13783_REG_POWERMISC_PWGTSPI_M) {
                u32 new_state = (val & MC13783_REG_POWERMISC_PWGTSPI_M) ^ mask;

                mc13783_state_powermisc_pwgt =
                        (mc13783_state_powermisc_pwgt & ~mask) | new_state;
        }

I use the EXOR with one to negate bits.
The state stored in mc13783_state_powermisc_pwgt would be what the next 
functions write.

> 
> > +	ret = mc13783_reg_read(mc13783, MC13783_REG_POWERMISC, &valread);
> > +	if (ret)
> > +		return ret;
> > +
> > +	valread = (valread & ~mask) | val;
> > +
> > +	/* Re propose the stored state for Power Gates */
> > +	valread = (valread & ~MC13783_REG_POWERMISC_PWGTSPI_M) |
> > +						mc13783_state_powermisc_pwgt;
> 
> ...and this further mainpulation.

What is obscure in this? it is the same operation as the previous
MC13783_REG_POWERMISC_PWGTSPI_M is the mask for PWGT1 and 2 bits and in 
mc13783_state_powermisc_pwgt there is the stored state for those two
bits.


