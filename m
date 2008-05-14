Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbYENToS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbYENToS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbYENTm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:42:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbYENTlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:41:45 -0400
Date: Wed, 14 May 2008 21:41:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514194122.GA1616@elte.hu>
References: <20080514174955.GA515@elte.hu> <alpine.LFD.1.10.0805141136340.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805141136340.3019@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Linus, Alan: the increased visibility and debuggability of the BKL 
> > already uncovered a rather serious regression in upstream -git. You 
> > might want to cherry pick this single fix, it will apply just fine 
> > to current -git:
> 
> Ok, so I'm obviously happy. This is exactly the kind of thing I would 
> want to see.
> 
> That said, the way it is now set up, it's unreasonable to merge 
> anything directly, and while I can cherry-pick obvious fixes this way, 
> I do think we could do things better.

yeah. This is just a first approximation. It might be v2.6.27 stuff, if 
it stabilizes fast enough.

> It should be possible to set things up so that it's a config option, 
> and we can mark it EXPERIMENTAL but still merge it into the standard 
> kernel, so that we'd have the debug stuff there. That would get a lot 
> more coverage, especially if it all still *works*, even if the debug 
> stuff then complains (ie it would be nicer if the lock itself didn't 
> start breaking).

yeah. Will try to reshape it like that.

> So for example, have CONFIG_DEBUG_BKL turn it into a mutex (and select 
> mutex debugging), and get all the debug coverage that way, but then 
> when somebody enters the scheduler with the lock held, first complain, 
> but then auto-release it anyway. That way, bugs get found and 
> complained about, but hopefully the machine still ends up working.

hm, we'll got more ideas about other debug helpers, but i dont think 
warning in the scheduler is realistic or useful: lots and lots of code 
_does_ reschedule with the BKL held and always did - we never knew this 
before in a reliable way due to the auto-release. Sleeping locks that 
purely nest inside the BKL are the norm in the VFS, in the tty code and 
in most other places - they should be fine and are frequently taken in 
BKL sections (and frequently produce scheduling there).

As the BKL gets pushed inside subsystems, so do inner locks vanish from 
its scope - and at the final stage it can become a spinlock or mutex, 
depending on what the actual use is.

The main point with the mutex is to make the BKL _stricter_ and more 
defined - this hurts BKL using code more (see the many fixes that were 
needed), but it also makes things much more visible and much more 
fixable IMO. This tree turns the BKL into "just another mutex", with a 
tiny bit of self-recursion glue on top of it.

Btw., often there's potential scheduling at points where BKL using code 
does not expect it. So this series might also _fix_ some rare races.

The fact that this also makes BKL critical sections involuntarily 
preemptible is a side-effect (which is one of my main motivations to do 
this whole thing), and it's a pretty much unavoidable side-effect.

Also, turning it into a more or less simple mutex with no scheduler 
smarts at all, it all fits into our "how do we remove a serializing 
lock" workflow rather well. Even if for some piece of code not much 
changes in reality, it becomes more familar, less mystic and more 
trustable to fix and improve.

Btw., while i hacked on this today, i _think_ i've got most of the worst 
problems mapped out already. I needed two fixes to get it to boot to a 
ssh shell prompt without hanging. I needed 10 more fixes to solve all 
the dependencies that lockdep found. Another 5 fixes were exposed in 
more directed randconfig based testing in the second half of the day.

I've got a full desktop running on SMP on two boxes with lots of 
services enabled. There are three known problem areas:

 - reiser3. I've got three patches for but they are not pretty - see 
   them below. One of them widens BKL locking to the VFS. I'm not sure 
   it's worth fixing - we could declare reiser3 legacy && make it depend 
   on !DEBUG_BKL?

 - NFS. Even with "remove the BKL: restructure NFS code" there's a 
   lockdep splat when mounting NFS. Havent looked into it yet, Peter 
   says it's hairy code.

 - racy procfs dir entry creation methods. These will not result in
   outright hangs, but need to be reviewed then fixed or annotated away 
   because they are potentially racy - they'll show up as WARN_ON()s in 
   fs/proc/.

