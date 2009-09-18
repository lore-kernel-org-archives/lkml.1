Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZIRGkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZIRGkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZIRGkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:40:09 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50806 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZIRGkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:40:05 -0400
Date: Fri, 18 Sep 2009 08:40:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
Message-ID: <20090918064006.GU23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk> <20090917194027.GS23126@kernel.dk> <1253229410.2783.16.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253229410.2783.16.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17 2009, Trond Myklebust wrote:
> On Thu, 2009-09-17 at 21:40 +0200, Jens Axboe wrote:
> > On Thu, Sep 17 2009, Jens Axboe wrote:
> > > Hi,
> > > 
> > > This can cause a hang on NFS umount, since the bdi gets pruned before we
> > > flush any pending dirty IO. Peter, can you check whether it fixes your
> > > issue?
> > 
> > There's another problem with NFS && backing devices. NFS may call
> > bdi_destroy() on a bdi without ever called bdi_init(). This was always a
> > bad idea, now it's an issue.
> > 
> > So, Trond, can I safely add a server->flags private flag to indicate
> > that we have called bdi_init()? Then nfs_free_server() knows when to
> > call bdi_destroy(). Seems like the safest fix, since error handling is
> > currently 'just call nfs_free_server()'.
> 
> Urgh... Is there any reason why we can't just move the call to
> bdi_init() into nfs_bdi_register()? It seems bizarre to have to
> initialise the backing_dev_info twice like this...

No reason at all, I don't know why it was implemented that way
originally.

> If we do that, then we can just look at the BDI_registered state flag in
> order to figure out if we need to call bdi_unregister()

That's not exactly pretty either, diving into internal bdi details to
find out if we did an init/register of the device. BDI_registered is
just a debug flag, it may even go away again shortly.

-- 
Jens Axboe

