Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbZFIKQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbZFIKQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759772AbZFIKPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:45 -0400
Received: from kroah.org ([198.145.64.141]:59725 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759673AbZFIKPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:44 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:53 2009
Message-Id: <20090609094053.454554199@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:54 -0700
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
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/87] net: fix length computation in rt_check_expire()
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=net-fix-length-computation-in-rt_check_expire.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <dada1@cosmosbay.com>

[ Upstream commit cf8da764fc6959b7efb482f375dfef9830e98205 ]

rt_check_expire() computes average and standard deviation of chain lengths,
but not correclty reset length to 0 at beginning of each chain.
This probably gives overflows for sum2 (and sum) on loaded machines instead
of meaningful results.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -785,7 +785,7 @@ static void rt_check_expire(void)
 	static unsigned int rover;
 	unsigned int i = rover, goal;
 	struct rtable *rth, **rthp;
-	unsigned long length = 0, samples = 0;
+	unsigned long samples = 0;
 	unsigned long sum = 0, sum2 = 0;
 	u64 mult;
 
@@ -795,9 +795,9 @@ static void rt_check_expire(void)
 	goal = (unsigned int)mult;
 	if (goal > rt_hash_mask)
 		goal = rt_hash_mask + 1;
-	length = 0;
 	for (; goal > 0; goal--) {
 		unsigned long tmo = ip_rt_gc_timeout;
+		unsigned long length;
 
 		i = (i + 1) & rt_hash_mask;
 		rthp = &rt_hash_table[i].chain;
@@ -809,6 +809,7 @@ static void rt_check_expire(void)
 
 		if (*rthp == NULL)
 			continue;
+		length = 0;
 		spin_lock_bh(rt_hash_lock_addr(i));
 		while ((rth = *rthp) != NULL) {
 			if (rt_is_expired(rth)) {


