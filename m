Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZBWTus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZBWTus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZBWTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:50:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:47521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbZBWTui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:50:38 -0500
Message-ID: <49A2FDBF.6050205@kernel.org>
Date: Mon, 23 Feb 2009 11:49:19 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Jeffrey Trull <jetrull@sbcglobal.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/agp: tight check to update amd nb aperture
References: <622229.85336.qm@web82407.mail.mud.yahoo.com> <49A257AB.4040200@kernel.org>
In-Reply-To: <49A257AB.4040200@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix bug to make agp working with dri

Jeffrey Reported that dri does work with 64bit, but doesn't work with 32bit
it turns out NB aperture is 32M, aperture on agp is 128M

64bit is using 64M for vaidation for 64 iommu/gart
32bit is only using 32M..., and will not update the nb aperture.

so try to compare nb apterture and agp apterture before leaving not touch nb
aperture.

Reported-by: Jeffrey Trull <jetrull@sbcglobal.net>
Tested-by: Jeffrey Trull <jetrull@sbcglobal.net>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/char/agp/amd64-agp.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/char/agp/amd64-agp.c
===================================================================
--- linux-2.6.orig/drivers/char/agp/amd64-agp.c
+++ linux-2.6/drivers/char/agp/amd64-agp.c
@@ -271,15 +271,15 @@ static __devinit int fix_northbridge(str
 	nb_order = (nb_order >> 1) & 7;
 	pci_read_config_dword(nb, AMD64_GARTAPERTUREBASE, &nb_base);
 	nb_aper = nb_base << 25;
-	if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order)) {
-		return 0;
-	}
 
 	/* Northbridge seems to contain crap. Try the AGP bridge. */
 
 	pci_read_config_word(agp, cap+0x14, &apsize);
-	if (apsize == 0xffff)
+	if (apsize == 0xffff) {
+		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
+			return 0;
 		return -1;
+	}
 
 	apsize &= 0xfff;
 	/* Some BIOS use weird encodings not in the AGPv3 table. */
@@ -301,6 +301,11 @@ static __devinit int fix_northbridge(str
 		order = nb_order;
 	}
 
+	if (nb_order >= order) {
+		if (agp_aperture_valid(nb_aper, (32*1024*1024)<<nb_order))
+			return 0;
+	}
+
 	dev_info(&agp->dev, "aperture from AGP @ %Lx size %u MB\n",
 		 aper, 32 << order);
 	if (order < 0 || !agp_aperture_valid(aper, (32*1024*1024)<<order))
