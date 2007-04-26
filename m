Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbXDZREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbXDZREF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbXDZRBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39578 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbXDZRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:09 -0400
Date: Thu, 26 Apr 2007 09:56:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       git-commits-head@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Cox <alan@redhat.com>
Subject: [patch 18/33] exec.c: fix coredump to pipe problem and obscure
	"security hole"
Message-ID: <20070426165623.GS1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="exec.c-fix-coredump-to-pipe-problem-and-obscure-security-hole.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

exec.c: fix coredump to pipe problem and obscure "security hole"

The patch checks for "|" in the pattern not the output and doesn't nail a
pid on to a piped name (as it is a program name not a file)

Also fixes a very very obscure security corner case.  If you happen to have
decided on a core pattern that starts with the program name then the user
can run a program called "|myevilhack" as it stands.  I doubt anyone does
this.

Signed-off-by: Alan Cox <alan@redhat.com>
Confirmed-by: Christopher S. Aker <caker@theshore.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1246,13 +1246,17 @@ EXPORT_SYMBOL(set_binfmt);
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
@@ -1343,8 +1347,8 @@ static void format_corename(char *corena
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
@@ -1352,8 +1356,9 @@ static void format_corename(char *corena
 			goto out;
 		out_ptr += rc;
 	}
-      out:
+out:
 	*out_ptr = 0;
+	return ispipe;
 }
 
 static void zap_process(struct task_struct *start)
@@ -1504,16 +1509,15 @@ int do_coredump(long signr, int exit_cod
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

-- 
