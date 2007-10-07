Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXJGXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXJGXzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXJGXzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:55:04 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750840AbXJGXzB (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:55:01 -0400
Date: Mon, 8 Oct 2007 09:54:33 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove throttle_vm_writeout()
Message-ID: <20071007235433.GW995458@sgi.com>
References: <E1IdPla-0002Bd-00@dorka.pomaz.szeredi.hu> <1191501626.22357.14.camel@twins> <E1IdQJn-0002Cv-00@dorka.pomaz.szeredi.hu> <1191504186.22357.20.camel@twins> <E1IdR58-0002Fq-00@dorka.pomaz.szeredi.hu> <1191516427.5574.7.camel@lappy> <20071004104650.d158121f.akpm@linux-foundation.org> <20071005123028.GA10372@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005123028.GA10372@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 08:30:28PM +0800, Fengguang Wu wrote:
> The improvement could be:
> - kswapd is now explicitly preferred to do the writeout;

Careful. kswapd is much less efficient at writeout than pdflush
because it does not do low->high offset writeback per address space.
It just flushes the pages in LRU order and that turns writeback into
a non-sequential mess. I/O sizes decrease substantially and
throughput falls through the floor.

So if you want kswapd to take over all the writeback, it needs to do
writeback in the same manner as the background flushes. i.e.  by
grabbing page->mapping and flushing that in sequential order rather
than just the page on the end of the LRU....

I documented the effect of kswapd taking over writeback in this
paper (section 5.3):

http://oss.sgi.com/projects/xfs/papers/ols2006/ols-2006-paper.pdf

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
