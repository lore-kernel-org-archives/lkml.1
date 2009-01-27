Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZA0Vs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZA0Vs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbZA0Vst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:48:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41163 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZA0Vss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:48:48 -0500
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] seq_file: Move traverse so it can be used from seq_read
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com>
	<20090124181924.d633523c.akpm@linux-foundation.org>
	<20090125120818.GA4454@x200.localdomain>
	<m1r62obev3.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jan 2009 13:48:56 -0800
In-Reply-To: <m1r62obev3.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 27 Jan 2009 13\:47\:44 -0800")
Message-ID: <m1mydcbet3.fsf_-_@fess.ebiederm.org>
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


To handle pread correctly we can't assume that f_pos is
where we left it in seq_read.  So modify traverse
so we can use it in seq_read.

Signed-off-by: Eric Biederman <ebiederm@xmission.com>
---
 fs/seq_file.c |  114 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index b569ff1..2716c12 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -54,6 +54,63 @@ int seq_open(struct file *file, const struct seq_operations *op)
 }
 EXPORT_SYMBOL(seq_open);
 
+static int traverse(struct seq_file *m, loff_t offset)
+{
+	loff_t pos = 0, index;
+	int error = 0;
+	void *p;
+
+	m->version = 0;
+	index = 0;
+	m->count = m->from = 0;
+	if (!offset) {
+		m->index = index;
+		return 0;
+	}
+	if (!m->buf) {
+		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
+		if (!m->buf)
+			return -ENOMEM;
+	}
+	p = m->op->start(m, &index);
+	while (p) {
+		error = PTR_ERR(p);
+		if (IS_ERR(p))
+			break;
+		error = m->op->show(m, p);
+		if (error < 0)
+			break;
+		if (unlikely(error)) {
+			error = 0;
+			m->count = 0;
+		}
+		if (m->count == m->size)
+			goto Eoverflow;
+		if (pos + m->count > offset) {
+			m->from = offset - pos;
+			m->count -= m->from;
+			m->index = index;
+			break;
+		}
+		pos += m->count;
+		m->count = 0;
+		if (pos == offset) {
+			index++;
+			m->index = index;
+			break;
+		}
+		p = m->op->next(m, p, &index);
+	}
+	m->op->stop(m, p);
+	return error;
+
+Eoverflow:
+	m->op->stop(m, p);
+	kfree(m->buf);
+	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
+	return !m->buf ? -ENOMEM : -EAGAIN;
+}
+
 /**
  *	seq_read -	->read() method for sequential files.
  *	@file: the file to read from
@@ -186,63 +243,6 @@ Efault:
 }
 EXPORT_SYMBOL(seq_read);
 
-static int traverse(struct seq_file *m, loff_t offset)
-{
-	loff_t pos = 0, index;
-	int error = 0;
-	void *p;
-
-	m->version = 0;
-	index = 0;
-	m->count = m->from = 0;
-	if (!offset) {
-		m->index = index;
-		return 0;
-	}
-	if (!m->buf) {
-		m->buf = kmalloc(m->size = PAGE_SIZE, GFP_KERNEL);
-		if (!m->buf)
-			return -ENOMEM;
-	}
-	p = m->op->start(m, &index);
-	while (p) {
-		error = PTR_ERR(p);
-		if (IS_ERR(p))
-			break;
-		error = m->op->show(m, p);
-		if (error < 0)
-			break;
-		if (unlikely(error)) {
-			error = 0;
-			m->count = 0;
-		}
-		if (m->count == m->size)
-			goto Eoverflow;
-		if (pos + m->count > offset) {
-			m->from = offset - pos;
-			m->count -= m->from;
-			m->index = index;
-			break;
-		}
-		pos += m->count;
-		m->count = 0;
-		if (pos == offset) {
-			index++;
-			m->index = index;
-			break;
-		}
-		p = m->op->next(m, p, &index);
-	}
-	m->op->stop(m, p);
-	return error;
-
-Eoverflow:
-	m->op->stop(m, p);
-	kfree(m->buf);
-	m->buf = kmalloc(m->size <<= 1, GFP_KERNEL);
-	return !m->buf ? -ENOMEM : -EAGAIN;
-}
-
 /**
  *	seq_lseek -	->llseek() method for sequential files.
  *	@file: the file in question
-- 
1.5.6.3

