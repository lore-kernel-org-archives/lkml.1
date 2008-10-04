Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbYJDON0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbYJDON0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 10:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbYJDONR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 10:13:17 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:38642 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752842AbYJDONQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 10:13:16 -0400
Date: Sat, 4 Oct 2008 10:12:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081004141252.GA23398@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002074523.GW19428@kernel.dk> <20081002010315.1cda8147.akpm@linux-foundation.org> <20081002120444.GA25164@mit.edu> <20081002061629.39d5e115@infradead.org> <20081002134659.GC25164@mit.edu> <20081002073304.7f027f52@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20081002073304.7f027f52@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 02, 2008 at 07:33:04AM -0700, Arjan van de Ven wrote:
> > I can whip up a patch which adds some markers which we could use to
> > find out more information about what is happening.
> 
> interesting testcase of the markers concept.

Sorry for the delay, I ran into a minor bug in the Modules.marker
generation support that prevented Systemtap from being able to use
markers.  (It was busted since 2.6.27-rc1, so I guess that gives us
some sense how often developers use Systemtap.  :-)

It looks like Andrew's workaround seems to help you out, but if you're
willing to run this while your mail reader is running, and correlate
it with with the large latency spikes, we might get some interesting
results.

Anyway, here's the patch (against ext4, although could pretty easily
move this to ext3 --- but you can mount an ext3 filesystem as ext4,
although for the moment you do have to run the command "tune2fs -E
test_fs /dev/hdXX" first), and a sample systemtap script.  You'll also
need the markers patch, and of course the latest systemtap from their
git repository.

						- Ted


P.S.  Make sure you install systemtap in /usr/local, instead of trying
to run it out of the build tree.  See for an interesting report from
Roland McGrath about what happens if you make this mistake:

	http://sources.redhat.com/ml/systemtap/2008-q3/msg00809.html

I really think Systemtap has a lot of potential if only they could get
past some "minor usability concerns".  So one thing that I think would
really help the Systemtap folks is if more people gave them more, ah,
"constructive feedback" to their mailing list.

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=add-debugging-markers

ext4: Add debugging markers that can be used by systemtap

This debugging markers are designed to debug problems such as the
random filesystem latency problems reported by Arjan.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index c37d1e8..f8b57a2 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -28,6 +28,7 @@
 #include <linux/writeback.h>
 #include <linux/jbd2.h>
 #include <linux/blkdev.h>
+#include <linux/marker.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -51,6 +52,10 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
+	trace_mark(ext4_sync_file, "datasync %d dev %d ino %ld parent %ld",
+		   datasync, inode->i_sb->s_dev, inode->i_ino,
+		   dentry->d_parent->d_inode->i_ino);
+
 	/*
 	 * data=writeback:
 	 *  The caller's filemap_fdatawrite()/wait will sync the data.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 515af05..68b0301 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -35,6 +35,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/marker.h>
 #include <linux/log2.h>
 #include <linux/crc16.h>
 #include <asm/uaccess.h>
@@ -2950,6 +2951,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
 
+	trace_mark(ext4_sync_fs, "dev %d wait %d", sb->s_dev, wait);
 	sb->s_dirt = 0;
 	if (jbd2_journal_start_commit(EXT4_SB(sb)->s_journal, &target)) {
 		if (wait)
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 91389c8..72bec15 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -20,6 +20,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
+#include <linux/marker.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
@@ -313,6 +329,8 @@ int jbd2_log_do_checkpoint(journal_t *journal)
 	 * journal straight away.
 	 */
 	result = jbd2_cleanup_journal_tail(journal);
+	trace_mark(jbd2_checkpoint, "dev %d need_checkpoint %d",
+		   journal->j_fs_dev->bd_dev, result);
 	jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
 	if (result <= 0)
 		return result;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index b091e53..ecb485b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -16,6 +16,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
+#include <linux/marker.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -368,6 +369,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	commit_transaction = journal->j_running_transaction;
 	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
+	trace_mark(jbd2_start_commit, "dev %d transaction %d",
+		   journal->j_fs_dev->bd_dev, commit_transaction->t_tid);
 	jbd_debug(1, "JBD: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
@@ -985,6 +988,9 @@ restart_loop:
 	}
 	spin_unlock(&journal->j_list_lock);
 
