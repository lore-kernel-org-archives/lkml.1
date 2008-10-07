Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYJGAmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYJGAmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbYJGAlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:41:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:60135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbYJGAlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:41:19 -0400
Date: Mon, 6 Oct 2008 17:37:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Yuri Tikhonov <yur@emcraft.com>,
       Ilya Yanok <yanok@emcraft.com>, Dan Williams <dan.j.williams@intel.com>
Subject: [patch 06/71] async_tx: fix the bug in async_tx_run_dependencies
Message-ID: <20081007003738.GG3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="async_tx-fix-the-bug-in-async_tx_run_dependencies.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Yuri Tikhonov <yur@emcraft.com>

commit de24125dd0a452bfd4502fc448e3534c5d2e87aa upstream

Should clear the next pointer of the TX if we are sure that the
next TX (say NXT) will be submitted to the channel too. Overwise,
we break the chain of descriptors, because we lose the information
about the next descriptor to run. So next time, when invoke
async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
NXT will be never submitted.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Ilya Yanok <yanok@emcraft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/async_tx/async_tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -136,7 +136,8 @@ async_tx_run_dependencies(struct dma_asy
 		spin_lock_bh(&next->lock);
 		next->parent = NULL;
 		_next = next->next;
-		next->next = NULL;
+		if (_next && _next->chan == chan)
+			next->next = NULL;
 		spin_unlock_bh(&next->lock);
 
 		next->tx_submit(next);

-- 
