Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbXHNHrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbXHNHrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXHNHqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55344 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbXHNHp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:45:57 -0400
Date: Tue, 14 Aug 2007 00:28:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, security@kernel.org, Willy Tarreau <w@1wt.eu>,
       Matt Mackall <mpm@selenic.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 02/12] random: fix bound check ordering (CVE-2007-3105)
Message-ID: <20070814072850.GC15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="random-fix-bound-check-ordering.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Mackall <mpm@selenic.com>

If root raised the default wakeup threshold over the size of the
output pool, the pool transfer function could overflow the stack with
RNG bytes, causing a DoS or potential privilege escalation.

(Bug reported by the PaX Team <pageexec@freemail.hu>)

Cc: Theodore Tso <tytso@mit.edu>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/random.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -693,9 +693,14 @@ static void xfer_secondary_pool(struct e
 
 	if (r->pull && r->entropy_count < nbytes * 8 &&
 	    r->entropy_count < r->poolinfo->POOLBITS) {
-		int bytes = max_t(int, random_read_wakeup_thresh / 8,
-				min_t(int, nbytes, sizeof(tmp)));
+		/* If we're limited, always leave two wakeup worth's BITS */
 		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
+		int bytes = nbytes;
+
+		/* pull at least as many as BYTES as wakeup BITS */
+		bytes = max_t(int, bytes, random_read_wakeup_thresh / 8);
+		/* but never more than the buffer size */
+		bytes = min_t(int, bytes, sizeof(tmp));
 
 		DEBUG_ENT("going to reseed %s with %d bits "
 			  "(%d of %d requested)\n",

-- 
