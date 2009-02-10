Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZBJTQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZBJTQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbZBJTEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:09 -0500
Received: from kroah.org ([198.145.64.141]:54086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755906AbZBJTEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:07 -0500
Date: Tue, 10 Feb 2009 11:01:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Biederman <ebiederm@xmission.com>,
       Paul Turner <pjt@google.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 37/53] seq_file: move traverse so it can be used from
	seq_read
Message-ID: <20090210190101.GL14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="seq_file-move-traverse-so-it-can-be-used-from-seq_read.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Eric Biederman <ebiederm@xmission.com>

commit 33da8892a2f9e7d4b2d9a35fc80833ba2d2b1aa6 upstream.

In 2.6.25 some /proc files were converted to use the seq_file
infrastructure.  But seq_files do not correctly support pread(), which
broke some usersapce applications.

To handle pread correctly we can't assume that f_pos is where we left it
in seq_read.  So move traverse() so that we can eventually use it in
seq_read and do thus some day support pread().

Signed-off-by: Eric Biederman <ebiederm@xmission.com>
Cc: Paul Turner <pjt@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/seq_file.c |  114 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -54,6 +54,63 @@ int seq_open(struct file *file, const st
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

