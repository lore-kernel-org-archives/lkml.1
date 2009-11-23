Return-Path: <linux-kernel-owner+w=401wt.eu-S1755211AbZKWOmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbZKWOmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZKWOmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:42:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60467 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbZKWOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:42:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JAmXhmENhkdECuWzkzKMdkBYeCdG2ALVOSMN51FyQHDXHSrh47tdqCSHZw4an9Hcbc
         Cia3VJRT5avnI1iypvtsaSdMYLBZN003SSyTsRjn/IktGQ9aZsyfTOuU6idfsGUS5flJ
         cN4btfkqLSRueYNkW3n6VmK6kA0GkoWeTFsG4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 2/4] hw-breakpoints: Check the breakpoint params from perf tools
Date: Mon, 23 Nov 2009 15:42:33 +0100
Message-Id: <1258987355-8751-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf tools create perf events as disabled in the beginning. Breakpoints
are then considered like ptrace temporary breakpoints, only meant to
reserve a breakpoint slot until we get all the necessary informations
from the user.

In this case, we don't check the address that is breakpointed as it is
NULL in the ptrace case.

But perf tools don't have the same purpose, events are created disabled
to wait for all events to be created before enabling all of them.
We want to check the breakpoint parameters in this case.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index b6d6fa2..1d8911a 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -263,7 +263,16 @@ int __register_perf_hw_breakpoint(struct perf_event *bp)
 	if (ret)
 		return ret;
 
-	if (!bp->attr.disabled)
+	/*
+	 * Ptrace breakpoints can be temporary perf events only
+	 * meant to reserve a slot. In this case, it is created disabled and
+	 * we don't want to check the params right now (as we put a null addr)
+	 * But perf tools create events as disabled and we want to check
+	 * the params for them.
+	 * This is a quick hack that will be removed soon, once we remove
+	 * the tmp breakpoints from ptrace
+	 */
+	if (!bp->attr.disabled || bp->callback == perf_bp_event)
 		ret = arch_validate_hwbkpt_settings(bp, bp->ctx->task);
 
 	return ret;
-- 
1.6.2.3

