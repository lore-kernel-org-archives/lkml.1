Return-Path: <linux-kernel-owner+w=401wt.eu-S933874AbXJQTQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874AbXJQTQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 15:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933400AbXJQTPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 15:15:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35118 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbXJQTPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:15:52 -0400
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
From: Chris Mason <chris.mason@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
In-Reply-To: <m1sl49ei8x.fsf@ebiederm.dsl.xmission.com>
References: <200710151028.34407.borntraeger@de.ibm.com>
	 <m1zlykj8zl.fsf_-_@ebiederm.dsl.xmission.com>
	 <200710160956.58061.borntraeger@de.ibm.com>
	 <200710171814.01717.borntraeger@de.ibm.com>
	 <m1sl49ei8x.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 15:14:16 -0400
Message-Id: <1192648456.15717.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-17 at 11:57 -0600, Eric W. Biederman wrote:
> Christian Borntraeger <borntraeger@de.ibm.com> writes:
> 
> > Eric,
> >
> > Am Dienstag, 16. Oktober 2007 schrieb Christian Borntraeger:
> >> Am Dienstag, 16. Oktober 2007 schrieb Eric W. Biederman:
> >> 
> >> > fs/buffer.c |    3 +++
> >> > 1 files changed, 3 insertions(+), 0 deletions(-)
> >> >  drivers/block/rd.c |   13 +------------
> >> >  1 files changed, 1 insertions(+), 12 deletions(-)
> >> 
> >> Your patches look sane so far. I have applied both patches, and the problem 
> >> seems gone. I will try to get these patches to our testers.
> >> 
> >> As long as they dont find new problems:
> >
> > Our testers did only a short test, and then they were stopped by problems with
> > reiserfs. At the moment I cannot say for sure if your patch caused this, but 
> > we got the following BUG
> 
> Thanks.
> 
> > ReiserFS: ram0: warning: Created .reiserfs_priv on ram0 - reserved for xattr
> > storage.
> > ------------[ cut here ]------------
> > kernel BUG at
> > /home/autobuild/BUILD/linux-2.6.23-20071017/fs/reiserfs/journal.c:1117!
> > illegal operation: 0001 [#1]
> > Modules linked in: reiserfs dm_multipath sunrpc dm_mod qeth ccwgroup vmur
> > CPU:    3    Not tainted
> > Process reiserfs/3 (pid: 2592, task: 77dac418, ksp: 7513ee88)
> > Krnl PSW : 070c3000 fb344380 (flush_commit_list+0x808/0x95c [reiserfs])
> >            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:3 PM:0
> > Krnl GPRS: 00000002 7411b5c8 0000002b 00000000
> >            7b04d000 00000001 00000000 76d1de00
> >            7513eec0 00000003 00000012 77f77680
> >            7411b608 fb343b7e fb34404a 7513ee50
> > Krnl Code: fb344374: a7210002           tmll    %r2,2
> >            fb344378: a7840004           brc     8,fb344380
> >            fb34437c: a7f40001           brc     15,fb34437e
> >           >fb344380: 5810d8c2           l       %r1,2242(%r13)
> >            fb344384: 5820b03c           l       %r2,60(%r11)
> >            fb344388: 0de1               basr    %r14,%r1
> >            fb34438a: 5810d90e           l       %r1,2318(%r13)
> >            fb34438e: 5820b03c           l       %r2,60(%r11)
> >
> >
> > Looking at the code, this really seems related to dirty buffers, so your patch
> > is the main suspect at the moment. 
> 
> Sounds reasonable.
> 
> >         if (!barrier) {
> >                 /* If there was a write error in the journal - we can't commit
> >                  * this transaction - it will be invalid and, if successful,
> >                  * will just end up propagating the write error out to
> >                  * the file system. */
> >                 if (likely(!retval && !reiserfs_is_journal_aborted (journal))) {
> >                         if (buffer_dirty(jl->j_commit_bh))
> > 1117---->                                BUG();
> >                         mark_buffer_dirty(jl->j_commit_bh) ;
> >                         sync_dirty_buffer(jl->j_commit_bh) ;
> >                 }
> >         }
> 
> Grr.  I'm not certain how to call that.
> 
> Given that I should also be able to trigger this case by writing to
> the block device through the buffer cache (to the write spot at the
> write moment) this feels like a reiserfs bug. 
> Although I feel
> screaming about filesystems that go BUG instead of remount read-only....
> 

In this case, the commit block isn't allowed to be dirty before reiserfs
decides it is safe to write it.  The journal code expects it is the only
spot in the kernel setting buffer heads dirty, and it only does so after
the rest of the log blocks are safely on disk.

Given this is a ramdisk, the check can be ignored, but I'd rather not
sprinkle if (ram_disk) into the FS code....

> At the same time I increasingly don't think we should allow user space
> to dirty or update our filesystem metadata buffer heads.  That seems
> like asking for trouble.
> 

Demanding trouble ;)

-chris

