Return-Path: <linux-kernel-owner+w=401wt.eu-S1765347AbYDQBN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765347AbYDQBN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758816AbYDQBH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:28 -0400
Received: from sous-sol.org ([216.99.217.87]:58838 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYDQBHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:23 -0400
Message-Id: <20080417010340.987341667@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:52 -0700
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
       "David S. Miller" <davem@davemloft.net>
Subject: SUNGEM: Fix NAPI assertion failure.
Content-Disposition: inline; filename=sungem-fix-napi-assertion-failure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: da990a2402aeaee84837f29054c4628eb02f7493

As reported by Johannes Berg:

I started getting this warning with recent kernels:

[  773.908927] ------------[ cut here ]------------
[  773.908954] Badness at net/core/dev.c:2204
 ...

If we loop more than once in gem_poll(), we'll
use more than the real budget in our gem_rx()
calls, thus eventually trigger the caller's
assertions in net_rx_action().

Subtract "work_done" from "budget" for the second
arg to gem_rx() to fix the bug.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/sungem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -910,7 +910,7 @@ static int gem_poll(struct napi_struct *
 		 * rx ring - must call napi_disable(), which
 		 * schedule_timeout()'s if polling is already disabled.
 		 */
-		work_done += gem_rx(gp, budget);
+		work_done += gem_rx(gp, budget - work_done);
 
 		if (work_done >= budget)
 			return work_done;

-- 