More will be found i'm sure, but also, about 80% of the fixes were not 
actual hangs but were proactive fixes based on lockdep warnings. Only 3 
out of the ~17 fixes were hang-induced. So i think even the current 
early form of it is quite hackable and debuggable.

	Ingo

---------------------
Subject: remove bkl: annotate reiserfs3
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 14 15:22:01 CEST 2008

reiserfs uses proc_create_data() with the BKL held;

WARNING: at fs/proc/generic.c:701 proc_create_data+0x33/0xc3()
Modules linked in:
Pid: 3193, comm: mount Not tainted 2.6.26-rc2-sched-devel.git #478
 [<c013d2ed>] warn_on_slowpath+0x41/0x6d
 [<c01571c0>] ? save_trace+0x37/0x8a
 [<c0157277>] ? add_lock_to_list+0x64/0x8a
 [<c01c7fea>] ? proc_register+0x2e/0x12e
 [<c04ae22c>] ? _spin_unlock+0x27/0x3c
 [<c01c811d>] proc_create_data+0x33/0xc3
 [<c01f6bd2>] add_file+0x23/0x2a
 [<c01f6c73>] ? show_version+0x0/0x3b
 [<c01f749a>] reiserfs_proc_info_init+0xab/0x136
 [<c01e4a3a>] reiserfs_fill_super+0xb97/0xc7d
 [<c02687f8>] ? vsnprintf+0x265/0x3fc
 [<c01cbd02>] ? disk_name+0x25/0x67
 [<c0195997>] get_sb_bdev+0xcd/0x10b
 [<c0190030>] ? cache_alloc_refill+0x53c/0x632
 [<c01a7609>] ? alloc_vfsmnt+0xe3/0x10b
 [<c01a7609>] ? alloc_vfsmnt+0xe3/0x10b
 [<c01e1f3d>] get_super_block+0x13/0x15
 [<c01e3ea3>] ? reiserfs_fill_super+0x0/0xc7d
 [<c019557f>] vfs_kern_mount+0x81/0xf7
 [<c0195639>] do_kern_mount+0x32/0xba
 [<c01a863d>] do_new_mount+0x46/0x74
 [<c01a8802>] do_mount+0x197/0x1b5
 [<c01586a7>] ? trace_hardirqs_on_caller+0xe0/0x115
 [<c04ace60>] ? mutex_lock_nested+0x222/0x22a
 [<c04ae4ab>] ? lock_kernel+0x1e/0x25
 [<c01a8884>] sys_mount+0x64/0x9b
 [<c0119a8a>] sysenter_past_esp+0x6a/0xa4
 =======================

