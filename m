Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbZDLKhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbZDLKhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbZDLKhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:37:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:35863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbZDLKhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:37:32 -0400
Date: Sun, 12 Apr 2009 10:36:36 GMT
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, tglx@linutronix.de, marcin.slusarz@gmail.com,
       mingo@elte.hu
In-Reply-To: <49DFB055.6070405@gmail.com>
References: <49DFB055.6070405@gmail.com>
Subject: [tip:x86/urgent] x86: fix wrong section of pat_disable & make it static
Message-ID: <tip-1ee4bd92a7aa49eb66c8d5672e837090d3e7b7ff@git.kernel.org>
Git-Commit-ID: 1ee4bd92a7aa49eb66c8d5672e837090d3e7b7ff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 10:36:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ee4bd92a7aa49eb66c8d5672e837090d3e7b7ff
Gitweb:     http://git.kernel.org/tip/1ee4bd92a7aa49eb66c8d5672e837090d3e7b7ff
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Fri, 10 Apr 2009 22:47:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 12:34:23 +0200

x86: fix wrong section of pat_disable & make it static

pat_disable cannot be __cpuinit anymore because it's called from pat_init
and the callchain looks like this:
pat_disable [cpuinit] <- pat_init <- generic_set_all <-
 ipi_handler <- set_mtrr <- (other non init/cpuinit functions)

WARNING: arch/x86/mm/built-in.o(.text+0x449e): Section mismatch in reference
from the function pat_init() to the function .cpuinit.text:pat_disable()
The function pat_init() references
the function __cpuinit pat_disable().
This is often because pat_init lacks a __cpuinit
annotation or the annotation of pat_disable is wrong.

Non CONFIG_X86_PAT version of pat_disable is static inline, so this version
can be static too (and there are no callers outside of this file).

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <49DFB055.6070405@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 640339e..c009a24 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -31,7 +31,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
-void __cpuinit pat_disable(const char *reason)
+static inline void pat_disable(const char *reason)
 {
 	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
