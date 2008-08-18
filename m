Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbYHRTqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbYHRTqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYHRTlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:41:55 -0400
Received: from ns1.suse.de ([195.135.220.2]:49549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765393AbYHRTlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:41:53 -0400
Date: Mon, 18 Aug 2008 12:20:47 -0700
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
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 41/49] radeon: misc corrections
Message-ID: <20080818192047.GP10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="radeon-misc-corrections.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Miller <davem@davemloft.net>

Commit efc491814308f89d5ef6c4fe19ae4552a67d4132 upstream

radeon: misc corrections

I have a new PCI-E radeon RV380 series card (PCI device ID 5b64) that
hangs in my sparc64 boxes when the init scripts set the font.  The problem
goes away if I disable acceleration.

I haven't figured out that bug yet, but along the way I found some
corrections to make based upon some auditing.

1) The RB2D_DC_FLUSH_ALL value used by the kernel fb driver
   and the XORG video driver differ.  I've made the kernel
   match what XORG is using.

2) In radeonfb_engine_reset() we have top-level code structure
   that roughly looks like:

	if (family is 300, 350, or V350)
		do this;
	else
		do that;
	...
	if (family is NOT 300, OR
	    family is NOT 350, OR
	    family is NOT V350)
		do another thing;

   this last conditional makes no sense, is always true,
   and obviously was likely meant to be "family is NOT
   300, 350, or V350".  So I've made the code match the
   intent.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/aty/radeon_accel.c |    4 ++--
 include/video/radeon.h           |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/video/aty/radeon_accel.c
+++ b/drivers/video/aty/radeon_accel.c
@@ -249,8 +249,8 @@ void radeonfb_engine_reset(struct radeon
 	INREG(HOST_PATH_CNTL);
 	OUTREG(HOST_PATH_CNTL, host_path_cntl);
 
-	if (rinfo->family != CHIP_FAMILY_R300 ||
-	    rinfo->family != CHIP_FAMILY_R350 ||
+	if (rinfo->family != CHIP_FAMILY_R300 &&
+	    rinfo->family != CHIP_FAMILY_R350 &&
 	    rinfo->family != CHIP_FAMILY_RV350)
 		OUTREG(RBBM_SOFT_RESET, rbbm_soft_reset);
 
--- a/include/video/radeon.h
+++ b/include/video/radeon.h
@@ -527,8 +527,9 @@
 
 
 /* DSTCACHE_CTLSTAT bit constants */
-#define RB2D_DC_FLUSH				   (3 << 0)
-#define RB2D_DC_FLUSH_ALL			   0xf
+#define RB2D_DC_FLUSH_2D			   (1 << 0)
+#define RB2D_DC_FREE_2D				   (1 << 2)
+#define RB2D_DC_FLUSH_ALL			   (RB2D_DC_FLUSH_2D | RB2D_DC_FREE_2D)
 #define RB2D_DC_BUSY				   (1 << 31)
 
 

-- 
