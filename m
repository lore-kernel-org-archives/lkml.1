Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbZCQJjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbZCQJjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZCQJjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:39:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:46607 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763255AbZCQJjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:39:36 -0400
Date: Tue, 17 Mar 2009 11:40:19 +0200
From: Denis Karpov <ext-denis.2.karpov@gmail.com>
To: "ext Jorge Boncompte [DTI2]" <jorge@dti2.net>
Cc: "npiggin@suse.de" <npiggin@suse.de>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Error testing ext3 on brd ramdisk
Message-ID: <20090317094019.GA10360@smart.research.nokia.com>
References: <20090305065529.GB11916@wotan.suse.de> <49AF9932.2040301@dti2.net> <20090305094623.GA17815@wotan.suse.de> <49AFAFD9.9050805@dti2.net> <49AFC1A9.90501@dti2.net> <20090310161247.GA19352@wotan.suse.de> <20090310163002.GC19352@wotan.suse.de> <49B69A09.3080408@dti2.net> <20090311021920.GA16561@wotan.suse.de> <49BA927F.8020701@dti2.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49BA927F.8020701@dti2.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-OriginalArrivalTime: 17 Mar 2009 09:39:07.0522 (UTC) FILETIME=[37C59620:01C9A6E4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Mar 13, 2009 at 06:06:07PM +0100, ext Jorge Boncompte [DTI2] wrote:
> Nick Piggin escribió:
> > On Tue, Mar 10, 2009 at 05:49:13PM +0100, Jorge Boncompte [DTI2] wrote:
> >> Nick Piggin escribió:
> >>> Ah, of course, it would be due to directory-in-pagecache. You need
> >>> the following patch if you expect this to work.
> >>>
> >>> And that confirms the ext3 problem is a different one because it
> >>> doesn't use directory in pagecache I think. Well, I'll look at
> >>> that one tomorrow.
> 	Hi Nick, no problems noticed in the last days running with the below 
> patch...
> 
> --- linux-2.6.29-rc8/fs/super.c       2009-03-13 13:46:19 +0100
> +++ kernel/fs/super.c       2009-03-13 13:47:50 +0100
> @@ -647,6 +647,8 @@ int do_remount_sb(struct super_block *sb
>                  acct_auto_close(sb);
>          shrink_dcache_sb(sb);
>          fsync_super(sb);
> +       if (sb->s_bdev && (flags & MS_RDONLY))
> +               invalidate_bdev(sb->s_bdev);
> 
>          /* If we are remounting RDONLY and current sb is read/write,
>             make sure there are no rw files opened */
> 

Hello, 

first off, sorry if you getting this email twice.

I also tried to do ext3/ext4 fs smoketesting and used Adraian's
script.  I am consistently getting the same results - filesystem get's
corrupted. 
I tested on quad Xeon, with patches posted in this thread.

1. tests with brd:
- ext3fs on brd
    corruption (see attached ext3fs.brd.corruption.txt)
- ext4fs on brd
    corruption (see attached ext4fs.brd.corruption.txt)

In both cases I saw some complains from JBD/JBD2:
 JBD: Detected IO errors while flushing file data on

2. I enabled JBD debugging, re-run the tests. Console was 
flooded with messages and in the end I got a soft lockup.
I cannot consistently reproduce this (see attached 
brd.ext3fs.softlock.txt).

Just to be sure I re-run the tests on real block device (usb stick)

3. tests with real block device (usb stick)
- ext3fs
    no fs currption (overnight run)
- ext4fs 
    no fs currption (overnight run)

Any ideas what else can be done here? I'd like to find out if this is
filesystem or brd related fault.

Denis

--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="brd.ext3fs.corruption.txt"

...
-------------------------------------------------------------
Cycle 15
Fri Mar 13 11:01:22 EDT 2009
Mounting
Removing old fsstress data
Starting fsstress
Sleeping 30 seconds
seed = 1237275074
Stopping fsstress
 8572 pts/0    00:00:00 fsstress_ext3
 8575 pts/0    00:00:25 fsstress_ext3
 8576 pts/0    00:00:25 fsstress_ext3
 8577 pts/0    00:00:25 fsstress_ext3
./brd_test_ext3.sh: line 37:  8572 Terminated              `pwd`/fsstress_ext3 -d $TESTDIR/work -p 3 -l 0 -n 100000000
Unmounting
Checking
/dev/ram0: HTREE directory inode 94 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram0: HTREE directory inode 218 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram0: HTREE directory inode 813 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram0: Entry 'cd8f' in /work/p1/d2f/d13df/d18e3/d521/d14f7 (218) has an incorrect filetype (was 3, should be 1).


/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="brd.ext3fs.softlock.txt"

...
JBD: Detected IO errors while flushing file data on 
ram0                       
...

and then relatively soon (cycle 11) final failure:

...
/dev/ram0: UNEXPECTED INCONSISTENCY; RUN fsck 
MANUALLY.                        
...


[  137.287143] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287153] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.287165] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345848, comm8
[  137.287185] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.287191] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.287196] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com8
[  137.287208] (fs/jbd/journal.c, 548): log_wait_commit: JBD: want 345849, j_co8
[  137.287215] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  137.287220] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345848, comm9
[  137.287223] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  137.287227] (fs/jbd/journal.c, 548): log_wait_commit: <7>(fs/jbd/commit.c, 39
 3458 ttyS0    0[  137.287237] JBD: want 345849, j_commit_sequence=345848       
0:00:00 fsstress[  137.287249] (fs/jbd/revoke.c, 521): journal_write_revoke_recs
                                                                                
 3460 ttyS0   [  137.287263] (fs/jbd/checkpoint.c, 753): __journal_drop_transace
 00:00:21 fsstre[  137.287267] (fs/jbd/commit.c, 955): journal_commit_transacti4
ss                                                                              
 3461 ttyS0 [  137.287278] (fs/jbd/journal.c, 143): kjournald: commit_sequence=9
   00:00:20 fsst[  137.287298] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloC
ress <defunct>                                                                  
[  137.287302] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com9
 3462 ttyS0    0[  137.287311] (fs/jbd/journal.c, 548): log_wait_commit: JBD: w9
0:00:00 fsstress[  137.287318] (fs/jbd/journal.c, 191): kjournald: kjournald was
                                                                                
[  137.287323] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345849, comm0
[  137.287326] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  137.287329] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin0
[  137.287340] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  137.287355] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287359] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.287367] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345850, comm0
[  137.287386] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.287390] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com0
[  137.287401] (fs/jbd/journal.c, 548): log_wait_commit: JBD: want 345851, j_co0

