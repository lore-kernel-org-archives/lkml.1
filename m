Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbXH2Hxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbXH2Hxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 03:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXH2Hxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 03:53:35 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:36089 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751359AbXH2Hxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 03:53:34 -0400
Message-ID: <388374011.01681@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 29 Aug 2007 15:53:30 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070829075330.GA5960@mail.ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com> <20070822011841.GA8090@mail.ustc.edu.cn> <20070823023306.GM61154114@sgi.com> <20070824135504.GA9029@mail.ustc.edu.cn> <20070828145530.GD61154114@sgi.com> <20070828110820.542bbd67@think.oraclecorp.com> <20070828163308.GE61154114@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828163308.GE61154114@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 02:33:08AM +1000, David Chinner wrote:
> On Tue, Aug 28, 2007 at 11:08:20AM -0400, Chris Mason wrote:
> > On Wed, 29 Aug 2007 00:55:30 +1000
> > David Chinner <dgc@sgi.com> wrote:
> > > On Fri, Aug 24, 2007 at 09:55:04PM +0800, Fengguang Wu wrote:
> > > > On Thu, Aug 23, 2007 at 12:33:06PM +1000, David Chinner wrote:
> > > > > On Wed, Aug 22, 2007 at 09:18:41AM +0800, Fengguang Wu wrote:
> > > > > > On Tue, Aug 21, 2007 at 08:23:14PM -0400, Chris Mason wrote:
> > > > > > Notes:
> > > > > > (1) I'm not sure inode number is correlated to disk location in
> > > > > >     filesystems other than ext2/3/4. Or parent dir?
> > > > > 
> > > > > The correspond to the exact location on disk on XFS. But, XFS has
> > > > > it's own inode clustering (see xfs_iflush) and it can't be moved
> > > > > up into the generic layers because of locking and integration into
> > > > > the transaction subsystem.
> > > > >
> > > > > > (2) It duplicates some function of elevators. Why is it
> > > > > > necessary?
> > > > > 
> > > > > The elevators have no clue as to how the filesystem might treat
> > > > > adjacent inodes. In XFS, inode clustering is a fundamental
> > > > > feature of the inode reading and writing and that is something no
> > > > > elevator can hope to acheive....
> > > >  
> > > > Thank you. That explains the linear write curve(perfect!) in Chris'
> > > > graph.
> > > > 
> > > > I wonder if XFS can benefit any more from the general writeback
> > > > clustering. How large would be a typical XFS cluster?
> > > 
> > > Depends on inode size. typically they are 8k in size, so anything
> > > from 4-32 inodes. The inode writeback clustering is pretty tightly
> > > integrated into the transaction subsystem and has some intricate
> > > locking, so it's not likely to be easy (or perhaps even possible) to
> > > make it more generic.
> > 
> > When I talked to hch about this, he said the order file data pages got
> > written in XFS was still dictated by the order the higher layers sent
> > things down.
> 
> Sure, that's file data. I was talking about the inode writeback, not the
> data writeback.
> 
> > Shouldn't the clustering still help to have delalloc done
> > in inode order instead of in whatever random order pdflush sends things
> > down now?
> 
> Depends on how things are being allocated. if you've got inode32 allocation
> and >1TB filesytsem, then data is nowhere near the inodes. If you've got large
> allocation groups, then data is typically nowhere near the inodes, either. If
> you've got full AGs, data will be nowehere near the inodes. If you've got
> large files and lots of data to write, then clustering multiple files together
> for writing is not needed.  So in many cases, clustering delalloc writes by
> inode number doesn't provide any better I/o patterns than not clustering...
> 
> The only difference we may see is that if we flush all the data on inodes
> in a single cluster, we can get away with a single inode cluster write
> for all of the inodes....

So we end up with two major cases:

- small files: inode and its data are expected to be close enough,
  hence it can help I_DIRTY_SYNC and/or I_DIRTY_PAGES

- big files: inode and its data may or may not be separated
        - I_DIRTY_SYNC:  could be improved
        - I_DIRTY_PAGES: no better, no worse(it's big I/O, the seek
          cost is not relevant in any case)

Conclusion: _inode_ writeback clustering is enough.

Isn't it simple? ;-)

Fengguang

