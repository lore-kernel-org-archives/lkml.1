Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbXGZBod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbXGZBod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXGZBoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:44:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:46660 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbXGZBoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:44:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gYfadVkAW7MjW28C0fM9YmX/5qelfOS4ja5VL66xBM+RELhKInIdAlvWx5dno3DAKURX9WrBPNGpiaVlD5HtGvlF269FeV7W6ahc5VI+uEN/imJqkFeJ2xIdmdWAEa2sj+QbFGSIzewIQvwIQKGpWiHkADBSBlQr3oIPWbhxVTI=
Message-ID: <21d7e9970707251844p5c0243d6q7366ab8fa3738f62@mail.gmail.com>
Date: Thu, 26 Jul 2007 11:44:22 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch] agp: don't lock pages
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       magnade@gmail.com, davej@codemonkey.org.uk
In-Reply-To: <20070726004114.GA17294@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725111922.GF29011@wotan.suse.de>
	 <1185398813.5439.342.camel@localhost.localdomain>
	 <20070726004114.GA17294@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On Thu, Jul 26, 2007 at 07:26:53AM +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2007-07-25 at 13:19 +0200, Nick Piggin wrote:
> > > Hi,
> > >
> > > Does this patch solve the X problem? Does anyone see anything wrong
> > > with it or know why agp was locking the pages?
> >
> > We need to do a little bit of auditing here, but I suspect it will turn
> > out all right. I think the reason it locked them in the first place was
> > to avoid AGP pages mapped into process space from being swapped out.
> >
> > I think that should be taken care of by appropriate vma flags nowadays,
> > but we need to double check. It also might have been a way around dodgy
> > refcounting at one point but I think we got that right nowadays (I
> > remember fixing issues in that area when we removed PageReserved from
> > those pages back then).
>
> Yeah I had a bit of a look around, and it seems OK (but would
> appreciate an ack from someone who knows the code).
>
> These pages will never get seen by page reclaim, so we're OK
> there. There is a get_page before the SetPageLocked and a put_page
> right before the unlock_page, so refcounting should not be broken
> if it wasn't already: note that the lock_page doesn't pin a
> reference on a page in general -- we can use it as such for pagecache
> (although it isn't very clean), because the lock pins the page in
> pagecache and the pagecache holds a ref.
>
> Anyway, if Dave or David can take a look, that would be appreciated.
> We'll need this for 2.6.23.

I talked with Ben earlier and I can't see anything inherently wrong
with removing the lock_page, I assume it was put there to stop things
getting swapped but if the get/put does that then I'd be happy to
remove it.

I'm just a bit confused how this didn't get picked up in -mm at all.

Dave.
