Return-Path: <linux-kernel-owner+w=401wt.eu-S1751371Ab0AVNjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab0AVNjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 08:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761Ab0AVNjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 08:39:21 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62751 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab0AVNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 08:39:20 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 01/12] perf tools: Add __data_loc support
Date: Fri, 22 Jan 2010 22:39:02 +0900
Message-Id: <1264167553-6510-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is required to test the next patch for perf lock.

At 064739bc4b3d7f424b2f25547e6611bcf0132415 ,
support for the modifier "__data_loc" of format is added.

But, when I wanted to parse format of lock_acquired (or some
event else), raw_field_ptr() did not returned correct pointer.

So I modified raw_field_ptr() like this patch. Then
raw_field_ptr() works well.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>
---
 tools/perf/util/trace-event-parse.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c5c32be..13aea80 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1925,6 +1925,13 @@ void *raw_field_ptr(struct event *event, const char *name, void *data)
 	if (!field)
 		return NULL;
 
+	if (field->flags & FIELD_IS_STRING) {
+		int offset;
+		offset = *(int *)(data + field->offset);
+		offset &= 0xffff;
+		return data + offset;
+	}
+
 	return data + field->offset;
 }
 
-- 
1.6.5.2

