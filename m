Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYLJXdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYLJXdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYLJXdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:33:16 -0500
Received: from smtp-out.google.com ([216.239.45.13]:17412 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbYLJXdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:33:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:content-transfer-encoding;
	b=Pahi34OjzuyOcKxtZUlRHcu4aVYVgt0YYVa0aK1nVjhLN0VTWQkl2ICwUNIeCEc8B
	wIFfuYiEuSj5AQ4yqic+Q==
MIME-Version: 1.0
Date: Wed, 10 Dec 2008 15:33:12 -0800
Message-ID: <6599ad830812101533r6cb007eeu5ef19499e278f6b7@mail.gmail.com>
Subject: [PATCH] CGroups: Fix a race between rmdir and remount
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a race between rmdir and remount

When a cgroup is removed, it's unlinked from its parent's children
list, but not actually freed until the last dentry on it is released
(at which point cgrp->root->number_of_cgroups is decremented).

Currently rebind_subsystems checks for the top cgroup's child list
being empty in order to rebind subsystems into or out of a hierarchy -
this can result in the set of subsystems bound to a hierarchy being
different than the set of subsystems with state in the
removed-but-not-freed cgroup.

The simplest fix for this is to forbid remounts that change the set of
subsystems on a hierarchy that has removed-but-not-freed cgroups.

This bug can be reproduced via:

mkdir /mnt/cg
mount -t cgroup -o ns,freezer cgroup /mnt/cg
mkdir /mnt/cg/foo
sleep 1h < /mnt/cg/foo &
rmdir /mnt/cg/foo
mount -t cgroup -o remount,ns,devices,freezer cgroup /mnt/cg
kill $!

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
===================================================================
--- hierarchy_lock-mmotm-2008-12-09.orig/kernel/cgroup.c
+++ hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
@@ -702,7 +702,7 @@ static int rebind_subsystems(struct cgro
 	 * any child cgroups exist. This is theoretically supportable
 	 * but involves complex error handling, so it's being left until
 	 * later */
-	if (!list_empty(&cgrp->children))
+	if (root->number_of_cgroups > 1)
 		return -EBUSY;

 	/* Process each subsystem */
