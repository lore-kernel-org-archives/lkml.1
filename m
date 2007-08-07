Return-Path: <linux-kernel-owner+w=401wt.eu-S936834AbXHGVMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936834AbXHGVMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965061AbXHGUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:54:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59582 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965056AbXHGUyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:54:25 -0400
Date: Tue, 7 Aug 2007 13:47:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, neilb@suse.de, bfields@citi.umich.edu,
       gnb@melbourne.sgi.com
Subject: [2.6.22.2 review 51/84] nfsd: fix possible read-ahead cache and
	export table corruption
Message-ID: <20070807204736.GA23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfsd-fix-possible-read-ahead-cache-and-export-table-corruption.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

The value of nperbucket calculated here is too small--we should be rounding up
instead of down--with the result that the index j in the following loop can
overflow the raparm_hash array.  At least in my case, the next thing in memory
turns out to be export_table, so the symptoms I see are crashes caused by the
appearance of four zeroed-out export entries in the first bucket of the hash
table of exports (which were actually entries in the readahead cache, a
pointer to which had been written to the export table in this initialization
code).

It looks like the bug was probably introduced with commit
fce1456a19f5c08b688c29f00ef90fdfa074c79b ("knfsd: make the readahead params
cache SMP-friendly").

Cc: Greg Banks <gnb@melbourne.sgi.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1890,7 +1890,7 @@ nfsd_racache_init(int cache_size)
 		raparm_hash[i].pb_head = NULL;
 		spin_lock_init(&raparm_hash[i].pb_lock);
 	}
-	nperbucket = cache_size >> RAPARM_HASH_BITS;
+	nperbucket = DIV_ROUND_UP(cache_size, RAPARM_HASH_SIZE);
 	for (i = 0; i < cache_size - 1; i++) {
 		if (i % nperbucket == 0)
 			raparm_hash[j++].pb_head = raparml + i;

-- 
