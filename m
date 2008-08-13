Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYHMWjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYHMWjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYHMWjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:39:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44648 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYHMWjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:39:22 -0400
Date: Wed, 13 Aug 2008 15:40:15 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] ibmaem: Prevent infinite probing loop on x3650 M2 systems
Message-ID: <20080813224015.GA28450@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On older machines, probing for a nonexistent AEM interface returned an IPMI
error; when we saw this, we'd stop probing.  On the x3650 M2 and (presumably)
later, we are returned a value indicating success and a buffer full of garbage
or zeroes.  This causes the probe function to run in an infinite loop.  To fix
this, we add one last check--if the interface number we're looking for is
higher than the number of interfaces that AEM claims to have, stop probing.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmaem.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index c1ee7dd..0f70dc2 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -682,7 +682,8 @@ static int aem_find_aem2(struct aem_ipmi_data *data,
 		return -ETIMEDOUT;
 
 	if (data->rx_result || data->rx_msg_len != sizeof(*fi_resp) ||
-	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)))
+	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)) ||
+	    fi_resp->num_instances <= instance_num)
 		return -ENOENT;
 
 	return 0;
