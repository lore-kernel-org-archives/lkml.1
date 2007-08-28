Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXH1PKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXH1PKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXH1PKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 11:10:45 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43173 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbXH1PKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 11:10:44 -0400
Date: Tue, 28 Aug 2007 11:08:20 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070828110820.542bbd67@think.oraclecorp.com>
In-Reply-To: <20070828145530.GD61154114@sgi.com>
References: <386910467.21100@ustc.edu.cn>
	<20070821202314.335e86ec@think.oraclecorp.com>
	<20070822011841.GA8090@mail.ustc.edu.cn>
	<20070823023306.GM61154114@sgi.com>
	<20070824135504.GA9029@mail.ustc.edu.cn>
	<20070828145530.GD61154114@sgi.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 00:55:30 +1000
David Chinner <dgc@sgi.com> wrote:

> On Fri, Aug 24, 2007 at 09:55:04PM +0800, Fengguang Wu wrote:
> > On Thu, Aug 23, 2007 at 12:33:06PM +1000, David Chinner wrote:
> > > On Wed, Aug 22, 2007 at 09:18:41AM +0800, Fengguang Wu wrote:
> > > > On Tue, Aug 21, 2007 at 08:23:14PM -0400, Chris Mason wrote:
> > > > Notes:
> > > > (1) I'm not sure inode number is correlated to disk location in
> > > >     filesystems other than ext2/3/4. Or parent dir?
> > > 
> > > The correspond to the exact location on disk on XFS. But, XFS has
> > > it's own inode clustering (see xfs_iflush) and it can't be moved
> > > up into the generic layers because of locking and integration into
> > > the transaction subsystem.
> > >
> > > > (2) It duplicates some function of elevators. Why is it
> > > > necessary?
> > > 
> > > The elevators have no clue as to how the filesystem might treat
> > > adjacent inodes. In XFS, inode clustering is a fundamental
> > > feature of the inode reading and writing and that is something no
> > > elevator can hope to acheive....
> >  
> > Thank you. That explains the linear write curve(perfect!) in Chris'
> > graph.
> > 
> > I wonder if XFS can benefit any more from the general writeback
> > clustering. How large would be a typical XFS cluster?
> 
> Depends on inode size. typically they are 8k in size, so anything
> from 4-32 inodes. The inode writeback clustering is pretty tightly
> integrated into the transaction subsystem and has some intricate
> locking, so it's not likely to be easy (or perhaps even possible) to
> make it more generic.

When I talked to hch about this, he said the order file data pages got
written in XFS was still dictated by the order the higher layers sent
things down.  Shouldn't the clustering still help to have delalloc done
in inode order instead of in whatever random order pdflush sends things
down now?

-chris
