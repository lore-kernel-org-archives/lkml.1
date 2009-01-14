Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbZANOcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbZANOcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZANOcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:32:19 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:60404 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbZANOcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:32:18 -0500
Date: Wed, 14 Jan 2009 17:32:28 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@gentoo.org>, Richard Henderson <rth@twiddle.net>,
       Jay Estabrook <jay.estabrook@hp.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] alpha: nautilus - fix compile failure with gcc-4.3
Message-ID: <20090114143228.GB10788@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_srm_irq() deals with irq's #16 and above, but size of irq_desc
array on nautilus and some other system types is 16. So gcc-4.3
complains that "array subscript is above array bounds", even though
this function is never called on those systems.

This adds a check for NR_IRQS <= 16, which effectively optimizes
init_srm_irq() code away on problematic platforms.

Thanks to Daniel Drake <dsd@gentoo.org> for detailed analysis
of the problem.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/kernel/irq_srm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/irq_srm.c b/arch/alpha/kernel/irq_srm.c
index 3221201..a03fbca 100644
--- a/arch/alpha/kernel/irq_srm.c
+++ b/arch/alpha/kernel/irq_srm.c
@@ -63,6 +63,8 @@ init_srm_irqs(long max, unsigned long ignore_mask)
 {
 	long i;
 
+	if (NR_IRQS <= 16)
+		return;
 	for (i = 16; i < max; ++i) {
 		if (i < 64 && ((ignore_mask >> i) & 1))
 			continue;
