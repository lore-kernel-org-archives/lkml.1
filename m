Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbXDZRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbXDZRBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbXDZRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbXDZQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:59:45 -0400
Date: Thu, 26 Apr 2007 09:55:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       John Heffner <jheffner@psc.edu>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 14/33] Fix errors in tcp_memcalculations.
Message-ID: <20070426165557.GO1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-errors-in-tcp_mem-calculations.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: John Heffner <jheffner@psc.edu>

In 2.6.18 a change was made to the tcp_mem[] calculations,
but this causes regressions for some folks up to 2.6.20

The following fix to smooth out the calculation from the
pending 2.6.21 tree by John Heffner fixes the problem for
these folks.

[TCP]: Fix tcp_mem[] initialization.

Change tcp_mem initialization function.  The fraction of total memory
is now a continuous function of memory size, and independent of page
size.

Signed-off-by: John Heffner <jheffner@psc.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2457,11 +2457,18 @@ void __init tcp_init(void)
 		sysctl_max_syn_backlog = 128;
 	}
 
-	/* Allow no more than 3/4 kernel memory (usually less) allocated to TCP */
-	sysctl_tcp_mem[0] = (1536 / sizeof (struct inet_bind_hashbucket)) << order;
-	sysctl_tcp_mem[1] = sysctl_tcp_mem[0] * 4 / 3;
+	/* Set the pressure threshold to be a fraction of global memory that
+	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
+	 * memory, with a floor of 128 pages.
+	 */
+	limit = min(nr_all_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
+	limit = (limit * (nr_all_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
+	limit = max(limit, 128UL);
+	sysctl_tcp_mem[0] = limit / 4 * 3;
+	sysctl_tcp_mem[1] = limit;
 	sysctl_tcp_mem[2] = sysctl_tcp_mem[0] * 2;
 
+	/* Set per-socket limits to no more than 1/128 the pressure threshold */
 	limit = ((unsigned long)sysctl_tcp_mem[1]) << (PAGE_SHIFT - 7);
 	max_share = min(4UL*1024*1024, limit);
 

-- 
