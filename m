Return-Path: <linux-kernel-owner+w=401wt.eu-S1946254AbXBCChP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946254AbXBCChP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946245AbXBCCg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:36:58 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52798 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946236AbXBCCgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:55 -0500
Message-Id: <20070203024119.875945000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:27 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Paul Moore" <paul.moore@hp.com>, antoine@nagafix.co.uk,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: [patch 23/59] SELinux: fix an oops with NetLabel and non-MLS SELinux policy
Content-Disposition: inline; filename=netlabel-selinux_mls_fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From:  <paul.moore@hp.com>

In the case where a user has configured NetLabel in the kernel but is not
using a SELinux policy with the MLS/MCS feature enabled there is a bug in
mls_export_cat() where a NULL pointer is used.  The initial problem report and
discussion can be found here (this patch has been ACK'd by Stephen Smalley and
 James Morris in the discussion thread below):

 * http://marc2.theaimsgroup.com/?t=116920302500004&r=1&w=2

This patch is specific to the 2.6.19.y kernel series as the mls_export_cat()
function has been replaced in the 2.6.20 kernel.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 security/selinux/ss/mls.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- linux-2.6.19.2.orig/security/selinux/ss/mls.c
+++ linux-2.6.19.2/security/selinux/ss/mls.c
@@ -641,10 +641,14 @@ int mls_export_cat(const struct context 
 	int rc = -EPERM;
 
 	if (!selinux_mls_enabled) {
-		*low = NULL;
-		*low_len = 0;
-		*high = NULL;
-		*high_len = 0;
+		if (low != NULL) {
+			*low = NULL;
+			*low_len = 0;
+		}
+		if (high != NULL) {
+			*high = NULL;
+			*high_len = 0;
+		}
 		return 0;
 	}
 

--
