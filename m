Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYLKTSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYLKTSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbYLKTSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:05 -0500
Received: from kroah.org ([198.145.64.141]:55755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756306AbYLKTSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:03 -0500
Date: Thu, 11 Dec 2008 11:13:34 -0800
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
       alan@lxorguk.ukuu.org.uk, Roland Dreier <rolandd@cisco.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 03/83] cxgb3: Fix kernel crash caused by uninitialized
	l2t_entry.arpq
Message-ID: <20081211191334.GC5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-cxgb3-Fix-kernel-crash-caused-by-uninitialized-l2t_.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Dreier <rdreier@cisco.com>

[ Upstream commit 6d329af9967e7ab3f4a3d7f1e8ef87539c3a069f ]

Commit 147e70e6 ("cxgb3: Use SKB list interfaces instead of home-grown
implementation.") causes a crash in t3_l2t_send_slow() when an iWARP
connection request is received.  This is because the new l2t_entry.arpq
skb queue is never initialized, and therefore trying to add an skb to
it causes a NULL dereference.  With the old code there was no need to
initialize the queues because the l2t_entry structures were zeroed,
and the code used NULL to mean empty.

Fix this by adding __skb_queue_head_init() when all the l2t_entry
structures get allocated.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cxgb3/l2t.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/cxgb3/l2t.c
+++ b/drivers/net/cxgb3/l2t.c
@@ -436,6 +436,7 @@ struct l2t_data *t3_init_l2t(unsigned in
 	for (i = 0; i < l2t_capacity; ++i) {
 		d->l2tab[i].idx = i;
 		d->l2tab[i].state = L2T_STATE_UNUSED;
+		__skb_queue_head_init(&d->l2tab[i].arpq);
 		spin_lock_init(&d->l2tab[i].lock);
 		atomic_set(&d->l2tab[i].refcnt, 0);
 	}

