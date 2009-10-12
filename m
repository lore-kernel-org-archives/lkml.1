Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbZJLWfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbZJLWfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933523AbZJLWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933477AbZJLWfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:35:19 -0400
Date: Tue, 13 Oct 2009 00:33:21 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH 1/6 RFC] arch/blackfin/kernel/process.c: Remove the BKL from
 sys_execve
In-Reply-To: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b9b41b5a546ed0202c099f0d973da4df9aea314a Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 12 Oct 2009 22:44:40 +0200
Subject: [PATCH] arch/blackfin/kernel/process.c: Remove the BKL from sys_execve

This looks like a cut-and-paste job.
For example, compare this function to sys_execve in
arch/x86/kernel/process_64.c

and it is almost line by line the same, except the one in x86 nolonger has the
big kernel lock. All of the functions called between the lock are generic
and not specific to blackfin - thus, I believe it is safe to remove the
bkl here.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/blackfin/kernel/process.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 430ae39..7d9c975 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -215,22 +215,18 @@ copy_thread(unsigned long clone_flags,
 /*
  * sys_execve() executes a new program.
  */
-
 asmlinkage int sys_execve(char __user *name, char __user * __user *argv, char __user * __user *envp)
 {
 	int error;
 	char *filename;
 	struct pt_regs *regs = (struct pt_regs *)((&name) + 6);
 
-	lock_kernel();
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
-		goto out;
+		return error;
 	error = do_execve(filename, argv, envp, regs);
 	putname(filename);
- out:
-	unlock_kernel();
 	return error;
 }
 
-- 
1.6.0.6


