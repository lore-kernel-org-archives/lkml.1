Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbZIQXQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbZIQXQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZIQXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:16:53 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:52527 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbZIQXQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:16:52 -0400
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
In-Reply-To: <20090917194027.GS23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk>
	 <20090917194027.GS23126@kernel.dk>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 19:16:50 -0400
Message-Id: <1253229410.2783.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 1471 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 3ABB7CFFA75875B834EC2F98DA2BD44CF1A59DF8
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 20 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 21:40 +0200, Jens Axboe wrote:
> On Thu, Sep 17 2009, Jens Axboe wrote:
> > Hi,
> > 
> > This can cause a hang on NFS umount, since the bdi gets pruned before we
> > flush any pending dirty IO. Peter, can you check whether it fixes your
> > issue?
> 
> There's another problem with NFS && backing devices. NFS may call
> bdi_destroy() on a bdi without ever called bdi_init(). This was always a
> bad idea, now it's an issue.
> 
> So, Trond, can I safely add a server->flags private flag to indicate
> that we have called bdi_init()? Then nfs_free_server() knows when to
> call bdi_destroy(). Seems like the safest fix, since error handling is
> currently 'just call nfs_free_server()'.

Urgh... Is there any reason why we can't just move the call to
bdi_init() into nfs_bdi_register()? It seems bizarre to have to
initialise the backing_dev_info twice like this...

If we do that, then we can just look at the BDI_registered state flag in
order to figure out if we need to call bdi_unregister()

Cheers
  Trond

