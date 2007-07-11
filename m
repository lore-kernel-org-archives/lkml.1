Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbXGKUkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbXGKUkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbXGKUkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:40:00 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48931 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756895AbXGKUkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:40:00 -0400
Subject: [PATCH] relay: fix bogus cast in subbuf_splice_actor()
From: Tom Zanussi <zanussi@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, dwilder@us.ibm.com
Content-Type: text/plain
Date: Wed, 11 Jul 2007 15:36:11 -0500
Message-Id: <1184186171.4517.33.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current code that sets the read position in subbuf_splice_actor may
give erroneous results if the buffer size isn't a power of 2.  This
patch fixes the problem.

Signed-off-by: Tom Zanussi <zanussi@us.ibm.com>

---
 relay.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 3b299fb..7802697 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -1074,7 +1074,9 @@ static int subbuf_splice_actor(struct file *in,
 	unsigned int pidx, poff, total_len, subbuf_pages, ret;
 	struct rchan_buf *rbuf = in->private_data;
 	unsigned int subbuf_size = rbuf->chan->subbuf_size;
-	size_t read_start = ((size_t)*ppos) % rbuf->chan->alloc_size;
+	uint64_t pos = (uint64_t) *ppos;
+	uint32_t alloc_size = (uint32_t) rbuf->chan->alloc_size;
+	size_t read_start = (size_t) do_div(pos, alloc_size);
 	size_t read_subbuf = read_start / subbuf_size;
 	size_t padding = rbuf->padding[read_subbuf];
 	size_t nonpad_end = read_subbuf * subbuf_size + subbuf_size - padding;



