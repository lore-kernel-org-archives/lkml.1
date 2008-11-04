Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYKDXmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYKDXmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbYKDXi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:51870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbYKDXi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:26 -0500
Date: Tue, 4 Nov 2008 15:31:28 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Ilpo =?utf-8?B?SsOD4oKscnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 15/57] tcp: Restore ordering of TCP options for the sake of
	inter-operability
Message-ID: <20081104233128.GP659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="0002-tcp-Restore-ordering-of-TCP-options-for-the-sake-of.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

[ Upstream commit fd6149d332973bafa50f03ddb0ea9513e67f4517 ]

This is not our bug! Sadly some devices cannot cope with the change
of TCP option ordering which was a result of the recent rewrite of
the option code (not that there was some particular reason steming
from the rewrite for the reordering) though any ordering of TCP
options is perfectly legal. Thus we restore the original ordering
to allow interoperability with/through such broken devices and add
some warning about this trap. Since the reordering just happened
without any particular reason, this change shouldn't cost us
anything.

There are already couple of known failure reports (within close
proximity of the last release), so the problem might be more
wide-spread than a single device. And other reports which may
be due to the same problem though the symptoms were less obvious.
Analysis of one of the case revealed (with very high probability)
that sack capability cannot be negotiated as the first option
(SYN never got a response).

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Reported-by: Aldo Maggi <sentiniate@tiscali.it>
Tested-by: Aldo Maggi <sentiniate@tiscali.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -357,6 +357,17 @@ struct tcp_out_options {
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 };
 
+/* Beware: Something in the Internet is very sensitive to the ordering of
+ * TCP options, we learned this through the hard way, so be careful here.
+ * Luckily we can at least blame others for their non-compliance but from
+ * inter-operatibility perspective it seems that we're somewhat stuck with
+ * the ordering which we have been using if we want to keep working with
+ * those broken things (not that it currently hurts anybody as there isn't
+ * particular reason why the ordering would need to be changed).
+ *
+ * At least SACK_PERM as the first option is known to lead to a disaster
+ * (but it may well be that other scenarios fail similarly).
+ */
 static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 			      const struct tcp_out_options *opts,
 			      __u8 **md5_hash) {
@@ -371,6 +382,12 @@ static void tcp_options_write(__be32 *pt
 		*md5_hash = NULL;
 	}
 
+	if (unlikely(opts->mss)) {
+		*ptr++ = htonl((TCPOPT_MSS << 24) |
+			       (TCPOLEN_MSS << 16) |
+			       opts->mss);
+	}
+
 	if (likely(OPTION_TS & opts->options)) {
 		if (unlikely(OPTION_SACK_ADVERTISE & opts->options)) {
 			*ptr++ = htonl((TCPOPT_SACK_PERM << 24) |
@@ -387,12 +404,6 @@ static void tcp_options_write(__be32 *pt
 		*ptr++ = htonl(opts->tsecr);
 	}
 
-	if (unlikely(opts->mss)) {
-		*ptr++ = htonl((TCPOPT_MSS << 24) |
-			       (TCPOLEN_MSS << 16) |
-			       opts->mss);
-	}
-
 	if (unlikely(OPTION_SACK_ADVERTISE & opts->options &&
 		     !(OPTION_TS & opts->options))) {
 		*ptr++ = htonl((TCPOPT_NOP << 24) |

-- 
