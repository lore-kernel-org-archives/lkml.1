Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbXHVBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbXHVBSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXHVBSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:18:46 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33364 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753091AbXHVBSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:18:44 -0400
Message-ID: <387745522.02814@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 22 Aug 2007 09:18:41 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070822011841.GA8090@mail.ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821202314.335e86ec@think.oraclecorp.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 08:23:14PM -0400, Chris Mason wrote:
> On Sun, 12 Aug 2007 17:11:20 +0800
> Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > Andrew and Ken,
> > 
> > Here are some more experiments on the writeback stuff.
> > Comments are highly welcome~ 
> 
> I've been doing benchmarks lately to try and trigger fragmentation, and
> one of them is a simulation of make -j N.  It takes a list of all
> the .o files in the kernel tree, randomly sorts them and then
> creates bogus files with the same names and sizes in clean kernel trees.
> 
> This is basically creating a whole bunch of files in random order in a
> whole bunch of subdirectories.
> 
> The results aren't pretty:
> 
> http://oss.oracle.com/~mason/compilebench/makej/compare-compile-dirs-0.png
> 
> The top graph shows one dot for each write over time.  It shows that
> ext3 is basically writing all over the place the whole time.  But, ext3
> actually wins the read phase, so the layout isn't horrible.  My guess
> is that if we introduce some write clustering by sending a group of
> inodes down at the same time, it'll go much much better.
> 
> Andrew has mentioned bringing a few radix trees into the writeback paths
> before, it seems like file servers and other general uses will benefit
> from better clustering here.
> 
> I'm hoping to talk you into trying it out ;)

Thank you for the description of problem. So far I have a similar one
in mind: if we are to delay writeback of atime-dirty-only inodes to
above 1 hour, some grouping/piggy-backing scenario would be
beneficial.  (Which I guess does not deserve the complexity now that
we have Ingo's make-reltime-default patch.)

My vague idea is to
- keep the s_io/s_more_io as a FIFO/cyclic writeback dispatching queue.
- convert s_dirty to some radix-tree/rbtree based data structure.
  It would have dual functions: delayed-writeback and clustered-writeback.
  
clustered-writeback:
- Use inode number as clue of locality, hence the key for the sorted
  tree.
- Drain some more s_dirty inodes into s_io on every kupdate wakeup,
  but do it in the ascending order of inode number instead of
  ->dirtied_when. 

delayed-writeback:
- Make sure that a full scan of the s_dirty tree takes <=30s, i.e.
  dirty_expire_interval.

Notes:
(1) I'm not sure inode number is correlated to disk location in
    filesystems other than ext2/3/4. Or parent dir?
(2) It duplicates some function of elevators. Why is it necessary?
    Maybe we have no clue on the exact data location at this time?

Fengguang

