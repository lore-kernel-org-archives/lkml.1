Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYLJRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYLJRab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYLJRaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:30:22 -0500
Received: from sing.entic.net ([208.64.63.147]:64524 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYLJRaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:30:22 -0500
Message-Id: <200812101729.mBAHTGdr008642@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: cebbert@redhat.com
Cc: airlied@gmail.com
Cc: akpm@linux-foundation.org
Date: Wed, 10 Dec 2008 18:17:06 +0100
Subject: [PATCH] lib/idr.c: Fix bug introduced by RCU fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last patch to lib/idr.c caused a bug if idr_get_new_above() was
called on an empty idr:
Usually, nodes stay on the same layer. New layers are added to the top
of the tree.
The exception is idr_get_new_above() on an empty tree: In this case,
the new root node is first added on layer 0, then moved upwards.
p->layer was not updated.

As usual: You shall never rely on the source code comments, they
will only mislead you.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 lib/idr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 7a785a0..1c4f928 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -220,8 +220,14 @@ build_up:
 	 */
 	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
 		layers++;
-		if (!p->count)
+		if (!p->count) {
+			/* special case: if the tree is currently empty,
+			 * then we grow the tree by moving the top node
+			 * upwards.
+			 */
+			p->layer++;
 			continue;
+		}
 		if (!(new = get_from_free_list(idp))) {
 			/*
 			 * The allocation failed.  If we built part of
-- 
1.5.6.5

