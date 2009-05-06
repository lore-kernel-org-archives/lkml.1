Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbZEFWIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbZEFWIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761509AbZEFVyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:52 -0400
Received: from kroah.org ([198.145.64.141]:57223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761487AbZEFVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:59 2009
Message-Id: <20090506214759.861567558@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>
Subject: [patch 33/58] compat_do_execve should unshare_files
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=compat_do_execve-should-unshare_files.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

commit 53e9309e01277ec99c38e84e0ca16921287cf470 upstream.

2.6.26's commit fd8328be874f4190a811c58cd4778ec2c74d2c05
"sanitize handling of shared descriptor tables in failing execve()"
moved the unshare_files() from flush_old_exec() and several binfmts
to the head of do_execve(); but forgot to make the same change to
compat_do_execve(), leaving a CLONE_FILES files_struct shared across
exec from a 32-bit process on a 64-bit kernel.

It's arguable whether the files_struct really ought to be unshared
across exec; but 2.6.1 made that so to stop the loading binary's fd
leaking into other threads, and a 32-bit process on a 64-bit kernel
ought to behave in the same way as 32 on 32 and 64 on 64.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1392,12 +1392,17 @@ int compat_do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
+	struct files_struct *displaced;
 	int retval;
 
+	retval = unshare_files(&displaced);
+	if (retval)
+		goto out_ret;
+
 	retval = -ENOMEM;
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
-		goto out_ret;
+		goto out_files;
 
 	retval = mutex_lock_interruptible(&current->cred_exec_mutex);
 	if (retval < 0)
@@ -1457,6 +1462,8 @@ int compat_do_execve(char * filename,
 	mutex_unlock(&current->cred_exec_mutex);
 	acct_update_integrals(current);
 	free_bprm(bprm);
+	if (displaced)
+		put_files_struct(displaced);
 	return retval;
 
 out:
@@ -1475,6 +1482,9 @@ out_unlock:
 out_free:
 	free_bprm(bprm);
 
+out_files:
+	if (displaced)
+		reset_files_struct(displaced);
 out_ret:
 	return retval;
 }


