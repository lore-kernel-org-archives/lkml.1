Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYKLAc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYKLAc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYKLA0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:22 -0500
Received: from kroah.org ([198.145.64.141]:42256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753468AbYKLA0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:20 -0500
Date: Tue, 11 Nov 2008 16:23:29 -0800
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
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Lothar Wafmann <LW@KARO-electronics.de>,
       Lennert Buytenhek <buytenh@marvell.com>,
       Eric Miao <eric.miao@marvell.com>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [patch 17/49] ARM: xsc3: fix xsc3_l2_inv_range
Message-ID: <20081112002329.GR10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="arm-xsc3-fix-xsc3_l2_inv_range.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit c7cf72dcadbe39c2077b32460f86c9f8167be3be upstream

When 'start' and 'end' are less than a cacheline apart and 'start' is
unaligned we are done after cleaning and invalidating the first
cacheline.  So check for (start < end) which will not walk off into
invalid address ranges when (start > end).

This issue was caught by drivers/dma/dmatest.

2.6.27 is susceptible.

Cc: <stable@kernel.org>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Lothar Wafmann <LW@KARO-electronics.de>
Cc: Lennert Buytenhek <buytenh@marvell.com>
Cc: Eric Miao <eric.miao@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/cache-xsc3l2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/cache-xsc3l2.c
+++ b/arch/arm/mm/cache-xsc3l2.c
@@ -97,7 +97,7 @@ static void xsc3_l2_inv_range(unsigned l
 	/*
 	 * Clean and invalidate partial last cache line.
 	 */
-	if (end & (CACHE_LINE_SIZE - 1)) {
+	if (start < end && (end & (CACHE_LINE_SIZE - 1))) {
 		xsc3_l2_clean_pa(end & ~(CACHE_LINE_SIZE - 1));
 		xsc3_l2_inv_pa(end & ~(CACHE_LINE_SIZE - 1));
 		end &= ~(CACHE_LINE_SIZE - 1);
@@ -106,7 +106,7 @@ static void xsc3_l2_inv_range(unsigned l
 	/*
 	 * Invalidate all full cache lines between 'start' and 'end'.
 	 */
-	while (start != end) {
+	while (start < end) {
 		xsc3_l2_inv_pa(start);
 		start += CACHE_LINE_SIZE;
 	}

-- 
