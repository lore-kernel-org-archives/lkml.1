Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYFQRp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYFQRp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYFQRpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:45:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686AbYFQRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:45:11 -0400
Date: Tue, 17 Jun 2008 10:45:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Linus Torvalds wrote:
> 
> That said, that bug may be distracting, but it seems to have nothign at 
> all to do with the actual problem. The bug seems to happen only when the 
> file is not pre-paged in.

Bron, does this untested patch hide the bug?

> Nick?

I don't think this patch is correct, because it doesn't really fix the 
basic issue (the code should do the right thing even if a page isn't 
there), but it might hide it by faulting in the whole "bytes" range rather 
than just the first iov.

So Nick, it's still over to you, but if this does hide it, then that's an 
interesting detail in itself.

		Linus

---
 mm/filemap.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 1e6a7d3..0080a27 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1808,9 +1808,20 @@ EXPORT_SYMBOL(iov_iter_advance);
  */
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
-	char __user *buf = i->iov->iov_base + i->iov_offset;
-	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
-	return fault_in_pages_readable(buf, bytes);
+	unsigned long offset = i->iov_offset;
+	const struct iovec *iov = i->iov;
+
+	while (bytes) {
+		char __user *buf = iov->iov_base + offset;
+		size_t n = min(bytes, iov->iov_len - offset);
+
+		if (fault_in_pages_readable(buf, n))
+			return -EFAULT;
+		bytes -= n;
+		offset = 0;
+		iov++;
+	}
+	return 0;	
 }
 EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
