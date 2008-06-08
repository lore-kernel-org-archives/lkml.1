Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYFHVdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYFHVdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbYFHVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:33:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbYFHVd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:33:28 -0400
Date: Sun, 8 Jun 2008 17:32:44 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-ID: <20080608173244.0ac4ad9b@bree.surriel.com>
In-Reply-To: <20080608135704.a4b0dbe1.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 13:57:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > > > From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> > 
> > > > The noreclaim infrastructure is enabled by a new mm Kconfig option
> > > > [CONFIG_]NORECLAIM_LRU.
> > > 
> > > Having a config option for this really sucks, and needs extra-special
> > > justification, rather than none.
> > 
> > I believe the justification is that it uses a page flag.
> > 
> > PG_noreclaim would be the 20th page flag used, meaning there are
> > 4 more free if 8 bits are used for zone and node info, which would
> > give 6 bits for NODE_SHIFT or 64 NUMA nodes - probably overkill
> > for 32 bit x86.
> > 
> > If you want I'll get rid of CONFIG_NORECLAIM_LRU and make everything
> > just compile in always.
> 
> Seems unlikely to be useful?  The only way in which this would be an
> advantage if if we hae some other feature which also needs a page flag
> but which will never be concurrently enabled with this one.
> 
> > Please let me know what your preference is.
> 
> Don't use another page flag?

I don't see how that would work.  We need a way to identify
the status of the page.

> > > > +#ifdef CONFIG_NORECLAIM_LRU
> > > > +	PG_noreclaim,		/* Page is "non-reclaimable"  */
> > > > +#endif
> > > 
> > > I fear that we're messing up the terminology here.
> > > 
> > > Go into your 2.6.25 tree and do `grep -i reclaimable */*.c'.  The term
> > > already means a few different things, but in the vmscan context,
> > > "reclaimable" means that the page is unreferenced, clean and can be
> > > stolen.  "reclaimable" also means a lot of other things, and we just
> > > made that worse.
> > > 
> > > Can we think of a new term which uniquely describes this new concept
> > > and use that, rather than flogging the old horse?
> > 
> > Want to reuse the BSD term "pinned" instead?
> 
> mm, "pinned" in Linuxland means "someone took a ref on it to prevent it
> from being reclaimed".
> 
> As a starting point: what, in your english-language-paragraph-length
> words, does this flag mean?

"Cannot be reclaimed because someone has it locked in memory
through mlock, or the page belongs to something that cannot
be evicted like ramfs."

-- 
All rights reversed.
