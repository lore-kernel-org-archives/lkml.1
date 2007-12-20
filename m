Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbXLTNfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbXLTNfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbXLTNeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760105AbXLTNeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:11 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 02/16] adapt lguest launcher to per-cpuness
Date: Thu, 20 Dec 2007 11:33:42 -0200
Message-Id: <11981576492807-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576442148-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes uses of pread() and pwrite() in lguest launcher
to communicate the vcpu id to the lguest driver. The id is kept in
a thread variable, which means we'll span in the future, vcpus as
threads. But right now, only the infrastructure is out there.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 Documentation/lguest/lguest.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 9b0e322..c406ba9 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -79,6 +79,9 @@ static void *guest_base;
 /* The maximum guest physical address allowed, and maximum possible. */
 static unsigned long guest_limit, guest_max;
 
+/* a per-cpu variable indicating whose vcpu is currently running */
+static unsigned int __thread vcpu_id;
+
 /* This is our list of devices. */
 struct device_list
 {
@@ -554,7 +557,7 @@ static void wake_parent(int pipefd, int lguest_fd)
 			else
 				FD_CLR(-fd - 1, &devices.infds);
 		} else /* Send LHREQ_BREAK command. */
-			write(lguest_fd, args, sizeof(args));
+			pwrite(lguest_fd, args, sizeof(args), 0);
 	}
 }
 
@@ -1511,7 +1514,8 @@ static void __attribute__((noreturn)) run_guest(int lguest_fd)
 		int readval;
 
 		/* We read from the /dev/lguest device to run the Guest. */
-		readval = read(lguest_fd, &notify_addr, sizeof(notify_addr));
+		readval = pread(lguest_fd, &notify_addr,
+				sizeof(notify_addr), vcpu_id);
 
 		/* One unsigned long means the Guest did HCALL_NOTIFY */
 		if (readval == sizeof(notify_addr)) {
@@ -1521,17 +1525,22 @@ static void __attribute__((noreturn)) run_guest(int lguest_fd)
 		/* ENOENT means the Guest died.  Reading tells us why. */
 		} else if (errno == ENOENT) {
 			char reason[1024] = { 0 };
-			read(lguest_fd, reason, sizeof(reason)-1);
+			pread(lguest_fd, reason, sizeof(reason)-1, vcpu_id);
 			errx(1, "%s", reason);
 		/* EAGAIN means the Waker wanted us to look at some input.
 		 * Anything else means a bug or incompatible change. */
 		} else if (errno != EAGAIN)
 			err(1, "Running guest failed");
 
-		/* Service input, then unset the BREAK to release the Waker. */
-		handle_input(lguest_fd);
-		if (write(lguest_fd, args, sizeof(args)) < 0)
-			err(1, "Resetting break");
+		if (!vcpu_id) {
+			/*
+			 * Service input, then unset the BREAK to
+			 * release the Waker.
+			 */
+			handle_input(lguest_fd);
+			if (pwrite(lguest_fd, args, sizeof(args), 0) < 0)
+				err(1, "Resetting break");
+		}
 	}
 }
 /*
@@ -1582,6 +1591,7 @@ int main(int argc, char *argv[])
 	devices.lastdev = &devices.dev;
 	devices.next_irq = 1;
 
+	vcpu_id = 0;
 	/* We need to know how much memory so we can set up the device
 	 * descriptor and memory pages for the devices as we parse the command
 	 * line.  So we quickly look through the arguments to find the amount
-- 
1.5.0.6

