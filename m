Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbYGaAb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbYGaAb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763558AbYGaA1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:27:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:39953 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761323AbYGaA1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:27:47 -0400
Date: Wed, 30 Jul 2008 17:00:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 62/62] Fix off-by-one error in iov_iter_advance()
Message-ID: <20080731000022.GJ12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-off-by-one-error-in-iov_iter_advance.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Linus Torvalds <torvalds@linux-foundation.org>

commit 94ad374a0751f40d25e22e036c37f7263569d24c upstream

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1778,7 +1778,7 @@ void iov_iter_advance(struct iov_iter *i
 		 * The !iov->iov_len check ensures we skip over unlikely
 		 * zero-length segments (without overruning the iovec).
 		 */
-		while (bytes || unlikely(!iov->iov_len && i->count)) {
+		while (bytes || unlikely(i->count && !iov->iov_len)) {
 			int copy;
 
 			copy = min(bytes, iov->iov_len - base);

-- 
