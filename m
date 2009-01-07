Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbZAGW7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbZAGW7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbZAGW6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:58:08 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64689 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbZAGW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:01 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KD4IG6-01-LSK-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/9] ring_buffer: fix ring_buffer_event_length()
Date: Wed, 7 Jan 2009 23:45:23 +0100
Message-ID: <1231368325-19246-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
References: <1231368325-19246-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:57:46.0554 (UTC) FILETIME=[5B3CD9A0:01C9711B]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function ring_buffer_event_length() provides an interface to detect
the length of data stored in an entry. However, the length contains
offsets depending on the internal usage. This makes it unusable. This
patch fixes this and now ring_buffer_event_length() returns the
alligned length that has been used in ring_buffer_lock_reserve().

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 kernel/trace/ring_buffer.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 30d57dd..d42b882 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -117,7 +117,13 @@ rb_event_length(struct ring_buffer_event *event)
  */
 unsigned ring_buffer_event_length(struct ring_buffer_event *event)
 {
-	return rb_event_length(event);
+	unsigned length = rb_event_length(event);
+	if (event->type != RINGBUF_TYPE_DATA)
+		return length;
+	length -= RB_EVNT_HDR_SIZE;
+	if (length > RB_MAX_SMALL_DATA + sizeof(event->array[0]))
+                length -= sizeof(event->array[0]);
+	return length;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_event_length);
 
-- 
1.6.0.1


