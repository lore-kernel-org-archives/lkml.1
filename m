Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZLaBjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZLaBjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 20:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZLaBjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 20:39:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:60267 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbZLaBjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 20:39:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="227984617"
Date: Thu, 31 Dec 2009 09:39:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [RFC][PATCH 2/2] readahead: avoid page-by-page reads on
	POSIX_FADV_RANDOM
Message-ID: <20091231013935.GA6570@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873a2s8hmp.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 02:02:38AM +0800, Andi Kleen wrote:
> Wu Fengguang <fengguang.wu@intel.com> writes:
> >   * the ra fields can be accessed concurrently in a racy way.
> > --- linux.orig/mm/fadvise.c	2009-12-30 13:02:03.000000000 +0800
> > +++ linux/mm/fadvise.c	2009-12-30 13:23:05.000000000 +0800
> > @@ -77,12 +77,14 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, lof
> >  	switch (advice) {
> >  	case POSIX_FADV_NORMAL:
> >  		file->f_ra.ra_pages = bdi->ra_pages;
> > +		file->f_ra.flags &= ~RA_FLAG_RANDOM;
> >  		break;
> >  	case POSIX_FADV_RANDOM:
> > -		file->f_ra.ra_pages = 0;
> > +		file->f_ra.flags |= RA_FLAG_RANDOM;
> 
> What prevents this from racing with a parallel readahead
> state modification, losing the bits?

Oh I pretended that the problem don't exist..

To be serious, the race only exist inside a mutithread application,
where one single fd is shared between two threads, one is doing
fadvise, another doing readahead.

A sane application won't do fadvise(POSIX_FADV_RANDOM) while active
reads are going one concurrently: this leads to indeterminate behavior
by itself -- from which request the random hint takes effect?

fadvise() shall always be in the same streamline with all reads.

In real workloads, 1% applications may do POSIX_FADV_RANDOM, among
which 1% applications may be broken. And if the race does happen, the
impact is very small. So I choose to just ignore the race and use
non-atomic operations..

Thanks,
Fengguang
