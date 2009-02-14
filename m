Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZBNDwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZBNDwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 22:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZBNDwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 22:52:40 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:11684 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZBNDwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 22:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QWlJ0fCsgZNip1SOfcSqCwkedfBNXbJmsoU/M76R85REpK6YzMOpKjwsFdxDF3v/uA
         iIJDZhZdHO1774RXwTpSE13ESZS4qDcL64rgf6niPE7ITsA+ny5xdR0LYlsm7JXmYJRP
         WzO7QyLNXUBVBtDr9L6WAfyCS3J/GO9M+5Mbk=
MIME-Version: 1.0
Date: Sat, 14 Feb 2009 09:36:00 +0600
Message-ID: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
Subject: [PATCH -mm] tracing: Fix section mismatch in trace_hw_branches.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       markus.t.metzger@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Impact: Fix section mismatch

The function bts_trace_init() references a variable
bts_hotcpu_notifier which is marked
as __cpuinitdata. Thus causes section mismatch. This patch fixes it.

  LD      kernel/trace/built-in.o
WARNING: kernel/trace/built-in.o(.text+0xc90c): Section mismatch in
reference from the function bts_trace_init() to the variable
.cpuinit.data:bts_hotcpu_notifier
The function bts_trace_init() references
the variable __cpuinitdata bts_hotcpu_notifier.
This is often because bts_trace_init lacks a __cpuinitdata
annotation or the annotation of bts_hotcpu_notifier is wrong.

WARNING: kernel/trace/built-in.o(.text+0xc92a): Section mismatch in
reference from the function bts_trace_reset() to the variable
.cpuinit.data:bts_hotcpu_notifier
The function bts_trace_reset() references
the variable __cpuinitdata bts_hotcpu_notifier.
This is often because bts_trace_reset lacks a __cpuinitdata
annotation or the annotation of bts_hotcpu_notifier is wrong.

Thanks.

---
Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/kernel/trace/trace_hw_branches.c	2009-02-13 11:23:55.000000000 +0600
+++ rakib/kernel/trace/trace_hw_branches.c	2009-02-13 22:12:30.000000000 +0600
@@ -127,7 +127,7 @@ static struct notifier_block bts_hotcpu_
 	.notifier_call = bts_hotcpu_handler
 };

-static int bts_trace_init(struct trace_array *tr)
+static int __cpuinit bts_trace_init(struct trace_array *tr)
 {
 	hw_branch_trace = tr;

@@ -137,7 +137,7 @@ static int bts_trace_init(struct trace_a
 	return 0;
 }

-static void bts_trace_reset(struct trace_array *tr)
+static void __cpuinit bts_trace_reset(struct trace_array *tr)
 {
 	bts_trace_stop(tr);
 	unregister_hotcpu_notifier(&bts_hotcpu_notifier);
