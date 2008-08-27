Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYH0Oaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYH0Oaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYH0OaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:30:25 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:57986 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbYH0OaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:30:24 -0400
Date: Wed, 27 Aug 2008 16:28:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [GIT PULL] 2.6.27-rc5 updates for s390
Message-ID: <20080827142809.GA10087@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

This contains just two s390 specific build fixes.

Heiko Carstens (2):
      [S390] Fix linker script.
      [S390] dcss: fix build bug.

 arch/s390/kernel/vmlinux.lds.S |    2 +-
 drivers/s390/block/dcssblk.c   |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 76c1e60..607bd67 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -55,7 +55,7 @@ SECTIONS
 		__start___ex_table = .;
 		*(__ex_table)
 		__stop___ex_table = .;
-	}
+	} :data
 
 	.data : {		/* Data */
 		DATA_DATA
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index db85f1f..711b300 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -384,9 +384,10 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	 * get minor, add to list
 	 */
 	down_write(&dcssblk_devices_sem);
-	if (dcssblk_get_segment_by_name(local_buf)) {
+	if (dcssblk_get_device_by_name(local_buf)) {
+		up_write(&dcssblk_devices_sem);
 		rc = -EEXIST;
-		goto release_gd;
+		goto unload_seg;
 	}
 	rc = dcssblk_assign_free_minor(dev_info);
 	if (rc) {