but its use of proc_create_data() is safe here. Annotate that by dropping
the BKL around the procfs ops.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/procfs.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/fs/reiserfs/procfs.c
===================================================================
--- linux.orig/fs/reiserfs/procfs.c
+++ linux/fs/reiserfs/procfs.c
@@ -494,6 +494,15 @@ int reiserfs_proc_info_init(struct super
 	spin_lock_init(&__PINFO(sb).lock);
 	REISERFS_SB(sb)->procdir = proc_mkdir(b, proc_info_root);
 	if (REISERFS_SB(sb)->procdir) {
+		int saved_lock_depth = current->lock_depth;
+
+		/*
+		 * This is in essence an annotation that tells procfs that
+		 * it is fine to call it with the BKL held (it causes
+		 * the kernel_locked() check to not trigger):
+		 */
+		current->lock_depth = -1;
+
 		REISERFS_SB(sb)->procdir->owner = THIS_MODULE;
 		REISERFS_SB(sb)->procdir->data = sb;
 		add_file(sb, "version", show_version);
@@ -503,6 +512,9 @@ int reiserfs_proc_info_init(struct super
 		add_file(sb, "on-disk-super", show_on_disk_super);
 		add_file(sb, "oidmap", show_oidmap);
 		add_file(sb, "journal", show_journal);
+
+		current->lock_depth = saved_lock_depth;
+
 		return 0;
 	}
 	reiserfs_warning(sb, "reiserfs: cannot create /proc/%s/%s",

------------>
Subject: remove: bkl sync supers dependency
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 14 16:10:36 CEST 2008

untangle this dependency:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc2-sched-devel.git #480
-------------------------------------------------------
pdflush/303 is trying to acquire lock:
 (kernel_mutex){--..}, at: [<c04ae4cb>] lock_kernel+0x1e/0x25

but task is already holding lock:
 (&type->s_lock_key#8){--..}, at: [<c0194b95>] lock_super+0x1b/0x1d

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #2 (&type->s_lock_key#8){--..}:
       [<c0159405>] __lock_acquire+0x97d/0xae6
       [<c01598da>] lock_acquire+0x4e/0x6c
       [<c04acd20>] mutex_lock_nested+0xc2/0x22a
       [<c0194b95>] lock_super+0x1b/0x1d
       [<c01956ff>] sync_supers+0x3e/0x99
       [<c017a3b9>] wb_kupdate+0x2a/0xdd
       [<c017a89d>] pdflush+0xf8/0x18d
       [<c014d5b4>] kthread+0x3b/0x63
       [<c011a737>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (&type->s_umount_key#15){----}:
       [<c0159405>] __lock_acquire+0x97d/0xae6
       [<c01598da>] lock_acquire+0x4e/0x6c
       [<c04ad28a>] down_write+0x28/0x44
       [<c0194f67>] sget+0x1fd/0x339
       [<c0195910>] get_sb_bdev+0x46/0x10b
       [<c01e1f3d>] get_super_block+0x13/0x15
       [<c019557f>] vfs_kern_mount+0x81/0xf7
       [<c0195639>] do_kern_mount+0x32/0xba
       [<c01a863d>] do_new_mount+0x46/0x74
       [<c01a8802>] do_mount+0x197/0x1b5
       [<c01a8884>] sys_mount+0x64/0x9b
       [<c06dba90>] mount_block_root+0xa3/0x1e6
       [<c06dbc1f>] mount_root+0x4c/0x54
       [<c06dbd72>] prepare_namespace+0x14b/0x172
       [<c06db565>] kernel_init+0x217/0x226
       [<c011a737>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (kernel_mutex){--..}:
       [<c015932c>] __lock_acquire+0x8a4/0xae6
       [<c01598da>] lock_acquire+0x4e/0x6c
       [<c04acd20>] mutex_lock_nested+0xc2/0x22a
       [<c04ae4cb>] lock_kernel+0x1e/0x25
       [<c01e2839>] reiserfs_sync_fs+0x15/0x5b
       [<c01e288c>] reiserfs_write_super+0xd/0xf
       [<c0195719>] sync_supers+0x58/0x99
       [<c017a3b9>] wb_kupdate+0x2a/0xdd
       [<c017a89d>] pdflush+0xf8/0x18d
       [<c014d5b4>] kthread+0x3b/0x63
       [<c011a737>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by pdflush/303:
 #0:  (&type->s_umount_key#15){----}, at: [<c01956f8>] sync_supers+0x37/0x99
 #1:  (&type->s_lock_key#8){--..}, at: [<c0194b95>] lock_super+0x1b/0x1d

stack backtrace:
Pid: 303, comm: pdflush Not tainted 2.6.26-rc2-sched-devel.git #480
 [<c0157af7>] print_circular_bug_tail+0x5b/0x66
 [<c015743f>] ? print_circular_bug_entry+0x39/0x43
 [<c015932c>] __lock_acquire+0x8a4/0xae6
 [<c0158040>] ? find_usage_backwards+0x97/0xb6
 [<c01598da>] lock_acquire+0x4e/0x6c
 [<c04ae4cb>] ? lock_kernel+0x1e/0x25
 [<c04acd20>] mutex_lock_nested+0xc2/0x22a
 [<c04ae4cb>] ? lock_kernel+0x1e/0x25
 [<c04ae4cb>] ? lock_kernel+0x1e/0x25
 [<c04ae4cb>] lock_kernel+0x1e/0x25
 [<c01e2839>] reiserfs_sync_fs+0x15/0x5b
 [<c0194b95>] ? lock_super+0x1b/0x1d
 [<c01e288c>] reiserfs_write_super+0xd/0xf
 [<c0195719>] sync_supers+0x58/0x99
 [<c017a3b9>] wb_kupdate+0x2a/0xdd
 [<c01586e7>] ? trace_hardirqs_on+0xb/0xd
 [<c017a7a5>] ? pdflush+0x0/0x18d
 [<c017a89d>] pdflush+0xf8/0x18d
 [<c017a38f>] ? wb_kupdate+0x0/0xdd
 [<c014d5b4>] kthread+0x3b/0x63
 [<c014d579>] ? kthread+0x0/0x63
 [<c011a737>] kernel_thread_helper+0x7/0x10
 =======================

it's a hack, because it widens the BKL's scope. But it's needed
for every filesystem that takes the BKL, up until the point that
SB code can stop using the BKL.

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/quota.c |    2 ++
 fs/super.c |    4 ++++
 2 files changed, 6 insertions(+)

Index: linux/fs/quota.c
===================================================================
--- linux.orig/fs/quota.c
+++ linux/fs/quota.c
@@ -206,10 +206,12 @@ restart:
 			continue;
 		sb->s_count++;
 		spin_unlock(&sb_lock);
+		lock_kernel();
 		down_read(&sb->s_umount);
 		if (sb->s_root && sb->s_qcop->quota_sync)
 			quota_sync_sb(sb, type);
 		up_read(&sb->s_umount);
+		unlock_kernel();
 		spin_lock(&sb_lock);
 		if (__put_super_and_need_restart(sb))
 			goto restart;
Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c
+++ linux/fs/super.c
@@ -408,9 +408,11 @@ restart:
 		if (sb->s_dirt) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
+			lock_kernel();
 			down_read(&sb->s_umount);
 			write_super(sb);
 			up_read(&sb->s_umount);
+			unlock_kernel();
 			spin_lock(&sb_lock);
 			if (__put_super_and_need_restart(sb))
 				goto restart;
@@ -459,10 +461,12 @@ restart:
 			continue;	/* hm.  Was remounted r/o meanwhile */
 		sb->s_count++;
 		spin_unlock(&sb_lock);
+		lock_kernel();
 		down_read(&sb->s_umount);
 		if (sb->s_root && (wait || sb->s_dirt))
 			sb->s_op->sync_fs(sb, wait);
 		up_read(&sb->s_umount);
+		unlock_kernel();
 		/* restart only when sb is no longer on the list */
 		spin_lock(&sb_lock);
 		if (__put_super_and_need_restart(sb))

------------->

Subject: remove bkl: reiserfs fix
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 14 16:26:36 CEST 2008

avoid j_commit_lock deadlock. Since the down() can block it is
safe to drop the BKL here.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/reiserfs/journal.c |    2 ++
 fs/super.c            |    2 ++
 2 files changed, 4 insertions(+)

Index: linux/fs/reiserfs/journal.c
===================================================================
--- linux.orig/fs/reiserfs/journal.c
+++ linux/fs/reiserfs/journal.c
@@ -1044,8 +1044,10 @@ static int flush_commit_list(struct supe
 		}
 	}
 
+//	unlock_kernel();
 	/* make sure nobody is trying to flush this one at the same time */
 	down(&jl->j_commit_lock);
+//	lock_kernel();
 	if (!journal_list_still_alive(s, trans_id)) {
 		up(&jl->j_commit_lock);
 		goto put_jl;
Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c
+++ linux/fs/super.c
@@ -180,10 +180,12 @@ void deactivate_super(struct super_block
 		s->s_count -= S_BIAS-1;
 		spin_unlock(&sb_lock);
 		DQUOT_OFF(s, 0);
+		lock_kernel();
 		down_write(&s->s_umount);
 		fs->kill_sb(s);
 		put_filesystem(fs);
 		put_super(s);
+		unlock_kernel();
 	}
 }
 

