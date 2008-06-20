Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYFTHKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYFTHKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYFTHKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:10:10 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:10261
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYFTHKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:10:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKf0WkjLO9AP/2dsb2JhbACvZQ
X-IronPort-AV: E=Sophos;i="4.27,678,1204470000"; 
   d="scan'208";a="345202554"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - add missing kfree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Fri, 20 Jun 2008 15:09:25 +0800
Message-ID: <20080620070923.17224.33149.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It see that the patch tittled "autofs4 - fix pending mount race" is
missing a change that I had recently made.

It's missing a kfree for the case mutex_lock_interruptible() fails
to aquire the wait queue mutex.

My appologies for this mistake.

Ian

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/waitq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
index ae637d9..d291b07 100644
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -328,8 +328,10 @@ int autofs4_wait(struct autofs_sb_info *sbi, struct dentry *dentry,
 	qstr.name = name;
 	qstr.hash = full_name_hash(name, qstr.len);
 
-	if (mutex_lock_interruptible(&sbi->wq_mutex))
+	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
+		kfree(qstr.name);
 		return -EINTR;
+	}
 
 	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
 	if (ret <= 0) {
