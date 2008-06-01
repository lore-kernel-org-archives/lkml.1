Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYFADj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYFADj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 23:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYFADjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 23:39:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55415 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbYFADjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 23:39:46 -0400
Date: Sat, 31 May 2008 20:39:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drm: fix crash due to /proc registration race
Message-ID: <20080531203940.40536c9a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] drm: fix crash due to /proc registration race

The DRM layer creates proc entries like this:

                ent = create_proc_entry(drm_proc_list[i].name,
                                        S_IFREG | S_IRUGO, minor->dev_root);
                if (!ent) {
			... stuff ...
                }
                ent->read_proc = drm_proc_list[i].f;
                ent->data = minor;

however that leaves a short window where the /proc file is visible,
but where ->data is not initialized yet.
It appears that this race is actually hit in practice:
http://www.kerneloops.org/search.php?search=drm_name_info

(of course it could be some other race.. but this race appears
to be there at least)

Reported-by: www.kerneloops.org
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/char/drm/drm_proc.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/drm_proc.c b/drivers/char/drm/drm_proc.c
index 93b1e04..19e61ad 100644
--- a/drivers/char/drm/drm_proc.c
+++ b/drivers/char/drm/drm_proc.c
@@ -164,9 +164,20 @@ static int drm_name_info(char *buf, char **start, off_t offset, int request,
 			 int *eof, void *data)
 {
 	struct drm_minor *minor = (struct drm_minor *) data;
-	struct drm_device *dev = minor->dev;
+	struct drm_device *dev;
 	int len = 0;
 
+	/*
+	 * When creating the /proc files, there is a tiny race window
+	 * where "data" isn't assigned yet... error out rather than dereference
+	 */
+	if (!data) {
+		*eof = 1;
+		return 0;
+	}
+
+	dev = minor->dev;
+
 	if (offset > DRM_PROC_LIMIT) {
 		*eof = 1;
 		return 0;
-- 
1.5.5.1


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