[  137.287408] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  137.287413] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345850, comm1
[  137.287416] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  137.287419] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin1
[  137.287430] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287435] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287443] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287448] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287457] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  137.287470] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287474] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.287482] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345851, comm1[  137.287718] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.287722] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com1
[  137.287733] (fs/jbd/journal.c, 548): log_wait_commit: JBD: want 345852, j_co1
[  137.287741] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  137.287746] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345851, comm2
[  137.287751] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  137.287754] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin2
[  137.287762] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287768] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287774] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287781] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287786] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge[  137.287791] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287795] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.287804] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  137.287857] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.287871] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345852, comm2
[  137.287938] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.287942] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com2
[  137.287951] (fs/jbd/journal.c, 548): log_wait_commit: JBD: want 345853, j_co2
[  137.287959] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  137.287963] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345852, comm3
[  137.287968] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  137.287971] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin3
[  137.287981] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  137.288020] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.288026] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.288035] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345853, comm3
[  137.288099] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.288103] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com3
[  137.288112] (fs/jbd/journal.c, 548): log_wait_commit: JBD: want 345854, j_co3
[  137.288120] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  137.288125] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345853, comm4
[  137.288128] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          [  137.288131] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin4
[  137.288142] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  137.288184] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.288190] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.288199] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345854, comm4
[  137.288264] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  137.288268] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com4
[  137.288282] (fs/jbd/journal.c, 548): log_wait_commit: JBD: want 345855, j_co4
[  137.288290] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  137.288295] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345854, comm5
[  137.288299] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  137.288302] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin5
[  137.288312] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  137.288352] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  137.288358] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 4
[  137.288367] (fs/jbd/journal.c, 143): kjournald: commit_sequence=345855, comm5
[  148.971458] JBD: Detected IO errors while flushing file data on ram1         
[  148.972649] JBD: Detected IO errors while flushing file data on ram1         
[  148.975145] JBD: Detected IO errors while flushing file data on ram1         
[  150.036402] JBD: Detected IO errors while flushing file data on ram1         
[ 1681.129521] Clocksource tsc unstable (delta = 1546657291253 ns)              
[ 1681.130181] BUG: soft lockup - CPU#2 stuck for 1414s! [fsstress:3462]        
[ 1681.130181] Modules linked in: brd ext3 jbd                                  
[ 1681.130181] irq event stamp: 37867                                           
[ 1681.130181] hardirqs last  enabled at (37866): [<b042af82>] _spin_unlock_irq0
[ 1681.130181] hardirqs last disabled at (37867): [<b0103ada>] apic_timer_inter4
[ 1681.130181] softirqs last  enabled at (37522): [<b012ff92>] __do_softirq+0x10
[ 1681.130181] softirqs last disabled at (37833): [<b013004d>] do_softirq+0x6d/0
[ 1681.130181]                                                                  
[ 1681.130181] Pid: 3462, comm: fsstress Not tainted (2.6.29-rc7-00102-g7a203f3 
[ 1681.130181] EIP: 0060:[<b042af85>] EFLAGS: 00000202 CPU: 2                   
[ 1681.130181] EIP is at _spin_unlock_irq+0x25/0x50                             
[ 1681.130181] EAX: edfe7b8c EBX: ef880000 ECX: 00000004 EDX: efa003d0          
[ 1681.130181] ESI: ef880000 EDI: 00000102 EBP: edfe7b90 ESP: edfe7b8c          
[ 1681.130181]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068                    
[ 1681.130181] CR0: 8005003b CR2: a7ebf0f0 CR3: 3c434000 CR4: 000006d0          
[ 1681.130181] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000          




[  839.603442] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin6
[  839.603458] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  839.603481] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  839.603488] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 9
[  839.603495] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490376, com6
[  839.603521] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  839.603528] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com6
[  839.603541] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  839.603545] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490376, com7
[  839.603551] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  839.603556] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin7
[  839.603569] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  839.603591] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[  839.603597] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 9
[  839.603606] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490377, com7
[  839.603636] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  839.603643] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com7
[  839.603655] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  839.603660] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490377, com8
[  839.603664] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  839.603670] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin8
[  839.603683] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[  839.603708] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge[  839.603715] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 9
[  839.603723] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490378, com8
[  839.603757] (fs/ext3/balloc.c, 1449): ext3_should_retry_alloc: ram1: retryinC
[  839.603763] (fs/jbd/journal.c, 446): __log_start_commit: JBD: requesting com8
[  839.603777] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[  839.603782] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490378, com9
[  839.603788] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[  839.603794] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin9
 4401 ttyS0    0[  839.603813] (fs/jbd/revoke.c, 521): journal_write_revoke_recs
