Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYKOF1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYKOF1r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYKOFY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:24:58 -0500
Received: from kroah.org ([198.145.64.141]:50523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752605AbYKOFY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:24:57 -0500
Date: Fri, 14 Nov 2008 21:23:09 -0800
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
       alan@lxorguk.ukuu.org.uk, Nicolas Pitre <nico@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 08/22] ARM: 5329/1: Feroceon: fix feroceon_l2_inv_range
Message-ID: <20081115052309.GI3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="arm-5329-1-feroceon-fix-feroceon_l2_inv_range.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Pitre <nico@cam.org>

commit 72bc2b1ad62f4d2f0a51b35829093d41f55accce upstream

Same fix as commit c7cf72dcadb: when 'start' and 'end' are less than a
cacheline apart and 'start' is unaligned we are done after cleaning and
invalidating the first cacheline.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mm/cache-feroceon-l2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/cache-feroceon-l2.c
+++ b/arch/arm/mm/cache-feroceon-l2.c
@@ -148,7 +148,7 @@ static void feroceon_l2_inv_range(unsign
 	/*
 	 * Clean and invalidate partial last cache line.
 	 */
-	if (end & (CACHE_LINE_SIZE - 1)) {
+	if (start < end && end & (CACHE_LINE_SIZE - 1)) {
 		l2_clean_inv_pa(end & ~(CACHE_LINE_SIZE - 1));
 		end &= ~(CACHE_LINE_SIZE - 1);
 	}
@@ -156,7 +156,7 @@ static void feroceon_l2_inv_range(unsign
 	/*
 	 * Invalidate all full cache lines between 'start' and 'end'.
 	 */
-	while (start != end) {
+	while (start < end) {
 		unsigned long range_end = calc_range_end(start, end);
 		l2_inv_pa_range(start, range_end - CACHE_LINE_SIZE);
 		start = range_end;

-- 
