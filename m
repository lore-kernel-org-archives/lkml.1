Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYFYJsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYFYJsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYFYJs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:48:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51044 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753064AbYFYJs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:48:28 -0400
Message-ID: <4862136B.4010107@cn.fujitsu.com>
Date: Wed, 25 Jun 2008 17:44:11 +0800
From: biannm <biannm@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: torvalds@linux-foundation.org, akpm@osdl.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: fix bug about seq_read read nothing
Content-Type: text/plain; charset=Shift_JIS
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i used seq_file to read a proc file, i got a bug of seq_read.
If show() skip the first element or the size of first element is 0, 
and the size of second element is larger than the seq_file->size at 
the same time, seq_read will return 0, so nothing can be read from
the proc file.

So, if seq_read will return because it finds the element is biger 
than the m->buf, it must make sure either some date was filled to 
m->buf by show(), or some data was flushed to the user buf before, 
if not,it should increase the m->buf until it can read this element.


Signed-off-by: Bian Naimeng  <biannm@cn.fujitsu.com>

---
 fs/seq_file.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3f54dbd..ab1ed27 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -107,6 +107,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		if (!size)
 			goto Done;
 	}
+First_record:
 	/* we need at least one record in buffer */
 	while (1) {
 		pos = m->index;
@@ -145,8 +146,17 @@ Fill:
 		err = m->op->show(m, p);
 		if (m->count == m->size || err) {
 			m->count = offs;
-			if (likely(err <= 0))
+			if (err < 0)
 				break;
+			/* If no data flush to the user buf and nothing was read
+			 * by show() before,it should increase the m->buf until
+			 * it can read this element.
+			*/
+			if (err == 0 && m->count == 0 && copied == 0) {
+				m->index = next;
+				m->op->stop(m, p);
+				goto First_record;
+			}
 		}
 		pos = next;
 	}
-- 
1.5.4.rc3

