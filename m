Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbYBKXRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbYBKXRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbYBKXRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:17:34 -0500
Received: from vena.lwn.net ([206.168.112.25]:39640 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYBKXRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:17:33 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Avoid buffer overflows in get_user_pages()
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 11 Feb 2008 16:17:33 -0700
Message-ID: <5758.1202771853@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid buffer overflows in get_user_pages()

So I spent a while pounding my head against my monitor trying to figure
out the vmsplice() vulnerability - how could a failure to check for
*read* access turn into a root exploit?  It turns out that it's a buffer
overflow problem which is made easy by the way get_user_pages() is
coded.

In particular, "len" is a signed int, and it is only checked at the
*end* of a do {} while() loop.  So, if it is passed in as zero, the loop
will execute once and decrement len to -1.  At that point, the loop will
proceed until the next invalid address is found; in the process, it will
likely overflow the pages array passed in to get_user_pages().

I think that, if get_user_pages() has been asked to grab zero pages,
that's what it should do.  Thus this patch; it is, among other things,
enough to block the (already fixed) root exploit and any others which
might be lurking in similar code.  I also think that the number of pages
should be unsigned, but changing the prototype of this function probably
requires some more careful review.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/mm/memory.c b/mm/memory.c
index e5628a5..7f50fd8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -989,6 +989,8 @@ int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	int i;
 	unsigned int vm_flags;
 
+	if (len <= 0)
+		return 0;
 	/* 
 	 * Require read or write permissions.
 	 * If 'force' is set, we only require the "MAY" flags.
