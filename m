Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZBJTFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZBJTFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZBJTDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:30 -0500
Received: from kroah.org ([198.145.64.141]:53621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754593AbZBJTD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:29 -0500
Date: Tue, 10 Feb 2009 10:59:50 -0800
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
       alan@lxorguk.ukuu.org.uk, Adam Tkac <vonsch@gmail.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: [patch 05/53] revert "rlimit: permit setting RLIMIT_NOFILE to
	RLIM_INFINITY"
Message-ID: <20090210185950.GF14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-rlimit-permit-setting-rlimit_nofile-to-rlim_infinity.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 60fd760fb9ff7034360bab7137c917c0330628c2 upstream.

Revert commit 0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f because it causes
(arguably poorly designed) existing userspace to spend interminable
periods closing billions of not-open file descriptors.

We could bring this back, with some sort of opt-in tunable in /proc, which
defaults to "off".

Peter's alanysis follows:

: I spent several hours trying to get to the bottom of a serious
: performance issue that appeared on one of our servers after upgrading to
: 2.6.28.  In the end it's what could be considered a userspace bug that
: was triggered by a change in 2.6.28.  Since this might also affect other
: people I figured I'd at least document what I found here, and maybe we
: can even do something about it:
:
:
: So, I upgraded some of debian.org's machines to 2.6.28.1 and immediately
: the team maintaining our ftp archive complained that one of their
: scripts that previously ran in a few minutes still hadn't even come
: close to being done after an hour or so.  Downgrading to 2.6.27 fixed
: that.
:
: Turns out that script is forking a lot and something in it or python or
: whereever closes all the file descriptors it doesn't want to pass on.
: That is, it starts at zero and goes up to ulimit -n/RLIMIT_NOFILE and
: closes them all with a few exceptions.
:
: Turns out that takes a long time when your limit -n is now 2^20 (1048576).
:
: With 2.6.27.* the ulimit -n was the standard 1024, but with 2.6.28 it is
: now a thousand times that.
:
: 2.6.28 included a patch titled "rlimit: permit setting RLIMIT_NOFILE to
: RLIM_INFINITY" (0c2d64fb6cae9aae480f6a46cfe79f8d7d48b59f)[1] that
: allows, as the title implies, to set the limit for number of files to
: infinity.
:
: Closer investigation showed that the broken default ulimit did not apply
: to "system" processes (like stuff started from init).  In the end I
: could establish that all processes that passed through pam_limit at one
: point had the bad resource limit.
:
: Apparently the pam library in Debian etch (4.0) initializes the limits
: to some default values when it doesn't have any settings in limit.conf
: to override them.  Turns out that for nofiles this is RLIM_INFINITY.
: Commenting out "case RLIMIT_NOFILE" in pam_limit.c:267 of our pam
: package version 0.79-5 fixes that - tho I'm not sure what side effects
: that has.
:
: Debian lenny (the upcoming 5.0 version) doesn't have this issue as it
: uses a different pam (version).

Reported-by: Peter Palfrader <weasel@debian.org>
Cc: Adam Tkac <vonsch@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sys.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1447,22 +1447,14 @@ SYSCALL_DEFINE2(setrlimit, unsigned int,
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
+	if (new_rlim.rlim_cur > new_rlim.rlim_max)
+		return -EINVAL;
 	old_rlim = current->signal->rlim + resource;
 	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
 	    !capable(CAP_SYS_RESOURCE))
 		return -EPERM;
-
-	if (resource == RLIMIT_NOFILE) {
-		if (new_rlim.rlim_max == RLIM_INFINITY)
-			new_rlim.rlim_max = sysctl_nr_open;
-		if (new_rlim.rlim_cur == RLIM_INFINITY)
-			new_rlim.rlim_cur = sysctl_nr_open;
-		if (new_rlim.rlim_max > sysctl_nr_open)
-			return -EPERM;
-	}
-
-	if (new_rlim.rlim_cur > new_rlim.rlim_max)
-		return -EINVAL;
+	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
+		return -EPERM;
 
 	retval = security_task_setrlimit(resource, &new_rlim);
 	if (retval)

