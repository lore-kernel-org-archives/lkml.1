Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZBNBCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZBNBCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZBNBBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:24 -0500
Received: from kroah.org ([198.145.64.141]:39366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbZBNBBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:23 -0500
Date: Fri, 13 Feb 2009 16:58:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
Subject: [patch 01/47] Fix page writeback thinko, causing Berkeley DB
	slowdown
Message-ID: <20090214005805.GB11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-page-writeback-thinko-causing-berkeley-db-slowdown.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 3a4c6800f31ea8395628af5e7e490270ee5d0585 upstream.

A bug was introduced into write_cache_pages cyclic writeout by commit
31a12666d8f0c22235297e1c1575f82061480029 ("mm: write_cache_pages cyclic
fix").  The intention (and comments) is that we should cycle back and
look for more dirty pages at the beginning of the file if there is no
more work to be done.

But the !done condition was dropped from the test.  This means that any
time the page writeout loop breaks (eg.  due to nr_to_write == 0), we
will set index to 0, then goto again.  This will set done_index to
index, then find done is set, so will proceed to the end of the
function.  When updating mapping->writeback_index for cyclic writeout,
we now use done_index == 0, so we're always cycling back to 0.

This seemed to be causing random mmap writes (slapadd and iozone) to
start writing more pages from the LRU and writeout would slowdown, and
caused bugzilla entry

	http://bugzilla.kernel.org/show_bug.cgi?id=12604

about Berkeley DB slowing down dramatically.

With this patch, iozone random write performance is increased nearly
5x on my system (iozone -B -r 4k -s 64k -s 512m -s 1200m on ext2).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reported-and-tested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1001,7 +1001,7 @@ continue_unlock:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!cycled) {
+	if (!cycled && !done) {
 		/*
 		 * range_cyclic:
 		 * We hit the last page and there is more work to be done: wrap

