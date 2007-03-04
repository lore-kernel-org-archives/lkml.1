Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXCDBtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXCDBtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbXCDBtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:49:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51514 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbXCDBtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:49:41 -0500
Date: Sat, 3 Mar 2007 17:49:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070303174927.2d314a71.akpm@linux-foundation.org>
In-Reply-To: <45EA1F7B.9060107@redhat.com>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	<45E9DD4A.2060806@redhat.com>
	<20070303131204.6706a95c.akpm@linux-foundation.org>
	<45E9E910.2070804@redhat.com>
	<20070303140744.b22699dd.akpm@linux-foundation.org>
	<45E9F5DA.2070708@redhat.com>
	<20070303145221.2a42cc0f.akpm@linux-foundation.org>
	<45EA0C3D.1010001@redhat.com>
	<20070303170237.31d26382.akpm@linux-foundation.org>
	<45EA1F7B.9060107@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 20:23:07 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Sat, 03 Mar 2007 19:01:01 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
> >> The use-once policy we have in the kernel should work
> >> perfectly fine for backups.  All we need to do is
> >> actually honor the accessed bit on active page cache
> >> pages, instead of flushing them onto the inactive
> >> list.
> >>
> >> What am I overlooking?
> > 
> > That'll improve backups but will break other things.
> > 
> > To do this effectively we'd need to change the policy so that new pagecache
> > allocations cause no scanning of used-twice pages at all.  So that even
> > after many gigs of backing up, the working set is still there.
> > 
> > Problem is, (for example) what about the person who has 80% of memory in
> > used-twice state and who then reads a file or files which are 20% or more of
> > the size of memory, two or more times.  It'll be 100% cache misses, every time.
> > This will happen quite a lot.  IOW, once those pages are in used-twice state,
> > how does further pagecache activity ever get them _out_ of that state?  Only
> > by joining the used-twice page set, and that can't happen if the used-once-so-far
> > pages got reclaimed.
> > 
> > Doing a refault thing would help a bit, but stops working at a certain point.
> 
> At what point does it stop working?

We need to store that this-page-got-reclaimed info somewhere.  I don't know
how space-efficient that is.  Did anyone ever do an implementation?

Of course, the pages need to be re-read again so there's a potential 100%
hit there, which is in fact not a huge amount in this context.  Depends how
often it occurs (all the time when refault is being useful?) versus what we
gain from it.

> I am not asking this to be difficult, I just want to get Linux
> a VM that does not need to be kludged up every time a distro
> ships it to its customers.

We have a communication problem here.  Please please please work harder to
get these problems communicated to the MM developers.  The only vendor MM
kludge of which I'm aware is a thing which Andrea is working on to address
a large-shm-segment versus bulk-IO problem (yup, database).

If you have enough of an understanding of a problem to be able to develop
and productise a fix then share that info madly, asap.

otoh, rhel-on-the-desktop-or-smaller probably isn't a huge priority, which
can be taken advantage of.

> I believe one starting point would be a concept that people
> cannot shoot holes in any more.  That is no guarantee, but
> as long as the concept has known holes coding it up is likely
> to be a waste of time since the code will need kludges to
> deal with the problems later on and we'd be back to square
> one.

You mean design it and review the design before coding it?  You'll find few
objections there.

