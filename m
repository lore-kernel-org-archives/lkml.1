Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058Ab0AMQm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0AMQm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984Ab0AMQmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:42:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:34883 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0AMQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:42:24 -0500
Date: Wed, 13 Jan 2010 16:39:51 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, ian.campbell@citrix.com, gorcunov@gmail.com,
       lists@nerdbynature.de, Jeremy.Fitzhardinge@citrix.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, lists@nerdbynature.de, ian.campbell@citrix.com,
       Jeremy.Fitzhardinge@citrix.com, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <1263377768-19600-2-git-send-email-ian.campbell@citrix.com>
References: <1263377768-19600-2-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: xen: 64-bit kernel RPL should be 0
Message-ID: <tip-e68266b7001a4e29af083716f0c36c0d6dbb1b39@git.kernel.org>
Git-Commit-ID: e68266b7001a4e29af083716f0c36c0d6dbb1b39
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 16:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e68266b7001a4e29af083716f0c36c0d6dbb1b39
Gitweb:     http://git.kernel.org/tip/e68266b7001a4e29af083716f0c36c0d6dbb1b39
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Wed, 13 Jan 2010 10:16:08 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 11:23:54 +0100

x86: xen: 64-bit kernel RPL should be 0

Under Xen 64 bit guests actually run their kernel in ring 3,
however the hypervisor takes care of squashing descriptor the
RPLs transparently (in order to allow them to continue to
differentiate between user and kernel space CS using the RPL).
Therefore the Xen paravirt backend should use RPL==0 instead of
1 (or 3). Using RPL==1 causes generic arch code to take
incorrect code paths because it uses "testl $3, <CS>, je foo"
type tests for a userspace CS and this considers 1==userspace.

This issue was previously masked because get_kernel_rpl() was
omitted when setting CS in kernel_thread(). This was fixed when
kernel_thread() was unified with 32 bit in
f443ff4201dd25cd4dec183f9919ecba90c8edc2.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1263377768-19600-2-git-send-email-ian.campbell@citrix.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/xen/enlighten.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2b26dd5..36daccb 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1151,9 +1151,13 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* keep using Xen gdt for now; no urgent need to change it */
 
+#ifdef CONFIG_X86_32
 	pv_info.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		pv_info.kernel_rpl = 0;
+#else
+	pv_info.kernel_rpl = 0;
+#endif
 
 	/* set the limit of our address space */
 	xen_reserve_top();