+	trace_mark(jbd2_end_commit, "dev %d transaction %d head %d",
+		   journal->j_fs_dev->bd_dev, commit_transaction->t_tid,
+		   journal->j_tail_sequence);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=markers-patch

commit d80d36745e53d211293e358bc124dd68a3c88ba9
Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date:   Fri Oct 3 15:54:36 2008 -0400

    Marker depmod fix core kernel list
    
    * Theodore Ts'o (tytso@mit.edu) wrote:
    >
    > I've been playing with adding some markers into ext4 to see if they
    > could be useful in solving some problems along with Systemtap.  It
    > appears, though, that as of 2.6.27-rc8, markers defined in code which is
    > compiled directly into the kernel (i.e., not as modules) don't show up
    > in Module.markers:
    >
    > kvm_trace_entryexit arch/x86/kvm/kvm-intel  %u %p %u %u %u %u %u %u
    > kvm_trace_handler arch/x86/kvm/kvm-intel  %u %p %u %u %u %u %u %u
    > kvm_trace_entryexit arch/x86/kvm/kvm-amd  %u %p %u %u %u %u %u %u
    > kvm_trace_handler arch/x86/kvm/kvm-amd  %u %p %u %u %u %u %u %u
    >
    > (Note the lack of any of the kernel_sched_* markers, and the markers I
    > added for ext4_* and jbd2_* are missing as wel.)
    >
    > Systemtap apparently depends on in-kernel trace_mark being recorded in
    > Module.markers, and apparently it's been claimed that it used to be
    > there.  Is this a bug in systemtap, or in how Module.markers is getting
    > built?   And is there a file that contains the equivalent information
    > for markers located in non-modules code?
    >
    > Thanks, regards,
    >
    
    I think the problem comes from this patch :
    commit d35cb360c29956510b2fe1a953bd4968536f7216
    "markers: fix duplicate modpost entry"
    
    Here is a fix that should take care if this problem. Given I am not the
    modpost expert, let's see if I can get an ACK from Sam.
    
    Thanks for the bug report!
    
    Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
    CC: Theodore Ts'o <tytso@mit.edu>
    CC: David Smith <dsmith@redhat.com>
    CC: Roland McGrath <roland@redhat.com>
    CC: Sam Ravnborg <sam@ravnborg.org>
    CC: Wenji Huang <wenji.huang@oracle.com>
    CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 418cd7d..8e0de6a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1986,11 +1986,13 @@ static void read_markers(const char *fname)
 
 		mod = find_module(modname);
 		if (!mod) {
-			if (is_vmlinux(modname))
-				have_vmlinux = 1;
 			mod = new_module(NOFAIL(strdup(modname)));
 			mod->skip = 1;
 		}
+		if (is_vmlinux(modname)) {
+			have_vmlinux = 1;
+			mod->skip = 0;
+		}
 
 		if (!mod->skip)
 			add_marker(mod, marker, fmt);

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext4-marker.stp"

probe kernel.mark("ext4_sync_file")
{
	t = gettimeofday_ms();
	printf("%d.%d:ext4_sync_file: datasync %d ino %d parent %d\n",
		t / 1000, t % 1000, $arg1, $arg3, $arg4)
}

probe kernel.mark("ext4_sync_fs")
{
	t = gettimeofday_ms();
	printf("%d.%d:ext4_sync_fs: wait %d\n", t / 1000, t % 1000,
		$arg2)
}

probe kernel.mark("jbd2_start_commit")
{
	t = gettimeofday_ms();
	printf("%d.%d:jbd2_start_commit: transaction %d\n",
		t / 1000, t % 1000, $arg2)
}

probe kernel.mark("jbd2_end_commit")
{
	t = gettimeofday_ms();
	printf("%d.%d:jbd2_end_commit: transaction %d head %d\n",
	       t / 1000, t % 1000, $arg2, $arg3)
}

probe kernel.mark("jbd2_checkpoint")
{
	t = gettimeofday_ms();
	printf("%d.%d:jbd2_checkpoint: need_checkpoint %d\n", 
		t / 1000, t % 1000, $arg2);
}


--qDbXVdCdHGoSgWSk--
