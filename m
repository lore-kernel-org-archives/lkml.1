Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYLDKOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYLDKOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYLDKOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:14:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYLDKOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:14:09 -0500
Date: Thu, 4 Dec 2008 11:13:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: akpm@linux-foundation.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ipc: fix warning of not used variable
Message-ID: <20081204101354.GC18708@elte.hu>
References: <20081204010026.GC17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081204010026.GC17445@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jianjun Kong <jianjun@zeuux.org> wrote:

> 
> fix this warning:
> ipc/ipc_sysctl.c:39: warning: ‘ipc_auto_callback’ defined but not used
> ipc_auto_callback() just called when CONFIG_PROC_FS was defined.
> 
> 
> Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
> ---
>  ipc/ipc_sysctl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

NAK.

the proper fix, considering all the possibilities, is below.

	Ingo

------------------->
>From 8f845313ba091a6041e666c611ef9bb751d91723 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 20 Oct 2008 09:19:55 +0200
Subject: [PATCH] fix warning in ipc/ipc_sysctl.c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix this warning:

  ipc/ipc_sysctl.c:39: warning: ‘ipc_auto_callback’ defined but not used

Move the already present #ifdef CONFIG_PROC_FS up by one function.

Also prepare get_ipc() for the !PROC_FS && !SYSCTL_SYSCALL case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 ipc/ipc_sysctl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 0dfebc5..010850a 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -18,6 +18,7 @@
 #include <linux/msg.h>
 #include "util.h"
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSCTL_SYSCALL)
 static void *get_ipc(ctl_table *table)
 {
 	char *which = table->data;
@@ -25,7 +26,9 @@ static void *get_ipc(ctl_table *table)
 	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
 	return which;
 }
+#endif
 
+#ifdef CONFIG_PROC_FS
 /*
  * Routine that is called when the file "auto_msgmni" has successfully been
  * written.
@@ -49,7 +52,6 @@ static void ipc_auto_callback(int val)
 	}
 }
 
-#ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
