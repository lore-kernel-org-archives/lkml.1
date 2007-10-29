Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbXJ2RYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbXJ2RYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbXJ2RYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:24:10 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:36683 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754736AbXJ2RYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:24:09 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 12:24:06 -0500
Message-Id: <1193678646.3383.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 18:18 +0100, Cornelia Huck wrote:
> On Mon, 29 Oct 2007 11:57:51 -0500,
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > On Mon, 2007-10-29 at 17:54 +0100, Kay Sievers wrote:
> > > On Mon, 2007-10-29 at 10:16 -0500, James Bottomley wrote:
> > > > This patch is a first pass at adding a filter function to the group
> > > > attributes, just to see how the idea flies.  If everyone's OK with this,
> > > > I think the next thing that we might do is add bitmap functions (so
> > > > every bit in the bitmap has a name, but also might not appear) to
> > > > groups.
> > > 
> > > Bitmaps in the attribute groups?
> > 
> > Actually, no ... that would spoil our one group for all devices rule.
> > So they would be a set of helper functions for manipulating bitmaps, but
> > the bitmap would have to be in separate storage elsewhere.
> 
> Can you determine which subset of the attributes you want just before
> actually creating the group? Then you could do something like:
> 
> create_group(grp, kobj)
> {
> 	grp->update_creation_mask(kobj);
> 	actually_create_attrs();
> }

That's actually what we currently do (at least in hand coded form) in
the current transport classes.  However, it leads to one separate group
for each attached class.  With the filter approach, we only need one
constructed group for every transport class.

> > 
> > > >  struct attribute_group {
> > > >  	const char		*name;
> > > > +	int			(*filter_show)(struct kobject *, int);
> > > 
> > > Are you sure that you want to return an array index here, instead of the
> > > actual attribute? Like:
> > 
> > Actually, it returns a true/false value indicating whether the given
> > attribute should be displayed.
> > 
> > >   int (*filter_show)(struct kobject *kobj, struct attribute *attr);
> 
> I'd agree that using the attribute is better in this function.
> 
> > > 
> > > The names "show" and "store" are the ususal file-operation names, and we
> > > are not filtering a "show" here, right? Maybe "create", or "export", or
> > > something else might be a better name?
> > 
> > how about (*attribute_is_visible)?
> 
> Well, you don't only stop the visibility, but the creation of the
> attribute, so perhaps (*creation_filter)?

visibility and creation are the same thing, aren't they?  An invisible
attribute doesn't appear in the sysfs directory, so it's equivalent to
the file for it not being created.

James


