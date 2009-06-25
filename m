Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZFYDMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZFYDMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 23:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZFYDMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 23:12:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbZFYDL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 23:11:59 -0400
Date: Wed, 24 Jun 2009 20:11:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix error handling in add_disk
Message-Id: <20090624201154.7e89cbee.akpm@linux-foundation.org>
In-Reply-To: <200906241218.13538.knikanth@suse.de>
References: <200906171231.10438.knikanth@suse.de>
	<20090623142357.b2050c14.akpm@linux-foundation.org>
	<200906241218.13538.knikanth@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 12:18:13 +0530 Nikanth Karthikesan <knikanth@suse.de> wrote:

> On Wednesday 24 June 2009 02:53:57 Andrew Morton wrote:
> > On Wed, 17 Jun 2009 12:31:10 +0530
> >
> > Nikanth Karthikesan <knikanth@suse.de> wrote:
> > > Fix error handling in add_disk. Also add WARN_ON()'s in case
> > > of error, which can be removed once the callers handle the error.
> >
> > I have a vague ancestral memory that some of the unchecked errors which
> > you're now checking for actually do happen in practice, and that this
> > "fix" will end up breaking currently-working setups.
> >
> > Or maybe I'm thinking of a similar but different piece of code (maybe
> > it was the partition code?).
> >
> > Still, I think it would be prudent to initially make this patch
> > continue to ignore the errors.  So add the warnings, but don't change
> > the response to errors.  Then we can get the change distributed for a
> > bit of testing and if that all looks good then we can add the control
> > flow changes later.
> >
> 
> add_disk and blk_register_region are functions returning void masking the
> error

ugh, we're bad.

> which this patch changes. So no caller check for it's return value! And
> hence errors are ignored, and nothing breaks.

It _does_ change behaviour.  add_disk() can now bale out if, for
example, sysfs_create_link() failed.  As it commonly does, due to
various screwups.

> > >  	retval = blk_alloc_devt(&disk->part0, &devt);
> > >  	if (retval) {
> > >  		WARN_ON(1);
> > > -		return;
> > > +		goto err_out;
> > >  	}
> > > ...
> > > +	if (retval) {
> > > +		WARN_ON(1);
> > > +		goto err_free_devt;
> > > +	}
> > > ...
> > > +	if (retval) {
> > > +		WARN_ON(1);
> > > +		goto err_free_region;
> > > +	}
> > > ...
> > > -	WARN_ON(retval);
> > > +	if (retval) {
> > > +		WARN_ON(1);
> > > +		goto err_free_queue;
> > > +	}
> >
> > These all can be coded as
> >
> > 	if (WARN_ON(retval))
> > 		goto foo;
> 
> done.
> 
> Thanks
> Nikanth
> 
> 
> Fix error handling in add_disk. Also add WARN_ON()'s in case
> of error, which can be removed once the callers handle the error.

The changelog hasn't been updated to reflect this discussion.  There's
information missing here.


Also, why was this patch written?  Have you observed some behaviour
which this patch improved or corrected?

I applaud the effort, but it's obviously incomplete.  Do you intend to
add further error checking and handling in this area?
