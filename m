Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYGUIEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYGUIEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGUIEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:04:33 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:18398 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbYGUIEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hm7WzwVg5gPFHewTohmnNm8As8oWfynbyzd8mOZpyvn0sNf6bSm8QDsDNmu4RVRJqg
         R6gi/pzyAs0Blw4SFY6IEFfJEBkDLKdNH2Mg0qHGP/3IfPdxQe4GtsWXi+M+eDB7moiP
         DB7/ojU0IRmrAcm+SeViH3HlVgqgQXEPN1XNs=
Date: Mon, 21 Jul 2008 12:04:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721080427.GC6662@lenovo>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721070346.GA28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Al Viro - Mon, Jul 21, 2008 at 08:03:46AM +0100]
| 
[...]
| The right thing here is to consider failing allocation of ->mnt_devname
| as failure of the entire alloc.
| 

Al, what about the patch below? I'm not sure if Li's version already
in someone tree so it's from-the-scratch. If this ok, i think Li could
update his version and resend.

		- Cyrill -
---

Index: linux-2.6.git/fs/namespace.c
===================================================================
--- linux-2.6.git.orig/fs/namespace.c	2008-07-21 11:34:37.000000000 +0400
+++ linux-2.6.git/fs/namespace.c	2008-07-21 12:00:01.000000000 +0400
@@ -112,9 +112,13 @@ struct vfsmount *alloc_vfsmnt(const char
 		int err;
 
 		err = mnt_alloc_id(mnt);
-		if (err) {
-			kmem_cache_free(mnt_cache, mnt);
-			return NULL;
+		if (err)
+			goto err;
+
+		if (name) {
+			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
+			if (!mnt->mnt_devname)
+				goto err;
 		}
 
 		atomic_set(&mnt->mnt_count, 1);
@@ -127,16 +131,12 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
 		atomic_set(&mnt->__mnt_writers, 0);
-		if (name) {
-			int size = strlen(name) + 1;
-			char *newname = kmalloc(size, GFP_KERNEL);
-			if (newname) {
-				memcpy(newname, name, size);
-				mnt->mnt_devname = newname;
-			}
-		}
 	}
 	return mnt;
+
+err:
+	kmem_cache_free(mnt_cache, mnt);
+	return NULL;
 }
 
 /*
