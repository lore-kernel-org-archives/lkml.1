Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZAVSXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZAVSXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZAVSWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:22:52 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:13104 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZAVSWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:22:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=P909lIgKZ3y9go1i+MJaydQTY1xyDitWOR7Di3GCLiBZxQyT6NNWh+l2jywzFBZMfK
         Wdx33hMkkQvgSdJx7+97HOxjbFRwR2Gs6YFW/V2qzztSaT62bULy6y/JAuAIBMLkjsj0
         XgrfOi4BRmjUw98GkRzRGGzWk4ycJepxrWRDk=
MIME-Version: 1.0
Date: Thu, 22 Jan 2009 20:22:48 +0200
Message-ID: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
Subject: [PATCH] atyfb: fix distorted image on PowerMacs
From: Risto Suominen <risto.suominen@gmail.com>
To: Alex Kern <alex.kern@gmx.de>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Content-Type: multipart/mixed; boundary=001636c5b0651754420461165caa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5b0651754420461165caa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
columns in their framebuffer image. This seems to depend on a value (4) read
from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
be written to the chip. This patch uses a value calculated by aty_init_pll_ct
instead, as a starting point.

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
---
The testing is done on kernel version 2.6.18.

--- a/drivers/video/aty/mach64_ct.c.org	2006-09-20 06:42:06.000000000 +0300
+++ b/drivers/video/aty/mach64_ct.c	2009-01-22 14:28:13.000000000 +0200
@@ -7,6 +7,7 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 #include <video/mach64.h>
+#include <asm/machdep.h>
 #include "atyfb.h"

 #undef DEBUG
@@ -536,6 +537,14 @@ static int __init aty_init_pll_ct(const
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

--001636c5b0651754420461165caa
Content-Type: text/x-diff; charset=US-ASCII; name="aty-mach64-pmac.diff"
Content-Disposition: attachment; filename="aty-mach64-pmac.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fq9oogx10

U2luY2UgdGhlIGNvbXBsZXRlIHJlLXdyaXRlIGluIDIuNi4xMCwgc29tZSBQb3dlck1hY3MgKEF0
IGxlYXN0IFBvd2VyTWFjIDU1MDAKYW5kIFBvd2VyTWFjIEczIEJlaWdlIHJldiBBKSB3aXRoIEFU
SSBNYWNoNjQgY2hpcCBoYXZlIHN1ZmZlcmVkIGZyb20gdW5zdGFibGUKY29sdW1ucyBpbiB0aGVp
ciBmcmFtZWJ1ZmZlciBpbWFnZS4gVGhpcyBzZWVtcyB0byBkZXBlbmQgb24gYSB2YWx1ZSAoNCkg
cmVhZApmcm9tIFBMTF9FWFRfQ05UTCByZWdpc3Rlciwgd2hpY2ggbGVhZHMgdG8gaW5jb3JyZWN0
IERTUCBjb25maWcgcGFyYW1ldGVycyB0bwpiZSB3cml0dGVuIHRvIHRoZSBjaGlwLiBUaGlzIHBh
dGNoIHVzZXMgYSB2YWx1ZSBjYWxjdWxhdGVkIGJ5IGF0eV9pbml0X3BsbF9jdAppbnN0ZWFkLCBh
cyBhIHN0YXJ0aW5nIHBvaW50LgoKU2lnbmVkLW9mZi1ieTogUmlzdG8gU3VvbWluZW4gPFJpc3Rv
LlN1b21pbmVuQGdtYWlsLmNvbT4KLS0tClRoZSB0ZXN0aW5nIGlzIGRvbmUgb24ga2VybmVsIHZl
cnNpb24gMi42LjE4LgoKLS0tIGEvZHJpdmVycy92aWRlby9hdHkvbWFjaDY0X2N0LmMub3JnCTIw
MDYtMDktMjAgMDY6NDI6MDYuMDAwMDAwMDAwICswMzAwCisrKyBiL2RyaXZlcnMvdmlkZW8vYXR5
L21hY2g2NF9jdC5jCTIwMDktMDEtMjIgMTQ6Mjg6MTMuMDAwMDAwMDAwICswMjAwCkBAIC03LDYg
KzcsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2RlbGF5Lmg+CiAjaW5jbHVkZSA8YXNtL2lvLmg+CiAj
aW5jbHVkZSA8dmlkZW8vbWFjaDY0Lmg+CisjaW5jbHVkZSA8YXNtL21hY2hkZXAuaD4KICNpbmNs
dWRlICJhdHlmYi5oIgogCiAjdW5kZWYgREVCVUcKQEAgLTUzNiw2ICs1MzcsMTQgQEAgc3RhdGlj
IGludCBfX2luaXQgYXR5X2luaXRfcGxsX2N0KGNvbnN0IAogCXBsbC0+Y3QueGNsa19wb3N0X2Rp
dl9yZWFsID0gcG9zdGRpdmlkZXJzW3hwb3N0X2Rpdl07CiAJcGxsLT5jdC5tY2xrX2ZiX2RpdiA9
IHEgKiBwbGwtPmN0LnhjbGtfcG9zdF9kaXZfcmVhbCAvIDg7CiAKKyNpZmRlZiBDT05GSUdfUFBD
CisJaWYgKG1hY2hpbmVfaXMocG93ZXJtYWMpKSB7CisJCS8qIE92ZXJyaWRlIFBMTF9FWFRfQ05U
TCAmIDB4MDcuICovCisJCXBsbC0+Y3QueGNsa19wb3N0X2RpdiA9IHhwb3N0X2RpdjsKKwkJcGxs
LT5jdC54Y2xrX3JlZl9kaXYgPSAxOworCX0KKyNlbmRpZgorCiAjaWZkZWYgREVCVUcKIAlwbGxt
Y2xrID0gKDEwMDAwMDAgKiBwbGwtPmN0Lm1jbGtfZmJfbXVsdCAqIHBsbC0+Y3QubWNsa19mYl9k
aXYpIC8KIAkJCShwYXItPnJlZl9jbGtfcGVyICogcGxsLT5jdC5wbGxfcmVmX2Rpdik7Cg==
--001636c5b0651754420461165caa--
