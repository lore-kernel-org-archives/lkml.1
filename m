Return-Path: <linux-kernel-owner+w=401wt.eu-S1751445AbZJTEMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbZJTEMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZJTEMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:12:06 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43648 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZJTEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:12:05 -0400
Date: Mon, 19 Oct 2009 21:13:37 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: dlezcano@fr.ibm.com, ebiederm@xmission.com, jack@ucw.cz,
       andrea@cpushare.com, sukadev@us.ibm.com,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] pidns: Fix a leak in /proc inodes and dentries
Message-ID: <20091020041337.GA31623@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a leak in /proc dentries and inodes with pid namespaces.

This fix reverts the commit 7766755a2f249e7e0. The leak was reported by
Daniel Lezcano - see  http://lkml.org/lkml/2009/10/2/159.

To summarize the thread, when container-init is terminated, it sets the
PF_EXITING flag and then zaps all the other processes in the container.
When those processes exit, they are expected to be reaped by the container-
init and as a part of reaping, the container-init should flush any /proc
dentries associated with the processes. But because the container-init is
itself exiting and the following PF_EXITING check, the dentires are not
flushed, resulting in leak in /proc inodes and dentries.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Reported-by: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Andrea Arcangeli <andrea@cpushare.com>

---
 fs/proc/base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c	2009-10-19 20:28:51.000000000 -0700
+++ linux-2.6/fs/proc/base.c	2009-10-19 20:29:03.000000000 -0700
@@ -2580,8 +2580,7 @@ static void proc_flush_task_mnt(struct v
 	name.len = snprintf(buf, sizeof(buf), "%d", pid);
 	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
 	if (dentry) {
-		if (!(current->flags & PF_EXITING))
-			shrink_dcache_parent(dentry);
+		shrink_dcache_parent(dentry);
 		d_drop(dentry);
 		dput(dentry);
 	}
