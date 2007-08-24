Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbXHXM53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbXHXM53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765827AbXHXM4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:56:48 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51754 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933679AbXHXM4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:56:46 -0400
Message-ID: <387960203.03917@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 24 Aug 2007 20:56:43 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070824125643.GB7933@mail.ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com> <387745522.02814@ustc.edu.cn> <20070822084201.2c4eceb6@think.oraclecorp.com> <20070823024723.GN61154114@sgi.com> <20070823081341.27807ad0@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823081341.27807ad0@think.oraclecorp.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 08:13:41AM -0400, Chris Mason wrote:
> On Thu, 23 Aug 2007 12:47:23 +1000
> David Chinner <dgc@sgi.com> wrote:
> 
> > On Wed, Aug 22, 2007 at 08:42:01AM -0400, Chris Mason wrote:
> > > I think we should assume a full scan of s_dirty is impossible in the
> > > presence of concurrent writers.  We want to be able to pick a start
> > > time (right now) and find all the inodes older than that start time.
> > > New things will come in while we're scanning.  But perhaps that's
> > > what you're saying...
> > > 
> > > At any rate, we've got two types of lists now.  One keeps track of
> > > age and the other two keep track of what is currently being
> > > written.  I would try two things:
> > > 
> > > 1) s_dirty stays a list for FIFO.  s_io becomes a radix tree that
> > > indexes by inode number (or some arbitrary field the FS can set in
> > > the inode).  Radix tree tags are used to indicate which things in
> > > s_io are already in progress or are pending (hand waving because
> > > I'm not sure exactly).
> > > 
> > > inodes are pulled off s_dirty and the corresponding slot in s_io is
> > > tagged to indicate IO has started.  Any nearby inodes in s_io are
> > > also sent down.
> > 
> > the problem with this approach is that it only looks at inode
> > locality. Data locality is ignored completely here and the data for
> > all the inodes that are close together could be splattered all over
> > the drive. In that case, clustering by inode location is exactly the
> > wrong thing to do.
> 
> Usually it won't be less wrong than clustering by time.
> 
> > 
> > For example, XFs changes allocation strategy at 1TB for 32bit inode
> > filesystems which makes the data get placed way away from the inodes.
> > i.e. inodes in AGs below 1TB, all data in AGs > 1TB. clustering
> > by inode number for data writeback is mostly useless in the >1TB
> > case.
> 
> I agree we'll want a way to let the FS provide the clustering key.  But
> for the first cut on the patch, I would suggest keeping it simple.
> 
> > 
> > The inode32 for <1Tb and inode64 allocators both try to keep data
> > close to the inode (i.e. in the same AG) so clustering by inode number
> > might work better here.
> > 
> > Also, it might be worthwhile allowing the filesystem to supply a
> > hint or mask for "closeness" for inode clustering. This would help
> > the gernic code only try to cluster inode writes to inodes that
> > fall into the same cluster as the first inode....
> 
> Yes, also a good idea after things are working.
> 
> > 
> > > > Notes:
> > > > (1) I'm not sure inode number is correlated to disk location in
> > > >     filesystems other than ext2/3/4. Or parent dir?
> > > 
> > > In general, it is a better assumption than sorting by time.  It may
> > > make sense to one day let the FS provide a clustering hint
> > > (corresponding to the first block in the file?), but for starters it
> > > makes sense to just go with the inode number.
> > 
> > Perhaps multiple hints are needed - one for data locality and one
> > for inode cluster locality.
> 
> So, my feature creep idea would have been more data clustering.  I'm
> mainly trying to solve this graph:
> 
> http://oss.oracle.com/~mason/compilebench/makej/compare-create-dirs-0.png
> 
> Where background writing of the block device inode is making ext3 do
> seeky writes while directory trees.  My simple idea was to kick
> off a 'I've just written block X' call back to the FS, where it may
> decide to send down dirty chunks of the block device inode that also
> happen to be dirty.
> 
> But, maintaining the kupdate max dirty time and congestion limits in
> the face of all this clustering gets tricky.  So, I wasn't going to
> suggest it until the basic machinery was working.
> 
> Fengguang, this isn't a small project ;)  But, lots of people will be
> interested in the results.

Exactly, the current writeback logics are unsatisfactory in many ways.
As for writeback clustering, inode/data localities can be different.
But I'll follow your suggestion to start simple first and give the
idea a spin on ext3.

-fengguang

