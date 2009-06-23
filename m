Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbZFWNFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbZFWNFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZFWNFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:05:31 -0400
Received: from a.mx.secunet.com ([213.68.205.161]:42497 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059AbZFWNFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:05:30 -0400
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 09:05:30 EDT
Message-ID: <4A40CE67.4060504@secunet.com>
Date: Tue, 23 Jun 2009 14:45:27 +0200
From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Dave Airlie <airlied@linux.ie>, Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH] drm: Fixes error with gcc 3.3.5 in i915 driver.
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2009 12:45:28.0380 (UTC) FILETIME=[7C909FC0:01C9F400]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling with gcc 3.3.5 I got the following error message in the
module i915.ko:

ERROR: "__udivdi3" [drivers/gpu/drm/i915/i915.ko] undefined!

This error did not occur when compiling the same code in gcc 4.3.2.

This patch replaces the 64 bit division by a call of div_u64 to avoid
triggering the problem on the older compiler.

The code to be fixed was introduced in
commit 2c07245fb8f7f0a282282e5a9747e46defdb2cc7
---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c
b/drivers/gpu/drm/i915/intel_display.c
index 3e1c781..306d198 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1502,7 +1502,7 @@ igdng_compute_m_n(int bytes_per_pixel, int nlanes,

 	temp = (u64) DATA_N * pixel_clock;
 	temp = div_u64(temp, link_clock);
-	m_n->gmch_m = (temp * bytes_per_pixel) / nlanes;
+	m_n->gmch_m = div_u64(temp * byte_per_pixel, nlanes);
 	m_n->gmch_n = DATA_N;
 	fdi_reduce_ratio(&m_n->gmch_m, &m_n->gmch_n);

-- 
1.5.4.2

