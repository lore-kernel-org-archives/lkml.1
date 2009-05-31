Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZEaFeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZEaFeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 01:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZEaFdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 01:33:55 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:23355 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZEaFdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 01:33:54 -0400
Subject: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Sun, 31 May 2009 01:33:39 -0400
Message-Id: <1243748019.7369.319.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coredump: Retry writes where appropriate

Core dump write operations (especially to a pipe) can be incomplete due
to signal reception or possibly recoverable partial writes.

Previously any incomplete write in the ELF core dumper caused the core
dump to stop, giving short cores in these cases.  Modify the core dumper
to retry the write where appropriate.

Signed-off-by: Paul Smith <paul@mad-scientist.net>
Cc: stable@kernel.org

---

 fs/binfmt_elf.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 40381df..26b03cc 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1119,7 +1119,24 @@ out:
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
+		} else
+			/* Lose! */
+			return 0;
+	}
 }
 
 static int dump_seek(struct file *file, loff_t off)

