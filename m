Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZIRUWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZIRUWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZIRUWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:22:42 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38206 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183AbZIRUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:22:42 -0400
Date: Fri, 18 Sep 2009 22:22:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090918202245.GR23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk> <20090917194027.GS23126@kernel.dk> <1253229410.2783.16.camel@heimdal.trondhjem.org> <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk> <1253290790.3183.14.camel@heimdal.trondhjem.org> <20090918173608.GD23126@kernel.dk> <20090918183203.GG23126@kernel.dk> <1253305003.10538.72.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253305003.10538.72.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Peter Zijlstra wrote:
> On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> > Peter, if you have
> > the time, it would be nice if you could check whether this one works for
> > you too.
> 
> Doesn't make my machine happy :/

That looks like a double register. Irk, I see what it is... Can you try
this additional patch?

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 712950d..f722de1 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2008,14 +2008,14 @@ struct nfs_sb_mountdata {
 	int mntflags;
 };
 
-static int nfs_bdi_register(struct nfs_server *server)
+static int nfs_bdi_register(struct nfs_server *server, dev_t dev)
 {
 	struct backing_dev_info *bdi = &server->backing_dev_info;
 	int err;
 
 	err = bdi_init(bdi);
 	if (!err) {
-		err = bdi_register_dev(bdi, server->s_dev);
+		err = bdi_register_dev(bdi, dev);
 		if (!err)
 			return 0;
 	}
@@ -2030,7 +2030,7 @@ static int nfs_set_super(struct super_block *s, void *data)
 	struct nfs_server *server = sb_mntdata->server;
 	int ret;
 
-	ret = nfs_bdi_register(server);
+	ret = nfs_bdi_register(server, s->s_dev);
 	if (ret)
 		return ret;
 

-- 
Jens Axboe

