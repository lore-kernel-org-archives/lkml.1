Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbXGAHOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbXGAHOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbXGAHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:14:09 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:29800 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXGAHNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:13:50 -0400
Subject: Re: [patch 5/5] Optimize page_mkclean_one
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Hugh Dickins <hugh@veritas.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <Pine.LNX.4.64.0706301448450.13752@blonde.wat.veritas.com>
References: <20070629135530.912094590@de.ibm.com>
	 <20070629141528.511942868@de.ibm.com>
	 <Pine.LNX.4.64.0706301448450.13752@blonde.wat.veritas.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 01 Jul 2007 09:15:53 +0200
Message-Id: <1183274153.15924.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 15:04 +0100, Hugh Dickins wrote:
> > Oh yes, the dirty handling is tricky. I had to fix a really nasty bug
> > with it lately. As for page_mkclean_one the difference is that it
> > doesn't claim a page is dirty if only the write protect bit has not been
> > set. If we manage to lose dirty bits from ptes and have to rely on the
> > write protect bit to take over the job, then we have a different problem
> > altogether, no ?
> 
> [Moving that over from 1/5 discussion].
> 
> Expect you're right, but I _really_ don't want to comment, when I don't
> understand that "|| pte_write" in the first place, and don't know the
> consequence of pte_dirty && !pte_write or !pte_dirty && pte_write there.

The pte_write() part is for the shared dirty page tracking. If you want
to make sure that a max of x% of your pages are dirty then you cannot
allow to have more than x% to be writable. Thats why page_mkclean_one
clears the dirty bit and makes the page read-only.

> My suspicion is that the "|| pte_write" is precisely to cover your
> s390 case where pte is never dirty (it may even have been me who got
> Peter to put it in for that reason).  In which case your patch would
> be fine - though I think it'd be improved a lot by a comment or
> rearrangement or new macro in place of the pte_dirty || pte_write
> line (perhaps adjust my pte_maybe_dirty in asm-generic/pgtable.h,
> and use that - its former use in msync has gone away now).

No, s390 is covered by the page_test_dirty / page_clear_dirty pair in
page_mkclean. 

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


