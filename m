Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZECA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZECA1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 20:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZECA1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 20:27:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60683 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbZECA1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 20:27:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] PM: Drop shrink_all_memory (rev. 2) (was: Re: [PATCH 3/3] PM/Hibernate: Use memory allocations to free memory)
Date: Sun, 3 May 2009 02:20:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905021346.34967.rjw@sisk.pl> <20090502104947.2720f173.akpm@linux-foundation.org>
In-Reply-To: <20090502104947.2720f173.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905030220.57933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 May 2009, Andrew Morton wrote:
> On Sat, 2 May 2009 13:46:34 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > > Do we need the bitmap?  I expect we can just string all these pages
> > > onto a local list via page.lru.  Would need to check that - the
> > > pageframe fields are quite overloaded.
> > 
> > This is the reason why we use the bitmaps for hibernation. :-)
> 
> grep the tree for page->lru and you'll see that quite a few page
> consumers are using it.  So you'd be pretty safe doing it this way.
> 
> Whether it's _worth_ doing it this way is debatable, given that
> hibernation uses bitmaps elsewhere.  But it would shrink the patch a
> bit I expect?

It probably would, but it turns out we need not create the new bitmap, we
can use the existing ones for marking the allocated pages.  That also has
the benefit that we can use swsusp_free() to release them.

Modified patch series follows:

[1/4] - your patch introducing __GFP_NO_OOM_KILL (I decided it would be better
        do it this way in this particular case.  The fact that the OOM killer
        is not going to work after tasks have been frozen is a different issue.)

[2/4] - move swsusp_shrink_memory to snapshot.c, no major changes

[3/4] - use memory allocations to for making the room for the image (added
        comments, used the existing bitmaps, cleaned up a bit)

[4/4] - new thing: do not release memory allocated by [3/4] and use it for
        creating the image directly.

Thanks,
Rafael

