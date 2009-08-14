Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbZHNDUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbZHNDUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 23:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZHNDUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 23:20:18 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:46102 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZHNDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 23:20:17 -0400
X-IronPort-AV: E=Sophos;i="4.43,378,1246852800"; 
   d="scan'208";a="5037181"
From: <graff.yang@gmail.com>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graff.yang@gmail.com>
Subject: [PATCH] mm/nommu.c: check read permission in validate_mmap_request()
Date: Fri, 14 Aug 2009 11:19:21 +0800
Message-ID: <1250219961-11681-1-git-send-email-graff.yang@gmail.com>
X-Mailer: git-send-email 1.6.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graff Yang <graff.yang@gmail.com>

According to the POSIX (1003.1-2008), the file shall have been opened
with read permission, regardless of the protection options specified.
The ltp test cases mmap06/07 need this.

Signed-off-by: Graff Yang <graff.yang@gmail.com>
---
 mm/nommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 53cab10..ac13b23 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -922,6 +922,10 @@ static int validate_mmap_request(struct file *file,
 		if (!file->f_op->read)
 			capabilities &= ~BDI_CAP_MAP_COPY;
 
+		/* The file shall have been opened with read permission. */
+		if (!(file->f_mode & FMODE_READ))
+			return -EACCES;
+
 		if (flags & MAP_SHARED) {
 			/* do checks for writing, appending and locking */
 			if ((prot & PROT_WRITE) &&
-- 
1.6.1

