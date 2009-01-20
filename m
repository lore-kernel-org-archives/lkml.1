Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbZATAXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbZATAXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764821AbZATARo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764775AbZATARf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:35 -0500
Message-Id: <20090120001733.836881476@goodmis.org>
References: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 7/8] ring-buffer: fix alignment problem
Content-Disposition: inline; filename=0007-ring-buffer-fix-alignment-problem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to allow some archs to use the ring buffer

Commits in the ring buffer are checked by pointer arithmetic.
If the calculation is incorrect, then the commits will never take
place and the buffer will simply fill up and report an error.

Each page in the ring buffer has a small header:

struct buffer_data_page {
	u64		time_stamp;
	local_t		commit;
	unsigned char	data[];
};

Unfortuntely, some of the calculations used sizeof(struct buffer_data_page)
to know the size of the header. But this is incorrect on some archs,
where sizeof(struct buffer_data_page) does not equal
offsetof(struct buffer_data_page, data), and on those archs, the commits
are never processed.

This patch replaces the sizeof with offsetof.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 0b9de5a..8de026d 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -244,7 +244,7 @@ static inline int test_time_stamp(u64 delta)
 	return 0;
 }
 
-#define BUF_PAGE_SIZE (PAGE_SIZE - sizeof(struct buffer_data_page))
+#define BUF_PAGE_SIZE (PAGE_SIZE - offsetof(struct buffer_data_page, data))
 
 /*
  * head_page == tail_page && head == tail then buffer is empty.
-- 
1.5.6.5

-- 
