Return-Path: <linux-kernel-owner+w=401wt.eu-S1759717AbYBYVFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717AbYBYVFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYBYVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:05:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:14213 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYBYVFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:05:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PDJ1Oni6JbbvStGubHSKqcgTrxIr1uylb11Uf95IO+t1lVcg/TJlMqh1R/OxgTXXjSSAqN1D4wnv6+lhs84ENuLzDByjfom+U7c/+OKWKohnT65gscOYxSd/j0rt/ickMT2bi2Xj/cMnO/k9fSGVjW9syisN0Ks3s0HGqI0Yo5g=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Mon, 25 Feb 2008 21:04:32 +0000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <c6b1100b0802220746s3441d28cj92896618bbb57bde@mail.gmail.com> <200802222047.52312.IvDoorn@gmail.com>
In-Reply-To: <200802222047.52312.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802252104.32416.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Firstly apologies for trimming linux-kernel and linux-wireless from my reply 
to Ivo yesterday. Basically, I replied saying that the patch below didn't fix 
the problem. But please do read on...

On Friday 22 February 2008, Ivo van Doorn wrote:
> On Friday 22 February 2008, Chris Clayton wrote:
> > Hi Ivo,
> >
> > On 18/02/2008, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > > Hi,
> >
> > [...]
> >
> > > Above traces should be enough, but to determine where rt2x00 broke
> > >  down approximatly I need to have a few test result on specific
> > > moments. Could you test the kernel with the following versions:
> > >
> > >  rt2x00 2.0.11   2d68de3efa62655d551092f5c787505735d561ad
> > >  rt2x00 2.0.12   a3c7aa58df7df80aa05f166fe3e42482247164cf
> > >  rt2x00 2.0.13   5a6012e105ae1664cd2841c33bf59fbdd8d4dbcc
> > >
> > >  Checking those out is simply a matter of:
> > >  git branch 2.0.11 2d68de3efa62655d551092f5c787505735d561ad
> > >  git checkout 2.0.11
> >
> > OK, we seem to be struggling a little, so I've built an installed git
> > and cloned Linus' 2.6 tree. My wireless network dies after a few pings
> > with rt2x00 2.0.11.
> >
> > >  No further bisecting is needed, but with above tests I can at least
> > >  narrow it down to find the cause of this issue.
> >
> > If you need me to bisect, just shout. Please be patient though, I'm
> > exploring new territory here :-)
>
> I don't think bisecting this will help a lot, the rt2x00 2.0.11 release
> introduced software diversity. And that is already something I suspect
> of being broken.
>
 I've bisected anyway and although the results are not absolutely conclusive, 
as I neared the end of the process, I was amongst a bunch of mac80211 
patches. This set me on a path that resulted in me discovering that with the 
rt61pci driver, I can freeze my wireless network connection almost at will if 
I set mac82011's ieee80211_default_rc_algo parameter to 'pid'. if the 
parametre is set to 'simple', the network seems to be reliable. I've just let 
the ping application run on and ping another box on my network almost 1500 
times whilst repeatedly transferring a kernel source tarball by ftp from 
another box and the network connection was mantained That's with the 
parameter set to 'simple', if \I set it to 'pid' the connection rarely 
survives more than 40 pings even without the ftp activity.

If I replace my wireless card with one that uses the rtl8180 driver, the 
network connection seems to be reliable regardless of how I set the 
parameter, although I admit that i have not tested this extensively yet. I'll 
do that now and report later.

Hope this helps.

Chris

> Unfortunately software diversity was a bugfix and fix in one,
> the previous setup was broken for some hardware since the
> lack of software diversity caused problems.
>
> Could you check if below patch helps in any way?
>
> Ivo
>
> ---
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c
> b/drivers/net/wireless/rt2x00/rt2x00config.c index a1d8e33..6995912 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00config.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00config.c
> @@ -122,6 +122,10 @@ void rt2x00lib_config_antenna(struct rt2x00_dev
> *rt2x00dev, libconf.ant.rx = rx;
>  	libconf.ant.tx = tx;
>
> +	if (rx == rt2x00dev->link.ant.active.rx &&
> +	    tx == rt2x00dev->link.ant.active.tx)
> +		return;
> +
>  	/*
>  	 * Antenna setup changes require the RX to be disabled,
>  	 * else the changes will be ignored by the device.
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c
> b/drivers/net/wireless/rt2x00/rt2x00dev.c index 65a512f..4325c08 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -191,16 +191,16 @@ static void rt2x00lib_evaluate_antenna_sample(struct
> rt2x00_dev *rt2x00dev) return;
>
>  	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) {
> -		if (sample_a > sample_b && rx == ANTENNA_B)
> +		if (sample_a > sample_b)
>  			rx = ANTENNA_A;
> -		else if (rx == ANTENNA_A)
> +		else
>  			rx = ANTENNA_B;
>  	}
>
>  	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY) {
> -		if (sample_a > sample_b && tx == ANTENNA_B)
> +		if (sample_a > sample_b)
>  			tx = ANTENNA_A;
> -		else if (tx == ANTENNA_A)
> +		else
>  			tx = ANTENNA_B;
>  	}
>
> @@ -257,7 +257,7 @@ static void rt2x00lib_evaluate_antenna(struct
> rt2x00_dev *rt2x00dev)
>
>  	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
>  	    !(rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)) {
> -		rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
> +		rt2x00dev->link.ant.flags = 0;
>  		return;
>  	}



-- 
Beauty is in the eye of the beerholder.
