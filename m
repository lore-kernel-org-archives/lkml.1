Return-Path: <linux-kernel-owner+w=401wt.eu-S936636AbXHGVJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936636AbXHGVJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935777AbXHGUxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:53:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935755AbXHGUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:53:38 -0400
Date: Tue, 7 Aug 2007 13:47:08 -0700
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
       alan@lxorguk.ukuu.org.uk, christophe@saout.de, kaber@trash.net,
       agk@redhat.com, mbroz@redhat.com
Subject: [2.6.22.2 review 45/84] dm io: fix panic on large request
Message-ID: <20070807204708.GU23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-io-fix-panic-on-large-request.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Milan Broz <mbroz@redhat.com>

Flush workqueue before releasing bioset and mopools in dm-crypt.  There can
be finished but not yet released request.

Call chain causing oops:
  run workqueue
    dec_pending
      bio_endio(...);
      	<remove device request - remove mempool>
      mempool_free(io, cc->io_pool);

This usually happens when cryptsetup create temporary
luks mapping in the beggining of crypt device activation.

When dm-core calls destructor crypt_dtr, no new request
are possible.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Cc: Christophe Saout <christophe@saout.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -920,6 +920,8 @@ static void crypt_dtr(struct dm_target *
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
+	flush_workqueue(_kcryptd_workqueue);
+
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->io_pool);

-- 
