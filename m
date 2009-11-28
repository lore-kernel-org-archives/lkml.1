Return-Path: <linux-kernel-owner+w=401wt.eu-S1753347AbZK1IvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbZK1IvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 03:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZK1IvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 03:51:12 -0500
Received: from iksaif.net ([88.191.73.63]:47242 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbZK1IvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 03:51:11 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Nov 2009 03:51:11 EST
From: Corentin Chary <corentincj@iksaif.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Brian Swetland <swetland@google.com>,
       Chih-Wei Huang <cwhuang@linux.org.tw>,
       LKML <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 1/2] staging/android: fix build issues
Date: Sat, 28 Nov 2009 09:45:14 +0100
Message-Id: <1259397915-762-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
References: <1259397915-762-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/staging/android/logger.c          |    1 +
 drivers/staging/android/lowmemorykiller.c |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 6c10b45..64cc2a1 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -17,6 +17,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 935d281..32314e8 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -100,15 +100,17 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		struct mm_struct *mm;
+		struct signal_struct *sig;
 		int oom_adj;
 
 		task_lock(p);
 		mm = p->mm;
-		if (!mm) {
+		sig = p->signal;
+		if (!mm || !sig) {
 			task_unlock(p);
 			continue;
 		}
-		oom_adj = mm->oom_adj;
+		oom_adj = sig->oom_adj;
 		if (oom_adj < min_adj) {
 			task_unlock(p);
 			continue;
-- 
1.6.5.2

