Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZCWP6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZCWP6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZCWP6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:58:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:48382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbZCWP6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:58:30 -0400
Date: Mon, 23 Mar 2009 15:57:36 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1237759847-21025-3-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-3-git-send-email-fweisbec@gmail.com>
Subject: [tip:tracing/ftrace] tracing/ftrace: check if debugfs is registered before creating files
Message-ID: <tip-3e1f60b80cafcb5d7e8d3665b35962fbb8fb9efa@git.kernel.org>
Git-Commit-ID: 3e1f60b80cafcb5d7e8d3665b35962fbb8fb9efa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:57:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e1f60b80cafcb5d7e8d3665b35962fbb8fb9efa
Gitweb:     http://git.kernel.org/tip/3e1f60b80cafcb5d7e8d3665b35962fbb8fb9efa
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sun, 22 Mar 2009 23:10:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:25:47 +0100

tracing/ftrace: check if debugfs is registered before creating files

Impact: fix a crash with ftrace={nop,boot} parameter

If the nop or initcall tracers are launched as boot tracers,
they will attempt to create their option directory and files.
But these tracers are registered very early and then assigned
as "boot tracers" very early if asked to.

Since they do this before debugfs has been registered (core initcall),
a crash is triggered.

Another early tracers could also come later. So we fix it by
checking if debugfs is initialized before creating the root
tracing directory.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1237759847-21025-3-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ace685c..f0e1337 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3513,6 +3513,9 @@ struct dentry *tracing_init_dentry(void)
 	if (d_tracer)
 		return d_tracer;
 
+	if (!debugfs_initialized())
+		return NULL;
+
 	d_tracer = debugfs_create_dir("tracing", NULL);
 
 	if (!d_tracer && !once) {
