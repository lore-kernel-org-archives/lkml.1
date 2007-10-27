Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXJ0Vf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXJ0Vf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXJ0Vfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:35:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXJ0Vfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:35:52 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1193519317.5776.14.camel@lov.site>
References: <1193410087.6914.34.camel@twins>
	 <1193411451.2431.13.camel@lov.site> <1193412147.27652.2.camel@twins>
	 <1193412788.2431.22.camel@lov.site> <1193412836.27652.11.camel@twins>
	 <1193414147.2431.35.camel@lov.site> <1193429066.5648.35.camel@lappy>
	 <1193447889.5648.44.camel@lappy> <20071027024033.GB29039@kroah.com>
	 <1193474399.27652.15.camel@twins>  <20071027160203.GA5709@kroah.com>
	 <1193519317.5776.14.camel@lov.site>
Content-Type: text/plain
Date: Sat, 27 Oct 2007 23:35:45 +0200
Message-Id: <1193520945.27652.36.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-27 at 23:08 +0200, Kay Sievers wrote:
> On Sat, 2007-10-27 at 09:02 -0700, Greg KH wrote:

> > Ah, I see a few problems.  Here, try this version instead.  It's
> > compile-tested only, and should be a lot simpler.
> > 
> > Note, we still are not setting the parent to the new bdi structure
> > properly, so the devices will show up in /sys/devices/virtual/ instead
> > of in their proper location.  To do this, we need the parent of the
> > device, which I'm not so sure what it should be (block device?  block
> > device controller?)
> 
> Assigning a parent device will only work with the upcoming conversion of
> the raw kobjects in the block subsystem to "struct device".
> 
> A few comments to the patch:
> 
> > --- a/include/linux/string.h
> > +++ b/include/linux/string.h
> > @@ -8,6 +8,7 @@
> >  #include <linux/compiler.h>	/* for inline */
> >  #include <linux/types.h>	/* for size_t */
> >  #include <linux/stddef.h>	/* for NULL */
> > +#include <stdarg.h>
> >  
> >  #ifdef __cplusplus
> >  extern "C" {
> > @@ -111,6 +112,9 @@ extern void *kmemdup(const void *src, si
> >  extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
> >  extern void argv_free(char **argv);
> >  
> > +char *kvprintf(const char *fmt, va_list args);
> > +char *kprintf(const char *fmt, ...);
> 
> Why is that here? I don't think we need this when we use the existing:
>   kvasprintf(GFP_KERNEL, fmt, args)

Ignorance of the existance of said function. Thanks for pointing it out.
(kobject_set_name ought to use it too I guess)

> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> 
> > +
> > +static struct device_attribute bdi_dev_attrs[] = {
> > +	__ATTR(readahead, 0644, readahead_show, readahead_store),
> > +	__ATTR_RO(reclaimable),
> > +	__ATTR_RO(writeback),
> > +	__ATTR_RO(dirty),
> > +	__ATTR_RO(bdi_dirty),
> > +};
> 
> Default attributes will need the NULL termination back (see below).
> 
> > +static __init int bdi_class_init(void)
> > +{
> > +	bdi_class = class_create(THIS_MODULE, "bdi");
> > +	return 0;
> > +}
> > +
> > +__initcall(bdi_class_init);
> > +
> > +int bdi_register(struct backing_dev_info *bdi, const char *fmt, ...)
> 
> This function should accept a: "struct device *parent" and all callers
> just pass NULL until the block layer conversion gets merged.

Yeah, you're right, but I wanted to just get something working before
bothering with the parent thing.

> > +{
> > +	char *name;
> > +	va_list args;
> > +	int ret = -ENOMEM;
> > +	int i;
> > +
> > +	va_start(args, fmt);
> > +	name = kvprintf(fmt, args);
> 
> kvasprintf(GFP_KERNEL, fmt, args);
> 
> > +	va_end(args);
> > +
> > +	if (!name)
> > +		return -ENOMEM;
> > +
> > +	bdi->dev = device_create(bdi_class, NULL, MKDEV(0,0), name);
> 
> The parent should be passed here.
> 
> > +	for (i = 0; i < ARRAY_SIZE(bdi_dev_attrs); i++) {
> > +		ret = device_create_file(bdi->dev, &bdi_dev_attrs[i]);
> > +		if (ret)
> > +			break;
> > +	}
> > +	if (ret) {
> > +		while (--i >= 0)
> > +			device_remove_file(bdi->dev, &bdi_dev_attrs[i]);
> > +		device_unregister(bdi->dev);
> > +		bdi->dev = NULL;
> > +	}
> 
> All this open-coded attribute stuff should go away and be replaced by:
>   bdi_class->dev_attrs = bdi_dev_attrs;
> Otherwise at event time the attributes are not created and stuff hooking
> into the events will not be able to set values. Also, the core will do
> proper add/remove and error handling then.

ok, that's good to know. someone ought to write a book on how to use all
this... really, even the functions are bare of documentation or
comments.

