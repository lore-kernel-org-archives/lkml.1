Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXLMG4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXLMG4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759601AbXLMGzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54981 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759125AbXLMGzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:31 -0500
Date: Wed, 12 Dec 2007 22:51:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <dada1@cosmosbay.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 02/60] NET: random : secure_tcp_sequence_number should not
	assume CONFIG_KTIME_SCALAR
Message-ID: <20071213065107.GC6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-random-secure_tcp_sequence_number-should-not-assume-config_ktime_scalar.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eric Dumazet <dada1@cosmosbay.com>

[NET] random : secure_tcp_sequence_number should not assume CONFIG_KTIME_SCALAR

[ Upstream commit: 6dd10a62353a50b30b30e0c18653650975b29c71 ]

All 32 bits machines but i386 dont have CONFIG_KTIME_SCALAR. On these
machines, ktime.tv64 is more than 4 times the (correct) result given
by ktime_to_ns()

Again on these machines, using ktime_get_real().tv64 >> 6 give a
32bits rollover every 64 seconds, which is not wanted (less than the
120 s MSL)

Using ktime_to_ns() is the portable way to get nsecs from a ktime, and
have correct code.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1494,7 +1494,7 @@ __u32 secure_tcpv6_sequence_number(__be3
 	seq = twothirdsMD4Transform((const __u32 *)daddr, hash) & HASH_MASK;
 	seq += keyptr->count;
 
-	seq += ktime_get_real().tv64;
+	seq += ktime_to_ns(ktime_get_real());
 
 	return seq;
 }
@@ -1556,7 +1556,7 @@ __u32 secure_tcp_sequence_number(__be32 
 	 *	overlaps less than one time per MSL (2 minutes).
 	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
 	 */
-	seq += ktime_get_real().tv64 >> 6;
+	seq += ktime_to_ns(ktime_get_real()) >> 6;
 #if 0
 	printk("init_seq(%lx, %lx, %d, %d) = %d\n",
 	       saddr, daddr, sport, dport, seq);
@@ -1616,7 +1616,7 @@ u64 secure_dccp_sequence_number(__be32 s
 	seq = half_md4_transform(hash, keyptr->secret);
 	seq |= ((u64)keyptr->count) << (32 - HASH_BITS);
 
-	seq += ktime_get_real().tv64;
+	seq += ktime_to_ns(ktime_get_real());
 	seq &= (1ull << 48) - 1;
 #if 0
 	printk("dccp init_seq(%lx, %lx, %d, %d) = %d\n",

-- 
