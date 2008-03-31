Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYCaIo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYCaIo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYCaIor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:44:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:35092 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbYCaIoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eaRvqVYTZNXyHcOJw48S3cSM61dY3dn+XTXMSPnpJkvdGrMK6AtU73HLYLis26fTpvOyVDcj4OTbG5PPP3hmlyvJTAyukNZpx3Tg1Gvbi1sKAj2FXyS/cZeeplR6SXHe9GvoM4IK7L6l2YnzXbKTAEZv8Ya/PSWlNaBLbGbP+2Y=
Date: Mon, 31 Mar 2008 12:44:38 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 2/6] Clocklib: debugfs support
Message-ID: <20080331084438.GA11626@doriath.ww600.siemens.net>
References: <20080331083947.GA11282@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331083947.GA11282@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide /sys/kernel/debug/clock to ease debugging.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 include/linux/clklib.h |    2 +
 kernel/clklib.c        |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/include/linux/clklib.h b/include/linux/clklib.h
index 88ab2c1..9f1c636 100644
--- a/include/linux/clklib.h
+++ b/include/linux/clklib.h
@@ -19,6 +19,7 @@ struct seq_file;
  * @get_rate: obtain the current clock rate of a specified clock
  * @set_rate: set the clock rate for a specified clock
  * @round_rate: adjust a reate to the exact rate a clock can provide
+ * @format: output any additional information for a clock
  *
  * This structure specifies clock operations that are used to configure
  * specific clock.
@@ -30,6 +31,7 @@ struct clk_ops {
 	unsigned long (*get_rate) (struct clk *clk);
 	int (*set_rate)  (struct clk *, unsigned long);
 	long (*round_rate) (struct clk *, unsigned long);
+	int (*format)	(struct clk *, struct seq_file *);
 };
 
 /**
diff --git a/kernel/clklib.c b/kernel/clklib.c
index 012f845..8d872e1 100644
--- a/kernel/clklib.c
+++ b/kernel/clklib.c
@@ -324,3 +324,77 @@ out:
 	return rc;
 }
 EXPORT_SYMBOL(clk_alloc_function);
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#define NAME_FIELD_LEN	20
+
+static void dump_clocks(struct seq_file *s, struct clk *parent, int nest)
+{
+	struct clk *clk;
+	int i;
+
+	list_for_each_entry(clk, &clocks, node) {
+		if (clk->parent == parent) {
+			for (i = 0; i < nest; i++) {
+				seq_putc(s, ' ');
+				seq_putc(s, ' ');
+			}
+			seq_puts(s, clk->name);
+
+			i = 2 * nest + strlen(clk->name);
+			if (i >= NAME_FIELD_LEN)
+				i = NAME_FIELD_LEN - 1;
+			for (; i < NAME_FIELD_LEN; i++) {
+				seq_putc(s, ' ');
+			}
+			seq_printf(s, "%c use=%d rate=%10lu Hz",
+				clk->ops && clk->ops->set_parent ? '*' : ' ',
+				clk->users,
+				__clk_get_rate(clk));
+			if (clk->ops && clk->ops->format)
+				clk->ops->format(clk, s);
+			seq_putc(s, '\n');
+
+			dump_clocks(s, clk, nest + 1);
+		}
+	}
+}
+
+static int clocklib_show(struct seq_file *s, void *unused)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&clocks_lock, flags);
+
+	dump_clocks(s, NULL, 0);
+
+	spin_unlock_irqrestore(&clocks_lock, flags);
+
+	return 0;
+}
+
+static int clocklib_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, clocklib_show, NULL);
+}
+
+static struct file_operations clocklib_operations = {
+	.open		= clocklib_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init clocklib_debugfs_init(void)
+{
+	debugfs_create_file("clock", S_IFREG | S_IRUGO,
+				NULL, NULL, &clocklib_operations);
+	return 0;
+}
+subsys_initcall(clocklib_debugfs_init);
+
+#endif /* DEBUG_FS */
-- 
1.5.4.4


-- 
With best wishes
Dmitry

