Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbXK2QWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbXK2QWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbXK2QWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:22:12 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:4468 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbXK2QWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:22:10 -0500
Date: Thu, 29 Nov 2007 17:21:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
 kobject_init
Message-ID: <20071129172134.74849579@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1196352280.3118.11.camel@lov.site>
References: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org>
	<1196352280.3118.11.camel@lov.site>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 17:04:40 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Thu, 2007-11-29 at 10:54 -0500, Alan Stern wrote:
> > On Thu, 29 Nov 2007, Kay Sievers wrote:
> > 
> > > > And if someone calls kobject_put() after kobject_init() to clean up,
> > > > their release function will not be called if they didn't set the ktype.
> > > > So the check really belongs into kobject_init() IMO.
> > 
> > Right.  And even though cleaning up no longer needs to drop a reference
> > to the kset, it still might need to free the kobject's name.  So for 
> > example, either of these sequences:
> > 
> > 	kobject_init();			kobject_set_name();
> > 	kobject_set_name();		kobject_init();
> > 	...				...
> > 	kobject_free();			kobject_free();
> > 
> > would leak memory.
> 
> Yeah, only the kobject_put() would free the name.
> 
> > In fact, if we were designing the kobject API from scratch, I'd suggest 
> > making the ktype value an argument to kobject_init() so that it 
> > _couldn't_ be omitted.
> 
> Sounds fine, maybe we should also pass the name along, so it will be
> obvious what happens here:
>   int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)

Agreed. Better don't hide too much.
