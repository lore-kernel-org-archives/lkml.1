Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYLUBFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYLUBFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 20:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYLUBFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 20:05:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:45644 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYLUBFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 20:05:31 -0500
Date: Sat, 20 Dec 2008 17:04:14 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       bastian@waldi.eu.org, gregkh@suse.de
Cc: daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [RFC][PATCH] SI_ASYNCIO: should be a kernel signal ?
Message-ID: <20081221010414.GA5284@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Fri, 19 Dec 2008 20:45:49 -0800
Subject: [RFC][PATCH] SI_ASYNCIO: should be a kernel signal ?

SI_ASYNCIO is currently defined as -4 in the kernel. This makes it appear
like a "user" signal (i.e SI_FROMUSER() is true). SI_ASYNCIO is generated
by the kernel for async events like SI_MESGQ and SI_POLL, but unlike
SI_ASYNCIO, SI_MESGQ and SI_POLL are "kernel" signals (i.e SI_FROMKERNEL()
is true).

Shouldn't SI_ASYNCIO be a "kernel" signal too ? It is currently generated
from USB core code.

This quick/untested RFC patch changes the in-kernel value of SI_ASYNCIO
as follows so that it becomes a "kernel" signal.

	(7 << 16)|(-4 & 0xffff) = 0x7fffc which is SI_FROMKERNEL().

The user-space value of SI_ASYNCIO continues to be -4.

Known side-effects:

	Is this required to be SI_FROMUSER() to enable the uid checks in
	kill_pid_info_as_uid() ? Also, changing to "kernel" signal would skip
	the permission checks in check_kill_permission().  Would that be a
	problem ?

Why bother now ? (Sigh. Condensed long story)

	Besides the consistency with SI_POLL and SI_MESGQ this could simplify
	implementation of special signal semantics for container-init.  When a
	signal is sent to container-init from user-space, we need to check the
	pid namespace of the sender in send_signal(). But since send_signal()
	can also be called from interrupt context,  we have no way of knowing
	if it is safe to check the pid namespace of the caller.

	If SI_ASYNCIO signal appears as a kernel signal, we could possibly use
	SI_FROMUSER() to check if it safe to reference the pid namespace of
	the sender.

	If this change has no other side-effects/breakage we will explore this
	path further for the signal semantics for container-init. (There could
	be other hurdles along the way...) 

	See also http://lkml.org/lkml/2008/12/20/183

Appreciate any comments on this.

TODO:
	If this makes sense, make corresponding change to the SI_ASYNCIO
	in arch/mips/siginfo.h.

	SI_DETHREAD and SI_SIGIO are currently unused in the kernel. Should
	we similarly make them "kernel" signals too ?

---
 include/asm-generic/siginfo.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 9695701..7b69598 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -124,6 +124,7 @@ typedef struct siginfo {
 #define __SI_CHLD	(4 << 16)
 #define __SI_RT		(5 << 16)
 #define __SI_MESGQ	(6 << 16)
+#define __SI_ASYNCIO	(7 << 16)
 #define __SI_CODE(T,N)	((T) | ((N) & 0xffff))
 #else
 #define __SI_KILL	0
@@ -133,6 +134,7 @@ typedef struct siginfo {
 #define __SI_CHLD	0
 #define __SI_RT		0
 #define __SI_MESGQ	0
+#define __SI_ASYNCIO	0
 #define __SI_CODE(T,N)	(N)
 #endif
 
@@ -145,7 +147,7 @@ typedef struct siginfo {
 #define SI_QUEUE	-1		/* sent by sigqueue */
 #define SI_TIMER __SI_CODE(__SI_TIMER,-2) /* sent by timer expiration */
 #define SI_MESGQ __SI_CODE(__SI_MESGQ,-3) /* sent by real time mesq state change */
-#define SI_ASYNCIO	-4		/* sent by AIO completion */
+#define SI_ASYNCIO __SI_CODE(__SI_ASYNCIO, -4)	/* sent by AIO completion */
 #define SI_SIGIO	-5		/* sent by queued SIGIO */
 #define SI_TKILL	-6		/* sent by tkill system call */
 #define SI_DETHREAD	-7		/* sent by execve() killing subsidiary threads */
-- 
1.5.2.5

