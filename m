Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbXIUPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbXIUPAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759267AbXIUPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:00:22 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:49894 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759757AbXIUPAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:00:21 -0400
To: hch@infradead.org
CC: trond.myklebust@fys.uio.no, miklos@szeredi.hu, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070921143427.GB14577@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 15:34:27 +0100)
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org> <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu> <20070921130642.GA9431@infradead.org> <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu> <1190385151.6680.35.camel@heimdal.trondhjem.org> <20070921143427.GB14577@infradead.org>
Message-Id: <E1IYjy8-0001lT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 16:59:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Sep 21, 2007 at 10:32:31AM -0400, Trond Myklebust wrote:
> > On Fri, 2007-09-21 at 15:16 +0200, Miklos Szeredi wrote:
> > 
> > > > ftruncate is a special case due to O_TRUNC.
> > > 
> > > No, it's special, because it does not do permission checking, while
> > > truncate() does.
> > 
> > So why not just add file->f_op->ftruncate() and file->f_op->fstat()?
> > Most filesystems can trivially redirect these to do_truncate() and their
> > existing getattr() method. Those, like FUSE, that care can use the hook.
> > In fact, I think that NFSv4 could also benefit from an ftruncate():
> > currently we have to hunt around for an open file context for that
> > particular case.
> 
> Havin the file for fruncate is fine and I'm planning to do something
> along those lines.  Having it for (f)stat is dumb because the operation
> is in no way related to the open file descriptor.

What I'm saying is that read and write are _no_more_ related to the
file than fstat.  Read/write operate on inode data, fstat operates on
inode metadata.

OK, read/write have a position state in the open file, but that is
something the filesystem should _never_ touch anyway, so it's
irrelevant to the discussion.

The fact is, if the filesystem uses a stateful open API, which defines
an fstat() operation, it can be useful to use that instead of the
plain stat().  But that is only possible if the VFS supplies the open
file, otherwise there will be just "hunting around" for suitable open
files, or "sillyrenaming".  None of which is desirable.

Miklos
