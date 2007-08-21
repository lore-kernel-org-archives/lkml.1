Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXHUEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXHUEqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 00:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXHUEp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 00:45:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35168 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbXHUEpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 00:45:54 -0400
Date: Mon, 20 Aug 2007 21:44:13 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.4
Message-ID: <20070821044413.GB13852@kroah.com>
References: <20070821044307.GA13852@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821044307.GA13852@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index bc2d377..f2a62ee 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .3
+EXTRAVERSION = .4
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/fs/exec.c b/fs/exec.c
index f20561f..9a93770 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -890,9 +890,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid || 
-	    file_permission(bprm->file, MAY_READ) ||
-	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
+	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+		suid_keys(current);
+		current->mm->dumpable = suid_dumpable;
+		current->pdeath_signal = 0;
+	} else if (file_permission(bprm->file, MAY_READ) ||
+			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
 		current->mm->dumpable = suid_dumpable;
 	}
@@ -983,8 +986,10 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid)
+	if (bprm->e_uid != current->uid) {
 		suid_keys(current);
+		current->pdeath_signal = 0;
+	}
 	exec_keys(current);
 
 	task_lock(current);
