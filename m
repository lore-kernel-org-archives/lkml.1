Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYLJCDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYLJCDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYLJCDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:03:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbYLJCDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:03:21 -0500
Date: Tue, 9 Dec 2008 18:02:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Airlie" <airlied@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, alan@lxorguk.ukuu.org.uk,
       "Manfred Spraul" <manfred@colorfullife.com>,
       "Clement Calmels" <cboulte@gmail.com>,
       "Nadia Derbey" <Nadia.Derbey@bull.net>,
       "Pierre Peiffer" <peifferp@gmail.com>
Subject: Re: [patch 021/104] lib/idr.c: fix rcu related race with idr_find
Message-Id: <20081209180250.8d7301a7.akpm@linux-foundation.org>
In-Reply-To: <21d7e9970812091746u5b6e8594s8567007ec1e26bac@mail.gmail.com>
References: <20081203193901.715896543@mini.kroah.org>
	<20081203194725.GA8950@kroah.com>
	<20081203194906.GV8950@kroah.com>
	<21d7e9970812091340p5121e8f8l1e2411035331e8d0@mail.gmail.com>
	<alpine.LFD.2.00.0812091447230.3340@localhost.localdomain>
	<21d7e9970812091643n7e3e4fe5g8e44030adfbababa@mail.gmail.com>
	<21d7e9970812091746u5b6e8594s8567007ec1e26bac@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 11:46:13 +1000 "Dave Airlie" <airlied@gmail.com> wrote:

> >>
> >> On Wed, 10 Dec 2008, Dave Airlie wrote:
> >>>
> >>> On Thu, Dec 4, 2008 at 5:49 AM, Greg KH <gregkh@suse.de> wrote:
> >>> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> >>> >
> >>> Revert.
> >>>
> >>> This caused problems in the F10 kernel with idr, the drm device alloc
> >>> went all wierd,
> >>> it might be a drm bug but changing this code triggers it and so it
> >>> isn't really "stable"
> >>
> >> Well, maybe it should be reverted in mainlne too, then?
> >
> > It appears idr_replace is broken at least in stable with this patch.
> >
> > I'm trying to track down where the problem is (idr_replace doesn't look like
> > idr_find in a lot of places and I wonder if this has ever been tested.)
> >
> (cc-trimmed).
> 
> Okay I'm not idr expert and maybe what the drm is doing is illegal but
> it never caused a problem up to now.
> 
> The drm grabs an idr minor number using a NULL pointer to reserve the
> number, it then uses idr_replace later
> to stick a pointer into the reserved number. However this seems to be
> what is broken, I'm not sure if this is a legal
> use of idrs but has worked like that for a long time now.
> 
> I can fix the drm to workaround this, and allocate my pointers before
> I try to get a minor number, but I'd like to know
> if my usage is illegal over just overlooked.


<greps for a while>

I assume we're talking about drivers/gpu/drm/drm_stub.c:drm_minor_get_id()?

I don't immediately see anything in the idr code which special-cases a
NULL caller pointer?

