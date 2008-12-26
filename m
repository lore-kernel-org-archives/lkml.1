Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYLZWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYLZWA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 17:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYLZWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 17:00:17 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:57699 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYLZWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 17:00:16 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An1IAHLiVEnVQJ+/PGdsb2JhbACBa5F2AQEBATUBqHRYjxWGRA
Message-ID: <495553EB.6030604@zappa.cx>
Date: Fri, 26 Dec 2008 23:00:11 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
References: <4954BAAB.9090108@zappa.cx> <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx> <20081226193307.GA2138@mit.edu>
In-Reply-To: <20081226193307.GA2138@mit.edu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Dec 26, 2008 at 07:48:22PM +0100, Andreas Sundstrom wrote:
>> Yes, I mounted it with ext3 and barrier=1 and could reproduce the problem.
>> ext3 did not remount the fs ro though, it seems to only disable barriers:
>>
>> [    7.681759] blkfront: xvda1: write barrier op failed
>> [    7.681776] blkfront: xvda1: barriers disabled
>> [    7.681785] end_request: I/O error, dev xvda1, sector 4584
>> [    7.681800] end_request: I/O error, dev xvda1, sector 4584
>> [    7.681886] JBD: barrier-based sync failed on xvda1 - disabling barriers
>>
>> And then I tested with ext4 and barrier=0 and that also works.
> 
> Ext4 has patches which will checks the error returns on writes to the
> journal, and will abort the journal in case of I/O failures.  Ext3
> should have the same patches, but it's apparently missing one of the
> patches, or it's otherwise not noticing the problem.  (You were
> testing ext3 on a 2.6.28 kernel, right?)

Yes it was the same kernel even.

> 
>> But I'm here if you want something tested or a patch verified or anything,
>> but I guess this might be a Xen issue rather than vanilla kernel stuff.
> 
> Yes, this looks very much like a Xen issue.  What is going on is that
> we submit the write with barriers enabled, and if it fails, we try
> again without barriers.  I'm guessing that Xen emulation code didn't
> notice that we were trying again without barriers, or the Xen
> emulation isn't clearing the error flag, but for whatever reason,
> we're getting a write failure somewhere else later on, and that's
> causing the failures.
> 
> What would be really useful to nail down exactly what is going on
> would be to patch fs/jbd/journal.c and fs/jbd2/journal.c so that the
> line:
> 
> u8 journal_enable_debug __read_mostly;
> 
> is changed to read:
> 
> u8 journal_enable_debug=3 __read_mostly;
> 
> 
> and similarly in fs/jbd2/journal.c, change:
> 
> u8 jbd2_journal_enable_debug __read_mostly;
> 
> to read
> 
> u8 jbd2_journal_enable_debug=3 __read_mostly;
> 
> That will generate a lot more debugging information, and hopefully we
> can see exactly what was going on right before the journal abort, and
> why ext4 apparently didn't get the corret error return after the
> barrier operation failed.
> 
> But yes, this ultimately seems very likely to be a Xen emulation bug.

