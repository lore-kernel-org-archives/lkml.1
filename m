Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbXK1NrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbXK1NrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXK1NrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:47:06 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:31085 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbXK1NrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:47:05 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Fix static rate if path faster than link
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Wed, 28 Nov 2007 15:46:28 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711281446.29085.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The formula would yield -1 for this, which is wrong in a bad way (max
throttling). Clamp to 0, which is the correct value.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

This fixes another regression introduced in rc3.
Please review and apply for 2.6.24-rc4. Thanks!

 drivers/infiniband/hw/ehca/ehca_av.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 453eb99..f7782c8 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -76,8 +76,12 @@ int ehca_calc_ipd(struct ehca_shca *shca, int port,
 
 	link = ib_width_enum_to_int(pa.active_width) * pa.active_speed;
 
-	/* IPD = round((link / path) - 1) */
-	*ipd = ((link + (path >> 1)) / path) - 1;
+	if (path >= link)
+		/* no need to throttle if path faster than link */
+		*ipd = 0;
+	else
+		/* IPD = round((link / path) - 1) */
+		*ipd = ((link + (path >> 1)) / path) - 1;
 
 	return 0;
 }
-- 
1.5.2



