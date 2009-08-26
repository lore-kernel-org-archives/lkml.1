Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbZHZRFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbZHZRFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZHZRFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:05:21 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:63553 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbZHZRFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:05:21 -0400
Subject: Re: [RFC PATCH] mm: balance_dirty_pages. reduce calls to
 global_page_state to reduce cache references
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <E1MfuU8-00088Q-Ta@pomaz-ex.szeredi.hu>
References: <1250855961.2226.94.camel@castor>
	 <1250863494.7538.49.camel@twins>  <E1MfuU8-00088Q-Ta@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 18:05:19 +0100
Message-Id: <1251306319.2290.6.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 13:46 +0200, Miklos Szeredi wrote:
> On Fri, 21 Aug 2009, Peter Zijlstra wrote:
> > > I have tried to retain the existing behavior as much as possible, but
> > > have added NR_WRITEBACK_TEMP to nr_writeback. This counter was used in
> > > clip_bdi_dirty_limit but not in balance_dirty_pages, grep suggests this
> > > is only used by FUSE but I haven't done any testing on that. It does
> > > seem logical to count all the WRITEBACK pages when making the throttling
> > > decisions so this change should be more correct ;)
> > 
> > Right, the NR_WRITEBACK_TEMP thing is a FUSE feature, its used in
> > writable mmap() support for FUSE things.
> > 
> > I must admit to forgetting the exact semantics of the things, maybe
> > Miklos can remind us.
> 
> I'll try: fuse is special because it needs writeback to be "very
> asynchronous".  What I mean by this is that writing a dirty page may
> block indefinitely and that shouldn't hold up unrelated filesystem or
> memory operations.
> 
> To satisfy this, fuse copies contents of dirty pages over to
> "temporary pages" and queues the write request with this temporary
> page, not the original page-cache page.
> 
> This has two effects:
> 
>  - the page-cache page does not remain in "writeback" state but is
>    cleaned immediately
> 
>  - the NR_WRITEBACK counter is not incremented for the duration of the
>    writeback
> 
> The first one is important because vmscan and page migration do
> wait_on_page_writeback() in some circumstances, which would block on
> fuse writebacks.
> 
> The second one is important because vmscan will throttle writeout if
> the NR_WRITEBACK counter goes over the dirty threshold
> (throttle_vm_writeout).  There were long discussions about this one,
> but in the end no one could surely tell how this works and why it is
> important.  But NR_WRITEBACK_TEMP must not be counted there, otherwise
> the page scanning can deadlock with fuse filesystems.
> 
> About balance_dirty_pages() I'm not quite sure.  By a similar logic we
> don't want NR_WRITEBACK_TEMP pages to contribute to throttling
> unrelated filesytem writebacks.  That might (through recursion via a
> userspace filesystem) lead to a deadlock.
> 
> So my recommendation is that we should retain the old behavior.
> 
> Thanks,
> Miklos

Thanks for the explanation.

The old behavior was to use NR_WRITEBACK_TEMP to clip the bdi
thresholds.
Should we continue to do this or just ignore NR_WRIEBACK_TEMP completely
in balance_dirty_pages ?

regards
Richard

