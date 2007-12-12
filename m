Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbXLLBA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbXLLBA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXLLBAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:00:47 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:58523 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXLLBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:00:46 -0500
Message-ID: <475F32B0.20107@oracle.com>
Date: Tue, 11 Dec 2007 17:00:32 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH] dio: falling through to buffered I/O when invalidation
  of a page fails
References: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>
In-Reply-To: <6.0.0.20.2.20071210164242.03915ca8@172.19.0.2>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hisashi Hifumi wrote:
> Hi.
> 
> Current dio has some problems:
> 1, In ext3 ordered, dio write can return with EIO because of the race
> between invalidation of
> a page and jbd. jbd pins the bhs while committing journal so
> try_to_release_page fails when jbd
> is committing the transaction.

Yeah.  It sure would be fantastic if some ext3 expert could stop this
from happening somehow.  But that hasn't happened in.. uh.. Badari, for
how many years has this been on the radar? :)

> 
> Past discussion about this issue is as follows.
> http://marc.info/?t=119343431200004&r=1&w=2
> http://marc.info/?t=112656762800002&r=1&w=2
> 
> 2, invalidate_inode_pages2_range() sets ret=-EIO when
> invalidate_complete_page2()
> fails, but this ret is cleared if do_launder_page() succeed on a page of
> next index.

Oops.  That's too bad.  So maybe we should fix it by not stomping on
that return code?

	ret2 = do_launder()
	if (ret2 == 0)
		ret2 = invalidate()
	if (ret == 0)
		ret = ret2

I'd be surprised if we ever wanted to mask an -EIO when later pages
laundered successfully.

> In this case, dio is carried out even if invalidate_complete_page2()
> fails on some pages.
> This can cause inconsistency between memory and blocks on HDD because
> the page
> cache still exists.

Yeah.

> I solved problems above by introducing invalidate_inode_pages3_range()
> and falling
> through to buffered I/O when invalidation of a page failed.

Well, I like the idea of more intelligently dealing with the known
problem between dio and ext3.  I'm not sure that falling back to
buffered is right.

If dio can tell that it only failed because jbd held the buffer, should
we have waited for the transaction to complete before trying to
invalidate again?

If we could do that, we'd avoid performing the IO twice.

> We can distinguish between failure of page invalidation and other errors
> with the return value of invalidate_inode_pages3_range().

I'm not sure duplicating the invalidation loop into a new function is
the right thing.  Maybe we'd just tweak inode_pages2 to indicate to the
caller the specific failing circumstances somehow.  Maybe.

- z
