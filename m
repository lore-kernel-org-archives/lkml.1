Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZAOU5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZAOU5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZAOUDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:23 -0500
Received: from kroah.org ([198.145.64.141]:49908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932123AbZAOUDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:19 -0500
Date: Thu, 15 Jan 2009 12:00:51 -0800
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
Subject: [patch 94/94] mm: fix assertion
Message-ID: <20090115200051.GP14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-fix-assertion.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 18e6959c385f3edf3991fa6662a53dac4eb10d5b upstream.

This assertion is incorrect for lockless pagecache.  By definition if we
have an unpinned page that we are trying to take a speculative reference
to, it may become the tail of a compound page at any time (if it is
freed, then reallocated as a compound page).

It was still a valid assertion for the vmscan.c LRU isolation case, but
it doesn't seem incredibly helpful...  if somebody wants it, they can
put it back directly where it applies in the vmscan code.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -253,7 +253,6 @@ static inline int put_page_testzero(stru
  */
 static inline int get_page_unless_zero(struct page *page)
 {
-	VM_BUG_ON(PageTail(page));
 	return atomic_inc_not_zero(&page->_count);
 }
 

