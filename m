Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbYFSVd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbYFSVd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbYFSVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:42690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbYFSVcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:01 -0400
Date: Thu, 19 Jun 2008 14:29:52 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
       bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 06/15] b43: Fix noise calculation WARN_ON
Message-ID: <20080619212952.GG20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-fix-noise-calculation-warn_on.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 98a3b2fe435ae76170936c14f5c9e6a87548e3ef upstream.

This removes a WARN_ON that is responsible for the following koops:
http://www.kerneloops.org/searchweek.php?search=b43_generate_noise_sample

The comment in the patch describes why it's safe to simply remove
the check.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/b43/b43.h  |    1 -
 drivers/net/wireless/b43/main.c |   16 ++++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -596,7 +596,6 @@ struct b43_dma {
 
 /* Context information for a noise calculation (Link Quality). */
 struct b43_noise_calculation {
-	u8 channel_at_start;
 	bool calculation_running;
 	u8 nr_samples;
 	s8 samples[8][4];
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1027,7 +1027,6 @@ static void b43_generate_noise_sample(st
 	b43_jssi_write(dev, 0x7F7F7F7F);
 	b43_write32(dev, B43_MMIO_MACCMD,
 		    b43_read32(dev, B43_MMIO_MACCMD) | B43_MACCMD_BGNOISE);
-	B43_WARN_ON(dev->noisecalc.channel_at_start != dev->phy.channel);
 }
 
 static void b43_calculate_link_quality(struct b43_wldev *dev)
@@ -1036,7 +1035,6 @@ static void b43_calculate_link_quality(s
 
 	if (dev->noisecalc.calculation_running)
 		return;
-	dev->noisecalc.channel_at_start = dev->phy.channel;
 	dev->noisecalc.calculation_running = 1;
 	dev->noisecalc.nr_samples = 0;
 
@@ -1053,9 +1051,16 @@ static void handle_irq_noise(struct b43_
 
 	/* Bottom half of Link Quality calculation. */
 
+	/* Possible race condition: It might be possible that the user
+	 * changed to a different channel in the meantime since we
+	 * started the calculation. We ignore that fact, since it's
+	 * not really that much of a problem. The background noise is
+	 * an estimation only anyway. Slightly wrong results will get damped
+	 * by the averaging of the 8 sample rounds. Additionally the
+	 * value is shortlived. So it will be replaced by the next noise
+	 * calculation round soon. */
+
 	B43_WARN_ON(!dev->noisecalc.calculation_running);
-	if (dev->noisecalc.channel_at_start != phy->channel)
-		goto drop_calculation;
 	*((__le32 *)noise) = cpu_to_le32(b43_jssi_read(dev));
 	if (noise[0] == 0x7F || noise[1] == 0x7F ||
 	    noise[2] == 0x7F || noise[3] == 0x7F)
@@ -1096,11 +1101,10 @@ static void handle_irq_noise(struct b43_
 			average -= 48;
 
 		dev->stats.link_noise = average;
-	      drop_calculation:
 		dev->noisecalc.calculation_running = 0;
 		return;
 	}
-      generate_new:
+generate_new:
 	b43_generate_noise_sample(dev);
 }
 

-- 
