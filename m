Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbZCWWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbZCWWZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbZCWWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:25:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895AbZCWWZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:25:13 -0400
Date: Mon, 23 Mar 2009 22:24:28 GMT
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       avorontsov@ru.mvista.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       avorontsov@ru.mvista.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090323220724.GA9851@oksana.dev.rtsoft.ru>
References: <20090323220724.GA9851@oksana.dev.rtsoft.ru>
Subject: [tip:tracing/ftrace] tracing: Fix TRACING_SUPPORT dependency for PPC32
Message-ID: <tip-45b9560895b07a4a09d55d49235c984db512c5aa@git.kernel.org>
Git-Commit-ID: 45b9560895b07a4a09d55d49235c984db512c5aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 22:24:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45b9560895b07a4a09d55d49235c984db512c5aa
Gitweb:     http://git.kernel.org/tip/45b9560895b07a4a09d55d49235c984db512c5aa
Author:     Anton Vorontsov <avorontsov@ru.mvista.com>
AuthorDate: Tue, 24 Mar 2009 01:07:24 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 23:23:03 +0100

tracing: Fix TRACING_SUPPORT dependency for PPC32

commit 40ada30f9621fbd831ac2437b9a2a399aa ("tracing: clean up menu"),
despite the "clean up" in its purpose, introduced a behavioural
change for Kconfig symbols: we no longer able to select tracing
support on PPC32 (because IRQFLAGS_SUPPORT isn't yet implemented).

The IRQFLAGS_SUPPORT is not mandatory for most tracers, tracing core
has a special case for platforms w/o irqflags (which, by the way, has
become useless as of the commit above).

Though according to Ingo Molnar, there was periodic build failures on
weird, unmaintained architectures that had no irqflags-tracing support
and hence didn't know the raw_irqs_save/restore primitives. Thus we'd
better not enable irqflags-less tracing for all architectures.

This patch restores the old behaviour for PPC32, and thus brings the
tracing back. Other architectures can either add themselves to the
exception list or (better) implement TRACE_IRQFLAGS_SUPPORT.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Acked-b: Steven Rostedt <rostedt@goodmis.org>
Cc: linuxppc-dev@ozlabs.org
LKML-Reference: <20090323220724.GA9851@oksana.dev.rtsoft.ru>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index b0a46f8..8a4d729 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -63,7 +63,11 @@ config TRACING
 #
 config TRACING_SUPPORT
 	bool
-	depends on TRACE_IRQFLAGS_SUPPORT
+	# PPC32 has no irqflags tracing support, but it can use most of the
+	# tracers anyway, they were tested to build and work. Note that new
+	# exceptions to this list aren't welcomed, better implement the
+	# irqflags tracing for your architecture.
+	depends on TRACE_IRQFLAGS_SUPPORT || PPC32
 	depends on STACKTRACE_SUPPORT
 	default y
 
