Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYLCTxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYLCTxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYLCTuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:13 -0500
Received: from kroah.org ([198.145.64.141]:34556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754471AbYLCTuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:08 -0500
Date: Wed, 3 Dec 2008 11:48:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: [patch 008/104] cgroups: fix a serious bug in cgroupstats
Message-ID: <20081203194831.GI8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cgroups-fix-a-serious-bug-in-cgroupstats.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

commit 33d283bef23132c48195eafc21449f8ba88fce6b upstream.

Try this, and you'll get oops immediately:
 # cd Documentation/accounting/
 # gcc -o getdelays getdelays.c
 # mount -t cgroup -o debug xxx /mnt
 # ./getdelays -C /mnt/tasks

Because a normal file's dentry->d_fsdata is a pointer to struct cftype,
not struct cgroup.

After the patch, it returns EINVAL if we try to get cgroupstats
from a normal file.

Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2045,10 +2045,13 @@ int cgroupstats_build(struct cgroupstats
 	struct cgroup *cgrp;
 	struct cgroup_iter it;
 	struct task_struct *tsk;
+
 	/*
-	 * Validate dentry by checking the superblock operations
+	 * Validate dentry by checking the superblock operations,
+	 * and make sure it's a directory.
 	 */
-	if (dentry->d_sb->s_op != &cgroup_ops)
+	if (dentry->d_sb->s_op != &cgroup_ops ||
+	    !S_ISDIR(dentry->d_inode->i_mode))
 		 goto err;
 
 	ret = 0;

