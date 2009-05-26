Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbZEZUbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbZEZUbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZEZUbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:31:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39294 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZEZUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:31:45 -0400
To: paul@mad-scientist.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Andi Kleen <andi@firstfloor.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
Date: Tue, 26 May 2009 22:31:41 +0200
In-Reply-To: <1243355634.29250.331.camel@psmith-ubeta.netezza.com> (Paul Smith's message of "Tue, 26 May 2009 12:33:54 -0400")
Message-ID: <878wkjobbm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Smith <paul@mad-scientist.net> writes:
>
> So I annotated dump_write() to printk() if this operation is false, and
> I get:
>
>         file ffff8803b95d0180: dump_write: -512 < 4096
>
> Well, -512 is ERESTARTSYS.  That, to me, seems like a reasonable error
> code to get when we're trying to dump core to a pipe.  Yes?  No?

Which signal is it? SIGPIPE?

>
> Shouldn't we be doing some kind of error handling here, at least for
> basic things like signals?  Should a process that's dumping core be set
> to ignore signals?  Should dump_write() try again on ERESTARTSYS?

I think it should block signals. Here's a untested patch.

It has the disadvantage that it reports the incorrect blocked mask
in the ELF corefile, but that's probably better than truncated 
coredumps.

-Andi

---

Block signals during core dump

When a signal happens during core dump the core dump to a pipe 
can fail, because the write returns short, but the ELF core dumpers
cannot handle that.

There's no reason to handle signals during core dumping, so just
block them all.

Open issue: ELF puts blocked signals into the core dump and
that will be always fully blocked now.  Need to save it somewhere?

Based on debugging by Paul Smith.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/exec.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.30-rc5-ak/fs/exec.c
===================================================================
--- linux-2.6.30-rc5-ak.orig/fs/exec.c	2009-05-14 11:46:24.000000000 +0200
+++ linux-2.6.30-rc5-ak/fs/exec.c	2009-05-26 22:22:12.000000000 +0200
@@ -1760,6 +1760,12 @@
 		goto fail;
 	}
 
+	/* block all signals */
+	spin_lock_irq(&current->sighand->siglock);
+	sigfillset(&current->blocked);
+	/* No recalc sigpending */
+	spin_unlock_irq(&current->sighand->siglock);
+
 	down_write(&mm->mmap_sem);
 	/*
 	 * If another thread got here first, or we are not dumpable, bail out.



-- 
ak@linux.intel.com -- Speaking for myself only.
