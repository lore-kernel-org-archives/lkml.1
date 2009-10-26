Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbZJZKnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbZJZKnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 06:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbZJZKnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 06:43:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:30406 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbZJZKnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 06:43:10 -0400
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
	oopses and panics
From: "Shargorodsky Atal (EXT-Teleca/Helsinki)" 
	<ext-atal.shargorodsky@nokia.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1256403957.29885.357.camel@localhost>
References: <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu>	<1255681467.32489.360.camel@localhost>
	 <20091016112556.6902b2dc@marrow.netinsight.se>
	 <20091016101045.GA3263@elte.hu>
	 <20091016140918.3981cfa2@marrow.netinsight.se>
	 <1255952922.32489.505.camel@localhost>	<20091019125017.GA9030@elte.hu>
	 <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
	 <20091022082500.602f9a7d@marrow.netinsight.se>
	 <1256313202.5824.60.camel@atal-desktop>
	 <1256403957.29885.357.camel@localhost>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 12:40:02 +0200
Message-Id: <1256553602.5822.29.camel@atal-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2009 10:41:46.0436 (UTC) FILETIME=[EA609840:01CA5628]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-24 at 19:05 +0200, Artem Bityutskiy wrote:
> On Fri, 2009-10-23 at 18:53 +0300, Shargorodsky Atal
> (EXT-Teleca/Helsinki) wrote:
> > Hi all,
> > 
> > On Thu, 2009-10-22 at 08:25 +0200, ext Simon Kagstrom wrote:
> > 
> > > Thanks to everyone for the reviewing and suggestions!
> > > 
> > 
> > I have a couple of questions:
> > 
> > 1. If somebody writes a module that uses dumper for uploading the
> > oopses/panics logs via some pay-per-byte medium,  since he has no way
> > to know in a module if the panic_on_oops flag is set, he'll have
> > to upload both oops and the following panic, because he does not
> > know for sure that the panic was caused by the oops. Hence he
> > pays twice for the same information, right?
> 
> Looks like a valid point to me. Indeed, in this case we will first call
> 'kmsg_dump(KMSG_DUMP_OOPS)' from 'oops_exit()', and then call it from
> 'panic()'. And the dumper may dump the same information, which is not
> nice.
> 
> I've looked briefly and tried to figure out how to fix this. But I
> cannot find an clean way. And I was confused by the die/oops/etc code.
> My question is, why the code does not work the following way instead?
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 2d8a371..8f322c7 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -235,13 +235,12 @@ void __kprobes oops_end(unsigned long flags, struct pt_regs *regs, int signr)
>         raw_local_irq_restore(flags);
>         oops_exit();
> 
> -       if (!signr)
> -               return;
>         if (in_interrupt())
>                 panic("Fatal exception in interrupt");
>         if (panic_on_oops)
>                 panic("Fatal exception");
> -       do_exit(signr);
> +       if (signr)
> +               do_exit(signr);
>  }
> 
>  int __kprobes __die(const char *str, struct pt_regs *regs, long err)
> 
> If the code worked like this, I think the problem indicated by Atal
> could be easily fixed.
> 

Could as well be, but will not help us much on arch/arm. :)

> > 2. We tried to use panic notifiers mechanism to print additional
> > information that we want to see in mtdoops logs and it worked well,
> > but having the kmsg_dump(KMSG_DUMP_PANIC) before the
> > atomic_notifier_call_chain() breaks this functionality.
> > Can we the call kmsg_dump() after the notifiers had been invoked?
> 
> Atal, I think you should just attach your patch, it is easier to express
> what you mean.
> 
> But for me it looks like atomic_notifier_call_chain() can be moved up.
> 
> Anyway, please, show your patch.
> 

Inlined:


>From 12343c0918853f326b042c6e285b0e184565564f Mon Sep 17 00:00:00 2001
Message-Id:
<12343c0918853f326b042c6e285b0e184565564f.1256223642.git.ext-atal.shargorodsky@nokia.com>
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
Date: Fri, 2 Oct 2009 17:34:56 +0300
Subject: [PATCH 1/3] debug: introduction of panic info buffer module

The feature of having an option for application to add some data
to be printed at panic could be useful for debugging systems where
the hardware, the kernel, the firmware for supplementary chips, etc.
are under constant development and kernel version does not identify
the exact setup in which the panic occurred.

The way to supply the string is to write it to debugfs file named
panic_info_buff. Currently the buffer length is limited to 1KB - 1B.

Signed-off-by: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
---
 drivers/misc/panic_info_buff.c |   92
++++++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/panic_info_buff.c

diff --git a/drivers/misc/panic_info_buff.c
b/drivers/misc/panic_info_buff.c
new file mode 100644
index 0000000..fa6d2b1
--- /dev/null
+++ b/drivers/misc/panic_info_buff.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright (C) Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <linux/notifier.h>
+
+#define PANIC_BUFFER_MAX_LEN  1024
+static char panic_info_buff[PANIC_BUFFER_MAX_LEN];
+static struct dentry *panic_info_buff_debugfs;
+
+static int panic_info_buff_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static ssize_t panic_info_buff_write(struct file *file,
+		const char __user *buf, size_t len, loff_t *off)
+{
+	if (len >= PANIC_BUFFER_MAX_LEN)
+		return -EINVAL;
+	if (copy_from_user(panic_info_buff, buf, len))
+		return -EFAULT;
+	panic_info_buff[len] = '\0';
+	return len;
+}
+
+static struct file_operations panic_info_buff_fops = {
+	.open   = panic_info_buff_open,
+	.write  = panic_info_buff_write,
+	.llseek = no_llseek,
+	.owner  = THIS_MODULE,
+};
+
+static int panic_info_buff_event(struct notifier_block *this,
+	unsigned long event, void *ptr)
+{
+	if (panic_info_buff[0] == '\0')
+		printk(KERN_EMERG "Panic info buffer is empty.\n");
+	else
+		printk(KERN_EMERG "Panic info buffer:\n"
+				"%s\nBuffer total length: %d characters.\n",
+				panic_info_buff,
+				strlen(panic_info_buff));
+	return NOTIFY_OK;
+}
+
+static struct notifier_block panic_info_buff_block = {
+	.notifier_call  = panic_info_buff_event,
+	.priority       = 1,
+};
+
+static int __devinit panic_info_buff_init(void)
+{
+	panic_info_buff_debugfs = debugfs_create_file("panic_info_buff",
+		S_IFREG | S_IWUSR | S_IWGRP,
+		NULL, NULL, &panic_info_buff_fops);
+	atomic_notifier_chain_register(&panic_notifier_list,
+		&panic_info_buff_block);
+	return 0;
+}
+module_init(panic_info_buff_init);
+
+static void __devexit panic_info_buff_exit(void)
+{
+	debugfs_remove(panic_info_buff_debugfs);
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+		&panic_info_buff_block);
+
+}
+module_exit(panic_info_buff_exit);
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("panic_info_buff");
-- 
1.5.4.3



