Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbXHODkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbXHODkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 23:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbXHODjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 23:39:53 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:40351 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753551AbXHODjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 23:39:52 -0400
Message-ID: <387149185.77275@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 11:39:45 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
Subject: Re: [patch 2/2] Sort module list by pointer address to get
	coherent sleepable seq_file iterators
Message-ID: <20070815033945.GA13134@mail.ustc.edu.cn>
Mail-Followup-To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Randy Dunlap <rddunlap@osdl.org>, Martin Bligh <mbligh@google.com>
References: <20070812150844.305211039@polymtl.ca> <20070812151039.996081605@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812151039.996081605@polymtl.ca>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 11:08:46AM -0400, Mathieu Desnoyers wrote:
>  
>  static void *m_next(struct seq_file *m, void *p, loff_t *pos)
>  {
> -	return seq_list_next(p, &modules, pos);
> +	return seq_sorted_list_next(p, &modules, &m->private);
>  }

In theory it is not safe to use something other than the passed in
*pos as an position indicator. Because seq_file do not always call
->next() to advance to the next item. Look at seq_file.c, it sometimes
increase the pos/index directly! Which also prevents pos to skip
forward, which is preferred in your case.

The attached patch tries to fix it.

The seq_file.c is so twisted!

Fengguang
===

seqfile: remove seq_file's assumption about iterators

The seq_file implementation has some hardcoded index++/pos++ lines,
which assumes iterators to be *continuous* integers.

This patch replaces the index++ lines with calls to m->next(), so that
seq_file users can freely use discrete forms of iterators, such as
ascending addresses.

Cc: Randy Dunlap <rddunlap@osdl.org>
Cc: Martin Bligh <mbligh@google.com>
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>

---
 fs/seq_file.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- linux-2.6.22-git15.orig/fs/seq_file.c
+++ linux-2.6.22-git15/fs/seq_file.c
@@ -13,6 +13,8 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
+#define SEQFILE_SHOW_NEXT	LONG_MAX
+
 /**
  *	seq_open -	initialize sequential file
  *	@file: file we initialize
@@ -93,6 +95,7 @@ ssize_t seq_read(struct file *file, char
 	/* if not empty - flush it first */
 	if (m->count) {
 		n = min(m->count, size);
+		BUG_ON(m->from == SEQFILE_SHOW_NEXT);
 		err = copy_to_user(buf, m->buf + m->from, n);
 		if (err)
 			goto Efault;
@@ -102,7 +105,7 @@ ssize_t seq_read(struct file *file, char
 		buf += n;
 		copied += n;
 		if (!m->count)
-			m->index++;
+			m->from = SEQFILE_SHOW_NEXT;
 		if (!size)
 			goto Done;
 	}
@@ -113,9 +116,11 @@ ssize_t seq_read(struct file *file, char
 		err = PTR_ERR(p);
 		if (!p || IS_ERR(p))
 			break;
-		err = m->op->show(m, p);
-		if (err)
-			break;
+		if (m->from != SEQFILE_SHOW_NEXT) {
+			err = m->op->show(m, p);
+			if (err)
+				break;
+		}
 		if (m->count < m->size)
 			goto Fill;
 		m->op->stop(m, p);
@@ -156,7 +161,7 @@ Fill:
 	if (m->count)
 		m->from = n;
 	else
-		pos++;
+		m->from = SEQFILE_SHOW_NEXT;
 	m->index = pos;
 Done:
 	if (!copied)
@@ -211,12 +216,9 @@ static int traverse(struct seq_file *m, 
 		}
 		pos += m->count;
 		m->count = 0;
-		if (pos == offset) {
-			index++;
-			m->index = index;
-			break;
-		}
 		p = m->op->next(m, p, &index);
+		if (pos == offset)
+			break;
 	}
 	m->op->stop(m, p);
 	return error;

