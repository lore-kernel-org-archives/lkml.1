Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbYKNCje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbYKNCje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYKNCjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:39:18 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:44336 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYKNCjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:39:17 -0500
Date: Fri, 14 Nov 2008 02:37:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Willy Tarreau <w@1wt.eu>, Christoph Hellwig <hch@infradead.org>,
       Peter Cordes <peter@cordes.ca>, Bodo Eggert <7eggert@gmx.de>,
       David Newall <davidn@davidnewall.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: [PATCH 2.6.28?] don't unlink an active swapfile
In-Reply-To: <20081018205647.GA29946@1wt.eu>
Message-ID: <Pine.LNX.4.64.0811140234300.5027@blonde.site>
References: <bnlDw-5vQ-7@gated-at.bofh.it> <bnwpg-2EA-17@gated-at.bofh.it>
 <bnJFK-3bu-7@gated-at.bofh.it> <bnR0A-4kq-1@gated-at.bofh.it>
 <E1KqkZK-0001HO-WF@be1.7eggert.dyndns.org> <Pine.LNX.4.64.0810171250410.22374@blonde.site>
 <20081018003117.GC26067@cordes.ca> <20081018051800.GO24654@1wt.eu>
 <Pine.LNX.4.64.0810182058120.7154@blonde.site> <20081018204948.GA22140@infradead.org>
 <20081018205647.GA29946@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Cordes is sorry that he rm'ed his swapfiles while they were in use,
he then had no pathname to swapoff.  It's a curious little oversight, but
not one worth a lot of hackery.  Kudos to Willy Tarreau for turning this
around from a discussion of synthetic pathnames to how to prevent unlink.
Mimic immutable: prohibit unlinking an active swapfile in may_delete()
(and don't worry my little head over the tiny race window).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Perhaps this is too late for 2.6.28: your decision.

 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.28-rc4/fs/namei.c	2008-10-24 09:28:19.000000000 +0100
+++ linux/fs/namei.c	2008-11-12 11:52:44.000000000 +0000
@@ -1378,7 +1378,7 @@ static int may_delete(struct inode *dir,
 	if (IS_APPEND(dir))
 		return -EPERM;
 	if (check_sticky(dir, victim->d_inode)||IS_APPEND(victim->d_inode)||
-	    IS_IMMUTABLE(victim->d_inode))
+	    IS_IMMUTABLE(victim->d_inode) || IS_SWAPFILE(victim->d_inode))
 		return -EPERM;
 	if (isdir) {
 		if (!S_ISDIR(victim->d_inode->i_mode))
