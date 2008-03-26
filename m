Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYCZPxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYCZPxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 11:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYCZPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 11:52:57 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:54535 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYCZPw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 11:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rEiH3mrdgWjcNOS7nOPZpbn7wKeOGV7Jeyaz7OaS1U56u2E1Ubfq/zJyzC59lCOQCLbraa4RbdtlCxURhxJ3AETuwKcxCafFcIglmBT5rsC6FhTf/fhKTukSnC/KEiIFNkK2uX8fYN8ocy//kt9Zo+ZKewFug6tIqwNgFFyvhRY=
Date: Wed, 26 Mar 2008 18:52:44 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hskinnemoen@atmel.com, domen.puncer@telargo.com,
       lethal@linux-sh.org, tony@atomide.com, rmk+kernel@arm.linux.org.uk,
       paul@pwsan.com
Subject: [PATCH 2/3] Clocklib: debugfs support
Message-ID: <20080326155244.GA15418@doriath.ww600.siemens.net>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326154913.GA15326@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide /sys/kernel/debug/clock to ease debugging.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 include/linux/clklib.h |    5 +++
 kernel/clklib.c        |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/include/linux/clklib.h b/include/linux/clklib.h
index 92f0a45..f9c1db4 100644
--- a/include/linux/clklib.h
+++ b/include/linux/clklib.h
@@ -30,6 +30,11 @@ struct clk {
 	int (*setrate)	(struct clk *, unsigned long);
 	long (*roundrate) (struct clk *, unsigned long);
 
+	/*
+	 * format any additional info
+	 */
+	int (*format)	(struct clk *, struct seq_file *);
+
 	void		*priv;
 };
 
diff --git a/kernel/clklib.c b/kernel/clklib.c
index b41e7c2..1c52e55 100644
--- a/kernel/clklib.c
+++ b/kernel/clklib.c
@@ -313,3 +313,73 @@ out:
 	return rc;
 }
 EXPORT_SYMBOL(clk_alloc_function);
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+static void dump_clocks(struct seq_file *s, struct clk *parent, int nest)
+{
+	struct clk *clk;
+	int i;
+
+	list_for_each_entry(clk, &clocks, node) {
+		if (clk->parent == parent) {
+			for (i = 0; i < nest; i++)
+				seq_putc(s, ' ');
+			seq_puts(s, clk->name);
+
+			i = nest + strlen(clk->name);
+			if (i >= 16)
+				i = 15;
+			for (; i < 16; i++) {
+				seq_putc(s, ' ');
+				seq_putc(s, ' ');
+			}
+			seq_printf(s, "%c use=%d rate=%10lu Hz",
+				clk->set_parent ? '*' : ' ',
+				clk->users,
+				__clk_get_rate(clk));
+			if (clk->format)
+				clk->format(clk, s);
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

