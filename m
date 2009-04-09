Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbZDIDXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbZDIDXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZDIDXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:23:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39813 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160AbZDIDXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:23:09 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@osdl.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] make consistent errno value when open pident vs exit(2) race
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090409121756.B3DD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  9 Apr 2009 12:23:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


proc_pident_instantiate() has following call flow.

proc_pident_lookup()
  proc_pident_instantiate()
    proc_pid_make_inode()

And, proc_pident_lookup() has following error handling.

	const struct pid_entry *p, *last;
	error = ERR_PTR(-ENOENT);
	if (!task)
		goto out_no_task;

Then, proc_pident_instantiate should return ENOENT too when racing against
exit(2) occur.

EINAL has two bad reason. 
  - it implies caller is wrong. bad the race isn't caller's mistake. 
  - man 2 open don't explain EINVAL. user often don't handle it.


Note: Other proc_pid_make_inode() caller already use ENOENT properly.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
--
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f715597..803d09e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1953,7 +1953,7 @@ static struct dentry *proc_pident_instantiate(struct inode *dir,
 	const struct pid_entry *p = ptr;
 	struct inode *inode;
 	struct proc_inode *ei;
-	struct dentry *error = ERR_PTR(-EINVAL);
+	struct dentry *error = ERR_PTR(-ENOENT);
 
 	inode = proc_pid_make_inode(dir->i_sb, task);
 	if (!inode)


