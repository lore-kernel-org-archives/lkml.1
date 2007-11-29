Return-Path: <linux-kernel-owner+w=401wt.eu-S1763939AbXK2V50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763939AbXK2V50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933770AbXK2Vz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:55:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38726 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750AbXK2Vz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:55:58 -0500
Date: Thu, 29 Nov 2007 13:54:55 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kobject_init rewrite
Message-ID: <20071129215455.GB5043@kroah.com>
References: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org> <1196352280.3118.11.camel@lov.site> <20071129172134.74849579@gondolin.boeblingen.de.ibm.com> <20071129215304.GA5043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129215304.GA5043@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One minor documentation update:

> /**
>  * kobject_init - initialize a kobject structure
>  * @kobj: pointer to the kobject to initialize
>  * @ktype: pointer to the ktype for this kobject.
>  * @fmt: the name of the kobject
>  *
>  * This function will properly initialize a kobject such that it can then
>  * be passed to the kobject_add() call.
>  *
>  * If the function returns an error, the memory allocated by the kobject
>  * can be safely freed, no other functions need to be called.

If the function does not return an error, the only way the kobject's
memory can be properly freed is with a call to kobject_put().  kfree()
should never be called on a kobject after this function has been called,
execept from the ktype's release function.

>  */
> int kobject_init(struct kobject *kobj, struct kobj_type *ktype, const char *fmt, ...)
> {
> 	va_list args;
> 	int retval;
> 
> 	if (!kobj)
> 		return -EINVAL;
> 
> 	if (!ktype)
> 		return -EINVAL;
> 
> 	WARN_ON(atomic_read(&kobj->kref.refcount));
> 	kref_init(&kobj->kref);
> 	INIT_LIST_HEAD(&kobj->entry);
> 	kobj->ktype = ktype;
> 
> 	va_start(args, fmt);
> 	retval = kobject_set_name_vargs(kobj, fmt, args);
> 	va_end(args);
> 
> 	return retval;
> }
> 
