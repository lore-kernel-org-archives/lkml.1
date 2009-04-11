Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZDKMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZDKMMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 08:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZDKMMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 08:12:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53826 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZDKMME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 08:12:04 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
       <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m1skkf761y.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 11 Apr 2009 05:11:59 -0700
In-Reply-To: <m1skkf761y.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sat\, 11 Apr 2009 05\:01\:29 -0700")
Message-ID: <m1ws9r5r00.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [RFC][PATCH 7/9] vfs: Optimize fops_read_lock
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After seeing fget_light and the justification for it in the commit
log I did not want to introduce something into the common read/write
path of file descriptors that could have a significant measurable impact
on I/O speed.

commit f6435db01709533f270b2dce1e5914770dbc65de
Author: akpm <akpm>
Date:   Thu May 8 05:19:50 2003 +0000

    [PATCH] reduced overheads in fget/fput

    From: Dipankar Sarma <dipankar@in.ibm.com>

    fget() shows up on profiles, especially on SMP.  Dipankar's patch
    special-cases the situation wherein there are no sharers of current->files.

    In this situation we know that no other process can close this file, so it
    is not necessary to increment the file's refcount.

    It's ugly as sin, but makes a substantial difference.

    The test is

        dd if=/dev/zero of=foo bs=1 count=1M

    On 4CPU P3 xeon with 1MB L2 cache and 512MB ram:

        kernel           sys time     std-dev
        ------------     --------     -------

        UP - vanilla     2.104        0.028
        UP - file        1.867        0.019

        SMP - vanilla    2.976        0.023
        SMP - file       2.719        0.026

    BKrev: 3eb9e8f6Db0nMWoSx5IdHx6SBal8aw

My test case was:
    dd if=/dev/zero of=/dev/null bs=1 count=1M.

As writing to a real file turned out to cover the cost.

Without the optimization I am seeing 2.4 - 2.5 MB/s on my
idle core2 single socket quad core.

With this optimization I am seeing 2.9 - 3.0 MB/s on the
same machine.  Maybe 2% slower than before I introduced
fops_read_lock.

The common case is that there is only one thread and so
the fget_light optimization applies and f_count remains
at 1.  Which implies that there is only a single process
performing operations through the file descriptor.

In that case because there is no possible contention
it is possible safely skip the atomic operations, gaining all
of the benefits of rcu without requiring a per cpu variable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/file_table.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index d216557..634d44c 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -495,15 +495,25 @@ void file_kill(struct file *file)
 int fops_read_lock(struct file *file)
 {
 	int revoked = (file->f_mode & FMODE_REVOKED);
-	if (likely(!revoked))
-		atomic_long_inc(&file->f_use);
+	if (likely(!revoked)) {
+		if (likely(atomic_long_read(&file->f_count) == 1))
+			atomic_long_set(&file->f_use,
+				atomic_long_read(&file->f_use) + 1);
+		else
+			atomic_long_inc(&file->f_use);
+	}
 	return revoked;
 }
 
 void fops_read_unlock(struct file *file, int revoked)
 {
-	if (likely(!revoked))
-		atomic_long_dec(&file->f_use);
+	if (likely(!revoked)) {
+		if (likely(atomic_long_read(&file->f_count) == 1))
+			atomic_long_set(&file->f_use,
+				atomic_long_read(&file->f_use) - 1);
+		else
+			atomic_long_dec(&file->f_use);
+	}
 }
 
 int fs_may_remount_ro(struct super_block *sb)
-- 
1.6.1.2.350.g88cc

