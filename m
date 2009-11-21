Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZKUNh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZKUNh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZKUNhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:37:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:36301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbZKUNhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:37:22 -0500
Date: Sat, 21 Nov 2009 13:36:38 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lethal@linux-sh.org, fweisbec@gmail.com,
       tglx@linutronix.de, prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lethal@linux-sh.org, fweisbec@gmail.com,
       tglx@linutronix.de, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091005102306.GA7889@linux-sh.org>
References: <20091005102306.GA7889@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/hw-breakpoints: Actually flush thread breakpoints in flush_thread().
Message-ID: <tip-41a48d14f6991020c9bb6b93e289ca5b411ed09a@git.kernel.org>
Git-Commit-ID: 41a48d14f6991020c9bb6b93e289ca5b411ed09a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41a48d14f6991020c9bb6b93e289ca5b411ed09a
Gitweb:     http://git.kernel.org/tip/41a48d14f6991020c9bb6b93e289ca5b411ed09a
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Mon, 5 Oct 2009 19:23:06 +0900
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 3 Nov 2009 18:05:44 +0100

x86/hw-breakpoints: Actually flush thread breakpoints in flush_thread().

flush_thread() tries to do a TIF_DEBUG check before calling in to
flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
but for some reason, the x86 code is manually clearing TIF_DEBUG
immediately before the test, so this path will never be taken.

This kills off the erroneous clear_tsk_thread_flag() and lets
flush_thread_hw_breakpoint() actually get invoked.

Presumably folks were getting lucky with testing and the
free_thread_info() -> free_thread_xstate() path was taking care of the
flush there.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>
LKML-Reference: <20091005102306.GA7889@linux-sh.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/process.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2275ce5..cf8ee00 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -107,8 +107,6 @@ void flush_thread(void)
 	}
 #endif
 
-	clear_tsk_thread_flag(tsk, TIF_DEBUG);
-
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_DEBUG)))
 		flush_thread_hw_breakpoint(tsk);
 	memset(tsk->thread.tls_array, 0, sizeof(tsk->thread.tls_array));
