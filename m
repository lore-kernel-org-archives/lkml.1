Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbZJLWhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbZJLWhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbZJLWhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083AbZJLWhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:37:21 -0400
Date: Tue, 13 Oct 2009 00:35:06 +0200 (CEST)
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
Subject: [PATCH 6/6 RFC] arch/mn10300/kernel/process.c: Remove the BKL from
 sys_execve
In-Reply-To: <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910130016540.3658@localhost.localdomain>
References: <alpine.LFD.2.00.0910122350140.3658@localhost.localdomain> <alpine.LFD.2.00.0910130007240.3658@localhost.localdomain> <alpine.LFD.2.00.0910130008320.3658@localhost.localdomain> <alpine.LFD.2.00.0910130010000.3658@localhost.localdomain>
 <alpine.LFD.2.00.0910130011180.3658@localhost.localdomain> <alpine.LFD.2.00.0910130014520.3658@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f05f8e3a2f5210e5274e758f66e33a9d168eacde Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 12 Oct 2009 23:41:55 +0200
Subject: [PATCH] arch/mn10300/kernel/process.c: Remove the BKL from sys_execve

This looks like a cut-and-paste from functionality that no-longer needs the bkl
Just remove it. Also, rewrite slightly so that it looks closer to sys_execve
on other architectures.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/mn10300/kernel/process.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 892cce8..ec8a21d 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -275,16 +275,12 @@ asmlinkage long sys_execve(char __user *name,
 	char *filename;
 	int error;
 
-	lock_kernel();
-
 	filename = getname(name);
 	error = PTR_ERR(filename);
-	if (!IS_ERR(filename)) {
-		error = do_execve(filename, argv, envp, __frame);
-		putname(filename);
-	}
-
-	unlock_kernel();
+	if (IS_ERR(filename))
+		return error;
+	error = do_execve(filename, argv, envp, __frame);
+	putname(filename);
 	return error;
 }
 
-- 
1.6.0.6


