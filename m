Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZBFISL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZBFISL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZBFIR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:17:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57001 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbZBFIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:17:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] fork.c: fix NULL pointer dereference when nr_threads ==
	threads-max
To: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Fri, 06 Feb 2009 08:17:19 +0000
Message-ID: <20090206081719.20378.39341.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

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
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/fork.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/kernel/fork.c b/kernel/fork.c
index bf0cef8..586874d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1007,6 +1007,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * triggers too late. This doesn't hurt, the check is only there
 	 * to stop root fork bombs.
 	 */
+	retval = -EAGAIN;
 	if (nr_threads >= max_threads)
 		goto bad_fork_cleanup_count;
 

