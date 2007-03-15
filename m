Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXCOVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXCOVDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXCOVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:03:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60982 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbXCOVDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:03:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Date: Thu, 15 Mar 2007 22:05:53 +0100
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
References: <200703122214.02657.rjw@sisk.pl> <200703122219.21171.rjw@sisk.pl> <20070315110816.8b4102b3.akpm@linux-foundation.org>
In-Reply-To: <20070315110816.8b4102b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703152205.54639.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 March 2007 20:08, Andrew Morton wrote:
> > On Mon, 12 Mar 2007 22:19:20 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > +int create_basic_memory_bitmaps(void)
> > +{
> > +	struct memory_bitmap *bm1, *bm2;
> > +	int error = 0;
> > +
> > +	BUG_ON(forbidden_pages_map || free_pages_map);
> > +
> > +	bm1 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
> > +	if (!bm1)
> > +		return -ENOMEM;
> > +
> > +	error = memory_bm_create(bm1, GFP_ATOMIC | __GFP_COLD, PG_ANY);
> > +	if (error)
> > +		goto Free_first_object;
> > +
> > +	bm2 = kzalloc(sizeof(struct memory_bitmap), GFP_ATOMIC);
> > +	if (!bm2)
> > +		goto Free_first_bitmap;
> > +
> > +	error = memory_bm_create(bm2, GFP_ATOMIC | __GFP_COLD, PG_ANY);
> > +	if (error)
> 
> What is the risk that we'll go OOM here?  GFP_ATOMIC is rather unreliable.

Well, this can be called after processes (including kswapd) has been frozen.
We can't go to sleep at this point.

> And why _does_ suspend use GFP_ATOMIC all over the place?

Generally, because it cannot sleep.
