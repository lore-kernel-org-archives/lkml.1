Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXLMHM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXLMHM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbXLMG5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55513 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762605AbXLMG5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:41 -0500
Date: Wed, 12 Dec 2007 22:52:58 -0800
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
Subject: [patch 39/60] NET: Corrects a bug in ip_rt_acct_read()
Message-ID: <20071213065258.GO6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-corrects-a-bug-in-ip_rt_acct_read.patch"
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

[NET]: Corrects a bug in ip_rt_acct_read()

[ Upstream commit: 483b23ffa3a5f44767038b0a676d757e0668437e ]

It seems that stats of cpu 0 are counted twice, since
for_each_possible_cpu() is looping on all possible cpus, including 0

Before percpu conversion of ip_rt_acct, we should also remove the
assumption that CPU 0 is online (or even possible)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2913,18 +2913,14 @@ static int ip_rt_acct_read(char *buffer,
 	offset /= sizeof(u32);
 
 	if (length > 0) {
-		u32 *src = ((u32 *) IP_RT_ACCT_CPU(0)) + offset;
 		u32 *dst = (u32 *) buffer;
 
-		/* Copy first cpu. */
 		*start = buffer;
-		memcpy(dst, src, length);
+		memset(dst, 0, length);
 
-		/* Add the other cpus in, one int at a time */
 		for_each_possible_cpu(i) {
 			unsigned int j;
-
-			src = ((u32 *) IP_RT_ACCT_CPU(i)) + offset;
+			u32 *src = ((u32 *) IP_RT_ACCT_CPU(i)) + offset;
 
 			for (j = 0; j < length/4; j++)
 				dst[j] += src[j];

-- 
