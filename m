Return-Path: <linux-kernel-owner+w=401wt.eu-S934879AbXGWTq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879AbXGWTq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934768AbXGWTqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:46:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50659 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934796AbXGWTqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:46:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type;
	b=b2f6ZcnVh0Pu1svwzvFbb899/l5l1DLESZ86YUPEs5+bj+QZeJGcc6VqTXdxAn+bE
	pNWFjXHoehEHA/E3wS5Pg==
Message-ID: <46A50567.3020308@google.com>
Date: Mon, 23 Jul 2007 12:45:43 -0700
From: Martin Bligh <mbligh@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] Add seq_file howto to Documentation/
Content-Type: multipart/mixed;
 boundary="------------040703020000050402010204"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040703020000050402010204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Add seq_file howto to Documentation/

Signed-off-by: Martin J. Bligh <mbligh@google.com>

Taken from kernelnewbies with Randy's permission.

--------------040703020000050402010204
Content-Type: text/plain;
 name="2.6.22-seq_file_doc"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.22-seq_file_doc"

diff -aurpN -X /home/mbligh/.diff.exclude linux-2.6.22/Documentation/seq_file_howto.txt 2.6.22-seq_file_doc/Documentation/seq_file_howto.txt
--- linux-2.6.22/Documentation/seq_file_howto.txt	1969-12-31 16:00:00.000000000 -0800
+++ 2.6.22-seq_file_doc/Documentation/seq_file_howto.txt	2007-07-23 12:41:24.000000000 -0700
@@ -0,0 +1,246 @@
+Linux kernel seq_file HOWTO
+Randy Dunlap  <rddunlap@osdl.org>
+v0: 2003-02-22
+v1: 2003-03-14
+
+Parts of this seq_file HOWTO were contributed by Andries Brouwer
+(aeb%win!tue!nl).
+
+[Another seq_file reference is "Driver porting: The seq_file interface"
+at <http://lwn.net/Articles/22355/>, which is part of the
+LWN.net series "Porting Drivers to 2.5" that is located at
+<http://lwn.net/Articles/driver-porting/>.]
+
+======================================================================
+
+* Introduction
+
+The "seq_file" interface to the /proc filesystem was introduced in
+Linux 2.4.15-pre3 and Linux 2.4.13-ac8.  It provides a safer interface
+to the /proc filesystem than previous procfs methods because it protects
+against overflow of the output buffer and easily handles procfs files
+that are larger than one page.  It also provides methods for
+traversing a list of kernel items and iterating on that list.
+It provides procfs output facilities that are less error-prone than
+the previous procfs interfaces.
+
+Overview:  seq_file operates by using "pull" methods, pulling or asking
+for data from seq_file operations methods, whereas the previous procfs
+methods pushed data into output buffers.
+
+======================================================================
+
+* seq_file creation and data structures
+
+A seq_file-type /proc file is created by using create_proc_entry() and
+setting the resulting proc_dir_entry->proc_fops pointer to the
+desired struct file_operations.  E.g. (from linux/mm/swapfile.c):
+
+static int __init procswaps_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	entry = create_proc_entry("swaps", 0, NULL);
+	if (entry)
+		entry->proc_fops = &proc_swaps_operations;
+	return 0;
+}
+
+struct file_operations for the seq_file-type proc file describes 4
+I/O methods, e.g.:
+
+static struct file_operations proc_swaps_operations = {
+	.open		= swaps_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+The last 3 are reusable seq_file-supplied methods.  The open method
+is what must be supplied for each proc file, and that open()
+function only needs to call seq_open() with a pointer to a struct
+seq_operations descriptor.  E.g. (still from linux/mm/swapfile.c):
+
+static int swaps_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &swaps_op);
+}
+
+struct seq_file seq_operations swaps_op supplies 4 methods for
+producing seq_file output:  start(), next(), stop(), and show().
+These are described below.  The structure typically looks like:
+
+static struct seq_operations swaps_op = {
+	.start =	swap_start,
+	.next =		swap_next,
+	.stop =		swap_stop,
+	.show =		swap_show
+};
+
+======================================================================
+
+* seq_file methods
+
+The seq_file routines never take any locks between the ->open() and
+->stop() functions, so seq_file callers are free to use anything --
+spinlocks, etc.
+
+The seq_file interface does require more data structures to be setup
+to point to methods that are used during seq_file access.  In return
+for this, you (we) get much safer /proc output methods.  These four
+methods are in struct seq_operations:
+
+struct seq_operations {
+	void * (*start) (struct seq_file *m, loff_t *pos);
+	void (*stop) (struct seq_file *m, void *v);
+	void * (*next) (struct seq_file *m, void *v, loff_t *pos);
+	int (*show) (struct seq_file *m, void *v);
+};
+
+The .start method is used to initialize data for walking through a list
+of kernel items.  This list can be an array, a linked list, a hash table,
+etc.  Its actual data type doesn't matter.  This function should lock
+whatever needs to be locked for safety and return an entry by number
+(0 for the first entry).  This method should also honor file offset
+semantics by using the "loff_t *pos" (second) parameter.
+The "entry number" value is passed to the stop, next, and show
+methods as the "void *v" parameter.
+In case of error, return ERR_PTR(error_code).
+
+If you need to show a header line or something, then return
+SEQ_START_TOKEN in your start() and recognise that in next() and
+show(). IOW, pos == 0 will be the header line, and pos == 1
+will correspond to the first actual item on your list, and so on.
+See net/netlink/af_netlink.c for a simple example.
+
+If there is any locking that needs to be done to iterate through the
+kernel list, the lock(s) can be acquired in the .start method.  However,
+if the .show method is very time-consuming and the .show method lends
+itself to locking there, that may be a better place for it.
+
+struct seq_file contains a "void *private" that can be used by the
+struct seq_operations functions to hold any private data that needs
+to be available to all of these related methods.  For example, the
+.start method might allocate some memory and save its address in
+seq_file.private so that the .next and .show methods can use it,
+then the .stop method would free that memory.
+
+The .stop method is called after the .next method has nothing more to
+do.  This method is used for cleanups, unlocking, freeing resources, etc.
+The .stop method is always called if the .start method was called, even
+if the .start method fails, so that all cleanups can be done in .stop.
+
+The .next method is the iterator for the items (list, array, table, etc.)
+that is being traversed for /proc file output.  It advances to the next
+item of interest to be shown in the /proc output file and indicates
+when there are no more items by returning NULL or an error (like -ENOMEM
+or -EACCES).  If there are more items to be shown, it returns the next
+element (entry) of the sequence by entry number.
+
+The .show method is used to show an entry (write output to the /proc
+file) by using seq_...() as you would use stdio functions.  It can
+write static headings or variable data into the seq_file output buffer.
+It uses seq_{putc, puts, printf, ...} to format the output (see below).
+In case of error, return a negative error_code; otherwise return 0.
+
+======================================================================
+
+* seq_file output routines
+
+The seq_file output methods are:
+
+/*
+ * seq_putc:
+ * print one character to the seq_file output buffer
+ * returns 0 for success or -1 for error
+ */
+int seq_putc(struct seq_file *m, char c);
+
+/*
+ * seq_puts:
+ * print a null-terminated string to the seq_file output buffer
+ * returns 0 for success or -1 for error
+ */
+int seq_puts(struct seq_file *m, const char *s);
+
+/*
+ * seq_printf:
+ * print a formatted string and variable data to the seq_file output buffer
+ * returns 0 for success or -1 for error
+ */
+int seq_printf(struct seq_file *m, const char *f, ...);
+
+/*
+ *	seq_open:	initialize sequential file
+ *	@file: file to initialize
+ *	@op: method table describing the sequence
+ *
+ *	seq_open() sets @file, associating it with a sequence described
+ *	by @op.  @op->start() sets the iterator up and returns the first
+ *	element of sequence. @op->stop() shuts it down.  @op->next()
+ *	returns the next element of sequence.  @op->show() prints element
+ *	into the buffer.  In case of error ->start() and ->next() return
+ *	ERR_PTR(error).  In the end of sequence they return %NULL. ->show()
+ *	returns 0 in case of success and negative number in case of error.
+ */
+int seq_open(struct file *file, struct seq_operations *op);
+
+/*
+ *	seq_read:	->read() method for sequential files.
+ *	@file, @buf, @size, @ppos: see file_operations method
+ *
+ *	Ready-made ->f_op->read()
+ */
+ssize_t seq_read(struct file *file, char *buf, size_t size, loff_t *ppos);
+
+/*
+ *	seq_lseek:	->llseek() method for sequential files.
+ *	@file, @offset, @origin: see file_operations method
+ *
+ *	Ready-made ->f_op->llseek()
+ */
+loff_t seq_lseek(struct file *file, loff_t offset, int origin);
+
+/*
+ *	seq_release:	free the structures associated with sequential file.
+ *	@file: file in question
+ *	@inode: file->f_dentry->d_inode
+ *
+ *	Frees the structures associated with sequential file; can be used
+ *	as ->f_op->release() if you don't have private data to destroy.
+ */
+int seq_release(struct inode *inode, struct file *file);
+
+/*
+ *	seq_escape: print string into buffer, escaping some characters
+ *	@m:	target buffer
+ *	@s:	string
+ *	@esc:	set of characters that need escaping
+ *
+ *	Puts string into buffer, replacing each occurence of character from
+ *	@esc with usual octal escape.  Returns 0 in case of success
+ *	or -1 in case of overflow.
+ */
+int seq_escape(struct seq_file *m, const char *s, const char *esc);
+
+======================================================================
+
+* Simplified seq_file methods
+
+If you only need a single function entry (call) to produce all the
+desired proc-fs output, just use single_open() and single_release().
+
+single_open() gets a parameter that is the "show" function for the data
+that is to be written to /proc.  The "show" function does everything
+that is needed to write the data, all in one function call.  This is
+useful either for writing small amounts of data to /proc, for cases in
+which the output is not iterative, or for cases in which recursion is
+more appropriate, since the non-single methods don't fit well with
+recursive techniques.  Examples of appropriate uses of single_open()
+"show" functions are:
+
+  linux/kernel/dma.c::proc_dma_show() : small quantity of data to write
+  linux/net/ipv4/proc.c::sockstat_seq_show() : non-iterative data
+  linux/net/sunrpc/rpc_pipe.c::rpc_show_info() : non-iterative data
+
+###

--------------040703020000050402010204--
