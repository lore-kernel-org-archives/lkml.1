Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbYICRmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbYICRmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbYICRmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:42:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57237 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbYICRmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:42:21 -0400
Date: Wed, 3 Sep 2008 10:26:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Thomas Graf <tgraf@suug.ch>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/42] sch_prio: Fix nla_parse_nested_compat() regression
Message-ID: <20080903172621.GC7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0009-sch_prio-Fix-nla_parse_nested_compat-regression.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Graf <tgraf@suug.ch>

[ No upstream commit, this is fixing code no longer in 2.6.27 ]

nla_parse_nested_compat() was used to parse two different message
formats in the netem and prio qdisc, when it was "fixed" to work
with netem, it broke the multi queue support in the prio qdisc.
Since the prio qdisc code in question is already removed in the
development tree, this patch only fixes the regression in the
stable tree.

Based on original patch from Alexander H Duyck <alexander.h.duyck@intel.com>

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/sch_prio.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -228,14 +228,20 @@ static int prio_tune(struct Qdisc *sch, 
 {
 	struct prio_sched_data *q = qdisc_priv(sch);
 	struct tc_prio_qopt *qopt;
-	struct nlattr *tb[TCA_PRIO_MAX + 1];
+	struct nlattr *tb[TCA_PRIO_MAX + 1] = {0};
 	int err;
 	int i;
 
-	err = nla_parse_nested_compat(tb, TCA_PRIO_MAX, opt, NULL, qopt,
-				      sizeof(*qopt));
-	if (err < 0)
-		return err;
+	qopt = nla_data(opt);
+	if (nla_len(opt) < sizeof(*qopt))
+		return -1;
+
+	if (nla_len(opt) >= sizeof(*qopt) + sizeof(struct nlattr)) {
+		err = nla_parse_nested(tb, TCA_PRIO_MAX,
+				       (struct nlattr *) (qopt + 1), NULL);
+		if (err < 0)
+			return err;
+	}
 
 	q->bands = qopt->bands;
 	/* If we're multiqueue, make sure the number of incoming bands

-- 
