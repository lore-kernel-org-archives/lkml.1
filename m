Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZLMDfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZLMDfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 22:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbZLMDfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 22:35:14 -0500
Received: from lists.laptop.org ([18.85.2.145]:32859 "HELO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757846AbZLMDfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 22:35:13 -0500
Date: Sat, 12 Dec 2009 22:30:03 -0500
From: Michael Stone <michael@laptop.org>
To: linux-kernel@vger.kernel.org
Cc: Michael Stone <michael@laptop.org>
Subject: [PATCH] Security: Document RLIMIT_NETWORK.
Message-ID: <20091213033003.GA4369@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1260674379-4262-1-git-send-email-michael@laptop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Stone <michael@laptop.org>
---
  Documentation/rlimit_network.txt |   55 ++++++++++++++++++++++++++++++++++++++
  1 files changed, 55 insertions(+), 0 deletions(-)
  create mode 100644 Documentation/rlimit_network.txt

diff --git a/Documentation/rlimit_network.txt b/Documentation/rlimit_network.txt
new file mode 100644
index 0000000..3307866
--- /dev/null
+++ b/Documentation/rlimit_network.txt
@@ -0,0 +1,55 @@
+Purpose
+-------
+
+Daniel Bernstein has observed [1] that security-conscious userland processes
+may benefit from the ability to irrevocably remove their ability to create,
+bind, connect to, or send messages except in the case of previously connected
+sockets or AF_UNIX filesystem sockets.
+
+This facility is particularly attractive to security platforms like OLPC
+Bitfrost [2] and to isolation programs like Rainbow [3] and Plash [4] because:
+
+  * it integrates well with standard techniques for writing privilege-separated
+    Unix programs
+
+  * it integrates well with the need to perform limited socket I/O, e.g., when
+    running X clients
+
+  * it's available to unprivileged programs
+
+  * it's a discretionary feature available to all of distributors,
+    administrators, authors, and users
+
+  * its effect is entirely local, rather than global (like netfilter)
+
+  * it's simple enough to have some hope of being used correctly
+
+Implementation
+--------------
+
+After considering implementations based on the Linux Security Module (LSM)
+framework, on SELinux in particular, on network namespaces (CLONE_NEWNET), and
+on direct modification of the kernel syscall and task_struct APIs, we came to
+the conclusion that the best way to implement this feature was to extend the
+resource limits framework with a new RLIMIT_NETWORK field and to modify the
+implementations of the relevant socket calls to return -EPERM when
+
+  current->signal->rlim[RLIMIT_NETWORK].rlim_cur == 0
+
+unless we are manipulating an AF_UNIX socket whose name does not begin with \0
+or, in the case of sendmsg(), unless we are manipulating a previously connected
+socket, i.e. one with
+
+  msg.msg_name == NULL && msg.msg_namelen == 0
+
+Finally, in response to criticism from Alan Cox, we insert a similar access
+check into __ptrace_may_access() to prevent processes which have dropped their
+networking privileges from performing network I/O by ptracing other processes.
+
+References
+----------
+
+[1]: http://cr.yp.to/unix/disablenetwork.html
+[2]: http://wiki.laptop.org/go/OLPC_Bitfrost
+[3]: http://wiki.laptop.org/go/Rainbow
+[4]: http://plash.beasts.org/
-- 
1.5.6.5

