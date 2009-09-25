Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbZIYCt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbZIYCt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 22:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZIYCt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 22:49:27 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50486 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZIYCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 22:49:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ABC2F87.7070001@jp.fujitsu.com>
Date: Fri, 25 Sep 2009 11:48:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/63] i7core_edac and edac_mce
References: <20090924192821.7fcffc80@pedra.chehab.org>
In-Reply-To: <20090924192821.7fcffc80@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> The content of this patch series is at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git for_linus
> 
> The first submission were done on Sept, 5 but weren't reviewed until 
> yesterday. 
> 
> It is not yet a pull request. It is just the last version, after the 
> last review.
> 
> My intention is to submit likely tomorrow a git pull request if 
> everything is ok and hoping that Linus will still accept it for 2.6.32.
> 
> This time I'm sending the it as a patch series for better review. The complete
> patchset is being sent to EDAC ML (bluesmoke-devel@lists.sourceforge.net).
> 
> Only this email and two others of this series is c/c at LKML. If more people is
> interested on reviewing it, you can always look at -git and/or bluesmoke archives.
> 
> The two patches c/c at LKML are:
> - the one that touches at PCI, for probing buses 254 and 255 - since, by
>   default, ACPI bios doesn't announce those buses with MCU registers;
> - edac_mce glue driver, that add two hooks on mce that are called only if a
>   driver is registered for receiving mce log events. This is needed in order to
>   get corrected error reports at the EDAC driver.
> 
> Cheers,
> Mauro

Interesting, but yes, definitely it needs more reviews.

Thanks,
H.Seto


Subject: [UNTESTED PATCH] i7core_edac: avoid spinlock on fatal error

Be careful on MCE context, or it might cause a deadlock.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/edac/i7core_edac.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 97f6d17..f915a39 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1679,6 +1679,12 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 		return 0;
 	}
 
+	/* Handle fatal errors immediately */
+	if (mce->mcgstatus & 1) {
+		i7core_mce_output_error(mci, mce);
+		return 1;
+	}
+
 	spin_lock_irqsave(&pvt->mce_lock, flags);
 	if (pvt->mce_count < MCE_LOG_LEN) {
 		memcpy(&pvt->mce_entry[pvt->mce_count], mce, sizeof(*mce));
@@ -1686,10 +1692,6 @@ static int i7core_mce_check_error(void *priv, struct mce *mce)
 	}
 	spin_unlock_irqrestore(&pvt->mce_lock, flags);
 
-	/* Handle fatal errors immediately */
-	if (mce->mcgstatus & 1)
-		i7core_check_error(mci);
-
 	/* Advice mcelog that the error were handled */
 	return 1;
 }
-- 
1.6.4.3

