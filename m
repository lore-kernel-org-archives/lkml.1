Return-Path: <linux-kernel-owner+w=401wt.eu-S1946191AbXBIIE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946191AbXBIIE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 03:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946192AbXBIIE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 03:04:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34323 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946191AbXBIIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 03:04:26 -0500
Date: Fri, 9 Feb 2007 00:03:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Frederik Deweerdt <deweerdt@free.fr>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jkenisto@us.ibm.com,
       anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system---Take-2
Message-Id: <20070209000353.f4c2057e.akpm@linux-foundation.org>
In-Reply-To: <45CB0D87.8070808@in.ibm.com>
References: <45C85097.1000106@in.ibm.com>
	<20070206100607.GA10296@infradead.org>
	<45C856F1.7060403@in.ibm.com>
	<45C894EA.4060305@in.ibm.com>
	<20070206145609.GA11249@slug>
	<45C962C3.2020904@in.ibm.com>
	<20070207142717.5da4d8d4.akpm@linux-foundation.org>
	<45CB0D87.8070808@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Feb 2007 17:16:15 +0530 Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> +module_init(debugfs_kprobe_init);
> +#endif /* CONFIG_DEBUG_FS */
> +
>  __initcall(init_kprobes);

I think you'll find this doesn't work when loaded as a module: we only
support a single initcall per module.  (Which might be a bit dumb of us -
it's probably easy to fix and is an inconsistency between modular and
built-in).

<looks>

Oh, kernel/kprobes.o can't be linked as a module.  It looks like it could
be though?

You have a little race: debugfs_kprobe_init() will be called before
init_kprobes().  If someone were able to read from the debugfs files in
that window (they probably can't as we don't support modular kprobes.ko)
they'll crash the kernel.  I'll switch debugfs_kprobe_init() to
late_initcall to fix that.

There are quite a few things in there which could have static scope.


I'll apply this:



diff -puN kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system-tidy kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system-tidy
+++ a/kernel/kprobes.c
@@ -836,12 +836,12 @@ static void __kprobes report_probe(struc
 		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
 }
 
-void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
 {
 	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
 }
 
-void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+static void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
 	if (*pos >= KPROBE_TABLE_SIZE)
@@ -849,12 +849,12 @@ void __kprobes *kprobe_seq_next(struct s
 	return pos;
 }
 
-void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+static void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
 {
 	/* Nothing to do */
 }
 
-int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
@@ -879,7 +879,7 @@ int __kprobes show_kprobe_addr(struct se
 	return 0;
 }
 
-struct seq_operations kprobes_seq_ops = {
+static struct seq_operations kprobes_seq_ops = {
 	.start = kprobe_seq_start,
 	.next  = kprobe_seq_next,
 	.stop  = kprobe_seq_stop,
@@ -916,10 +916,10 @@ static int __kprobes debugfs_kprobe_init
 	return 0;
 }
 
-module_init(debugfs_kprobe_init);
+late_initcall(debugfs_kprobe_init);
 #endif /* CONFIG_DEBUG_FS */
 
-__initcall(init_kprobes);
+module_init(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
@@ -928,4 +928,3 @@ EXPORT_SYMBOL_GPL(unregister_jprobe);
 EXPORT_SYMBOL_GPL(jprobe_return);
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
-
_

