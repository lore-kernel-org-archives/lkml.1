Return-Path: <linux-kernel-owner+w=401wt.eu-S932452AbYEFUVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbYEFUVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754765AbYEFUVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:21:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:54203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYEFUVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:21:06 -0400
Date: Tue, 6 May 2008 13:20:33 -0700
From: Greg KH <gregkh@suse.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: acpi_cpu_freq_init warning...
Message-ID: <20080506202033.GA3114@suse.de>
References: <86802c440805051951u153ebc21p15f0d73904496217@mail.gmail.com> <87k5i8hrmk.fsf@duaron.myhome.or.jp> <alpine.LFD.1.10.0805060741290.32269@woody.linux-foundation.org> <87skwvcl2a.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skwvcl2a.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 04:02:53AM +0900, OGAWA Hirofumi wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Tue, 6 May 2008, OGAWA Hirofumi wrote:
> >> -	if ((drv->entry.next != drv->entry.prev) ||
> >> +	if ((drv->entry.next != drv->entry.prev) &&
> >>  	    (drv->entry.next != NULL)) {
> >
> > Umm. That code still makes no sense.
> >
> > The "drv->entry.next == drv->entry.prev" condition will trigger under 
> > *three* different circumstances:
> >
> >  - next/prev == NULL (uninitialized). Checked for by the explicit check 
> >    against NULL.
> >
> >  - list empty (both next/prev point back to itself), which I assume the 
> >    check was *meant* for.
> >
> >  - list has only *one* entry, when next/prev both point to the list head.
> >
> > and I'm pretty damn sure that whoever wrote that code didn't mean that 
> > last one, but who knows..
> >
> > The fact is, looking at next/prev this way is a sure way to have bugs.
> >
> > What is that PoS *trying* to test for? I assume it is meant to test for
> >
> > 	/* Is the list initialized and non-empty? */
> > 	if (drv->entry.next && !list_empty(&drv->entry)) {
> > 		...
> >
> > and dammit, just doing it that way is shorter and simpler.

But I don't think that will work as others have pointed out, this
structure's list field isn't initialized yet.

> Whoops, sorry. You are right.
> 
> diff -puN drivers/base/sys.c~fix-sys-bogus-warning drivers/base/sys.c
> --- linux-2.6/drivers/base/sys.c~fix-sys-bogus-warning	2008-05-07 03:51:00.000000000 +0900
> +++ linux-2.6-hirofumi/drivers/base/sys.c	2008-05-07 04:01:14.000000000 +0900
> @@ -175,8 +175,7 @@ int sysdev_driver_register(struct sysdev
>  	}
>  
>  	/* Check whether this driver has already been added to a class. */
> -	if ((drv->entry.next != drv->entry.prev) ||
> -	    (drv->entry.next != NULL)) {
> +	if (drv->entry.next && !list_empty(&drv->entry)) {

Did you try this patch out?

I say rip the whole thing out, it was added to try to make some bugs in
upper layers more obvious, but if it can't be correct, I have no
objection to removing the thing.  Other bad things happen later on if
the developer messes this one up, this is not a 'user can cause this'
type of error at all.

thanks,

greg k-h
