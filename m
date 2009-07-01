Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZGASii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZGASii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZGASiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:38:19 -0400
Received: from kroah.org ([198.145.64.141]:46759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZGASiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:38:19 -0400
Date: Wed, 1 Jul 2009 11:36:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Cc: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 31/30] bsdacct: fix access to invalid filp in acct_on()
Message-ID: <20090701183651.GB14064@kroah.com>
References: <20090701002817.GA6156@kroah.com>
 <20090701183548.GA14064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701183548.GA14064@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch

----------------

From: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>

commit df279ca8966c3de83105428e3391ab17690802a9 upstream.

The file opened in acct_on and freshly stored in the ns->bacct struct can
be closed in acct_file_reopen by a concurrent call after we release
acct_lock and before we call mntput(file->f_path.mnt).

Record file->f_path.mnt in a local variable and use this variable only.

Signed-off-by: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>
Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/acct.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -215,6 +215,7 @@ static void acct_file_reopen(struct bsd_
 static int acct_on(char *name)
 {
 	struct file *file;
+	struct vfsmount *mnt;
 	int error;
 	struct pid_namespace *ns;
 	struct bsd_acct_struct *acct = NULL;
@@ -256,11 +257,12 @@ static int acct_on(char *name)
 		acct = NULL;
 	}
 
-	mnt_pin(file->f_path.mnt);
+	mnt = file->f_path.mnt;
+	mnt_pin(mnt);
 	acct_file_reopen(ns->bacct, file, ns);
 	spin_unlock(&acct_lock);
 
-	mntput(file->f_path.mnt); /* it's pinned, now give up active reference */
+	mntput(mnt); /* it's pinned, now give up active reference */
 	kfree(acct);
 
 	return 0;
