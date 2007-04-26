Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXDZQ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXDZQ7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbXDZQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:58:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34978 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbXDZQ6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:58:14 -0400
Date: Thu, 26 Apr 2007 09:55:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mst@mellanox.co.il,
       general@lists.openfabrics.org,
       "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 02/33] IB/mthca: Fix data corruption after FMR unmap on
	Sinai
Message-ID: <20070426165502.GC1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-mthca-fix-data-corruption-after-fmr-unmap-on-sinai.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael S. Tsirkin <mst@dev.mellanox.co.il>

In mthca_arbel_fmr_unmap(), the high bits of the key are masked off.
This gets rid of the effect of adjust_key(), which makes sure that
bits 3 and 23 of the key are equal when the Sinai throughput
optimization is enabled, and so it may happen that an FMR will end up
with bits 3 and 23 in the key being different.  This causes data
corruption, because when enabling the throughput optimization, the
driver promises the HCA firmware that bits 3 and 23 of all memory keys
will always be equal.

Fix by re-applying adjust_key() after masking the key.

Thanks to Or Gerlitz for reproducing the problem, and Ariel Shahar for
help in debug.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/mthca/mthca_mr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -751,6 +751,7 @@ void mthca_arbel_fmr_unmap(struct mthca_
 
 	key = arbel_key_to_hw_index(fmr->ibmr.lkey);
 	key &= dev->limits.num_mpts - 1;
+	key = adjust_key(dev, key);
 	fmr->ibmr.lkey = fmr->ibmr.rkey = arbel_hw_index_to_key(key);
 
 	fmr->maps = 0;

-- 
