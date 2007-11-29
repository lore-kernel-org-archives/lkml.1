Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXK2Vz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXK2Vz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933384AbXK2Vyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:54:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45148 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbXK2Vyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:54:50 -0500
Date: Thu, 29 Nov 2007 13:53:04 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: kobject_init rewrite
Message-ID: <20071129215304.GA5043@kroah.com>
References: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org> <1196352280.3118.11.camel@lov.site> <20071129172134.74849579@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129172134.74849579@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:21:34PM +0100, Cornelia Huck wrote:
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> >   int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)
> 
> Agreed. Better don't hide too much.


Ok, how about this function.  If it errors out, it is free to just call
kfree() on the kobject.  Seems simple enough to me, any objections?  If
not, I'll go through and fix up the whole tree...

thanks,

greg k-h

-----------------

/**
 * kobject_init - initialize a kobject structure
 * @kobj: pointer to the kobject to initialize
 * @ktype: pointer to the ktype for this kobject.
 * @fmt: the name of the kobject
 *
 * This function will properly initialize a kobject such that it can then
 * be passed to the kobject_add() call.
 *
 * If the function returns an error, the memory allocated by the kobject
 * can be safely freed, no other functions need to be called.
 */
int kobject_init(struct kobject *kobj, struct kobj_type *ktype, const char *fmt, ...)
{
	va_list args;
	int retval;

	if (!kobj)
		return -EINVAL;

	if (!ktype)
		return -EINVAL;

	WARN_ON(atomic_read(&kobj->kref.refcount));
	kref_init(&kobj->kref);
	INIT_LIST_HEAD(&kobj->entry);
	kobj->ktype = ktype;

	va_start(args, fmt);
	retval = kobject_set_name_vargs(kobj, fmt, args);
	va_end(args);

	return retval;
}

