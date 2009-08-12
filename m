Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZHLQQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZHLQQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZHLQQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:16:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42174 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbZHLQQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:16:02 -0400
Subject: Re: Libertas: Association request to the driver failed
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Roel Kluin <roel.kluin@gmail.com>, Daniel Mack <daniel@caiaq.de>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090811182426.GE2634@tuxdriver.com>
References: <20090807191156.GS19257@buzzloop.caiaq.de>
	 <20090807193610.GK7545@tuxdriver.com>
	 <20090808123512.GZ19257@buzzloop.caiaq.de> <4A7D8AB6.9030707@gmail.com>
	 <4A7E9596.4070901@gmail.com> <20090809102417.GH13639@buzzloop.caiaq.de>
	 <4A7EAED8.9090900@gmail.com> <20090810175939.GH2733@tuxdriver.com>
	 <4A811776.8090003@gmail.com>  <20090811182426.GE2634@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 11:15:37 -0500
Message-Id: <1250093737.31650.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 14:24 -0400, John W. Linville wrote:
> Comments from the libertas crowd?  This seems a bit long for this
> part of the cycle.
> 
> Should we just revert the original patch, then reapply it with this
> one for 2.6.32?

I'd feel more comfortable with that.  Roel did find a real problem, but
we need to make sure the fix doesn't break stuff since it appears the
rate code is more complicated than we thought.

Dan


> John
> 
> On Tue, Aug 11, 2009 at 09:02:14AM +0200, Roel Kluin wrote:
> > The size of the tmp buffer was too small, causing a regression
> > 
> > rates->rates has an arraysize of 1, so a memcpy with
> > MAX_RATES (14) was already causing reads out of bounds.
> > 
> > In get_common_rates() the memset/memcpy can be moved upwards.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > Tested-by: Daniel Mack <daniel@caiaq.de>
> > ---
> > > Delta patch, please...
> > 
> > Here,
> > 
> > diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> > index d699737..ba0164a 100644
> > --- a/drivers/net/wireless/libertas/assoc.c
> > +++ b/drivers/net/wireless/libertas/assoc.c
> > @@ -44,8 +44,8 @@ static int get_common_rates(struct lbs_private *priv,
> >  	u16 *rates_size)
> >  {
> >  	u8 *card_rates = lbs_bg_rates;
> > -	int ret = 0, i, j;
> > -	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
> > +	int i, j;
> > +	u8 tmp[MAX_RATES * ARRAY_SIZE(lbs_bg_rates)];
> >  	size_t tmp_size = 0;
> >  
> >  	/* For each rate in card_rates that exists in rate1, copy to tmp */
> > @@ -62,20 +62,23 @@ static int get_common_rates(struct lbs_private *priv,
> >  	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
> >  	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
> >  
> > +	memset(rates, 0, *rates_size);
> > +	*rates_size = min_t(u16, tmp_size, *rates_size);
> > +	memcpy(rates, tmp, *rates_size);
> > +
> >  	if (!priv->enablehwauto) {
> >  		for (i = 0; i < tmp_size; i++) {
> >  			if (tmp[i] == priv->cur_rate)
> > -				goto done;
> > +				break;
> > +		}
> > +		if (i == tmp_size) {
> > +			lbs_pr_alert("Previously set fixed data rate %#x isn't "
> > +					"compatible with the network.\n",
> > +					priv->cur_rate);
> > +			return -1;
> >  		}
> > -		lbs_pr_alert("Previously set fixed data rate %#x isn't "
> > -		       "compatible with the network.\n", priv->cur_rate);
> > -		ret = -1;
> >  	}
> > -done:
> > -	memset(rates, 0, *rates_size);
> > -	*rates_size = min_t(int, tmp_size, *rates_size);
> > -	memcpy(rates, tmp, *rates_size);
> > -	return ret;
> > +	return 0;
> >  }
> >  
> >  
> > @@ -319,8 +322,8 @@ static int lbs_associate(struct lbs_private *priv,
> >  
> >  	rates = (struct mrvl_ie_rates_param_set *) pos;
> >  	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
> > -	memcpy(&rates->rates, &bss->rates, MAX_RATES);
> >  	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
> > +	memcpy(&rates->rates, &bss->rates, tmplen);
> >  	if (get_common_rates(priv, rates->rates, &tmplen)) {
> >  		ret = -1;
> >  		goto done;
> > 
> 

