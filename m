Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbYBWAik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbYBWAik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934215AbYBWAeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934135AbYBWAeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:08 -0500
Date: Fri, 22 Feb 2008 16:30:15 -0800
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
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 11/38] TC: oops in em_meta
Message-ID: <20080223003015.GL7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tc-oops-in-em_meta.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

Upstream commit: 04f217aca4d803fe72c2c54fe460d68f5233ce52

If userspace passes a unknown match index into em_meta, then
em_meta_change will return an error and the data for the match will
not be set. This then causes an null pointer dereference when the
cleanup is done in the error path via tcf_em_tree_destroy. Since the
tree structure comes kzalloc, it is initialized to NULL.

Discovered when testing a new version of tc command against an
accidental older kernel.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/em_meta.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -719,11 +719,13 @@ static int em_meta_match(struct sk_buff 
 
 static inline void meta_delete(struct meta_match *meta)
 {
-	struct meta_type_ops *ops = meta_type_ops(&meta->lvalue);
+	if (meta) {
+		struct meta_type_ops *ops = meta_type_ops(&meta->lvalue);
 
-	if (ops && ops->destroy) {
-		ops->destroy(&meta->lvalue);
-		ops->destroy(&meta->rvalue);
+		if (ops && ops->destroy) {
+			ops->destroy(&meta->lvalue);
+			ops->destroy(&meta->rvalue);
+		}
 	}
 
 	kfree(meta);

-- 
