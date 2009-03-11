Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZCKVey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZCKVey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZCKVep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:34:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:41584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZCKVeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:34:44 -0400
Subject: [git-pull -tip] x86: cpu_debug support read-write opertaions for
 PMC
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 03:04:13 +0530
Message-Id: <1236807253.15646.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently I added read-write operations for PMC MSRs for cpu_debug:

[root@ht]# cat /sys/kernel/debug/x86/cpu/cpu1/pmc/0x300/value
0x0

[root@ht]# cat /sys/kernel/debug/x86/cpu/cpu1/pmc/0x300/value
0x0

[root@ht]# echo 1234 > /sys/kernel/debug/x86/cpu/cpu1/pmc/0x300/value
[root@ht]# cat /sys/kernel/debug/x86/cpu/cpu1/pmc/0x300/value
0x4d2

[root@ht]# echo 0x1234 > /sys/kernel/debug/x86/cpu/cpu1/pmc/0x300/value
[root@ht]# cat /sys/kernel/debug/x86/cpu/cpu1/pmc/0x300/value
0x1234

Should I also add write operations for other registers.

The following changes since commit 8851485ba842e892adfa343463ce6b74550bb8b1:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git master

Jaswinder Singh Rajput (1):
      x86: cpu_debug support read-write opertaions for PMC

 arch/x86/kernel/cpu/cpu_debug.c |   45 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 9abbcbd..032ab9b 100755
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -11,6 +11,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kprobes.h>
+#include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
@@ -608,9 +609,53 @@ static int cpu_seq_open(struct inode *inode, struct file *file)
 	return err;
 }
 
+static int write_msr(struct cpu_private *priv, const char *buf)
+{
+	u32 low, high;
+	int ret;
+	u64 val;
+
+	ret = strict_strtoull(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	high = (val >> 32) & 0xffffffff;
+	low = val & 0xffffffff;
+
+	if (!wrmsr_safe_on_cpu(priv->cpu, priv->reg, low, high))
+		return 0;
+
+	return -EPERM;
+}
+
+static ssize_t cpu_seq_write(struct file *file, const char __user *ubuf,
+			     size_t count, loff_t *off)
+{
+	struct seq_file *seq = file->private_data;
+	struct cpu_private *priv = seq->private;
+	char buf[19];
+
+	if ((priv == NULL) || (count >= sizeof(buf)))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, count))
+		return -EFAULT;
+
+	buf[count] = 0;
+
+	/* Supporting only PMC */
+	if ((cpu_base[priv->type].flag == CPU_PMC) && (priv->file))
+		if (!write_msr(priv, buf))
+			return count;
+
+	return -EACCES;
+}
+
 static const struct file_operations cpu_fops = {
+	.owner		= THIS_MODULE,
 	.open		= cpu_seq_open,
 	.read		= seq_read,
+	.write		= cpu_seq_write,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };


