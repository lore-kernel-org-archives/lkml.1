Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZHYLrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZHYLrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZHYLrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:47:03 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51430 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZHYLrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:47:01 -0400
To: a.p.zijlstra@chello.nl
CC: richard@rsk.demon.co.uk, akpm@linux-foundation.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, miklos@szeredi.hu
In-reply-to: <1250863494.7538.49.camel@twins> (message from Peter Zijlstra on
	Fri, 21 Aug 2009 16:04:54 +0200)
Subject: Re: [RFC PATCH] mm: balance_dirty_pages. reduce calls to
 global_page_state to reduce cache references
References: <1250855961.2226.94.camel@castor> <1250863494.7538.49.camel@twins>
Message-Id: <E1MfuU8-00088Q-Ta@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Aug 2009 13:46:44 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Peter Zijlstra wrote:
> > I have tried to retain the existing behavior as much as possible, but
> > have added NR_WRITEBACK_TEMP to nr_writeback. This counter was used in
> > clip_bdi_dirty_limit but not in balance_dirty_pages, grep suggests this
> > is only used by FUSE but I haven't done any testing on that. It does
> > seem logical to count all the WRITEBACK pages when making the throttling
> > decisions so this change should be more correct ;)
> 
> Right, the NR_WRITEBACK_TEMP thing is a FUSE feature, its used in
> writable mmap() support for FUSE things.
> 
> I must admit to forgetting the exact semantics of the things, maybe
> Miklos can remind us.

I'll try: fuse is special because it needs writeback to be "very
asynchronous".  What I mean by this is that writing a dirty page may
block indefinitely and that shouldn't hold up unrelated filesystem or
memory operations.

To satisfy this, fuse copies contents of dirty pages over to
"temporary pages" and queues the write request with this temporary
page, not the original page-cache page.

This has two effects:

 - the page-cache page does not remain in "writeback" state but is
   cleaned immediately

 - the NR_WRITEBACK counter is not incremented for the duration of the
   writeback

The first one is important because vmscan and page migration do
wait_on_page_writeback() in some circumstances, which would block on
fuse writebacks.

The second one is important because vmscan will throttle writeout if
the NR_WRITEBACK counter goes over the dirty threshold
(throttle_vm_writeout).  There were long discussions about this one,
but in the end no one could surely tell how this works and why it is
important.  But NR_WRITEBACK_TEMP must not be counted there, otherwise
the page scanning can deadlock with fuse filesystems.

About balance_dirty_pages() I'm not quite sure.  By a similar logic we
don't want NR_WRITEBACK_TEMP pages to contribute to throttling
unrelated filesytem writebacks.  That might (through recursion via a
userspace filesystem) lead to a deadlock.

So my recommendation is that we should retain the old behavior.

Thanks,
Miklos
