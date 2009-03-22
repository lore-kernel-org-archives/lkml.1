Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZCVWLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZCVWLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbZCVWKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:10:55 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51615 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZCVWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jJwMklZSF8bko+8qHXdhb/ykoWxsfSe2wYJs5Ont5aJPrEAGYVGa2Lim07YGMb4V3N
         3QemIiqKUOVkaNU6AYDKpbkBb+jyR4xSvkkjfzQfwm71pYk1Ml2gi+nSAl3sRp+KZdN1
         RZi0WItgSUH3hGz6ECWla2Qks8mDo5w4ivPXQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] tracing/ftrace: check if debugfs is registered before creating files
Date: Sun, 22 Mar 2009 23:10:45 +0100
Message-Id: <1237759847-21025-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.6.1

