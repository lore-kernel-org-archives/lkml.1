Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbZCIJNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbZCIJNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZCIJNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:13:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:40796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbZCIJNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:13:06 -0400
Date: Mon, 9 Mar 2009 09:12:26 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
References: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/printk] tracing: trace_printk() fix, move format array to data section
Message-ID: <tip-8a20d84d09ab5d121f989cd99e4fc5f4b49f98ba@git.kernel.org>
Git-Commit-ID: 8a20d84d09ab5d121f989cd99e4fc5f4b49f98ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Mar 2009 09:12:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a20d84d09ab5d121f989cd99e4fc5f4b49f98ba
Gitweb:     http://git.kernel.org/tip/8a20d84d09ab5d121f989cd99e4fc5f4b49f98ba
Author:     "Ingo Molnar" <mingo@elte.hu>
AuthorDate: Mon, 9 Mar 2009 10:09:06 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 9 Mar 2009 10:11:08 +0100

tracing: trace_printk() fix, move format array to data section

Impact: fix kernel crash when using trace_printk()

trace_printk_fmt section is defined into the readonly section.
But we do:

	trace_printk_fmt = fmt;

to fill in that table of format strings - which is not read-only.
Under CONFIG_DEBUG_RODATA=y this crashes ...

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1236356510-8381-5-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/asm-generic/vmlinux.lds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48ade31..d656b46 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -98,6 +98,7 @@
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
+	TRACE_PRINTKS()							\
 	FTRACE_EVENTS()
 
 #define RO_DATA(align)							\
@@ -108,7 +109,6 @@
 		*(__vermagic)		/* Kernel version magic */	\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
-		TRACE_PRINTKS()					\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
