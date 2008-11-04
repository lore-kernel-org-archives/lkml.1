Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbYKDXhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbYKDXhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbYKDXh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:29 -0500
Received: from mail.suse.de ([195.135.220.2]:47129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYKDXh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:29 -0500
Date: Tue, 4 Nov 2008 15:30:57 -0800
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
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 01/57] agp: Fix stolen memory counting on G4X.
Message-ID: <20081104233057.GB659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="agp-fix-stolen-memory-counting-on-g4x.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Anholt <eric@anholt.net>

commit 82e14a6215cbc9804ecc35281e973c6c8ce22fe7 upstream

On the GM45, the amount of stolen memory mapped to the GTT was underestimated,
even though we had 508KB more available since the GTT doesn't take from
stolen memory. On the non-GM45 G4X, we overestimated how much stolen was
mapped to the GTT by 4KB, resulting in GPU page faults when that page was
accessed.

This update requires a corresponding update to xf86-video-intel to work
correctly.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -54,8 +54,7 @@
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
 		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB || \
-		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB)
+		 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GME_HB)
 
 #define IS_G33 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G33_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q35_HB || \
@@ -63,7 +62,8 @@
 
 #define IS_G4X (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IGD_E_HB || \
 		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_Q45_HB || \
-		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G45_HB)
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G45_HB || \
+		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB)
 
 extern int agp_memory_reserved;
 
@@ -525,8 +525,10 @@ static void intel_i830_init_gtt_entries(
 		size += 4;
 	} else if (IS_G4X) {
 		/* On 4 series hardware, GTT stolen is separate from graphics
-		 * stolen, ignore it in stolen gtt entries counting */
-		size = 0;
+		 * stolen, ignore it in stolen gtt entries counting.  However,
+		 * 4KB of the stolen memory doesn't get mapped to the GTT.
+		 */
+		size = 4;
 	} else {
 		/* On previous hardware, the GTT size was just what was
 		 * required to map the aperture.

-- 
