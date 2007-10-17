Return-Path: <linux-kernel-owner+w=401wt.eu-S936242AbXJQQOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936242AbXJQQOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbXJQQOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:14:18 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:47189 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764181AbXJQQOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:14:17 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] rd: Mark ramdisk buffers heads dirty
Date: Wed, 17 Oct 2007 18:14:01 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <m1zlykj8zl.fsf_-_@ebiederm.dsl.xmission.com> <200710160956.58061.borntraeger@de.ibm.com>
In-Reply-To: <200710160956.58061.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710171814.01717.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

Am Dienstag, 16. Oktober 2007 schrieb Christian Borntraeger:
> Am Dienstag, 16. Oktober 2007 schrieb Eric W. Biederman:
> 
> > fs/buffer.c |    3 +++
> > 1 files changed, 3 insertions(+), 0 deletions(-)
> >  drivers/block/rd.c |   13 +------------
> >  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> Your patches look sane so far. I have applied both patches, and the problem 
> seems gone. I will try to get these patches to our testers.
> 
> As long as they dont find new problems:

Our testers did only a short test, and then they were stopped by problems with
reiserfs. At the moment I cannot say for sure if your patch caused this, but 
we got the following BUG

ReiserFS: ram0: warning: Created .reiserfs_priv on ram0 - reserved for xattr storage.
------------[ cut here ]------------
kernel BUG at /home/autobuild/BUILD/linux-2.6.23-20071017/fs/reiserfs/journal.c:1117!
illegal operation: 0001 [#1]
Modules linked in: reiserfs dm_multipath sunrpc dm_mod qeth ccwgroup vmur
CPU:    3    Not tainted
Process reiserfs/3 (pid: 2592, task: 77dac418, ksp: 7513ee88)
Krnl PSW : 070c3000 fb344380 (flush_commit_list+0x808/0x95c [reiserfs])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:3 PM:0
Krnl GPRS: 00000002 7411b5c8 0000002b 00000000
           7b04d000 00000001 00000000 76d1de00
           7513eec0 00000003 00000012 77f77680
           7411b608 fb343b7e fb34404a 7513ee50
Krnl Code: fb344374: a7210002           tmll    %r2,2
           fb344378: a7840004           brc     8,fb344380
           fb34437c: a7f40001           brc     15,fb34437e
          >fb344380: 5810d8c2           l       %r1,2242(%r13)
           fb344384: 5820b03c           l       %r2,60(%r11)
           fb344388: 0de1               basr    %r14,%r1
           fb34438a: 5810d90e           l       %r1,2318(%r13)
           fb34438e: 5820b03c           l       %r2,60(%r11)


Looking at the code, this really seems related to dirty buffers, so your patch
is the main suspect at the moment. 

        if (!barrier) {
                /* If there was a write error in the journal - we can't commit
                 * this transaction - it will be invalid and, if successful,
                 * will just end up propagating the write error out to
                 * the file system. */
                if (likely(!retval && !reiserfs_is_journal_aborted (journal))) {
                        if (buffer_dirty(jl->j_commit_bh))
1117---->                                BUG();
                        mark_buffer_dirty(jl->j_commit_bh) ;
                        sync_dirty_buffer(jl->j_commit_bh) ;
                }
        }

Christian
