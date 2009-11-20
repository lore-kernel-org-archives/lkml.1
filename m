Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZKTQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZKTQnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZKTQk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:40:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbZKTQkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:40:53 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, jkacur@redhat.com,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, Jan Blunck <jblunck@suse.de>
Subject: [PATCH 04/15] s390: tape_char should update ppos instead of using file->f_pos
Date: Fri, 20 Nov 2009 17:40:34 +0100
Message-Id: <1258735245-25826-5-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258735245-25826-1-git-send-email-jblunck@suse.de>
References: <1258735245-25826-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tapechar_read()/tapechar_write() modify file->f_pos directly instead of
the ppos given to them. The VFS later updates the file->f_pos and
overwrites it with the unchanged value of ppos.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/s390/char/tape_char.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/tape_char.c b/drivers/s390/char/tape_char.c
index 31566c5..3514f6e 100644
--- a/drivers/s390/char/tape_char.c
+++ b/drivers/s390/char/tape_char.c
@@ -170,7 +170,7 @@ tapechar_read(struct file *filp, char __user *data, size_t count, loff_t *ppos)
 	if (rc == 0) {
 		rc = block_size - request->rescnt;
 		DBF_EVENT(6, "TCHAR:rbytes:  %x\n", rc);
-		filp->f_pos += rc;
+		*ppos += rc;
 		/* Copy data from idal buffer to user space. */
 		if (idal_buffer_to_user(device->char_data.idal_buf,
 					data, rc) != 0)
@@ -238,7 +238,7 @@ tapechar_write(struct file *filp, const char __user *data, size_t count, loff_t
 			break;
 		DBF_EVENT(6, "TCHAR:wbytes: %lx\n",
 			  block_size - request->rescnt);
-		filp->f_pos += block_size - request->rescnt;
+		*ppos += block_size - request->rescnt;
 		written += block_size - request->rescnt;
 		if (request->rescnt != 0)
 			break;
-- 
1.6.4.2

