Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbZBDSxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbZBDSxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761284AbZBDStK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:10 -0500
Received: from kroah.org ([198.145.64.141]:34333 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760217AbZBDStG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:06 -0500
Date: Wed, 4 Feb 2009 10:46:02 -0800
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
       alan@lxorguk.ukuu.org.uk, Risto Suominen <Risto.Suominen@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 07/41] fbdev/atyfb: Fix DSP config on some PowerMacs &
	PowerBooks
Message-ID: <20090204184602.GH25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fbdev-atyfb-fix-dsp-config-on-some-powermacs-powerbooks.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Risto Suominen <Risto.Suominen@gmail.com>

commit 7fbb7cadd062baf299fd8b26a80ea99da0c3fe01 upstream.

Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
columns in their framebuffer image. This seems to depend on a value (4) read
from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
be written to the chip. This patch uses a value calculated by aty_init_pll_ct
instead, as a starting point.

There are questions as to whether this should be extended to other platforms
or maybe made dependent on specific chip types, but in the meantime, this has
been tested on various powermacs and works for them so let's commit it.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Tested-by: Michael Pettersson <mike@it.uu.se>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/aty/mach64_ct.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/video/aty/mach64_ct.c
+++ b/drivers/video/aty/mach64_ct.c
@@ -8,6 +8,9 @@
 #include <asm/io.h>
 #include <video/mach64.h>
 #include "atyfb.h"
+#ifdef CONFIG_PPC
+#include <asm/machdep.h>
+#endif
 
 #undef DEBUG
 
@@ -536,6 +539,14 @@ static int __devinit aty_init_pll_ct(con
 	pll->ct.xclk_post_div_real = postdividers[xpost_div];
 	pll->ct.mclk_fb_div = q * pll->ct.xclk_post_div_real / 8;
 
+#ifdef CONFIG_PPC
+	if (machine_is(powermac)) {
+		/* Override PLL_EXT_CNTL & 0x07. */
+		pll->ct.xclk_post_div = xpost_div;
+		pll->ct.xclk_ref_div = 1;
+	}
+#endif
+
 #ifdef DEBUG
 	pllmclk = (1000000 * pll->ct.mclk_fb_mult * pll->ct.mclk_fb_div) /
 			(par->ref_clk_per * pll->ct.pll_ref_div);

