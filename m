Return-Path: <linux-kernel-owner+w=401wt.eu-S935311AbXHGVCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935311AbXHGVCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964953AbXHGUvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:51:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56361 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964945AbXHGUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:51:42 -0400
Date: Tue, 7 Aug 2007 13:45:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [2.6.22.2 review 33/84] splice: fix double page unlock
Message-ID: <20070807204539.GH23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="splice-fix-double-page-unlock.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

If add_to_page_cache_lru() fails, the page will not be locked. But
splice jumps to an error path that does a page release and unlock,
causing a BUG() in unlock_page().

Fix this by adding one more label that just releases the page. This bug
was actually triggered on EL5 by gurudas pai <gurudas.pai@oracle.com>
using fio.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -601,7 +601,7 @@ find_page:
 		ret = add_to_page_cache_lru(page, mapping, index,
 					    GFP_KERNEL);
 		if (unlikely(ret))
-			goto out;
+			goto out_release;
 	}
 
 	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
@@ -657,8 +657,9 @@ find_page:
 	 */
 	mark_page_accessed(page);
 out:
-	page_cache_release(page);
 	unlock_page(page);
+out_release:
+	page_cache_release(page);
 out_ret:
 	return ret;
 }

-- 