Unfortunately it didn't compile with the above changes and I'm totally
crap at programming :(

But I enabled debugfs and did
"echo 3 > /sys/kernel/debug/jbd2/jbd2-debug" and reproduced the problem
by taking a snapshot while the system was live.
I hope this had the same effect as your proposed change.

I also put it on this URL to make it easier to read
http://pastebin.com/m7efd8eb3


Dec 26 22:38:57 192.168.20.33 kernel: imklog 3.18.6, log source =
/proc/kmsg started.
Dec 26 22:42:01 192.168.20.33 kernel: [  482.814386]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be000
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815139]
(fs/jbd2/transaction.c, 1267): jbd2_journal_stop: transaction too old,
requesting commit for handle c34be000

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815147] (fs/jbd2/journal.c,
449): __jbd2_log_start_commit: JBD: requesting commit 1549171/1549170

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815157] (fs/jbd2/journal.c,
546): jbd2_log_wait_commit: JBD: want 1549171, j_commit_sequence=1549170

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815168] (fs/jbd2/journal.c,
195): kjournald2: kjournald2 wakes
Dec 26 22:42:01 192.168.20.33 kernel: [  482.815174] (fs/jbd2/journal.c,
147): kjournald2: commit_sequence=1549170, commit_request=1549171

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815181] (fs/jbd2/journal.c,
150): kjournald2: OK, requests differ

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815188] (fs/jbd2/commit.c,
362): jbd2_journal_commit_transaction: superblock not updated

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815194] (fs/jbd2/commit.c,
374): jbd2_journal_commit_transaction: JBD: starting commit of
transaction 1549171

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815210]
(fs/jbd2/checkpoint.c, 762): __jbd2_journal_drop_transaction: Dropping
transaction 1549170, all done

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815218] (fs/jbd2/commit.c,
447): jbd2_journal_commit_transaction: JBD: commit phase 1

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815226] (fs/jbd2/commit.c,
465): jbd2_journal_commit_transaction: JBD: commit phase 2

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815235] (fs/jbd2/revoke.c,
520): jbd2_journal_write_revoke_records: Wrote 0 revoke records

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815242] (fs/jbd2/commit.c,
477): jbd2_journal_commit_transaction: JBD: commit phase 2

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815249] (fs/jbd2/commit.c,
703): jbd2_journal_commit_transaction: JBD: commit phase 3

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815255] (fs/jbd2/commit.c,
762): jbd2_journal_commit_transaction: JBD: commit phase 4

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815261] (fs/jbd2/commit.c,
792): jbd2_journal_commit_transaction: JBD: commit phase 5

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815369]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be018
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815389]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be018
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815415]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be018
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815425]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be018
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815490]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be018
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.815500]
(fs/jbd2/transaction.c, 111): start_this_handle: New handle c34be018
going live.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.816304] blkfront: xvda1:
write barrier op failed
Dec 26 22:42:01 192.168.20.33 kernel: [  482.816320] blkfront: xvda1:
barriers disabled
Dec 26 22:42:01 192.168.20.33 kernel: [  482.816330] end_request: I/O
error, dev xvda1, sector 5600
Dec 26 22:42:01 192.168.20.33 kernel: [  482.816342] end_request: I/O
error, dev xvda1, sector 5600
Dec 26 22:42:01 192.168.20.33 kernel: [  482.816380] Aborting journal on
device xvda1:8.
Dec 26 22:42:01 192.168.20.33 kernel: [  482.816389] (fs/jbd2/journal.c,
449): __jbd2_log_start_commit: JBD: requesting commit 1549172/1549170

Dec 26 22:42:01 192.168.20.33 kernel: [  482.816397] (fs/jbd2/journal.c,
1278): jbd2_journal_update_superblock: JBD: updating superblock (start
1, seq 1549157, errno -5)
Dec 26 22:42:01 192.168.20.33 kernel: [  482.821228] EXT4-fs error
(device xvda1) in ext4_reserve_inode_write: Journal has aborted

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836134] (fs/jbd2/commit.c,
812): jbd2_journal_commit_transaction: JBD: commit phase 6

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836142] (fs/jbd2/commit.c,
937): jbd2_journal_commit_transaction: JBD: commit phase 7

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836151]
(fs/jbd2/checkpoint.c, 762): __jbd2_journal_drop_transaction: Dropping
transaction 1549171, all done

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836158] (fs/jbd2/commit.c,
1005): jbd2_journal_commit_transaction: JBD: commit 1549171 complete,
head 1549157
Dec 26 22:42:01 192.168.20.33 kernel: [  482.836169] (fs/jbd2/journal.c,
147): kjournald2: commit_sequence=1549171, commit_request=1549172

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836175] (fs/jbd2/journal.c,
150): kjournald2: OK, requests differ

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836182] (fs/jbd2/commit.c,
362): jbd2_journal_commit_transaction: superblock not updated

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836189] (fs/jbd2/commit.c,
374): jbd2_journal_commit_transaction: JBD: starting commit of
transaction 1549172

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836205] journal commit I/O
error
Dec 26 22:42:01 192.168.20.33 kernel: [  482.836521] ext4_abort called.

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836531] EXT4-fs error
(device xvda1): ext4_journal_start_sb: Detected aborted journal

Dec 26 22:42:01 192.168.20.33 kernel: [  482.836548] Remounting
filesystem read-only
Dec 26 22:42:01 192.168.20.33 kernel: [  482.836685] ext4_da_writepages:
jbd2_start: 1642 pages, ino 81965; err -30

/Andreas
