Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYG3WFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYG3WFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYG3WFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:05:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763AbYG3WFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:05:45 -0400
Date: Wed, 30 Jul 2008 15:02:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linuxfoundation.org, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.27-rc1: IP: iov_iter_advance+0x2e/0x90
In-Reply-To: <alpine.LFD.1.10.0807301442130.3277@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807301500480.3277@nehalem.linux-foundation.org>
References: <20080730195457.GA3517@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807301255560.3334@nehalem.linux-foundation.org> <20080730213745.GA20546@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0807301442130.3277@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Linus Torvalds wrote:
> 
> Ok, I'll commit it as obvious, ugly as it may be. And hope that Nick or 
> some other god of iov_iter will think about trying to make these things 
> more reliable and easier to use.

Oh, and I think it's stable material. Unless I misread something, this 
area hasn't changed since 2.6.25. But somebody should double-check me, 
that just sounds wrong.

stable added to cc, with patch appended.

		Linus
---
commit 94ad374a0751f40d25e22e036c37f7263569d24c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 30 14:45:12 2008 -0700

    Fix off-by-one error in iov_iter_advance()
    
    The iov_iter_advance() function would look at the iov->iov_len entry
    even though it might have iterated over the whole array, and iov was
    pointing past the end.  This would cause DEBUG_PAGEALLOC to trigger a
    kernel page fault if the allocation was at the end of a page, and the
    next page was unallocated.
    
    The quick fix is to just change the order of the tests: check that there
    is any iovec data left before we check the iov entry itself.
    
    Thanks to Alexey Dobriyan for finding this case, and testing the fix.
    
    Reported-and-tested-by: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: Nick Piggin <npiggin@suse.de>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: <stable@kernel.org> [2.6.25.x, 2.6.26.x]
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 42bbc69..d97d1ad 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1879,7 +1879,7 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 		 * The !iov->iov_len check ensures we skip over unlikely
 		 * zero-length segments (without overruning the iovec).
 		 */
-		while (bytes || unlikely(!iov->iov_len && i->count)) {
+		while (bytes || unlikely(i->count && !iov->iov_len)) {
 			int copy;
 
 			copy = min(bytes, iov->iov_len - base);
