Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbZLaCxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbZLaCxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZLaCxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:53:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:41947 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZLaCxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:53:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227998463"
Date: Thu, 31 Dec 2009 10:53:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC][PATCH 2/2] readahead: avoid page-by-page reads on
	POSIX_FADV_RANDOM
Message-ID: <20091231025343.GA11327@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20091231013935.GA6570@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231013935.GA6570@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 09:39:36AM +0800, Wu Fengguang wrote:
> On Thu, Dec 31, 2009 at 02:02:38AM +0800, Andi Kleen wrote:
> > Wu Fengguang <fengguang.wu@intel.com> writes:
> > >   * the ra fields can be accessed concurrently in a racy way.
> > > --- linux.orig/mm/fadvise.c	2009-12-30 13:02:03.000000000 +0800
> > > +++ linux/mm/fadvise.c	2009-12-30 13:23:05.000000000 +0800
> > > @@ -77,12 +77,14 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
> > >  	switch (advice) {
> > >  	case POSIX_FADV_NORMAL:
> > >  		file->f_ra.ra_pages = bdi->ra_pages;
> > > +		file->f_ra.flags &= ~RA_FLAG_RANDOM;
> > >  		break;
> > >  	case POSIX_FADV_RANDOM:
> > > -		file->f_ra.ra_pages = 0;
> > > +		file->f_ra.flags |= RA_FLAG_RANDOM;
> > 
> > What prevents this from racing with a parallel readahead
> > state modification, losing the bits?
> 
> Oh I pretended that the problem don't exist..
> 
> To be serious, the race only exist inside a mutithread application,
> where one single fd is shared between two threads, one is doing
> fadvise, another doing readahead.
> 
> A sane application won't do fadvise(POSIX_FADV_RANDOM) while active
> reads are going one concurrently: this leads to indeterminate behavior
> by itself -- from which request the random hint takes effect?
> 
> fadvise() shall always be in the same streamline with all reads.
> 
> In real workloads, 1% applications may do POSIX_FADV_RANDOM, among
> which 1% applications may be broken. And if the race does happen, the
> impact is very small. So I choose to just ignore the race and use
> non-atomic operations..

OK, when updating the manpages as follows, I feel ashamed to add a
sentence like "make sure there are no concurrent reads on the same file
descriptor...otherwise your advice will be lost".

So how about add a FMODE_HINT_RANDOM_READ bit to file->f_mode?
Modifying it at fadvise() time at least won't disturb the existing
open-time-modify-only f_mode bits..

Thanks,
Fengguang

---
 man2/posix_fadvise.2 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- manpages-3.23.orig/man2/posix_fadvise.2	2009-12-31 09:46:13.000000000 +0800
+++ manpages-3.23/man2/posix_fadvise.2	2009-12-31 10:28:58.000000000 +0800
@@ -104,7 +104,8 @@ in POSIX.1-2003 TC1.
 .SH NOTES
 Under Linux, \fBPOSIX_FADV_NORMAL\fP sets the readahead window to the
 default size for the backing device; \fBPOSIX_FADV_SEQUENTIAL\fP doubles
-this size, and \fBPOSIX_FADV_RANDOM\fP disables file readahead entirely.
+this size. \fBPOSIX_FADV_RANDOM\fP ignores the readahead size, and will
+submit IO for the read requests as-is.
 These changes affect the entire file, not just the specified region
 (but other open file handles to the same file are unaffected).
 