0:00:24 fsstress[  839.603837] (fs/jbd/checkpoint.c, 753): __journal_drop_transe
 <defunct>                                                                      
 440[  839.603844] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: com9
2 ttyS0    00:00[  839.603850] (fs/jbd/journal.c, 143): kjournald: commit_seque9
[ 1833.097021] Clocksource tsc unstable (delta = 993639928371 ns)               
[ 1833.099443] (fs/jbd/journal.c, 191): kjournald: kjournald wakes              
[ 1833.099448] (fs/jbd/journal.c, 199): kjournald: woke because of timeout      
[ 1833.099451] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490379, com0
[ 1833.099456] (fs/jbd/journal.c, 146): kjournald: OK, requests differ          
[ 1833.099463] (fs/jbd/commit.c, 345): journal_commit_transaction: JBD: startin0
[ 1833.099479] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge[ 1833.099488] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[ 1833.099501] (fs/jbd/revoke.c, 521): journal_write_revoke_records: Wrote 0 res
[ 1833.099542] (fs/jbd/checkpoint.c, 753): __journal_drop_transaction: Droppinge
[ 1833.099547] (fs/jbd/commit.c, 955): journal_commit_transaction: JBD: commit 9
[ 1833.099554] (fs/jbd/journal.c, 143): kjournald: commit_sequence=1490380, com0
[ 1833.099631] BUG: soft lockup - CPU#3 stuck for 921s! [fsstress:4402]         
[ 1833.099631] Modules linked in: brd ext3 jbd                                  
[ 1833.099631] irq event stamp: 5787241                                         
[ 1833.099631] hardirqs last  enabled at (5787240): [<b042af82>] _spin_unlock_i0
[ 1833.099631] hardirqs last disabled at (5787241): [<b0103ada>] apic_timer_int4
[ 1833.099631] softirqs last  enabled at (5787190): [<b012ff92>] __do_softirq+00
[ 1833.099631] softirqs last disabled at (5787221): [<b013004d>] do_softirq+0x60
[ 1833.099631]                                                                  
[ 1833.099631] Pid: 4402, comm: fsstress Not tainted (2.6.29-rc7-00102-g7a203f3 
[ 1833.099631] EIP: 0060:[<b042af85>] EFLAGS: 00000202 CPU: 3                   
[ 1833.099631] EIP is at _spin_unlock_irq+0x25/0x50                             [ 1833.099631] EAX: dce59ce4 EBX: ef88e000 ECX: 00000004 EDX: eed3ed70          
[ 1833.099631] ESI: ef88e000 EDI: 00000102 EBP: dce59ce8 ESP: dce59ce4          
[ 1833.099631]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068                    
[ 1833.099631] CR0: 8005003b CR2: af868fdc CR3: 3e7e6000 CR4: 000006d0          
[ 1833.099631] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000          
[ 1833.099631] DR6: ffff0ff0 DR7: 00000400                                      
[ 1833.099631] Call Trace:                                                      
[ 1833.099631]  [<b0133ea6>] run_timer_softirq+0x146/0x1c0                      
[ 1833.099631]  [<b014ec71>] ? mark_held_locks+0x41/0x80                        
[ 1833.099631]  [<b013bd70>] ? delayed_work_timer_fn+0x0/0x30                   
[ 1833.099631]  [<b012ff0f>] __do_softirq+0x9f/0x170                            
[ 1833.099631]  [<b013004d>] do_softirq+0x6d/0x80                               
[ 1833.099631]  [<b013029d>] irq_exit+0x7d/0xa0                                 
[ 1833.099631]  [<b0114fee>] smp_apic_timer_interrupt+0x5e/0x90                 
[ 1833.099631]  [<b0264828>] ? trace_hardirqs_off_thunk+0xc/0x14                
[ 1833.099631]  [<b0103ae1>] apic_timer_interrupt+0x2d/0x34                     
[ 1833.099631]  [<b042afdf>] ? _spin_unlock_irqrestore+0x2f/0x70                
[ 1833.099631]  [<b012b7dd>] ? vprintk+0x29d/0x3d0                              
[ 1833.099631]  [<f0a39fd9>] ? journal_stop+0x169/0x3a0 [jbd]                   [ 1833.099631]  [<b0427b13>] printk+0x18/0x1a                                   
[ 1833.099631]  [<f0a76cb0>] ext3_should_retry_alloc+0x80/0xa0 [ext3]           
[ 1833.099631]  [<f0a81396>] ext3_create+0x46/0x100 [ext3]                      
[ 1833.099631]  [<b0198c7c>] vfs_create+0xbc/0x120                              
[ 1833.099631]  [<b042b03d>] ? _spin_unlock+0x1d/0x40                           
[ 1833.099631]  [<f0a81350>] ? ext3_create+0x0/0x100 [ext3]                     
[ 1833.099631]  [<b019be80>] do_filp_open+0x6d0/0x7e0                           
[ 1833.099631]  [<b042b03d>] ? _spin_unlock+0x1d/0x40                           
[ 1833.099631]  [<b01a5148>] ? alloc_fd+0xe8/0x100                              
[ 1833.099631]  [<b018e2e9>] do_sys_open+0x59/0xf0                              
[ 1833.099631]  [<b018e3e9>] sys_open+0x29/0x40                                 
[ 1833.099631]  [<b018e420>] sys_creat+0x20/0x30                                
[ 1833.099631]  [<b0103385>] sysenter_do_call+0x12/0x35                         
[ 1833.099631] Kernel panic - not syncing: softlockup: hung tasks               
[ 1833.099631] ------------[ cut here ]------------                             [ 1833.099631] WARNING: at kernel/mutex.c:351 mutex_trylock+0x13f/0x1a0()       
[ 1833.099631] Hardware name: Precision WorkStation 650                         
[ 1833.099631] Modules linked in: brd ext3 jbd                                  
[ 1833.099631] Pid: 4402, comm: fsstress Not tainted 2.6.29-rc7-00102-g7a203f3 4
[ 1833.099631] Call Trace:                                                      
[ 1833.099631]  [<b0427b13>] ? printk+0x18/0x1a                                 
[ 1833.099631]  [<b012aa33>] warn_slowpath+0x73/0xd0                            
[ 1833.099631]  [<b014ded5>] ? check_usage_forwards+0x45/0xb0                   
[ 1833.099631]  [<b014d24a>] ? save_trace+0x3a/0xa0                             
[ 1833.099631]  [<b014e4ed>] ? mark_lock+0x4fd/0xc40                            
[ 1833.099631]  [<b014f9d7>] ? __lock_acquire+0x147/0x18f0                      
[ 1833.099631]  [<b0145195>] ? sched_clock_cpu+0x135/0x190                      
[ 1833.099631]  [<b042904f>] mutex_trylock+0x13f/0x1a0                          
[ 1833.099631]  [<b015c50b>] crash_kexec+0x1b/0xc0                              
[ 1833.099631]  [<b014d3ab>] ? trace_hardirqs_off+0xb/0x10                      
[ 1833.099631]  [<b042b00d>] ? _spin_unlock_irqrestore+0x5d/0x70                
[ 1833.099631]  [<b0143f0a>] ? down_trylock+0x2a/0x40                           
[ 1833.099631]  [<b012b4a7>] ? console_unblank+0x17/0x80                        
[ 1833.099631]  [<b0427a52>] panic+0x57/0x100                                   
[ 1833.099631]  [<b016233d>] softlockup_tick+0x15d/0x190                        [ 1833.099631]  [<b0134277>] run_local_timers+0x17/0x20                         
[ 1833.099631]  [<b01342af>] update_process_times+0x2f/0x70                     
[ 1833.099631]  [<b014b13d>] tick_sched_timer+0x5d/0xc0                         
[ 1833.099631]  [<b014b0e0>] ? tick_sched_timer+0x0/0xc0                        
[ 1833.099631]  [<b01427b2>] __run_hrtimer+0x42/0x100                           
[ 1833.099631]  [<b042b1b5>] ? _spin_lock+0x45/0x50                             
[ 1833.099631]  [<b0143535>] hrtimer_interrupt+0x175/0x220                      
[ 1833.099631]  [<b0114fe9>] smp_apic_timer_interrupt+0x59/0x90                 
[ 1833.099631]  [<b0264828>] ? trace_hardirqs_off_thunk+0xc/0x14                
[ 1833.099631]  [<b0103ae1>] apic_timer_interrupt+0x2d/0x34                     
[ 1833.099631]  [<b042af85>] ? _spin_unlock_irq+0x25/0x50                       
[ 1833.099631]  [<b0133ea6>] run_timer_softirq+0x146/0x1c0                      
[ 1833.099631]  [<b014ec71>] ? mark_held_locks+0x41/0x80                        
[ 1833.099631]  [<b013bd70>] ? delayed_work_timer_fn+0x0/0x30                   
[ 1833.099631]  [<b012ff0f>] __do_softirq+0x9f/0x170                            
[ 1833.099631]  [<b013004d>] do_softirq+0x6d/0x80                               
[ 1833.099631]  [<b013029d>] irq_exit+0x7d/0xa0                                 
[ 1833.099631]  [<b0114fee>] smp_apic_timer_interrupt+0x5e/0x90                 
[ 1833.099631]  [<b0264828>] ? trace_hardirqs_off_thunk+0xc/0x14                
[ 1833.099631]  [<b0103ae1>] apic_timer_interrupt+0x2d/0x34                     [ 1833.099631]  [<b042afdf>] ? _spin_unlock_irqrestore+0x2f/0x70                
[ 1833.099631]  [<b012b7dd>] ? vprintk+0x29d/0x3d0                              
[ 1833.099631]  [<f0a39fd9>] ? journal_stop+0x169/0x3a0 [jbd]                   
[ 1833.099631]  [<b0427b13>] printk+0x18/0x1a                                   
[ 1833.099631]  [<f0a76cb0>] ext3_should_retry_alloc+0x80/0xa0 [ext3]           
[ 1833.099631]  [<f0a81396>] ext3_create+0x46/0x100 [ext3]                      
[ 1833.099631]  [<b0198c7c>] vfs_create+0xbc/0x120                              
[ 1833.099631]  [<b042b03d>] ? _spin_unlock+0x1d/0x40                           
[ 1833.099631]  [<f0a81350>] ? ext3_create+0x0/0x100 [ext3]                     
[ 1833.099631]  [<b019be80>] do_filp_open+0x6d0/0x7e0                           
[ 1833.099631]  [<b042b03d>] ? _spin_unlock+0x1d/0x40                           
[ 1833.099631]  [<b01a5148>] ? alloc_fd+0xe8/0x100                              
[ 1833.099631]  [<b018e2e9>] do_sys_open+0x59/0xf0                              
[ 1833.099631]  [<b018e3e9>] sys_open+0x29/0x40                                 
[ 1833.099631]  [<b018e420>] sys_creat+0x20/0x30                                [ 1833.099631]  [<b0103385>] sysenter_do_call+0x12/0x35                         
[ 1833.099631] ---[ end trace 1b613fe912a9ef3d ]---                             
[ 1833.099631] ------------[ cut here ]------------                             
[ 1833.099631] WARNING: at kernel/smp.c:329 smp_call_function_many+0x1d2/0x230()
[ 1833.099631] Hardware name: Precision WorkStation 650                         
[ 1833.099631] Modules linked in: brd ext3 jbd                                  
[ 1833.099631] Pid: 4402, comm: fsstress Tainted: G        W  2.6.29-rc7-00102-4
[ 1833.099631] Call Trace:                                                      
[ 1833.099631]  [<b0427b13>] ? printk+0x18/0x1a                                 
[ 1833.099631]  [<b012aa33>] warn_slowpath+0x73/0xd0                            
[ 1833.099631]  [<b014f9d7>] ? __lock_acquire+0x147/0x18f0                      
[ 1833.099631]  [<b0145195>] ? sched_clock_cpu+0x135/0x190                      
[ 1833.099631]  [<b014d3ab>] ? trace_hardirqs_off+0xb/0x10                      
[ 1833.099631]  [<b0428e6e>] ? __mutex_unlock_slowpath+0xce/0x160               
[ 1833.099631]  [<b0428fc3>] ? mutex_trylock+0xb3/0x1a0                         
[ 1833.099631]  [<b0428f08>] ? mutex_unlock+0x8/0x10                            
[ 1833.099631]  [<b0155b22>] smp_call_function_many+0x1d2/0x230                 
[ 1833.099631]  [<b0109cf0>] ? stop_this_cpu+0x0/0x40                           
[ 1833.099631]  [<b0155bad>] smp_call_function+0x2d/0x60                        
[ 1833.099631]  [<b011399e>] native_smp_send_stop+0x1e/0x60                     [ 1833.099631]  [<b0427a58>] panic+0x5d/0x100                                   
[ 1833.099631]  [<b016233d>] softlockup_tick+0x15d/0x190                        
[ 1833.099631]  [<b0134277>] run_local_timers+0x17/0x20                         
[ 1833.099631]  [<b01342af>] update_process_times+0x2f/0x70                     
[ 1833.099631]  [<b014b13d>] tick_sched_timer+0x5d/0xc0                         
[ 1833.099631]  [<b014b0e0>] ? tick_sched_timer+0x0/0xc0                        
[ 1833.099631]  [<b01427b2>] __run_hrtimer+0x42/0x100                           
[ 1833.099631]  [<b042b1b5>] ? _spin_lock+0x45/0x50                             
[ 1833.099631]  [<b0143535>] hrtimer_interrupt+0x175/0x220                      
[ 1833.099631]  [<b0114fe9>] smp_apic_timer_interrupt+0x59/0x90                 
[ 1833.099631]  [<b0264828>] ? trace_hardirqs_off_thunk+0xc/0x14                
[ 1833.099631]  [<b0103ae1>] apic_timer_interrupt+0x2d/0x34                     
[ 1833.099631]  [<b042af85>] ? _spin_unlock_irq+0x25/0x50                       
[ 1833.099631]  [<b0133ea6>] run_timer_softirq+0x146/0x1c0                      
[ 1833.099631]  [<b014ec71>] ? mark_held_locks+0x41/0x80                        [ 1833.099631]  [<b013bd70>] ? delayed_work_timer_fn+0x0/0x30                   
[ 1833.099631]  [<b012ff0f>] __do_softirq+0x9f/0x170                            
[ 1833.099631]  [<b013004d>] do_softirq+0x6d/0x80                               
[ 1833.099631]  [<b013029d>] irq_exit+0x7d/0xa0                                 
[ 1833.099631]  [<b0114fee>] smp_apic_timer_interrupt+0x5e/0x90                 
[ 1833.099631]  [<b0264828>] ? trace_hardirqs_off_thunk+0xc/0x14                
[ 1833.099631]  [<b0103ae1>] apic_timer_interrupt+0x2d/0x34                     
[ 1833.099631]  [<b042afdf>] ? _spin_unlock_irqrestore+0x2f/0x70                
[ 1833.099631]  [<b012b7dd>] ? vprintk+0x29d/0x3d0                              
[ 1833.099631]  [<f0a39fd9>] ? journal_stop+0x169/0x3a0 [jbd]                   
[ 1833.099631]  [<b0427b13>] printk+0x18/0x1a                                   
[ 1833.099631]  [<f0a76cb0>] ext3_should_retry_alloc+0x80/0xa0 [ext3]           
[ 1833.099631]  [<f0a81396>] ext3_create+0x46/0x100 [ext3]                      
[ 1833.099631]  [<b0198c7c>] vfs_create+0xbc/0x120                              
[ 1833.099631]  [<b042b03d>] ? _spin_unlock+0x1d/0x40                           
[ 1833.099631]  [<f0a81350>] ? ext3_create+0x0/0x100 [ext3]                     
[ 1833.099631]  [<b019be80>] do_filp_open+0x6d0/0x7e0                           
[ 1833.099631]  [<b042b03d>] ? _spin_unlock+0x1d/0x40                           
[ 1833.099631]  [<b01a5148>] ? alloc_fd+0xe8/0x100                              
[ 1833.099631]  [<b018e2e9>] do_sys_open+0x59/0xf0                              [ 1833.099631]  [<b018e3e9>] sys_open+0x29/0x40                                 
[ 1833.099631]  [<b018e420>] sys_creat+0x20/0x30                                
[ 1833.099631]  [<b0103385>] sysenter_do_call+0x12/0x35                         
[ 1833.099631] ---[ end trace 1b613fe912a9ef3e ]---                             

--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="brd.ext4fs.corruption.txt"

-------------------------------------------------------------
Cycle 12
Fri Mar 13 10:59:33 EDT 2009
Mounting
Removing old fsstress data
Starting fsstress
Sleeping 30 seconds
seed = 1237202926
Stopping fsstress
 8461 pts/1    00:00:00 fsstress_ext4
 8464 pts/1    00:00:19 fsstress_ext4
 8465 pts/1    00:00:19 fsstress_ext4
 8466 pts/1    00:00:19 fsstress_ext4
./brd_test_ext4.sh: line 36:  8461 Terminated              `pwd`/fsstress_ext4 -d $TESTDIR/work -p 3 -l 0 -n 100000000
Unmounting
Checking
/dev/ram1: HTREE directory inode 352 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram1: HTREE directory inode 713 has an invalid root node.
HTREE INDEX CLEARED.
/dev/ram1: Entry 'c2d8' in /work/p0/da/d124/d544 (713) has an incorrect filetype (was 3, should be 1).


/dev/ram1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)


--3siQDZowHQqNOShm--
