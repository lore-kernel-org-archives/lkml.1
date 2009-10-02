Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZJBBwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZJBBwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbZJBBwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:52:32 -0400
Received: from kroah.org ([198.145.64.141]:33158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbZJBBdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:15 2009
Message-Id: <20091002012415.010310639@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [057/136] drm/i915: prevent FIFO calculation overflows on 32 bits with high dotclocks
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-prevent-fifo-calculation-overflows-on-32-bits-with-high-dotclocks.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit d660467c3ff2a0b7413e1b7a51452b34ffb49e5f upstream.

A very high dotclock (e.g. 229500kHz as reported by Anton) can cause
the entries_required variable to overflow, potentially leading to a
FIFO watermark value that's too low to support the given mode.  Split
the division across the calculation to avoid this.

Reported-by: Anton Khirnov <wyskas@gmail.com>
Tested-by: Anton Khirnov <wyskas@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1858,7 +1858,14 @@ static unsigned long intel_calculate_wm(
 {
 	long entries_required, wm_size;
 
-	entries_required = (clock_in_khz * pixel_size * latency_ns) / 1000000;
+	/*
+	 * Note: we need to make sure we don't overflow for various clock &
+	 * latency values.
+	 * clocks go from a few thousand to several hundred thousand.
+	 * latency is usually a few thousand
+	 */
+	entries_required = ((clock_in_khz / 1000) * pixel_size * latency_ns) /
+		1000;
 	entries_required /= wm->cacheline_size;
 
 	DRM_DEBUG("FIFO entries required for mode: %d\n", entries_required);


