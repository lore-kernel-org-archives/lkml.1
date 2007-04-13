Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXDMMgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXDMMgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbXDMMgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:36:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34634 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753967AbXDMMgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:36:03 -0400
Date: Fri, 13 Apr 2007 13:39:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Christopher S. Aker" <caker@theshore.net>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070413133915.55cbf012@the-village.bc.nu>
In-Reply-To: <461EE95A.3090600@theshore.net>
References: <461E55C6.1030905@theshore.net>
	<20070412172845.58bfeff5@the-village.bc.nu>
	<20070412164251.GC11736@ti88.telemetry-investments.com>
	<p73ps697agf.fsf@bingen.suse.de>
	<461EE95A.3090600@theshore.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking at the code, it seems to me that format_corename() is appending 
> .pid, regardless if !core_uses_pid and corename[0]=='|', in which case 
> it creates an invalid path for call_usermodehelper_pipe().
> 
> Bug in the code, or bug in my methods?

This looks somewhat better and might do the trick. Also fixes a very very
obscure security corner case. If you change core pattern to start with
the program name then the user can run a program called "|myevilhack" as
it stands. The patch checks for "|" in the pattern not the output and
doesn't nail a pid on to a piped name.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.21-rc6-mm1/fs/exec.c linux-2.6.21-rc6-mm1/fs/exec.c
--- linux.vanilla-2.6.21-rc6-mm1/fs/exec.c	2007-04-12 14:15:05.000000000 +0100
+++ linux-2.6.21-rc6-mm1/fs/exec.c	2007-04-13 13:11:20.709835952 +0100
@@ -1265,13 +1265,17 @@
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static void format_corename(char *corename, const char *pattern, long signr)
+static int format_corename(char *corename, const char *pattern, long signr)
 {
 	const char *pat_ptr = pattern;
 	char *out_ptr = corename;
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
+	int ispipe = 0;
+	
+	if (*pattern == '|')
+		ispipe = 1;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1362,8 +1366,8 @@
 	 *
 	 * If core_pattern does not include a %p (as is the default)
 	 * and core_uses_pid is set, then .%pid will be appended to
-	 * the filename */
-	if (!pid_in_pattern
+	 * the filename. Do not do this for piped commands. */
+	if (!ispipe && !pid_in_pattern
             && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", current->tgid);
@@ -1371,8 +1375,9 @@
 			goto out;
 		out_ptr += rc;
 	}
-      out:
+out:
 	*out_ptr = 0;
+	return ispipe;
 }
 
 static void zap_process(struct task_struct *start)
@@ -1523,16 +1528,15 @@
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	format_corename(corename, core_pattern, signr);
+	ispipe = format_corename(corename, core_pattern, signr);
 	unlock_kernel();
- 	if (corename[0] == '|') {
+ 	if (ispipe) {
 		/* SIGPIPE can happen, but it's just never processed */
  		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
  			goto fail_unlock;
  		}
-		ispipe = 1;
  	} else
  		file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
