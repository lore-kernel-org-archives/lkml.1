Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbXDQOmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbXDQOmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbXDQOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:42:07 -0400
Received: from cs1.cs.huji.ac.il ([132.65.16.10]:63201 "EHLO cs1.cs.huji.ac.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430AbXDQOmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:42:06 -0400
X-Greylist: delayed 2648 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 10:42:06 EDT
Date: Tue, 17 Apr 2007 16:57:55 +0300
From: Tom Alsberg <alsbergt@cs.huji.ac.il>
To: Linux-Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: CPU time limit patch / setrlimit(RLIMIT_CPU, 0) cheat fix
Message-ID: <20070417135755.GA55049@cs.huji.ac.il>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
X-Face: "5"j@Y1Peoz1;ftTv>\|['ox-csmV+:_RDNdi/2lSe2x?0:HVAeVW~ajwQ7RfDlcb^18eJ;t,O,s5-aNdU/DJ2E8h1s,..4}N9$27u`pWmH|;s!zlqqVwr9R^_ji=1\3}Z6gQBYyQ]{gd5-V8s^fYf{$V2*_&S>eA|SH@Y\hOVUjd[5eah{EO@gCr.ydSpJHJIU[QsH~bC?$C@O:SzF=CaUxp80-iknM(]q(W<UR
User-Agent: mutt-ng/devel-r804 (FreeBSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi there.

As discovered here today, the change in Kernel 2.6.17 intended to
inhibit users from setting RLIMIT_CPU to 0 (as that is equivalent to
unlimited) by "cheating" and setting it to 1 in such a case, does not
make a difference, as the check is done in the wrong place (too late),
and only applies to the profiling code.

On all systems I checked running kernels above 2.6.17, no matter what
the hard and soft CPU time limits were before, a user could escape
them by issuing in the shell (sh/bash/zsh) "ulimit -t 0", and then the
user's process was not ever killed.

Attached is a trivial patch to fix that.  Simply moving the check to a
slightly earlier location (specifically, before the line that actually
assigns the limit - *old_rlim = new_rlim), does the trick.

Do note that at least the zsh (but not ash, dash, or bash) shell has
the problem of "caching" the limits set by the ulimit command, so when
running zsh the fix will not immediately be evident - after entering
"ulimit -t 0", "ulimit -a" will show "-t: cpu time (seconds) 0", even
though the actual limit as returned by getrlimit(...) will be 1.  It
can be verified by opening a subshell (which will not have the values
of the parent shell in cache) and checking in it, or just by running a
CPU intensive command like "echo '65536^1048576' | bc" and verifying
that it dumps core after one second.

Regardless of whether that is a misfeature in the shell, perhaps it
would be better to return -EINVAL from setrlimit in such a case
instead of cheating and setting to 1, as that does not really reflect
the actual state of the process anymore.  I do not however know what
the ground for that decision was in the original 2.6.17 change, and
whether there would be any "backward" compatibility issues, so I
preferred not to touch that right now.

  Cheers,
  -- Tom

-- 
  Tom Alsberg - hacker (being the best description fitting this space)
  Web page:	http://www.cs.huji.ac.il/~alsbergt/
DISCLAIMER:  The above message does not even necessarily represent what
my fingers have typed on the keyboard, save anything further.

--XsQoSWH+UP9D9v3l
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.20.3-cpulimit.diff"

Follows a trivial patch to check for RLIMIT_CPU to 0 in the right place.

diff -urN linux-2.6.20.3.orig/kernel/sys.c linux-2.6.20.3/kernel/sys.c
--- linux-2.6.20.3.orig/kernel/sys.c	2007-03-13 20:27:08.000000000 +0200
+++ linux-2.6.20.3/kernel/sys.c	2007-04-17 16:38:51.651236000 +0300
@@ -1916,6 +1916,16 @@
 	if (retval)
 		return retval;
 
+	if (resource == RLIMIT_CPU && new_rlim.rlim_cur == 0) {
+		/*
+		 * The caller is asking for an immediate RLIMIT_CPU
+		 * expiry.  But we use the zero value to mean "it was
+		 * never set".  So let's cheat and make it one second
+		 * instead
+		 */
+		new_rlim.rlim_cur = 1;
+	}
+
 	task_lock(current->group_leader);
 	*old_rlim = new_rlim;
 	task_unlock(current->group_leader);
@@ -1937,15 +1947,6 @@
 		unsigned long rlim_cur = new_rlim.rlim_cur;
 		cputime_t cputime;
 
-		if (rlim_cur == 0) {
-			/*
-			 * The caller is asking for an immediate RLIMIT_CPU
-			 * expiry.  But we use the zero value to mean "it was
-			 * never set".  So let's cheat and make it one second
-			 * instead
-			 */
-			rlim_cur = 1;
-		}
 		cputime = secs_to_cputime(rlim_cur);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&current->sighand->siglock);

--XsQoSWH+UP9D9v3l--
