Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZBNBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZBNBJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbZBNBBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:46 -0500
Received: from kroah.org ([198.145.64.141]:39645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760353AbZBNBBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:43 -0500
Date: Fri, 13 Feb 2009 16:58:47 -0800
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 21/47] ipv6: Disallow rediculious flowlabel option sizes.
Message-ID: <20090214005847.GV11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv6-disallow-rediculious-flowlabel-option-sizes.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 684de409acff8b1fe8bf188d75ff2f99c624387d ]

Just like PKTINFO, limit the options area to 64K.

Based upon report by Eric Sesterhenn and analysis by
Roland Dreier.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_flowlabel.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -323,17 +323,21 @@ static struct ip6_flowlabel *
 fl_create(struct net *net, struct in6_flowlabel_req *freq, char __user *optval,
 	  int optlen, int *err_p)
 {
-	struct ip6_flowlabel *fl;
+	struct ip6_flowlabel *fl = NULL;
 	int olen;
 	int addr_type;
 	int err;
 
+	olen = optlen - CMSG_ALIGN(sizeof(*freq));
+	err = -EINVAL;
+	if (olen > 64 * 1024)
+		goto done;
+
 	err = -ENOMEM;
 	fl = kzalloc(sizeof(*fl), GFP_KERNEL);
 	if (fl == NULL)
 		goto done;
 
-	olen = optlen - CMSG_ALIGN(sizeof(*freq));
 	if (olen > 0) {
 		struct msghdr msg;
 		struct flowi flowi;

