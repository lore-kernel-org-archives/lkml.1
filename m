Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107Ab0ANW3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0ANW3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625Ab0ANW3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:29:07 -0500
Received: from kroah.org ([198.145.64.141]:60727 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab0ANW3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:29:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/52] fix braindamage in audit_tree.c untag_chunk()
Date: Thu, 14 Jan 2010 14:27:27 -0800
Message-Id: <1263508051-7868-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-47-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
 <1263508051-7868-40-git-send-email-gregkh@suse.de>
 <1263508051-7868-41-git-send-email-gregkh@suse.de>
 <1263508051-7868-42-git-send-email-gregkh@suse.de>
 <1263508051-7868-43-git-send-email-gregkh@suse.de>
 <1263508051-7868-44-git-send-email-gregkh@suse.de>
 <1263508051-7868-45-git-send-email-gregkh@suse.de>
 <1263508051-7868-46-git-send-email-gregkh@suse.de>
 <1263508051-7868-47-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 6f5d51148921c242680a7a1d9913384a30ab3cbe upstream.

... aka "Al had badly fscked up when writing that thing and nobody
noticed until Eric had fixed leaks that used to mask the breakage".

The function essentially creates a copy of old array sans one element
and replaces the references to elements of original (they are on cyclic
lists) with those to corresponding elements of new one.  After that the
old one is fair game for freeing.

First of all, there's a dumb braino: when we get to list_replace_init we
use indices for wrong arrays - position in new one with the old array
and vice versa.

Another bug is more subtle - termination condition is wrong if the
element to be excluded happens to be the last one.  We shouldn't go
until we fill the new array, we should go until we'd finished the old
one.  Otherwise the element we are trying to kill will remain on the
cyclic lists...

That crap used to be masked by several leaks, so it was not quite
trivial to hit.  Eric had fixed some of those leaks a while ago and the
shit had hit the fan...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/audit_tree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 2451dc6..b36aa96 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -277,7 +277,7 @@ static void untag_chunk(struct node *p)
 		owner->root = NULL;
 	}
 
-	for (i = j = 0; i < size; i++, j++) {
+	for (i = j = 0; j <= size; i++, j++) {
 		struct audit_tree *s;
 		if (&chunk->owners[j] == p) {
 			list_del_init(&p->list);
@@ -290,7 +290,7 @@ static void untag_chunk(struct node *p)
 		if (!s) /* result of earlier fallback */
 			continue;
 		get_tree(s);
-		list_replace_init(&chunk->owners[i].list, &new->owners[j].list);
+		list_replace_init(&chunk->owners[j].list, &new->owners[i].list);
 	}
 
 	list_replace_rcu(&chunk->hash, &new->hash);
-- 
1.6.6

