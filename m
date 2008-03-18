Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYCRMvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYCRMvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYCRMvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:51:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37658 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYCRMvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:51:24 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1205843375.8514.357.camel@twins> (message from Peter Zijlstra on
	Tue, 18 Mar 2008 13:29:35 +0100)
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
	end_page_writeback()
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191945.122011759@szeredi.hu> <1205840031.8514.346.camel@twins>
	 <E1JbaTH-0005jN-4r@pomaz-ex.szeredi.hu> <1205843375.8514.357.camel@twins>
Message-Id: <E1JbbHf-0005rm-R5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Mar 2008 13:51:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, it does two things, _however_ those two things are very much
> related. Your use-case that breaks this relation is an execption - and I
> haven't really grasped it yet..
> 
> I'm in general not too keen about you having to export the BDI
> accounting stuff and using it explicitly like this, but I'm afraid I
> don't see a way around it - the danger is that other filesystems will
> get creative (hence the req for GPL - that excludes the most creative
> ones).
> 
> Yes, it makes sense to delay the write completion accounting until its
> actually completed.. but I would suggest all writeback accounting.

Doesn't work, as long as we have throttle_vm_writeout() waiting for
NR_WRITEBACK to go below a threshold, delaying the NR_WRITEBACK
accounting could lead to a deadlock.

So at least until that's resolved NR_WRITEBACK_TEMP needs to be
separate from NR_WRITEBACK_TEMP.  And it makes sense possibly even
after that, as they are fundamentally different things.  The first one
is page cache pages being under writeout, the second is just kernel
buffers (mostly) unrelated to the page cache.

> So the thing that's in your way is that removing a page from the radix
> tree doesn't imply its done writing. So perhaps we should make that
> distinction instead?
> 
> So instead of conditionally do part of the accounting, never do it and
> require something like: page_writeback_complete() to be called after a
> successfull test_clear_page_writeback().

Yes, that's a possibility, but then normal filesystems miss out on the
small optimization provided by doing the BDI accounting functions
inside the same IRQ disabled region as the radix tree operation.
Would that have any significant performance impact?

Miklos
