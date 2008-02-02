Return-Path: <linux-kernel-owner+w=401wt.eu-S1763006AbYBBAYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763006AbYBBAYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761685AbYBBAXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:23:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:54472 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbYBBAXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:23:50 -0500
Date: Fri, 1 Feb 2008 16:19:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Julia Lawall <julia@diku.dk>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/27] X25: Add missing x25_neigh_put
Message-ID: <20080202001946.GB8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x25-add-missing-x25_neigh_put.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Julia Lawall <julia@diku.dk>

[X25]: Add missing x25_neigh_put

[ Upstream commit: 76975f8a3186dae501584d0155ea410464f62815 ]

The function x25_get_neigh increments a reference count.  At the point of
the second goto out, the result of calling x25_get_neigh is only stored in
a local variable, and thus no one outside the function will be able to
decrease the reference count.  Thus, x25_neigh_put should be called before
the return in this case.

The problem was found using the following semantic match.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>

@@
type T,T1,T2;
identifier E;
statement S;
expression x1,x2,x3;
int ret;
@@

  T E;
  ...
* if ((E = x25_get_neigh(...)) == NULL)
  S
  ... when != x25_neigh_put(...,(T1)E,...)
      when != if (E != NULL) { ... x25_neigh_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (...) {
    ... when != x25_neigh_put(...,(T2)E,...)
        when != if (E != NULL) { ... x25_neigh_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/x25/x25_forward.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/x25/x25_forward.c
+++ b/net/x25/x25_forward.c
@@ -118,13 +118,14 @@ int x25_forward_data(int lci, struct x25
 		goto out;
 
 	if ( (skbn = pskb_copy(skb, GFP_ATOMIC)) == NULL){
-		goto out;
+		goto output;
 
 	}
 	x25_transmit_link(skbn, nb);
 
-	x25_neigh_put(nb);
 	rc = 1;
+output:
+	x25_neigh_put(nb);
 out:
 	return rc;
 }

-- 
