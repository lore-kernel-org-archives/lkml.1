Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZCNBWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZCNBWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZCNBTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:49 -0400
Received: from kroah.org ([198.145.64.141]:34770 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159AbZCNBTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:32 2009
Message-Id: <20090314011032.139859319@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:43 -0700
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
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Paul Turner <pjt@google.com>
Subject: [patch 006/114] seq_file: properly cope with pread
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=seq_file-properly-cope-with-pread.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Biederman <ebiederm@xmission.com>

commit 8f19d472935c83d823fa4cf02bcc0a7b9952db30 upstream.

Currently seq_read assumes that the offset passed to it is always the
offset it passed to user space.  In the case pread this assumption is
broken and we do the wrong thing when presented with pread.

To solve this I introduce an offset cache inside of struct seq_file so we
know where our logical file position is.  Then in seq_read if we try to
read from another offset we reset our data structures and attempt to go to
the offset user space wanted.

[akpm@linux-foundation.org: restore FMODE_PWRITE]
[pjt@google.com: seq_open needs its fmode opened up to take advantage of this]
Signed-off-by: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Paul Turner <pjt@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/seq_file.c            |   36 ++++++++++++++++++++++++++++++++----
 include/linux/seq_file.h |    1 +
 2 files changed, 33 insertions(+), 4 deletions(-)

--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -48,8 +48,16 @@ int seq_open(struct file *file, const st
 	 */
 	file->f_version = 0;
 
-	/* SEQ files support lseek, but not pread/pwrite */
-	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
+	/*
+	 * seq_files support lseek() and pread().  They do not implement
+	 * write() at all, but we clear FMODE_PWRITE here for historical
+	 * reasons.
+	 *
+	 * If a client of seq_files a) implements file.write() and b) wishes to
+	 * support pwrite() then that client will need to implement its own
+	 * file.open() which calls seq_open() and then sets FMODE_PWRITE.
+	 */
+	file->f_mode &= ~FMODE_PWRITE;
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
@@ -131,6 +139,22 @@ ssize_t seq_read(struct file *file, char
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
@@ -230,8 +254,10 @@ Fill:
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
@@ -266,16 +292,18 @@ loff_t seq_lseek(struct file *file, loff
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


