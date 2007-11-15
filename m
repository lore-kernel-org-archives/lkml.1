Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbXKOGUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbXKOGUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759717AbXKOGQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762418AbXKOGQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:30 -0500
Date: Wed, 14 Nov 2007 22:14:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Lepton Wu <ytht.net@gmail.com>, Jeff Dike <jdike@linux.intel.com>
Subject: [patch 10/19] UML - kill subprocesses on exit
Message-ID: <20071115061454.GK7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-kill-subprocesses-on-exit.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Lepton Wu <ytht.net@gmail.com>

commit a24864a1d52a97e345a6bd4862a057f98364d098

uml: definitively kill subprocesses on panic

In a stock 2.6.22.6 kernel, poweroff a user mode linux guest (2.6.22.6 running
in skas0 mode) will halt the host linux.  I think the reason is the kernel
thread abort because of a bug.  Then the sys_reboot in process of user mode
linux guest is not trapped by the user mode linux kernel and is executed by
host.  I think it is better to make sure all of our children process to quit
when user mode linux kernel abort.

[ jdike - the kernel process needs to ignore SIGTERM, plus the waitpid/kill
loop is needed to make sure that all of our children are dead before the
kernel exits ]

Signed-off-by: Lepton Wu <ytht.net@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/skas/process.c |    2 +-
 arch/um/os-Linux/util.c         |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -182,7 +182,7 @@ static int userspace_tramp(void *stack)
 
 	ptrace(PTRACE_TRACEME, 0, 0, 0);
 
-	init_new_thread_signals();
+	signal(SIGTERM, SIG_DFL);
 	err = set_interval(1);
 	if(err)
 		panic("userspace_tramp - setting timer failed, errno = %d\n",
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -105,6 +105,44 @@ int setjmp_wrapper(void (*proc)(void *, 
 
 void os_dump_core(void)
 {
+	int pid;
+
 	signal(SIGSEGV, SIG_DFL);
+
+	/*
+	 * We are about to SIGTERM this entire process group to ensure that
+	 * nothing is around to run after the kernel exits.  The
+	 * kernel wants to abort, not die through SIGTERM, so we
+	 * ignore it here.
+	 */
+
+	signal(SIGTERM, SIG_IGN);
+	kill(0, SIGTERM);
+	/*
+	 * Most of the other processes associated with this UML are
+	 * likely sTopped, so give them a SIGCONT so they see the
+	 * SIGTERM.
+	 */
+	kill(0, SIGCONT);
+
+	/*
+	 * Now, having sent signals to everyone but us, make sure they
+	 * die by ptrace.  Processes can survive what's been done to
+	 * them so far - the mechanism I understand is receiving a
+	 * SIGSEGV and segfaulting immediately upon return.  There is
+	 * always a SIGSEGV pending, and (I'm guessing) signals are
+	 * processed in numeric order so the SIGTERM (signal 15 vs
+	 * SIGSEGV being signal 11) is never handled.
+	 *
+	 * Run a waitpid loop until we get some kind of error.
+	 * Hopefully, it's ECHILD, but there's not a lot we can do if
+	 * it's something else.  Tell os_kill_ptraced_process not to
+	 * wait for the child to report its death because there's
+	 * nothing reasonable to do if that fails.
+	 */
+
+	while ((pid = waitpid(-1, NULL, WNOHANG)) > 0)
+		os_kill_ptraced_process(pid, 0);
+
 	abort();
 }

-- 
