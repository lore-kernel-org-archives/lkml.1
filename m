Return-Path: <linux-kernel-owner+w=401wt.eu-S1754438AbZCED2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbZCED2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZCED1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:27:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbZCED1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:27:15 -0500
Message-Id: <20090305032712.546335280@goodmis.org>
References: <20090305032532.802709985@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Mar 2009 22:25:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7] ring-buffer: fix timestamp in partial ring_buffer_page_read
Content-Disposition: inline; filename=0001-ring-buffer-fix-timestamp-in-partial-ring_buffer_pa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If a partial ring_buffer_page_read happens, then some of the
incremental timestamps may be lost. This patch writes the
recent timestamp into the page that is passed back to the caller.

A partial ring_buffer_page_read is where the full page would not
be written back to the user, and instead, just part of the page
is copied to the user. A full page would be a page swap with the
ring buffer and the timestamps would be correct.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f2a163d..f747364 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2461,6 +2461,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 	unsigned long flags;
 	unsigned int commit;
 	unsigned int read;
+	u64 save_timestamp;
 	int ret = -1;
 
 	/*
@@ -2515,6 +2516,9 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 		if (len < size)
 			goto out;
 
+		/* save the current timestamp, since the user will need it */
+		save_timestamp = cpu_buffer->read_stamp;
+
 		/* Need to copy one event at a time */
 		do {
 			memcpy(bpage->data + pos, rpage->data + rpos, size);
@@ -2531,7 +2535,7 @@ int ring_buffer_read_page(struct ring_buffer *buffer,
 
 		/* update bpage */
 		local_set(&bpage->commit, pos);
-		bpage->time_stamp = rpage->time_stamp;
+		bpage->time_stamp = save_timestamp;
 
 		/* we copied everything to the beginning */
 		read = 0;
-- 
1.6.1.3

-- 
