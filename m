Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbYIPWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYIPWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIPWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:25:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33655 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbYIPWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:25:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jonathan Steel <jon.steel@esentire.com>
References: <48D0067F.3020007@esentire.com>
Date: Tue, 16 Sep 2008 15:21:53 -0700
In-Reply-To: <48D0067F.3020007@esentire.com> (Jonathan Steel's message of
	"Tue, 16 Sep 2008 15:18:23 -0400")
Message-ID: <m1d4j3g29q.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0303]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH] kexec: segmentation fault in kimage_add_entry
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Steel <jon.steel@esentire.com>

A segmentation fault can occur in kimage_add_entry in kexec.c when
loading a kernel image into memory. The fault occurs because a page is
requested by calling kimage_alloc_page with gfp_mask GFP_KERNEL and the
function may actually return a page with gfp_mask GFP_HIGHUSER. The high
mem page is returned because it was swapped with the kernel page due to
the kernel page being a page that will shortly be copied to.

This patch ensures that kimage_alloc_page returns a page that was
created with the correct gfp flags.


I have verified the change and fixed the whitespace damage of the
original patch.  Jonathan did a great job of tracking this down
after he hit the problem. -- Eric

Signed-off-by: Jonathan Steel <jon.steel@esentire.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/kexec.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f3f0d..aef2653 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -753,8 +753,14 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			*old = addr | (*old & ~PAGE_MASK);
 
 			/* The old page I have found cannot be a
-			 * destination page, so return it.
+			 * destination page, so return it if it's
+			 * gfp_flags honor the ones passed in.
 			 */
+			if (!(gfp_mask & __GFP_HIGHMEM) &&
+			    PageHighMem(old_page)) {
+				kimage_free_pages(old_page);
+				continue;
+			}
 			addr = old_addr;
 			page = old_page;
 			break;
-- 
1.5.3.rc6.17.g1911

