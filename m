Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbXKGCOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbXKGCOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbXKGCNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:13:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35854 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755575AbXKGCNs (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:13:48 -0500
Date: Wed, 7 Nov 2007 13:13:24 +1100
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
Message-ID: <20071107021324.GD995458@sgi.com>
References: <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com> <393903856.06449@ustc.edu.cn> <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com> <394340668.31055@ustc.edu.cn> <64bb37e0711061353g4a8b881cgd78fef3a11378b9c@mail.gmail.com> <20071106233114.GB995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106233114.GB995458@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 10:31:14AM +1100, David Chinner wrote:
> On Tue, Nov 06, 2007 at 10:53:25PM +0100, Torsten Kaiser wrote:
> > On 11/6/07, David Chinner <dgc@sgi.com> wrote:
> > > Rather than vmstat, can you use something like iostat to show how busy your
> > > disks are?  i.e. are we seeing RMW cycles in the raid5 or some such issue.
> > 
> > Both "vmstat 10" and "iostat -x 10" output from this test:
> > procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
> >  2  0      0 3700592      0  85424    0    0    31    83  108  244  2  1 95  1
> > -> emerge reads something, don't knwo for sure what...
> >  1  0      0 3665352      0  87940    0    0   239     2  343  585  2  1 97  0
> ....
> > 
> > The last 20% of the btrace look more or less completely like this, no
> > other programs do any IO...
> > 
> > 253,0    3   104626   526.293450729   974  C  WS 79344288 + 8 [0]
> > 253,0    3   104627   526.293455078   974  C  WS 79344296 + 8 [0]
> > 253,0    1    36469   444.513863133  1068  Q  WS 154998480 + 8 [xfssyncd]
> > 253,0    1    36470   444.513863135  1068  Q  WS 154998488 + 8 [xfssyncd]
>                                                 ^^
> Apparently we are doing synchronous writes. That would explain why
> it is slow. We shouldn't be doing synchronous writes here. I'll see if
> I can reproduce this.
> 
> <goes off and looks>
> 
> Yes, I can reproduce the sync writes coming out of xfssyncd. I'll
> look into this further and send a patch when I have something concrete.

Ok, so it's not synchronous writes that we are doing - we're just
submitting bio's tagged as WRITE_SYNC to get the I/O issued quickly.
The "synchronous" nature appears to be coming from higher level
locking when reclaiming inodes (on the flush lock). It appears that
inode write clustering is failing completely so we are writing the
same block multiple times i.e. once for each inode in the cluster we
have to write.

This must be a side effect of some other change as we haven't
changed anything in the reclaim code recently.....

/me scurries off to run some tests 

Indeed it is. The patch below should fix the problem - the inode
clusters weren't getting set up properly when inodes were being
read in or allocated. This is a regression, introduced by this
mod:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=da353b0d64e070ae7c5342a0d56ec20ae9ef5cfb

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_iget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c	2007-11-02 13:44:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c	2007-11-07 13:08:42.534440675 +1100
@@ -248,7 +248,7 @@ finish_inode:
 	icl = NULL;
 	if (radix_tree_gang_lookup(&pag->pag_ici_root, (void**)&iq,
 							first_index, 1)) {
-		if ((iq->i_ino & mask) == first_index)
+		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) == first_index)
 			icl = iq->i_cluster;
 	}
 
