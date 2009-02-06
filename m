Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbZBFBPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbZBFBPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbZBFBO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:14:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54011 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbZBFBO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:14:58 -0500
Message-ID: <498B8EEB.7050104@cn.fujitsu.com>
Date: Fri, 06 Feb 2009 09:14:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fork.c: fix NULL pointer dereference when nr_threads == threads-max
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I happened to forked lots of processes, and hit NULL pointer dereference.
It is because in copy_process() after checking max_threads, 0 is returned
but not -EAGAIN.

The bug is introduced by this patch:

| commit f1752eec6145c97163dbce62d17cf5d928e28a27
| Author: David Howells <dhowells@redhat.com>
| Date:   Fri Nov 14 10:39:17 2008 +1100
|
|    CRED: Detach the credentials from task_struct

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/fork.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 242a706..6d5dbb7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1005,6 +1005,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * triggers too late. This doesn't hurt, the check is only there
 	 * to stop root fork bombs.
 	 */
+	retval = -EAGAIN;
 	if (nr_threads >= max_threads)
 		goto bad_fork_cleanup_count;
 
-- 
1.5.4.rc3

