Return-Path: <linux-kernel-owner+w=401wt.eu-S1763365AbYCUWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763365AbYCUWsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762678AbYCUWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34735 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762673AbYCUWqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:14 -0400
Message-Id: <20080321224454.264815306@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:44:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dan Williams <dan.j.williams@intel.com>, Neil Brown <neilb@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 73/76] async_tx: avoid the async xor_zero_sum path when src_cnt > device->max_xor
Content-Disposition: inline; filename=async_tx-avoid-the-async-xor_zero_sum-path-when-src_cnt-device-max_xor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dan Williams <dan.j.williams@intel.com>

If the channel cannot perform the operation in one call to
->device_prep_dma_zero_sum, then fallback to the xor+page_is_zero path.
This only affects users with arrays larger than 16 devices on iop13xx or
32 devices on iop3xx.

Cc: <stable@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[chrisw@sous-sol.org: backport to 2.6.24.3]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
please verify the backport makes sense

 crypto/async_tx/async_xor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -264,7 +264,7 @@ async_xor_zero_sum(struct page *dest, st
 
 	BUG_ON(src_cnt <= 1);
 
-	if (tx) {
+	if (tx && src_cnt <= device->max_xor) {
 		dma_addr_t dma_addr;
 		enum dma_data_direction dir;
 

-- 
