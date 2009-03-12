Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZCLHrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZCLHrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZCLHrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:47:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57980 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbZCLHrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:47:12 -0400
Subject: Re: [git-pull -tip] x86: cpu_debug support read-write opertaions
 for PMC
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236842076.12116.7.camel@ht.satnam>
References: <1236807253.15646.11.camel@ht.satnam>
	 <1236842076.12116.7.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 13:16:21 +0530
Message-Id: <1236843981.12116.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 12:44 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-12 at 03:04 +0530, Jaswinder Singh Rajput wrote:
> > Currently I added read-write operations for PMC MSRs for cpu_debug:
> 
> Now I made generic write support by adding write flag for registers.
> currently write is enabled only for PMC MSR but we can also support
> another MSRs just changing the write flag.

Here some more cleanups and comment to avoid confusions, and then new
request pull:

Log is available at:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-cpu.git;a=commit;h=1fdb3c7038d8bde067f56d43705ea24e866c9673

The following changes since commit 8851485ba842e892adfa343463ce6b74550bb8b1:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git master

Jaswinder Singh Rajput (1):
      x86: cpu_debug add write support for MSRs

 arch/x86/include/asm/cpu_debug.h |   16 ++++--
 arch/x86/kernel/cpu/cpu_debug.c  |  118 +++++++++++++++++++++++++++----------
 2 files changed, 97 insertions(+), 37 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index d24d64f..56f1635 100755
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -171,16 +171,22 @@ struct cpu_private {
 struct cpu_debug_base {
 	char			*name;		/* Register name	*/
 	unsigned		flag;		/* Register flag	*/
+	unsigned		write;		/* Register write flag	*/
 };
 
-struct cpu_cpuX_base {
-	struct dentry		*dentry;	/* Register dentry	*/
-	int			init;		/* Register index file	*/
-};
-
+/*
+ * Currently it looks similar to cpu_debug_base but once we add more files
+ * cpu_file_base will go in different direction
+ */
 struct cpu_file_base {
 	char			*name;		/* Register file name	*/
 	unsigned		flag;		/* Register file flag	*/
+	unsigned		write;		/* Register write flag	*/
+};
+
+struct cpu_cpuX_base {
+	struct dentry		*dentry;	/* Register dentry	*/
+	int			init;		/* Register index file	*/
 };
 
 struct cpu_debug_range {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 9abbcbd..21c0cf8 100755
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
@@ -40,41 +41,41 @@ static DEFINE_MUTEX(cpu_debug_lock);
 static struct dentry *cpu_debugfs_dir;
 
 static struct cpu_debug_base cpu_base[] = {
-	{ "mc",		CPU_MC		},	/* Machine Check	*/
-	{ "monitor",	CPU_MONITOR	},	/* Monitor		*/
-	{ "time",	CPU_TIME	},	/* Time			*/
-	{ "pmc",	CPU_PMC		},	/* Performance Monitor	*/
-	{ "platform",	CPU_PLATFORM	},	/* Platform		*/
-	{ "apic",	CPU_APIC	},	/* APIC			*/
-	{ "poweron",	CPU_POWERON	},	/* Power-on		*/
-	{ "control",	CPU_CONTROL	},	/* Control		*/
-	{ "features",	CPU_FEATURES	},	/* Features control	*/
-	{ "lastbranch",	CPU_LBRANCH	},	/* Last Branch		*/
-	{ "bios",	CPU_BIOS	},	/* BIOS			*/
-	{ "freq",	CPU_FREQ	},	/* Frequency		*/
-	{ "mtrr",	CPU_MTRR	},	/* MTRR			*/
-	{ "perf",	CPU_PERF	},	/* Performance		*/
-	{ "cache",	CPU_CACHE	},	/* Cache		*/
-	{ "sysenter",	CPU_SYSENTER	},	/* Sysenter		*/
-	{ "therm",	CPU_THERM	},	/* Thermal		*/
-	{ "misc",	CPU_MISC	},	/* Miscellaneous	*/
-	{ "debug",	CPU_DEBUG	},	/* Debug		*/
-	{ "pat",	CPU_PAT		},	/* PAT			*/
-	{ "vmx",	CPU_VMX		},	/* VMX			*/
-	{ "call",	CPU_CALL	},	/* System Call		*/
-	{ "base",	CPU_BASE	},	/* BASE Address		*/
-	{ "smm",	CPU_SMM		},	/* System mgmt mode	*/
-	{ "svm",	CPU_SVM		},	/*Secure Virtial Machine*/
-	{ "osvm",	CPU_OSVM	},	/* OS-Visible Workaround*/
-	{ "tss",	CPU_TSS		},	/* Task Stack Segment	*/
-	{ "cr",		CPU_CR		},	/* Control Registers	*/
-	{ "dt",		CPU_DT		},	/* Descriptor Table	*/
-	{ "registers",	CPU_REG_ALL	},	/* Select all Registers	*/
+	{ "mc",		CPU_MC,		0	},
+	{ "monitor",	CPU_MONITOR,	0	},
+	{ "time",	CPU_TIME,	0	},
+	{ "pmc",	CPU_PMC,	1	},
+	{ "platform",	CPU_PLATFORM,	0	},
+	{ "apic",	CPU_APIC,	0	},
+	{ "poweron",	CPU_POWERON,	0	},
+	{ "control",	CPU_CONTROL,	0	},
+	{ "features",	CPU_FEATURES,	0	},
+	{ "lastbranch",	CPU_LBRANCH,	0	},
+	{ "bios",	CPU_BIOS,	0	},
+	{ "freq",	CPU_FREQ,	0	},
+	{ "mtrr",	CPU_MTRR,	0	},
+	{ "perf",	CPU_PERF,	0	},
+	{ "cache",	CPU_CACHE,	0	},
+	{ "sysenter",	CPU_SYSENTER,	0	},
+	{ "therm",	CPU_THERM,	0	},
+	{ "misc",	CPU_MISC,	0	},
+	{ "debug",	CPU_DEBUG,	0	},
+	{ "pat",	CPU_PAT,	0	},
+	{ "vmx",	CPU_VMX,	0	},
+	{ "call",	CPU_CALL,	0	},
+	{ "base",	CPU_BASE,	0	},
+	{ "smm",	CPU_SMM,	0	},
+	{ "svm",	CPU_SVM,	0	},
+	{ "osvm",	CPU_OSVM,	0	},
+	{ "tss",	CPU_TSS,	0	},
+	{ "cr",		CPU_CR,		0	},
+	{ "dt",		CPU_DT,		0	},
+	{ "registers",	CPU_REG_ALL,	0	},
 };
 
 static struct cpu_file_base cpu_file[] = {
-	{ "index",	CPU_REG_ALL	},	/* index		*/
-	{ "value",	CPU_REG_ALL	},	/* value		*/
+	{ "index",	CPU_REG_ALL,	0	},
+	{ "value",	CPU_REG_ALL,	1	},
 };
 
 /* Intel Registers Range */
@@ -608,9 +609,62 @@ static int cpu_seq_open(struct inode *inode, struct file *file)
 	return err;
 }
 
+static int write_msr(struct cpu_private *priv, u64 val)
+{
+	u32 low, high;
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
+static int write_cpu_register(struct cpu_private *priv, const char *buf)
+{
+	int ret = -EPERM;
+	u64 val;
+
+	ret = strict_strtoull(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	/* Supporting only MSRs */
+	if (priv->type < CPU_TSS_BIT)
+		return write_msr(priv, val);
+
+	return ret;
+}
+
+static ssize_t cpu_write(struct file *file, const char __user *ubuf,
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
+	if ((cpu_base[priv->type].write) && (cpu_file[priv->file].write))
+		if (!write_cpu_register(priv, buf))
+			return count;
+
+	return -EACCES;
+}
+
 static const struct file_operations cpu_fops = {
+	.owner		= THIS_MODULE,
 	.open		= cpu_seq_open,
 	.read		= seq_read,
+	.write		= cpu_write,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };


