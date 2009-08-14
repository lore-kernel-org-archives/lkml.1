Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZHNLaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZHNLaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbZHNL0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:26:33 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46833 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZHNL0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:21 -0400
Message-Id: <20090814112617.964417879@de.ibm.com>
References: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:40 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 23/34] kernel: Convert upper case scpdata to lower case
Content-Disposition: inline; filename=122-scpdata-lower-case.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>

If the CP SET LOADDEV on the 3215 console has been used to specify
SCPdata, all data is converted to upper case letters.

When scpdata contains upper case letters only, convert all letters
to lower case.

Signed-off-by: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/ipl.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: quilt-2.6/arch/s390/kernel/ipl.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/ipl.c
+++ quilt-2.6/arch/s390/kernel/ipl.c
@@ -340,19 +340,28 @@ size_t reipl_append_ascii_scpdata(char *
 {
 	size_t count;
 	size_t i;
+	int has_lowercase;
 
 	count = min(size - 1, scpdata_length(ipb->ipl_info.fcp.scp_data,
 					     ipb->ipl_info.fcp.scp_data_len));
 	if (!count)
 		goto out;
 
-	for (i = 0; i < count; i++)
+	has_lowercase = 0;
+	for (i = 0; i < count; i++) {
 		if (!isascii(ipb->ipl_info.fcp.scp_data[i])) {
 			count = 0;
 			goto out;
 		}
+		if (!has_lowercase && islower(ipb->ipl_info.fcp.scp_data[i]))
+			has_lowercase = 1;
+	}
 
-	memcpy(dest, ipb->ipl_info.fcp.scp_data, count);
+	if (has_lowercase)
+		memcpy(dest, ipb->ipl_info.fcp.scp_data, count);
+	else
+		for (i = 0; i < count; i++)
+			dest[i] = tolower(ipb->ipl_info.fcp.scp_data[i]);
 out:
 	dest[count] = '\0';
 	return count;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

