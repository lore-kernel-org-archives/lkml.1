Return-Path: <linux-kernel-owner+w=401wt.eu-S1030651AbXCSVwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbXCSVwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXCSVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:59317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965122AbXCSVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:39 -0400
Date: Mon, 19 Mar 2007 14:39:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Joy Latten <latten@austin.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/31] Fix extraneous IPSEC larval SA creation
Message-ID: <20070319213950.GT9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-extraneous-ipsec-larval-sa-creation.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joy Latten <latten@austin.ibm.com>

[XFRM]: Fix missing protocol comparison of larval SAs.

I noticed that in xfrm_state_add we look for the larval SA in a few
places without checking for protocol match. So when using both
AH and ESP, whichever one gets added first, deletes the larval SA.
It seems AH always gets added first and ESP is always the larval
SA's protocol since the xfrm->tmpl has it first. Thus causing the
additional km_query()

Adding the check eliminates accidental double SA creation.

Signed-off-by: Joy Latten <latten@austin.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_state.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -707,7 +707,8 @@ static struct xfrm_state *__find_acq_cor
 		    x->props.mode   != mode ||
 		    x->props.family != family ||
 		    x->km.state     != XFRM_STATE_ACQ ||
-		    x->id.spi       != 0)
+		    x->id.spi       != 0 ||
+		    x->id.proto	    != proto)
 			continue;
 
 		switch (family) {
@@ -804,7 +805,8 @@ int xfrm_state_add(struct xfrm_state *x)
 
 	if (use_spi && x->km.seq) {
 		x1 = __xfrm_find_acq_byseq(x->km.seq);
-		if (x1 && xfrm_addr_cmp(&x1->id.daddr, &x->id.daddr, family)) {
+		if (x1 && ((x1->id.proto != x->id.proto) ||
+		    xfrm_addr_cmp(&x1->id.daddr, &x->id.daddr, family))) {
 			xfrm_state_put(x1);
 			x1 = NULL;
 		}

-- 
