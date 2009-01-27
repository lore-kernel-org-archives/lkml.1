Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZA0Vtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZA0Vtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZA0Vtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:49:39 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38206 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZA0Vti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:49:38 -0500
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] seq_file:  Properly cope with pread
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
	<20090124181924.d633523c.akpm@linux-foundation.org>
	<20090125120818.GA4454@x200.localdomain>
	<m1r62obev3.fsf@fess.ebiederm.org>
	<m1mydcbet3.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jan 2009 13:49:45 -0800
In-Reply-To: <m1mydcbet3.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 27 Jan 2009 13\:48\:56 -0800")
Message-ID: <m1iqo0berq.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: adobriyan@gmail.com, linux-kernel@vger.kernel.org, pjt@google.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently seq_read assumes that the offset passed
to it is always the offset it passed to user space.
In the case pread this assumption is broken and we
do the wrong thing when presented with pread.

To solve this I introduce an offset cache inside of
struct seq_file so we know where our logical file position
is.  Then in seq_read if we try to read from another
offset we reset our data structures and attempt
to go to the offset user space wanted.

Signed-off-by: Eric Biederman <ebiederm@xmission.com>
---
 fs/seq_file.c            |   24 ++++++++++++++++++++++--
 include/linux/seq_file.h |    1 +
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 2716c12..cd63d69 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -130,6 +130,22 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	int err = 0;
 
 	mutex_lock(&m->lock);
+
+	/* Don't assume *ppos is where we left it */
+	if (unlikely(*ppos != m->read_pos)) {
+		m->read_pos = *ppos;
+		while ((err = traverse(m, *ppos)) == -EAGAIN)
+			;
+		if (err) {
+			/* With prejudice... */
+			m->read_pos = 0;
+			m->version = 0;
+			m->index = 0;
+			m->count = 0;
+			goto Done;
+		}
+	}
+
 	/*
 	 * seq_file->op->..m_start/m_stop/m_next may do special actions
 	 * or optimisations based on the file->f_version, so we want to
@@ -229,8 +245,10 @@ Fill:
 Done:
 	if (!copied)
 		copied = err;
-	else
+	else {
 		*ppos += copied;
+		m->read_pos += copied;
+	}
 	file->f_version = m->version;
 	mutex_unlock(&m->lock);
 	return copied;
@@ -265,16 +283,18 @@ loff_t seq_lseek(struct file *file, loff_t offset, int origin)
 			if (offset < 0)
 				break;
 			retval = offset;
-			if (offset != file->f_pos) {
+			if (offset != m->read_pos) {
 				while ((retval=traverse(m, offset)) == -EAGAIN)
 					;
 				if (retval) {
 					/* with extreme prejudice... */
 					file->f_pos = 0;
+					m->read_pos = 0;
 					m->version = 0;
 					m->index = 0;
 					m->count = 0;
 				} else {
+					m->read_pos = offset;
 					retval = file->f_pos = offset;
 				}
 			}
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 40ea505..f616f31 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -19,6 +19,7 @@ struct seq_file {
 	size_t from;
 	size_t count;
 	loff_t index;
+	loff_t read_pos;
 	u64 version;
 	struct mutex lock;
 	const struct seq_operations *op;
-- 
1.5.6.3

