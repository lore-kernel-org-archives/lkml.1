Return-Path: <linux-kernel-owner+w=401wt.eu-S935506AbYBGVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935506AbYBGVOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762800AbYBGUyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:35 -0500
Received: from mx1.suse.de ([195.135.220.2]:46102 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933364AbYBGUyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:33 -0500
Date: Thu, 7 Feb 2008 12:48:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 42/45] fix writev regression: pan hanging unkillable and
	un-straceable
Message-ID: <20080207204819.GQ16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-writev-regression-pan-hanging-unkillable-and-un-straceable.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Nick Piggin <nickpiggin@yahoo.com.au>

patch 124d3b7041f9a0ca7c43a6293e1cae4576c32fd5 in mainline.

Frederik Himpe reported an unkillable and un-straceable pan process.

Zero length iovecs can go into an infinite loop in writev, because the 
iovec iterator does not always advance over them.

The sequence required to trigger this is not trivial. I think it 
requires that a zero-length iovec be followed by a non-zero-length iovec 
which causes a pagefault in the atomic usercopy. This causes the writev 
code to drop back into single-segment copy mode, which then tries to 
copy the 0 bytes of the zero-length iovec; a zero length copy looks like 
a failure though, so it loops.

Put a test into iov_iter_advance to catch zero-length iovecs. We could 
just put the test in the fallback path, but I feel it is more robust to 
skip over zero-length iovecs throughout the code (iovec iterator may be 
used in filesystems too, so it should be robust).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1733,7 +1733,11 @@ static void __iov_iter_advance_iov(struc
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
 
-		while (bytes) {
+		/*
+		 * The !iov->iov_len check ensures we skip over unlikely
+		 * zero-length segments.
+		 */
+		while (bytes || !iov->iov_len) {
 			int copy = min(bytes, iov->iov_len - base);
 
 			bytes -= copy;
@@ -2251,6 +2255,7 @@ again:
 
 		cond_resched();
 
+		iov_iter_advance(i, copied);
 		if (unlikely(copied == 0)) {
 			/*
 			 * If we were unable to copy any data at all, we must
@@ -2264,7 +2269,6 @@ again:
 						iov_iter_single_seg_count(i));
 			goto again;
 		}
-		iov_iter_advance(i, copied);
 		pos += copied;
 		written += copied;
 

-- 
