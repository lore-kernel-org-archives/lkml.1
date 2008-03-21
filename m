Return-Path: <linux-kernel-owner+w=401wt.eu-S1763100AbYCUXrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763100AbYCUXrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYCUXph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60184 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbYCUXp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:27 -0400
Message-Id: <20080321224331.440687042@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:42:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 04/76] TCP: Improve ipv4 established hash function.
Content-Disposition: inline; filename=tcp-improve-ipv4-established-hash-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: 7adc3830f90df04a13366914d80a3ed407db5381

If all of the entropy is in the local and foreign addresses,
but xor'ing together would cancel out that entropy, the
current hash performs poorly.

Suggested by Cosmin Ratiu:

	Basically, the situation is as follows: There is a client
	machine and a server machine. Both create 15000 virtual
	interfaces, open up a socket for each pair of interfaces and
	do SIP traffic. By profiling I noticed that there is a lot of
	time spent walking the established hash chains with this
	particular setup.

	The addresses were distributed like this: client interfaces
	were 198.18.0.1/16 with increments of 1 and server interfaces
	were 198.18.128.1/16 with increments of 1. As I said, there
	were 15000 interfaces. Source and destination ports were 5060
	for each connection.  So in this case, ports don't matter for
	hashing purposes, and the bits from the address pairs used
	cancel each other, meaning there are no differences in the
	whole lot of pairs, so they all end up in the same hash chain.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 include/net/inet_sock.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -175,7 +175,8 @@ extern void build_ehash_secret(void);
 static inline unsigned int inet_ehashfn(const __be32 laddr, const __u16 lport,
 					const __be32 faddr, const __be16 fport)
 {
-	return jhash_2words((__force __u32) laddr ^ (__force __u32) faddr,
+	return jhash_3words((__force __u32) laddr,
+			    (__force __u32) faddr,
 			    ((__u32) lport) << 16 | (__force __u32)fport,
 			    inet_ehash_secret);
 }

-- 
