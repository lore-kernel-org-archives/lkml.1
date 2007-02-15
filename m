Return-Path: <linux-kernel-owner+w=401wt.eu-S966147AbXBOQz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966147AbXBOQz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966151AbXBOQz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:55:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966147AbXBOQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:55:55 -0500
Date: Thu, 15 Feb 2007 17:52:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 06/14] syslets: core, documentation
Message-ID: <20070215165232.GG4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_20 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1578]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Add Documentation/syslet-design.txt with a high-level description
of the syslet concepts.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 Documentation/syslet-design.txt |  137 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

Index: linux/Documentation/syslet-design.txt
===================================================================
--- /dev/null
+++ linux/Documentation/syslet-design.txt
@@ -0,0 +1,137 @@
+Syslets / asynchronous system calls
+===================================
+
+started by Ingo Molnar <mingo@redhat.com>
+
+Goal:
+-----
+
+The goal of the syslet subsystem is to allow user-space to execute
+arbitrary system calls asynchronously. It does so by allowing user-space
+to execute "syslets" which are small scriptlets that the kernel can execute
+both securely and asynchronously without having to exit to user-space.
+
+the core syslet concepts are:
+
+The Syslet Atom:
+----------------
+
+The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
+user-space memory, which is the basic unit of execution within the syslet
+framework. A syslet represents a single system-call and its arguments.
+In addition it also has condition flags attached to it that allows the
+construction of larger programs (syslets) from these atoms.
+
+Arguments to the system call are implemented via pointers to arguments.
+This not only increases the flexibility of syslet atoms (multiple syslets
+can share the same variable for example), but is also an optimization:
+copy_uatom() will only fetch syscall parameters up until the point it
+meets the first NULL pointer. 50% of all syscalls have 2 or less
+parameters (and 90% of all syscalls have 4 or less parameters).
+
+ [ Note: since the argument array is at the end of the atom, and the
+   kernel will not touch any argument beyond the final NULL one, atoms
+   might be packed more tightly. (the only special case exception to
+   this rule would be SKIP_TO_NEXT_ON_STOP atoms, where the kernel will
+   jump a full syslet_uatom number of bytes.) ]
+
+The Syslet:
+-----------
+
+A syslet is a program, represented by a graph of syslet atoms. The
+syslet atoms are chained to each other either via the atom->next pointer,
+or via the SYSLET_SKIP_TO_NEXT_ON_STOP flag.
+
+Running Syslets:
+----------------
+
+Syslets can be run via the sys_async_exec() system call, which takes
+the first atom of the syslet as an argument. The kernel does not need
+to be told about the other atoms - it will fetch them on the fly as
+execution goes forward.
+
+A syslet might either be executed 'cached', or it might generate a
+'cachemiss'.
+
+'Cached' syslet execution means that the whole syslet was executed
+without blocking. The system-call returns the submitted atom's address
+in this case.
+
+If a syslet blocks while the kernel executes a system-call embedded in
+one of its atoms, the kernel will keep working on that syscall in
+parallel, but it immediately returns to user-space with a NULL pointer,
+so the submitting task can submit other syslets.
+
+Completion of asynchronous syslets:
+-----------------------------------
+
+Completion of asynchronous syslets is done via the 'completion ring',
+which is a ringbuffer of syslet atom pointers user user-space memory,
+provided by user-space in the sys_async_register() syscall. The
+kernel fills in the ringbuffer starting at index 0, and user-space
+must clear out these pointers. Once the kernel reaches the end of
+the ring it wraps back to index 0. The kernel will not overwrite
+non-NULL pointers (but will return an error), user-space has to
+make sure it completes all events it asked for.
+
+Waiting for completions:
+------------------------
+
+Syslet completions can be waited for via the sys_async_wait()
+system call - which takes the number of events it should wait for as
+a parameter. This system call will also return if the number of
+pending events goes down to zero.
+
+Sample Hello World syslet code:
+
+--------------------------->
+/*
+ * Set up a syslet atom:
+ */
+static void
+init_atom(struct syslet_uatom *atom, int nr,
+	  void *arg_ptr0, void *arg_ptr1, void *arg_ptr2,
+	  void *arg_ptr3, void *arg_ptr4, void *arg_ptr5,
+	  void *ret_ptr, unsigned long flags, struct syslet_uatom *next)
+{
+	atom->nr = nr;
+	atom->arg_ptr[0] = arg_ptr0;
+	atom->arg_ptr[1] = arg_ptr1;
+	atom->arg_ptr[2] = arg_ptr2;
+	atom->arg_ptr[3] = arg_ptr3;
+	atom->arg_ptr[4] = arg_ptr4;
+	atom->arg_ptr[5] = arg_ptr5;
+	atom->ret_ptr = ret_ptr;
+	atom->flags = flags;
+	atom->next = next;
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long int fd_out = 1; /* standard output */
+	char *buf = "Hello Syslet World!\n";
+	unsigned long size = strlen(buf);
+	struct syslet_uatom atom, *done;
+
+	async_head_init();
+
+	/*
+	 * Simple syslet consisting of a single atom:
+	 */
+	init_atom(&atom, __NR_sys_write, &fd_out, &buf, &size,
+		  NULL, NULL, NULL, NULL, SYSLET_ASYNC, NULL);
+	done = sys_async_exec(&atom);
+	if (!done) {
+		sys_async_wait(1);
+		if (completion_ring[curr_ring_idx] == &atom) {
+			completion_ring[curr_ring_idx] = NULL;
+			printf("completed an async syslet atom!\n");
+		}
+	} else {
+		printf("completed an cached syslet atom!\n");
+	}
+
+	async_head_exit();
+
+	return 0;
+}
