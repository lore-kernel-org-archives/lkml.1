Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYGUH7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYGUH7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbYGUH67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:58:59 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39820 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbYGUH66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:58:58 -0400
Date: Mon, 21 Jul 2008 09:58:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/7] drivers/video: Release mutex in error handling code
Message-ID: <Pine.LNX.4.64.0807210958320.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/arkfb.c    |    9 +++------
 drivers/video/vt8623fb.c |    9 +++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff -u -p a/drivers/video/arkfb.c b/drivers/video/arkfb.c
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -1126,11 +1126,8 @@ static int ark_pci_resume (struct pci_de
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
 
-	if (par->ref_count == 0) {
-		mutex_unlock(&(par->open_lock));
-		release_console_sem();
-		return 0;
-	}
+	if (par->ref_count == 0)
+		goto fail;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -1143,8 +1140,8 @@ static int ark_pci_resume (struct pci_de
 	arkfb_set_par(info);
 	fb_set_suspend(info, 0);
 
-	mutex_unlock(&(par->open_lock));
 fail:
+	mutex_unlock(&(par->open_lock));
 	release_console_sem();
 	return 0;
 }
diff -u -p a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -853,11 +853,8 @@ static int vt8623_pci_resume(struct pci_
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
 
-	if (par->ref_count == 0) {
-		mutex_unlock(&(par->open_lock));
-		release_console_sem();
-		return 0;
-	}
+	if (par->ref_count == 0)
+		goto fail;
 
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
@@ -870,8 +867,8 @@ static int vt8623_pci_resume(struct pci_
 	vt8623fb_set_par(info);
 	fb_set_suspend(info, 0);
 
-	mutex_unlock(&(par->open_lock));
 fail:
+	mutex_unlock(&(par->open_lock));
 	release_console_sem();
 
 	return 0;
