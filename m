Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500Ab0ASUgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0ASUgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487Ab0ASUgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:36:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0ASUgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:36:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Tue, 19 Jan 2010 21:37:35 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001182141.49907.rjw@sisk.pl> <201001191025.37579.oliver@neukum.org>
In-Reply-To: <201001191025.37579.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001192137.35232.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010, Oliver Neukum wrote:
> Am Montag, 18. Januar 2010 21:41:49 schrieb Rafael J. Wysocki:
> > On Monday 18 January 2010, Oliver Neukum wrote:
> > > Am Sonntag, 17. Januar 2010 14:55:55 schrieb Rafael J. Wysocki:
> > > > +void mm_force_noio_allocations(void)
> > > > +{
> > > > +       /* Wait for all slowpath allocations using the old mask to complete */
> > > > +       down_write(&gfp_allowed_mask_sem);
> > > > +       saved_gfp_allowed_mask = gfp_allowed_mask;
> > > > +       gfp_allowed_mask &= ~(__GFP_IO | __GFP_FS);
> > > > +       up_write(&gfp_allowed_mask_sem);
> > > > +}
> > > 
> > > In addition to this you probably want to exhaust all memory reserves
> > > before you fail a memory allocation
> > 
> > I'm not really sure what you mean.
> 
> Forget it, it was foolish. Instead there's a different problem.
> Suppose we are tight on memory. The problem is that we must not
> exhaust all memory. If we are really out of memory we may be unable
> to satisfy memory allocations in resume()

That doesn't make things any worse than the are already.  If we block on
I/O forever during resume, the gross result is pretty much the same.

That said, Maxim reported that in his test case the mm subsystem apparently
attempted to use I/O even if there was a plenty of free memory available and
I'd like prevent _that_ from happening.

Rafael
