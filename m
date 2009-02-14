Return-Path: <linux-kernel-owner+w=401wt.eu-S1764829AbZBNBkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764829AbZBNBkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbZBNBQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:38 -0500
Received: from kroah.org ([198.145.64.141]:50520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763340AbZBNBQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:29 -0500
Date: Fri, 13 Feb 2009 17:13:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 30/48] ipv6: Copy cork options in ip6_append_data
Message-ID: <20090214011320.GE17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-copy-cork-options-in-ip6_append_data.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 0178b695fd6b40a62a215cbeb03dd51ada3bb5e0 ]

As the options passed to ip6_append_data may be ephemeral, we need
to duplicate it for corking.  This patch applies the simplest fix
which is to memdup all the relevant bits.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_output.c |   67 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 15 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1104,6 +1104,18 @@ static inline int ip6_ufo_append_data(st
 	return err;
 }
 
+static inline struct ipv6_opt_hdr *ip6_opt_dup(struct ipv6_opt_hdr *src,
+					       gfp_t gfp)
+{
+	return src ? kmemdup(src, (src->hdrlen + 1) * 8, gfp) : NULL;
+}
+
+static inline struct ipv6_rt_hdr *ip6_rthdr_dup(struct ipv6_rt_hdr *src,
+						gfp_t gfp)
+{
+	return src ? kmemdup(src, (src->hdrlen + 1) * 8, gfp) : NULL;
+}
+
 int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 	int offset, int len, int odd, struct sk_buff *skb),
 	void *from, int length, int transhdrlen,
@@ -1129,17 +1141,37 @@ int ip6_append_data(struct sock *sk, int
 		 * setup for corking
 		 */
 		if (opt) {
-			if (np->cork.opt == NULL) {
-				np->cork.opt = kmalloc(opt->tot_len,
-						       sk->sk_allocation);
-				if (unlikely(np->cork.opt == NULL))
-					return -ENOBUFS;
-			} else if (np->cork.opt->tot_len < opt->tot_len) {
-				printk(KERN_DEBUG "ip6_append_data: invalid option length\n");
+			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
-			}
-			memcpy(np->cork.opt, opt, opt->tot_len);
-			inet->cork.flags |= IPCORK_OPT;
+
+			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			if (unlikely(np->cork.opt == NULL))
+				return -ENOBUFS;
+
+			np->cork.opt->tot_len = opt->tot_len;
+			np->cork.opt->opt_flen = opt->opt_flen;
+			np->cork.opt->opt_nflen = opt->opt_nflen;
+
+			np->cork.opt->dst0opt = ip6_opt_dup(opt->dst0opt,
+							    sk->sk_allocation);
+			if (opt->dst0opt && !np->cork.opt->dst0opt)
+				return -ENOBUFS;
+
+			np->cork.opt->dst1opt = ip6_opt_dup(opt->dst1opt,
+							    sk->sk_allocation);
+			if (opt->dst1opt && !np->cork.opt->dst1opt)
+				return -ENOBUFS;
+
+			np->cork.opt->hopopt = ip6_opt_dup(opt->hopopt,
+							   sk->sk_allocation);
+			if (opt->hopopt && !np->cork.opt->hopopt)
+				return -ENOBUFS;
+
+			np->cork.opt->srcrt = ip6_rthdr_dup(opt->srcrt,
+							    sk->sk_allocation);
+			if (opt->srcrt && !np->cork.opt->srcrt)
+				return -ENOBUFS;
+
 			/* need source address above miyazawa*/
 		}
 		dst_hold(&rt->u.dst);
@@ -1166,8 +1198,7 @@ int ip6_append_data(struct sock *sk, int
 	} else {
 		rt = (struct rt6_info *)inet->cork.dst;
 		fl = &inet->cork.fl;
-		if (inet->cork.flags & IPCORK_OPT)
-			opt = np->cork.opt;
+		opt = np->cork.opt;
 		transhdrlen = 0;
 		exthdrlen = 0;
 		mtu = inet->cork.fragsize;
@@ -1406,9 +1437,15 @@ error:
 
 static void ip6_cork_release(struct inet_sock *inet, struct ipv6_pinfo *np)
 {
-	inet->cork.flags &= ~IPCORK_OPT;
-	kfree(np->cork.opt);
-	np->cork.opt = NULL;
+	if (np->cork.opt) {
+		kfree(np->cork.opt->dst0opt);
+		kfree(np->cork.opt->dst1opt);
+		kfree(np->cork.opt->hopopt);
+		kfree(np->cork.opt->srcrt);
+		kfree(np->cork.opt);
+		np->cork.opt = NULL;
+	}
+
 	if (inet->cork.dst) {
 		dst_release(inet->cork.dst);
 		inet->cork.dst = NULL;

