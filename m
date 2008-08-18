Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYHRR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYHRR7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYHRR7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:59:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYHRR7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:59:00 -0400
From: michaelc@cs.wisc.edu
To: linux-kernel@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>,
       Shyam Kumar Iyer <shyam_iyer@dell.com>,
       Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH 1/1] ibft: fix target info parsing in ibft module
Date: Mon, 18 Aug 2008 12:58:48 -0500
Message-Id: <1219082328-11010-1-git-send-email-michaelc@cs.wisc.edu>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

I got this patch through Red Hat's bugzilla from the bug
submitter and patch creator. I have just fixed it up so it applies without
fuzz to upstream kernels.

Original patch and description from Shyam kumar Iyer:

The issue [ibft module not displaying targets with short names]
is because of an offset calculatation error in the iscsi_ibft.c
code.  Due to this error directory structure for the target
in /sys/firmware/ibft does not get created and so the initiator is unable to
connect to the target.

Note that this bug surfaced only with an name that had a short section at the
end.
eg: "iqn.1984-05.com.dell:dell".
It did not surface when the iqn's had a longer section at the end.
eg: "iqn.2001-04.com.example:storage.disk2.sys1.xyz"

So, the eot_offset was calculated such that an extra 48 bytes i.e. the size of
the ibft_header which has already been accounted was subtracted twice.

This was not evident with longer iqn names because they would overshoot the
total ibft length more than 48 bytes and thus would escape the bug.

Signed-off-by: Shyam Kumar Iyer <shyam_iyer@dell.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>


---
 drivers/firmware/iscsi_ibft.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 8024e3b..b91ef63 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -669,8 +669,7 @@ static int __init ibft_register_kobjects(struct ibft_table_header *header,
 
 	control = (void *)header + sizeof(*header);
 	end = (void *)control + control->hdr.length;
-	eot_offset = (void *)header + header->length -
-		     (void *)control - sizeof(*header);
+	eot_offset = (void *)header + header->length - (void *)control;
 	rc = ibft_verify_hdr("control", (struct ibft_hdr *)control, id_control,
 			     sizeof(*control));
 
-- 
1.5.4.1

