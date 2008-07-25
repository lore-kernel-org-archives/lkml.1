Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYGYXMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYGYXMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 19:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757266AbYGYXMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 19:12:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33527 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724AbYGYXMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 19:12:30 -0400
Date: Fri, 25 Jul 2008 16:07:31 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 6/9] pppoe: Unshare skb before anything else
Message-ID: <20080725230731.GG1612@suse.de>
References: <20080725225425.193966072@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006-pppoe-Unshare-skb-before-anything-else.patch"
In-Reply-To: <20080725230644.GA1612@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit bc6cffd177f9266af38dba96a2cea06c1e7ff932 ]

We need to unshare the skb first as otherwise pskb_may_pull may
write to a shared skb which could be bad.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pppoe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/pppoe.c
+++ b/drivers/net/pppoe.c
@@ -432,12 +432,12 @@ static int pppoe_disc_rcv(struct sk_buff
 	if (dev->nd_net != &init_net)
 		goto abort;
 
-	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
-		goto abort;
-
 	if (!(skb = skb_share_check(skb, GFP_ATOMIC)))
 		goto out;
 
+	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
+		goto abort;
+
 	ph = pppoe_hdr(skb);
 	if (ph->code != PADT_CODE)
 		goto abort;

-- 
