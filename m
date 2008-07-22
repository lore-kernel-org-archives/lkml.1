Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYGVMPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYGVMPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYGVMO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:14:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46200 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbYGVMO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:14:57 -0400
Date: Tue, 22 Jul 2008 16:18:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [PATCH -mm] coredump: format_corename: don't append .%pid if multi-threaded
Message-ID: <20080722121824.GB1383@tv-sign.ru>
References: <200807210137.m6L1bN0H011138@imap1.linux-foundation.org> <20080721102940.666d733d@the-village.bc.nu> <20080721210121.C5E741541A5@magilla.localdomain> <20080721221416.6d4f9014@lxorguk.ukuu.org.uk> <20080722113731.GA1383@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722113731.GA1383@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the coredumping is multi-threaded, format_corename() appends .%pid
to the corename. This was needed before the proper multi-thread core
dump support, now all the threads in the mm go into a single unified
core file.

Remove this special case, it is not even documented and we have "%p"
and core_uses_pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/fs/exec.c~FORMAT_CORENAME_NO_MT_PID	2008-07-22 15:42:15.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-22 15:46:04.000000000 +0400
@@ -1373,7 +1373,7 @@ EXPORT_SYMBOL(set_binfmt);
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, int nr_threads, long signr)
+static int format_corename(char *corename, long signr)
 {
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
@@ -1480,8 +1480,7 @@ static int format_corename(char *corenam
 	 * If core_pattern does not include a %p (as is the default)
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
-	if (!ispipe && !pid_in_pattern
-	    && (core_uses_pid || nr_threads)) {
+	if (!ispipe && !pid_in_pattern && core_uses_pid) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", task_tgid_vnr(current));
 		if (rc > out_end - out_ptr)
@@ -1745,7 +1744,7 @@ int do_coredump(long signr, int exit_cod
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	ispipe = format_corename(corename, retval, signr);
+	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points

