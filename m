Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251Ab0ANXKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0ANXKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931Ab0ANXKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:10:17 -0500
Received: from kroah.org ([198.145.64.141]:41914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab0ANXKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:10:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Jan 14 15:06:21 2010
Message-Id: <20100114230621.084598004@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jan 2010 15:04:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [3/6] fix braindamage in audit_tree.c untag_chunk()
In-Reply-To: <20100114230640.GA7259@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -276,7 +276,7 @@ static void untag_chunk(struct node *p)
 		owner->root = NULL;
 	}
 
-	for (i = j = 0; i < size; i++, j++) {
+	for (i = j = 0; j <= size; i++, j++) {
 		struct audit_tree *s;
 		if (&chunk->owners[j] == p) {
 			list_del_init(&p->list);
@@ -289,7 +289,7 @@ static void untag_chunk(struct node *p)
 		if (!s) /* result of earlier fallback */
 			continue;
 		get_tree(s);
-		list_replace_init(&chunk->owners[i].list, &new->owners[j].list);
+		list_replace_init(&chunk->owners[j].list, &new->owners[i].list);
 	}
 
 	list_replace_rcu(&chunk->hash, &new->hash);


