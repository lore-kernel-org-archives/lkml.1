Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYICWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYICWyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYICWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:54:11 -0400
Received: from waste.org ([66.93.16.53]:41243 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYICWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:54:10 -0400
Subject: Re: drivers/char/random.c line 728 BUG
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: aaron@merfinllc.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       stable@kernel.org
In-Reply-To: <20080903153206.24dc88c3.akpm@linux-foundation.org>
References: <20080826225918.GC5452@merfinllc.com>
	 <20080828225924.GD6432@merfinllc.com>
	 <20080829124807.54293904.akpm@linux-foundation.org>
	 <1220465901.17608.55.camel@calx> <20080903182845.GM17899@merfinllc.com>
	 <1220479920.17608.62.camel@calx>
	 <20080903153206.24dc88c3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 03 Sep 2008 17:51:37 -0500
Message-Id: <1220482297.17608.84.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-03 at 15:32 -0700, Andrew Morton wrote:
> On Wed, 03 Sep 2008 17:12:00 -0500
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > > Could we still apply his patch for the upcoming stable tree and fix it
> > > the "right" way at some point in the future?
> > 
> > I'm not sure what the current state of play is here in terms of the
> > original patch being pushed to stable and mainline, but my patch is both
> > simpler and more correct. If it's not too late, it's the one that should
> > go to both places.
> 
> It's a fairly minor thing.  The post-this-patch code takes care to
> ensure that ->entropy_count never has an illegal value, so it's OK but
> aesthetially unpleasing to check its value outside the lock.
> 
> And the post-this-patch code generates less .text, so it's a desirable
> thing from that POV too.
> 
> We could/should do both, I guess.

Sure, adding a local variable is fine. Though really, this shouldn't
actually improve things, that's just our compiler being sucky. And I
think it's a wash in terms of readability.

> I kinda ducked your move-the-BUG
> patch because I wasn't in a write-yet-another-changelog mood.

I included one, but it was terse:

 Avoid checking lock-protected entropy_count when lock isn't held.

Here's a more expansive version:

﻿Avoid checking lock-protected entropy_count when lock isn't held. This
fixes a bug reported by and diagnosed by Aaron Straus.

This fixes a regression introduced into 2.6.26 by
 
     commit adc782dae6c4c0f6fb679a48a544cfbcd79ae3dc
     Author: Matt Mackall <mpm@selenic.com>
     Date:   Tue Apr 29 01:03:07 2008 -0700
 
         random: simplify and rename credit_entropy_store

Signed-off-by: Matt Mackall <mpm@selenic.com>
 
diff -r ddae8a8d3c6f drivers/char/random.c
--- a/drivers/char/random.c	Tue Jul 29 03:07:11 2008 +0000
+++ b/drivers/char/random.c	Wed Sep 03 17:43:18 2008 -0500
@@ -726,11 +726,10 @@
 {
 	unsigned long flags;
 
-	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
-
 	/* Hold lock while accounting */
 	spin_lock_irqsave(&r->lock, flags);
 
+	BUG_ON(r->entropy_count > r->poolinfo->POOLBITS);
 	DEBUG_ENT("trying to extract %d bits from %s\n",
 		  nbytes * 8, r->name);

-- 
Mathematics is the supreme nostalgia of our time.

