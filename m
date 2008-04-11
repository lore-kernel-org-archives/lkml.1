Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYDKJZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYDKJZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 05:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbYDKJZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 05:25:01 -0400
Received: from www.tglx.de ([62.245.132.106]:49538 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758348AbYDKJZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 05:25:00 -0400
Date: Fri, 11 Apr 2008 11:24:50 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] UIO: generic platform driver
Message-ID: <20080411092449.GB3185@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411062106.GA18096@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:21:06AM +0200, Uwe Kleine-König wrote:
> Hello Hans,
> 
> Hans J. Koch wrote:
> > > +/* XXX: I thought there already exists something like STRINGIFY, but I could not
> > > + * find it ...
> > > + */
> > 
> > Why do you want that macro? You only use it once. The macro definition and the
> > comment above are more than you can ever expect to save with it.
> See below.
> BTW, I found it, it's in linux/stringify.h.  And there are several
> possible users:

All right, I won't argue about this one. If you like it, use it.

> 
> > > +static int uio_pdrv_open(struct uio_info *info, struct inode *inode)
> > > +{
> > > +	struct uio_platdata *pdata = info->priv;
> > > +	int ret;
> > > +
> > > +	BUG_ON(pdata->uioinfo != info);
> > 
> > How can this BUG ever be triggered?
> I hope it cannot, that's why it is a bug if it happens. :-)  And one
> should expect that no BUG_ON should ever be triggered.  I usually use
> BUG_ON for "declaring" preconditions.

OK, as this is a generic driver where we don't know what crap people
will pass in, it might be justified. OK.

>  
> > > +	for (i = 0; i < pdev->num_resources; ++i) {
> > > +		struct resource *r = &pdev->resource[i];
> > 
> > Please don't define new variables in the middle of a function.
> This is a matter of taste.  In my eyes it's better to declare it here
> because then it's easier to see where it's used.

No. It's more important to see which variables are declared in the
function and which are declared elsewhere. If you have to search the
whole body of a function for possible declarations, this is BAD. And if
it's not clear where a variable is used, the function is too long or has
other style problems. Your function is short and clean, so where's the
problem? Please move the declaration to the top of the function.

>  
> > > +
> > > +		if (r->flags != IORESOURCE_MEM)
> > > +			continue;
> > > +
> > > +		if (uiomem >= &uioinfo->mem[MAX_UIO_MAPS]) {
> > 
> > I'd prefer this:
> > 		if (i >= MAX_UIO_MAPS) {
> > 		...
> OK.
> 
> BTW would you be open to redefine uio_info as:
> 
> 	struct uio_info {
> 		struct uio_device       *uio_dev;
> 		...
> 		size_t			num_memmaps;
> 		struct uio_mem		mem[];
> 	}
> 
> This allows to allocate exactly the number of members in the mem array
> that are needed (for the cost of a size_t).  (You just do:
> 
> 	uio_info uioinfo = kzalloc(sizeof(*uioinfo) + num_memmaps * sizeof(uioinfo->mem[0]), GFP_KERNEL);
> 
> it's still one chunk of memory and usage is similar---just with
> MAX_UIO_MAPS substituted by uioinfo->num_memmaps.)

I don't like it. It makes things more complicated without any obvious
gain. sizeof(struct uio_info) would return wrong values, you need to
free the extra memory, userspace applications need to be able to deal
with 10000 mappings...

If there's an actual usecase where 5 mappings are not enough, we can
talk about increasing MAX_UIO_MAPS to some other value.

> 	
> > > +			dev_warn(&pdev->dev, "device has more than "
> > > +					STRINGIFY(MAX_UIO_MAPS)
> > > +					" I/O memory resources.\n");
> > 
> > What about this:
> > 
> > 			dev_warn(&pdev->dev, "device has more than %d"
> > 				" I/O memory resources.\n", MAX_UIO_MAPS);
> > 
> > would save the macro.
> The macro is for free, using "%d" is not:
> 
> 	ukleinek@zentaur:~/kbuild-ns921x$ size drivers/uio/uio_pdrv_with*
> 	   text    data     bss     dec     hex filename
> 	    808      72       0     880     370 drivers/uio/uio_pdrv_withoutstringify.o
> 	    800      72       0     872     368 drivers/uio/uio_pdrv_withstringify.o
> 
> You might consider that a bit over-engineered :-)

As I said above, feel free to use it.

> 
> > > +	ret = uio_register_device(&pdev->dev, pdata->uioinfo);
> > > +
> > > +	if (ret) {
> > > +		clk_put(pdata->clk);
> > > +err_clk_get:
> > > +
> > > +		kfree(pdata);
> > > +err_alloc_pdata:
> > > +err_uioinfo:
> > > +		return ret;
> > > +	}
> > 
> > How I hate labels within blocks... OK, I admit, it looks good here...
> > Well...
> That's a matter of taste, too, I like it that way.  Probably it doesn't
> matter for the compiler (I havn't tried), but this way it's one goto
> less.  And if it doesn't matter for the compiler it's at least nice for
> the reader.  Though obviously YMMV.

As I said, it looks OK here. You can keep it if you like it.

I'd like to thank you for your work. After giving it some thought, I
really like the idea of having a generic UIO driver for platform
devices. I think many people (including /me) will use it. So, please send
an updated patch, I think we should push it to mainline.

Thanks,
Hans
