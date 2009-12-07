Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbZLGDes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbZLGDes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933134AbZLGDer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:34:47 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:64414 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113AbZLGDeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:34:46 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] Does raw_field_ptr() supports __data_loc?
Date: Mon,  7 Dec 2009 12:34:43 +0900
Message-Id: <1260156884-8474-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091115022135.GA5427@nowhere>
References: <20091115022135.GA5427@nowhere>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VERY very sorry for my long silence...

Please don't commit this patch, Ingo.
This patch is required to test the next patch for perf lock.

I have a question for Steven Rostedt and Tom Zanussi.
Does current raw_field_ptr() support __data_loc?

At 064739bc4b3d7f424b2f25547e6611bcf0132415 ,
support for the modifier "__data_loc" of format is added.

But, when I wanted to parse format of lock_acquired (or some event else),
raw_field_ptr() did not returned correct pointer.

So I modified raw_field_ptr() like this patch. Then raw_field_ptr() works well.
Parser was large so I'd like to ask you about this.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <srostedt@redhat.com>

I have a question
---
 tools/perf/util/trace-event-parse.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0302405..494a470 100644
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

