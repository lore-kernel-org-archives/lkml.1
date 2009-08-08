Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZHHPtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZHHPtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZHHPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:49:11 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:56365 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbZHHPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pM5DPcTOExOQ1nqMn1P0wHR8j/6ZOmxGJvHF8dui3NQoEYIMvO4h8vNAJLPvN0mZmr
         FtDqVwV6R7apzhACtqoroL4uUNDx2SIo92Txg/7FSGeS24GToRc3BcMxNHhn4BJOBynI
         cF8G1FHKLdHi7HJ7BFDw69LxQzwAl51FVcjHs=
Subject: [2.6.31 PATCH] tracing/filters: don't use pred on alloc failure
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Carpenter <error27@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 10:49:09 -0500
Message-Id: <1249746549.6453.29.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter sent me a fix to prevent pred from being used if it
couldn't be allocated.  I noticed the same problem also existed for
the create_pred() case and added a fix for that.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

The original report:

create_logical_pred() could sometimes return NULL.

It's a static checker complaining rather than problems at runtime...

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 kernel/trace/trace_events_filter.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 936c621..1557148 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1029,6 +1029,8 @@ static int replace_preds(struct event_subsystem *system,
 
 		if (elt->op == OP_AND || elt->op == OP_OR) {
 			pred = create_logical_pred(elt->op);
+			if (!pred)
+				return -ENOMEM;
 			if (call) {
 				err = filter_add_pred(ps, call, pred);
 				filter_free_pred(pred);
@@ -1048,6 +1050,8 @@ static int replace_preds(struct event_subsystem *system,
 		}
 
 		pred = create_pred(elt->op, operand1, operand2);
+		if (!pred)
+			return -ENOMEM;
 		if (call) {
 			err = filter_add_pred(ps, call, pred);
 			filter_free_pred(pred);
-- 
1.5.6.3



