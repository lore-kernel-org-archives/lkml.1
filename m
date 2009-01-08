Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbZAHE66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbZAHE66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbZAHE6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:58:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbZAHE6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:58:41 -0500
Date: Wed, 7 Jan 2009 23:58:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] ring_buffer: fix ring_buffer_event_length()
Message-ID: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

I added the Impact line. This probably should go into 2.6.29.

The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Robert Richter (1):
      ring_buffer: fix ring_buffer_event_length()

----
 kernel/trace/ring_buffer.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)
---------------------------
commit 49c86f2104c25d36f1a44e569c08968f388da75d
Author: Robert Richter <robert.richter@amd.com>
Date:   Wed Jan 7 23:45:23 2009 +0100

    ring_buffer: fix ring_buffer_event_length()
    
    Impact: fix to ring_buffer_event_length()
    
    Function ring_buffer_event_length() provides an interface to detect
    the length of data stored in an entry. However, the length contains
    offsets depending on the internal usage. This makes it unusable. This
    patch fixes this and now ring_buffer_event_length() returns the
    alligned length that has been used in ring_buffer_lock_reserve().
    
    Signed-off-by: Robert Richter <robert.richter@amd.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a9d9760..8b0daf0 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -168,7 +168,13 @@ rb_event_length(struct ring_buffer_event *event)
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
 

