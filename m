Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYJ1SMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYJ1SMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYJ1SLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:11:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:56493 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYJ1SLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=uKeq25Fm6F3Aow6VS54zBWrE4qJtzvfHmXOjmA0MIM9gPUP/qsf42hHbUqMbKovDQa
         6Z40zKHGXAN9UexFTgr5Ht7IReJBXtYlLD3s8d7HiHy/1waUvbR5TqvKYAFlOs4X8DG5
         8LW779lB2bBcSskQdscF6pXV7qerSBJvuqLw4=
Message-ID: <49076552.2090500@gmail.com>
Date: Tue, 28 Oct 2008 20:17:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: perform an initialization for ftrace to enable it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Corrects a bug which made the function tracer not functionnal

With latest git, the function tracer didn't get any trace.
The problem was the fact that ftrace_enabled wasn't
initialized to 1 because ftrace hasn't any init function when DYNAMIC_FTRACE
is disabled.
So when a tracer tries to register an ftrace_ops struct, 
__register_ftrace_function failed to set the hook.

This patch corrects it by setting an init function to initialize
ftrace during the boot.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7618c52..4a39d24 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1339,6 +1339,14 @@ void __init ftrace_init(void)
 }
 
 #else
+
+static int __init ftrace_nodyn_init(void)
+{
+	ftrace_enabled = 1;
+	return 0;
+}
+device_initcall(ftrace_nodyn_init);
+
 # define ftrace_startup()		do { } while (0)
 # define ftrace_shutdown()		do { } while (0)
 # define ftrace_startup_sysctl()	do { } while (0)
