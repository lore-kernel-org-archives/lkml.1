Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZE0GRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZE0GRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbZE0GRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:17:03 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:55246 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbZE0GRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:17:02 -0400
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090526172935.fad52c49.akpm@linux-foundation.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	 <878wkjobbm.fsf@basil.nowhere.org>
	 <20090526160017.98fc62e4.akpm@linux-foundation.org>
	 <20090526231428.GK846@one.firstfloor.org>
	 <20090526162821.02e11d5b.akpm@linux-foundation.org>
	 <20090526234109.GL846@one.firstfloor.org>
	 <20090526164532.6c780234.akpm@linux-foundation.org>
	 <20090527001104.GN846@one.firstfloor.org>
	 <20090526172935.fad52c49.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Wed, 27 May 2009 02:17:02 -0400
Message-Id: <1243405022.7369.171.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 17:29 -0700, Andrew Morton wrote:
> Many filesystems will return a short write if they hit a memory
> allocation failure, for example.  pipe_write() sure will.  Retrying
> is appropriate in such a case.

Here's a patch that "works for me" and tries to address the various
issues.  I've no idea what landmines I might have stepped on here.  I
also have no git-fu so this uses simple diff -u format.

Open issues: is it possible to get -EAGAIN or -EINTR at this level of
the kernel?  Or will it always be just -ERESTARTSYS?  Is there evil in
simply running clear_thread_flag(TIF_SIGPENDING) without "handling" the
signal in any way?

---

Retry core dump writes where appropriate

Core dump write operations can be incomplete due to signal reception or
possibly recoverable partial writes.

Previously any incomplete write in the ELF core dumper caused the core
dump to stop, giving short cores in these cases.  Modify the core dumper
to retry the write where appropriate.

Signed-off-by: Paul Smith <paul@mad-scientist.net>

---
--- a/fs/binfmt_elf.c	2009-05-27 01:12:35.000000000 -0400
+++ b/fs/binfmt_elf.c	2009-05-27 01:20:21.000000000 -0400
@@ -1128,7 +1128,25 @@
  */
 static int dump_write(struct file *file, const void *addr, int nr)
 {
-	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
+	const char *p = addr;
+	while (1) {
+		int r = file->f_op->write(file, p, nr, &file->f_pos);
+
+		if (likely(r == nr))
+			return 1;
+
+		if (r == -ERESTARTSYS || r == -EAGAIN || r == -EINTR)
+			/* Ignore signals during coredump. */
+			clear_thread_flag(TIF_SIGPENDING);
+		else if (r > 0) {
+			/* Partial write: try again with the rest. */
+			p += r;
+			nr -= r;
+		}
+		else
+			/* Lose! */
+			return 0;
+	}
 }
 
 static int dump_seek(struct file *file, loff_t off)

