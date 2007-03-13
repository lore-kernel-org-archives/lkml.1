Return-Path: <linux-kernel-owner+w=401wt.eu-S1030383AbXCMOXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030383AbXCMOXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030405AbXCMOXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:23:48 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10770 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030383AbXCMOXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:23:47 -0400
Date: Tue, 13 Mar 2007 17:31:06 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, devel@openvz.org
Subject: [PATCH -mm] proc: remove pathetic ->deleted WARN_ON
Message-ID: <20070313143106.GA11372@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WARN_ON(de && de->deleted); is sooo unreliable. Why?

proc_lookup				remove_proc_entry
===========				=================
lock_kernel();
spin_lock(&proc_subdir_lock);
[find proc entry]
spin_unlock(&proc_subdir_lock);
					spin_lock(&proc_subdir_lock);
					[find proc entry]

proc_get_inode
==============
WARN_ON(de && de->deleted);			...

					if (!atomic_read(&de->count))
						free_proc_entry(de);
					else
						de->deleted = 1;

So, if you have some strange oops [1], and doesn't see this WARN_ON it means
nothing.

[1] try_module_get() of module which doesn't exist, two lines below
    should suffice, or not?

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/inode.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -418,8 +418,6 @@ struct inode *proc_get_inode(struct supe
 {
 	struct inode * inode;
 
-	WARN_ON(de && de->deleted);
-
 	if (de != NULL && !try_module_get(de->owner))
 		goto out_mod;
 

