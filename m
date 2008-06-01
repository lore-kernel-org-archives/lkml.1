Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYFAEu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYFAEu3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 00:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYFAEuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 00:50:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48350 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYFAEuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 00:50:17 -0400
Date: Sat, 31 May 2008 21:48:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] drm: make drm use create_proc_read_entry() instead
Message-ID: <20080531214821.19218b6b@infradead.org>
In-Reply-To: <20080531203940.40536c9a@infradead.org>
References: <20080531203940.40536c9a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] drm: make drm use create_proc_read_entry() instead

Al Viro points out that DRM should have used create_proc_read_entry(),
and although that is still racey right now, it at least has a chance
of getting fixed on the api level.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/char/drm/drm_proc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/drm/drm_proc.c b/drivers/char/drm/drm_proc.c
index 19e61ad..b586378 100644
--- a/drivers/char/drm/drm_proc.c
+++ b/drivers/char/drm/drm_proc.c
@@ -102,8 +102,9 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
 	}
 
 	for (i = 0; i < DRM_PROC_ENTRIES; i++) {
-		ent = create_proc_entry(drm_proc_list[i].name,
-					S_IFREG | S_IRUGO, minor->dev_root);
+		ent = create_proc_read_entry(drm_proc_list[i].name,
+					S_IFREG | S_IRUGO, minor->dev_root,
+					drm_proc_list[i].f, minor);
 		if (!ent) {
 			DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
 				  name, drm_proc_list[i].name);
@@ -114,8 +115,6 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
 			minor->dev_root = NULL;
 			return -1;
 		}
-		ent->read_proc = drm_proc_list[i].f;
-		ent->data = minor;
 	}
 
 	return 0;
-- 
1.5.5.1

