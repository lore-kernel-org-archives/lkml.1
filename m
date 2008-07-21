Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYGUInS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYGUInS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYGUInJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:43:09 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:60050 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGUInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H0N1auiWk+RJBZ5BAKFH6lnBUKc8++9tnKMs9DqNyCZI9i1WPJT1I6PLoZ9Ty33vdF
         aacz1ogRXo3jG9KQMxP+doOwdWBDWps5eFZLo2id9TjoIjrK6HJl2g/Sd/rAP31BYD4O
         QUFRj1QKSv7K96jrehpdWe+dQadt2OeOJ3O1c=
Date: Mon, 21 Jul 2008 12:42:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721084259.GC20011@lenovo>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <20080721082857.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721082857.GB28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Al Viro - Mon, Jul 21, 2008 at 09:28:57AM +0100]
| On Mon, Jul 21, 2008 at 12:04:27PM +0400, Cyrill Gorcunov wrote:
| >  		err = mnt_alloc_id(mnt);
| > -		if (err) {
| > -			kmem_cache_free(mnt_cache, mnt);
| > -			return NULL;
| > +		if (err)
| > +			goto err;
| 
| Ugh...  Labels are in a separate namespace, but really...
| 
| > +		if (name) {
| > +			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
| > +			if (!mnt->mnt_devname)
| > +				goto err;
| 
| > +err:
| > +	kmem_cache_free(mnt_cache, mnt);
| > +	return NULL;
| 
| Leak; note the mnt_alloc_id() above.  Either do that kstrdup() first and
| kfree the result on mnt_alloc_id() failure or do mnt_free_id() on kstrdup()
| one...
| 

ok, here is an update version. labels names could be not that good
choosen (check please).

		- Cyrill -
---

Index: linux-2.6.git/fs/namespace.c
===================================================================
--- linux-2.6.git.orig/fs/namespace.c	2008-07-21 11:34:37.000000000 +0400
+++ linux-2.6.git/fs/namespace.c	2008-07-21 12:40:12.000000000 +0400
@@ -112,9 +112,13 @@ struct vfsmount *alloc_vfsmnt(const char
 		int err;
 
 		err = mnt_alloc_id(mnt);
-		if (err) {
-			kmem_cache_free(mnt_cache, mnt);
-			return NULL;
+		if (err)
+			goto out_free_cache;
+
+		if (name) {
+			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
+			if (!mnt->mnt_devname)
+				goto out_free_id;
 		}
 
 		atomic_set(&mnt->mnt_count, 1);
@@ -127,16 +131,14 @@ struct vfsmount *alloc_vfsmnt(const char
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
+out_free_id:
+	mnt_free_id(mnt);
+out_free_cache:
+	kmem_cache_free(mnt_cache, mnt);
+	return NULL;
 }
 
 /*
