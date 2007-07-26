Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbXGZPXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbXGZPXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763481AbXGZPXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:23:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbXGZPW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:22:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [patch] nfs: fix locking in nfs/inode.c in nfs_free_open_context
Date: Thu, 26 Jul 2007 17:13:07 +0200
User-Agent: KMail/1.9.6
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org
References: <20070725170837.5fba5fd1@localhost> <20070726144433.080126f7@localhost> <1185456203.6585.180.camel@localhost>
In-Reply-To: <1185456203.6585.180.camel@localhost>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261713.07936.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18DBpvXsYXsvcZka+g4WHn9j3JNKL2Y5ukwYX5
 GpCLZ+LSA2ySDaHAM76mesY0wB3hWuPb2eaq8nfCjx/wr9ffID
 ODgSBNMP7dfFqZ6ecZgUw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007, Trond Myklebust wrote:
> 
> > > > Wrong. It is quite safe to test the structure member ctx->list for
> > > > emptiness outside the spinlock because we have an explicit guarantee
> > > > that nobody else has a reference to this structure, plus the
> > > > atomic_dec_and_test() in kref_put() has acted as a memory barrier for
> > > > us
> > >
> > > Well, the real question then is how the ctx can still be present in the
> > > nfsi->open_files list. Since we are in nfs_free_open_context(), there
> > > must not be any pointer to the ctx anywhere, but still we have this other
> > > thread calling get_nfs_open_context() on it
> >
> No. That is still incorrect. The list of open contexts is used for
> things like NFSv4 state recovery (when we're doing background writes,
> and the server happens to reboot). The lifetime of the open context may
> exceed that of the struct file that created it.

Unfortunately, you didn't answer my question. The observed problem is
that the final kref_put gets called at a time where there are still
references to the context in nfsi->open_files, and other threads
therefore do get at them.

The list_empty()/list_del() in nfs_free_open_context is bogus, because
as you say, there is a guarantee that there is no other reference on
the structure, and I take it that ought to include the ->open_files
list.

I would guess that a quick fix for this looks something like the
patch below. The race is in put_nfs_open_context() between the point
where we check the reference count and the point where the context
gets removed from the open_files list. If another thread searches
the list between these points and grabs a new reference, we die.

The patch holds the i_lock around the kref_put to prevent others
from searching the list. Ugly, I know, but it seems that's the
price you pay for using a kref in such unconventional ways, i.e.
not counting every reference.

	Arnd <><

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -487,10 +487,10 @@ static void nfs_free_open_context(struct kref *kref)
 
 	if (!list_empty(&ctx->list)) {
 		struct inode *inode = ctx->path.dentry->d_inode;
-		spin_lock(&inode->i_lock);
 		list_del(&ctx->list);
-		spin_unlock(&inode->i_lock);
 	}
+	spin_unlock(&inode->i_lock);
+
 	if (ctx->state != NULL)
 		nfs4_close_state(&ctx->path, ctx->state, ctx->mode);
 	if (ctx->cred != NULL)
@@ -498,11 +498,15 @@ static void nfs_free_open_context(struct kref *kref)
 	dput(ctx->path.dentry);
 	mntput(ctx->path.mnt);
 	kfree(ctx);
+
+	spin_lock(&inode->i_lock);
 }
 
 void put_nfs_open_context(struct nfs_open_context *ctx)
 {
+	spin_lock(&inode->i_lock);
 	kref_put(&ctx->kref, nfs_free_open_context);
+	spin_unlock(&inode->i_lock);
 }
 
 /*

