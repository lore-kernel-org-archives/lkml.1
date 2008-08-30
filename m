Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYH3Fcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYH3Fcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYH3Fch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:32:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25563 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYH3Fch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Lv3xjqoLRqI1OnpVSLuVwq/FgVoOunTsWa6FcDZdtBgKaY0bPzUmXDQc3e10kx9CqB
         Q8aHZbDAfYjuocBMSBtqwV6m7RWJT3qlimHe1Rz8fotAVop3BmvFeiOXWOD5jmY3BXzX
         UK8ztNVUgz3Mz1zEyLlF7ZjCQdSoXFdN2mFiE=
Date: Sat, 30 Aug 2008 09:34:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: fix return value of proc_reg_open() in "too late"
	case
Message-ID: <20080830053412.GB25179@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ->open() wasn't called, returning 0 is misleading and, theoretically,
oopsable:
1. remove_proc_entry clears ->proc_fops, drops lock,
2. ->open "succeeds",
3. ->release oopses, because it assumes ->open was called (single_release()).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -350,7 +350,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	if (!pde->proc_fops) {
 		spin_unlock(&pde->pde_unload_lock);
 		kfree(pdeo);
-		return rv;
+		return -EINVAL;
 	}
 	pde->pde_users++;
 	open = pde->proc_fops->open;

