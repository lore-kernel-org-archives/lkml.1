Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXDVJI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXDVJI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXDVJI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:08:57 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:43110 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558AbXDVJI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:08:56 -0400
Subject: Re: [PATCH 08/10] mm: count writeback pages per BDI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
In-Reply-To: <20070422001949.4d697fe5.akpm@linux-foundation.org>
References: <20070420155154.898600123@chello.nl>
	 <20070420155503.334628394@chello.nl>
	 <20070421025525.042ed73a.akpm@linux-foundation.org>
	 <1177153636.2934.43.camel@lappy>
	 <20070422001949.4d697fe5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 22 Apr 2007 11:08:52 +0200
Message-Id: <1177232932.7316.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 00:19 -0700, Andrew Morton wrote:

> It could be that we never call test_clear_page_writeback() against
> !bdi_cap_writeback_dirty() pages anwyay.  I can't think why we would, but
> the relationships there aren't very clear.  Does "don't account for dirty
> memory" imply "doesn't ever do writeback"?  One would need to check, and
> it's perhaps a bit fragile.

I did, thats how that test ended up there; I guess a comment would have
been a good thing, no? :-)

end_swap_bio_write() calls end_page_writeback(), and
swap_backing_dev_info has neither cap_writeback nor cap_account_dirty.

> It's worth checking though.  Boy we're doing a lot of stuff in there
> nowadays.
> 
> OT: it might be worth looking into batching this work up - the predominant
> caller should be mpage_end_io_write(), and he has a whole bunch of pages
> which are usually all from the same file, all contiguous.  It's pretty
> inefficient to be handling that data one-page-at-a-time, and some
> significant speedups may be available.

Right, that might be a good spot to hook into, I'll have a look.

> Instead, everyone seems to think that variable pagecache page size is the
> only way of improving things.  Shudder.

hehe, I guess you haven't looked at my concurrent pagecache patches yet
either :-)

