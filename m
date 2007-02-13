Return-Path: <linux-kernel-owner+w=401wt.eu-S1030584AbXBMG3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030584AbXBMG3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030651AbXBMG3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:29:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:32100 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030584AbXBMG3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wu/lSZKZCRVqZMIci1Uo/PJ4jYkBdtSio0ZzNJrDmgY1rQdYyG2WTAIacaTJRJdBCqLknxrcy+H4IEtfARXf3e5p4uuUqyVqUAKS5fimNuqMAsRLu3yzuNQHeF+vydbKw9UC1IU/W0keb2dhrwoSwIdq/MXuq7m+EVuK6TG+v0E=
Message-ID: <653402b90702122229l525f0d3ak5c5bc0cd7690fdcc@mail.gmail.com>
Date: Tue, 13 Feb 2007 07:29:17 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH mm] cfag12864b: fix crash when built-in and no parport present
Cc: dwalker@mvista.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070212213557.4b28e567.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070210205123.699abb9c.maxextreme@gmail.com>
	 <20070212213557.4b28e567.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 10 Feb 2007 20:51:23 +0100 Miguel Ojeda <maxextreme@gmail.com>
> wrote:
>
> > Andrew, Daniel who reported the crash has tested this patch and says that
> it works fine avoiding it, so you can merge.
> >
> >
> drivers-add-lcd-support-fix-crash-when-built-in-and-no-parport-present.patch
> > Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
> > ---
> > diff --git a/drivers/auxdisplay/cfag12864b.c
> b/drivers/auxdisplay/cfag12864b.c
> > index 889583d..cb44cb4 100644
> > --- a/drivers/auxdisplay/cfag12864b.c
> > +++ b/drivers/auxdisplay/cfag12864b.c
> > @@ -312,6 +312,17 @@ EXPORT_SYMBOL_GPL(cfag12864b_disable);
> >  EXPORT_SYMBOL_GPL(cfag12864b_isenabled);
> >
> >  /*
> > + * Is the module inited?
> > + */
> > +
> > +static unsigned char cfag12864b_inited;
> > +unsigned char cfag12864b_isinited(void)
> > +{
> > +	return cfag12864b_inited;
> > +}
> > +EXPORT_SYMBOL_GPL(cfag12864b_isinited);
> > +
> > +/*
> >   * Module Init & Exit
> >   */
> >
> > @@ -319,6 +330,13 @@ static int __init cfag12864b_init(void)
> >  {
> >  	int ret = -EINVAL;
> >
> > +	/* ks0108_init() must be called first */
> > +	if (!ks0108_isinited()) {
> > +		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
> > +			"ks0108 is not initialized\n");
> > +		goto none;
> > +	}
> > +
> >  	if (PAGE_SIZE < CFAG12864B_SIZE) {
> >  		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
> >  			"page size (%i) < cfag12864b size (%i)\n",
> > @@ -354,6 +372,7 @@ static int __init cfag12864b_init(void)
> >  	cfag12864b_clear();
> >  	cfag12864b_on();
> >
> > +	cfag12864b_inited = 1;
> >  	return 0;
> >
> >  cachealloced:
> > diff --git a/drivers/auxdisplay/cfag12864bfb.c
> b/drivers/auxdisplay/cfag12864bfb.c
> > index 94765e7..66fafbb 100644
> > --- a/drivers/auxdisplay/cfag12864bfb.c
> > +++ b/drivers/auxdisplay/cfag12864bfb.c
> > @@ -137,7 +137,14 @@ static struct platform_device *cfag12864
> >
> >  static int __init cfag12864bfb_init(void)
> >  {
> > -	int ret;
> > +	int ret = -EINVAL;
> > +
> > +	/* cfag12864b_init() must be called first */
> > +	if (!cfag12864b_isinited()) {
> > +		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
> > +			"cfag12864b is not initialized\n");
> > +		goto none;
> > +	}
> >
> >  	if (cfag12864b_enable()) {
> >  		printk(KERN_ERR CFAG12864BFB_NAME ": ERROR: "
> > @@ -162,6 +169,7 @@ static int __init cfag12864bfb_init(void
> >  		}
> >  	}
> >
> > +none:
> >  	return ret;
> >  }
> >
> > diff --git a/drivers/auxdisplay/ks0108.c b/drivers/auxdisplay/ks0108.c
> > index a637575..e6c3646 100644
> > --- a/drivers/auxdisplay/ks0108.c
> > +++ b/drivers/auxdisplay/ks0108.c
> > @@ -111,6 +111,17 @@ EXPORT_SYMBOL_GPL(ks0108_address);
> >  EXPORT_SYMBOL_GPL(ks0108_page);
> >
> >  /*
> > + * Is the module inited?
> > + */
> > +
> > +static unsigned char ks0108_inited;
> > +unsigned char ks0108_isinited(void)
> > +{
> > +	return ks0108_inited;
> > +}
> > +EXPORT_SYMBOL_GPL(ks0108_isinited);
> > +
> > +/*
> >   * Module Init & Exit
> >   */
> >
> > @@ -142,6 +153,7 @@ static int __init ks0108_init(void)
> >  		goto registered;
> >  	}
> >
> > +	ks0108_inited = 1;
> >  	return 0;
> >
> >  registered:
> > diff --git a/include/linux/cfag12864b.h b/include/linux/cfag12864b.h
> > index 0bc45e6..1605dd8 100644
> > --- a/include/linux/cfag12864b.h
> > +++ b/include/linux/cfag12864b.h
> > @@ -73,5 +73,10 @@ extern void cfag12864b_disable(void);
> >   */
> >  extern unsigned char cfag12864b_isenabled(void);
> >
> > +/*
> > + * Is the module inited?
> > + */
> > +extern unsigned char cfag12864b_isinited(void);
> > +
> >  #endif /* _CFAG12864B_H_ */
> >
> > diff --git a/include/linux/ks0108.h b/include/linux/ks0108.h
> > index 8047d4b..a2c54ac 100644
> > --- a/include/linux/ks0108.h
> > +++ b/include/linux/ks0108.h
> > @@ -43,4 +43,7 @@ extern void ks0108_address(unsigned char
> >  /* Set the controller's current page (0..7) */
> >  extern void ks0108_page(unsigned char page);
> >
> > +/* Is the module inited? */
> > +extern unsigned char ks0108_isinited(void);
> > +
> >  #endif /* _KS0108_H_ */
>
> This looks hacky.
>
> Your patch didn't include a description of the bug (please always include
> such a description) so I'm not sure what's going on here.  But I'm
>

Indeed, sorry. The patch is about "crash on CONFIG_CFAG12864B=y in
2.6.20-rc3-mm1" ( http://lkml.org/lkml/2007/1/7/118 ).

> suspecting that module dependencies and appropriate choice of initcall
> levels is the right way to fix whatever bug this is.
>

The problem comes when ks0108/cfag12864b are built-in and any parallel
port is present. ks0108_init() is called first, as it should be, but
fails to load (as there is no parallel port to use).

After that, cfag12864b_init() gets called, without knowing anything
about ks0108 failed, and calls ks0108_writecontrol(), which
dereferences an uninitialized pointer.

Init order is OK, I think. The problem is how to stop
cfag12864b_init() being called if ks0108 failed to load. modprobe does
it for us, but, how when built-in?

As anybody suggested another solution, I send that patch.

Regards,
Miguel

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
