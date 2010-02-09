Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab0BIRXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:23:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:42324 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0BIRXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:23:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U3QoQYX0h+fyt4tgQ5TMwp3M7qs6vz9JkdDkqpvY/HPn4p5aZbFyZVsUlem5AzR2Rd
         5Q5kwZ01ypo4YqdjIOdfge2YDsE1n9HzkJHD0mUHJCcwqt8xnwfGdf2OEiv8pvL/GL1u
         cgPARUG0l35P52U068Uws8yUZx+R5Hy7OUDpY=
Subject: Re: [PATCH 01/17] MTD: create lockless versions of
 {get,put}_mtd_device This will be used to resolve deadlock in block
 translation layer.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "stanley.miao" <stanley.miao@windriver.com>,
       Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1265735693.11509.253.camel@laptop>
References: <1265734665-22656-1-git-send-email-maximlevitsky@gmail.com>
	 <1265734665-22656-2-git-send-email-maximlevitsky@gmail.com>
	 <1265735693.11509.253.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Feb 2010 19:23:26 +0200
Message-ID: <1265736206.9195.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 18:14 +0100, Peter Zijlstra wrote: 
> On Tue, 2010-02-09 at 18:57 +0200, Maxim Levitsky wrote:
> > These functions can be used as long as we don't need access to global mtd table, but have
> > a pointer to the mtd device.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/mtd/mtdcore.c   |   60 ++++++++++++++++++++++++++++++----------------
> >  include/linux/mtd/mtd.h |    3 +-
> >  2 files changed, 41 insertions(+), 22 deletions(-)
> 
> > +int __get_mtd_device(struct mtd_info *mtd)
> > +{
> > +	int err;
> > +
> > +	if (!try_module_get(mtd->owner))
> > +		return -ENODEV;
> > +
> > +	if (mtd->get_device) {
> > +
> > +		err = mtd->get_device(mtd);
> > +
> > +		if (err) {
> > +			module_put(mtd->owner);
> > +			return err;
> > +		}
> > +	}
> > +	mtd->usecount++;
> > +	return 0;
> >  }
> 
> > +void __put_mtd_device(struct mtd_info *mtd)
> > +{
> > +	--mtd->usecount;
> > +	BUG_ON(mtd->usecount < 0);
> > +
> >  	if (mtd->put_device)
> >  		mtd->put_device(mtd);
> >  
> >  	module_put(mtd->owner);
> >  }
> 
> That's racy, use kref.
> 
Couldn't agree with you more.

However, these functions aren't intended for general use, and probably
will be used by mtd translation layer only. I do have a lock that
protects concurrent use of these functions.

Thus, I better add a comment about this?

Best regards,
Maxim Levitsky

