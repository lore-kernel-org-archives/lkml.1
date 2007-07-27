Return-Path: <linux-kernel-owner+w=401wt.eu-S936701AbXG0Kls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936701AbXG0Kls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765625AbXG0Klh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:41:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765098AbXG0Klg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:41:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in nfs_free_open_context
Date: Fri, 27 Jul 2007 11:44:30 +0200
User-Agent: KMail/1.9.6
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <20070725170837.5fba5fd1@localhost> <200707261713.07936.arnd@arndb.de> <1185466097.6585.186.camel@localhost>
In-Reply-To: <1185466097.6585.186.camel@localhost>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200707271144.31550.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Oh/kRemhh0BbilDaBnV7Qi2mK66zKUXJk46b
 4fT+zS7PhwjvlXB1LmCo406Tc+h904mQLYJPxLjg9714bZ8Is+
 Nkd5CWQL4iPgHJoRujBdw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007, Trond Myklebust wrote:
> Really ugly. Here's an alternative that is a lot more palatable.

Yes, much better than mine.

> ---------------------
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date: Thu, 26 Jul 2007 12:06:17 -0400
> NFS: Fix put_nfs_open_context
> 
> We need to grab the inode->i_lock atomically with the last reference put in
> order to remove the open context that is being freed from the
> nfsi->open_files list.
> 
> Fix by converting the kref to a standard atomic counter and then using
> atomic_dec_and_lock()...
> 
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

>From the bit of research I did on the bug yesterday, it seems
that the race has been in there for ages, but may have become easier
to hit with the change to kref after 2.6.22. I don't really
understand why we didn't hit it in RHEL5/2.6.18 with the same
test case, but in Fedora 7/2.6.21.

Should a patch like the one below (I said like, you know you
can't trust my patches for your code ;-) be put into 2.6.22.x
and updated distro kernels?

	Arnd <><

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -482,21 +482,19 @@ struct nfs_open_context *get_nfs_open_context(struct nfs_open_context *ctx)
 
 void put_nfs_open_context(struct nfs_open_context *ctx)
 {
-	if (atomic_dec_and_test(&ctx->count)) {
-		if (!list_empty(&ctx->list)) {
-			struct inode *inode = ctx->dentry->d_inode;
-			spin_lock(&inode->i_lock);
-			list_del(&ctx->list);
-			spin_unlock(&inode->i_lock);
-		}
-		if (ctx->state != NULL)
-			nfs4_close_state(ctx->state, ctx->mode);
-		if (ctx->cred != NULL)
-			put_rpccred(ctx->cred);
-		dput(ctx->dentry);
-		mntput(ctx->vfsmnt);
-		kfree(ctx);
-	}
+	struct inode *inode = ctx->dentry->d_inode;
+
+	if (!atomic_dec_and_lock(&ctx->count, &inode->i_lock))
+		return;
+	list_del(&ctx->list);
+	spin_unlock(&inode->i_lock);
+	if (ctx->state != NULL)
+		nfs4_close_state(ctx->state, ctx->mode);
+	if (ctx->cred != NULL)
+		put_rpccred(ctx->cred);
+	dput(ctx->dentry);
+	mntput(ctx->vfsmnt);
+	kfree(ctx);
 }
 
 /*
