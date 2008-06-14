Return-Path: <linux-kernel-owner+w=401wt.eu-S1763995AbYFNAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763995AbYFNAY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762185AbYFNAO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762171AbYFNAOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:54 -0400
Date: Fri, 13 Jun 2008 17:11:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: [patch 36/47] hgafb: resource management fix
Message-ID: <20080614001157.GJ24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hgafb-resource-management-fix.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Krzysztof Helt <krzysztof.h1@wp.pl>

commit 630c270183133ac25bef8c8d726ac448df9b169a upstream
Date: Thu, 12 Jun 2008 15:21:29 -0700
Subject: [patch 36/47] hgafb: resource management fix

Release ports which are requested during detection which are not freed if
there is no hga card.  Otherwise there is a crash during cat /proc/ioports
command.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/hgafb.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -279,7 +279,7 @@ static void hga_blank(int blank_mode)
 
 static int __init hga_card_detect(void)
 {
-	int count=0;
+	int count = 0;
 	void __iomem *p, *q;
 	unsigned short p_save, q_save;
 
@@ -303,20 +303,18 @@ static int __init hga_card_detect(void)
 	writew(0x55aa, p); if (readw(p) == 0x55aa) count++;
 	writew(p_save, p);
 
-	if (count != 2) {
-		return 0;
-	}
+	if (count != 2)
+		goto error;
 
 	/* Ok, there is definitely a card registering at the correct
 	 * memory location, so now we do an I/O port test.
 	 */
 	
-	if (!test_hga_b(0x66, 0x0f)) {	    /* cursor low register */
-		return 0;
-	}
-	if (!test_hga_b(0x99, 0x0f)) {     /* cursor low register */
-		return 0;
-	}
+	if (!test_hga_b(0x66, 0x0f))	    /* cursor low register */
+		goto error;
+
+	if (!test_hga_b(0x99, 0x0f))     /* cursor low register */
+		goto error;
 
 	/* See if the card is a Hercules, by checking whether the vsync
 	 * bit of the status register is changing.  This test lasts for
@@ -331,7 +329,7 @@ static int __init hga_card_detect(void)
 	}
 
 	if (p_save == q_save) 
-		return 0;
+		goto error;
 
 	switch (inb_p(HGA_STATUS_PORT) & 0x70) {
 		case 0x10:
@@ -348,6 +346,12 @@ static int __init hga_card_detect(void)
 			break;
 	}
 	return 1;
+error:
+	if (release_io_ports)
+		release_region(0x3b0, 12);
+	if (release_io_port)
+		release_region(0x3bf, 1);
+	return 0;
 }
 
 /**

-- 
