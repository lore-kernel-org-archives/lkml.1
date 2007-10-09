Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbXJIEFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbXJIEFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbXJIEEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:04:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54374 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbXJIEEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:04:52 -0400
Date: Mon, 8 Oct 2007 21:04:02 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: Avoid /proc/lockdep & lock_stat infinite
	output
Message-ID: <20071009040401.GA3493@tpepper-t42p.dolavim.us>
References: <20071009011551.GA3592@tpepper-t42p.dolavim.us> <20071009013011.GV8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009013011.GV8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09 Oct at 02:30:11 +0100 viro@ftp.linux.org.uk said:
> On Mon, Oct 08, 2007 at 06:15:51PM -0700, Tim Pepper wrote:
> > 
> > -	if (&class->lock_entry == all_lock_classes.next)
> > +	if (*pos == 0)
> >  		seq_printf(m, "all lock classes:\n");
> 
> Do not generate output outside of ->show() and you won't have these
> problems.  That's where your infinite output crap comes from.
> 
> IOW, NAK - fix the underlying problem.

Aaah...OK.  Can we add something like the following then:




Document that output must only come from _show() and SEQ_START_TOKEN is how
a _start() indicates a header is to be printed.

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Al Viro <viro@ftp.linux.org.uk>

---

--- linux-2.6.orig/include/linux/seq_file.h
+++ linux-2.6.23-rc9/include/linux/seq_file.h
@@ -36,9 +36,10 @@ ssize_t seq_read(struct file *, char __u
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
 int seq_escape(struct seq_file *, const char *, const char *);
+
+/* these may only be called from a (*show) function */
 int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
-
 int seq_printf(struct seq_file *, const char *, ...)
 	__attribute__ ((format (printf,2,3)));
 
@@ -48,6 +49,11 @@ int single_open(struct file *, int (*)(s
 int single_release(struct inode *, struct file *);
 int seq_release_private(struct inode *, struct file *);
 
+/*
+ * return SEQ_START_TOKEN in your (*start) function and test for
+ * (v == SEQ_START_TOKEN) in * your (*show) funtion in order to
+ * print a header before your seq data
+ */
 #define SEQ_START_TOKEN ((void *)1)
 
 /*
