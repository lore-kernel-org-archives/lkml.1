Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZJRMt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZJRMt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 08:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZJRMt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 08:49:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:53810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbZJRMt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 08:49:27 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BUGFIX] dnotify: handle_event shouldn't match on FS_EVENT_ON_CHILD
Date: Sun, 18 Oct 2009 14:46:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910181446.44625.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mask off FS_EVENT_ON_CHILD in dnotify_handle_event().  Otherwise, when there
is more than one watch on a directory and dnotify_should_send_event()
succeeds, events with FS_EVENT_ON_CHILD set will trigger all watches and cause
spurious events.

This case was overlooked in commit e42e2773.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/notify/dnotify/dnotify.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index 828a889..0a8f1de 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -106,7 +106,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 	spin_lock(&entry->lock);
 	prev = &dnentry->dn;
 	while ((dn = *prev) != NULL) {
-		if ((dn->dn_mask & event->mask) == 0) {
+		if ((dn->dn_mask & event->mask & ~FS_EVENT_ON_CHILD) == 0) {
 			prev = &dn->dn_next;
 			continue;
 		}
--
