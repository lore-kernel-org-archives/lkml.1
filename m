Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbXITRT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbXITRT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756001AbXITRSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:18:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:50648 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbXITRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:18:47 -0400
Message-Id: <20070920171846.062209000@stravinsky.suse.de>
References: <20070920171845.774383000@stravinsky.suse.de>
User-Agent: quilt/0.46-47.1
Date: Thu, 20 Sep 2007 19:18:46 +0200
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [patch 1/7] Extended crashkernel command line
Content-Disposition: inline; filename=crashkernel-generic
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is the generic part of the patch. It adds a parse_crashkernel() function
in kernel/kexec.c that is called by the architecture specific code that
actually reserves the memory. That function takes the whole command line and
looks itself for "crashkernel=" in it.

If there are multiple occurrences, then the last one is taken.  The advantage
is that if you have a bootloader like lilo or elilo which allows you to append
a command line parameter but not to remove one (like in GRUB), then you can add
another crashkernel value for testing at the boot command line and this one
overwrites the command line in the configuration then.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 include/linux/kexec.h |    2 
 kernel/kexec.c        |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -179,6 +179,8 @@ extern note_buf_t *crash_notes;
 extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 extern unsigned int vmcoreinfo_size;
 extern unsigned int vmcoreinfo_max_size;
+int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
+		unsigned long long *crash_size, unsigned long long *crash_base);
 
 
 #else /* !CONFIG_KEXEC */
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1146,6 +1146,147 @@ static int __init crash_notes_memory_ini
 }
 module_init(crash_notes_memory_init)
 
+
+/*
+ * parsing the "crashkernel" commandline
+ *
+ * this code is intended to be called from architecture specific code
+ */
+
+
+/*
+ * This function parses command lines in the format
+ *
+ *   crashkernel=<ramsize-range>:<size>[,...][@<base>]
+ *
+ * The function returns 0 on success and -EINVAL on failure.
+ */
+static int __init parse_crashkernel_mem(char 			*cmdline,
+					unsigned long 		system_ram,
+					unsigned long long 	*crash_size,
+					unsigned long long 	*crash_base)
+{
+	char *cur = cmdline;
+
+	/* for each entry of the comma-separated list */
+	do {
+		unsigned long long start = 0, end = ULLONG_MAX;
+		unsigned long long size = -1;
+
+		/* get the start of the range */
+		start = memparse(cur, &cur);
+		if (*cur != '-') {
+			printk(KERN_WARNING "crashkernel: '-' expected\n");
+			return -EINVAL;
+		}
+		cur++;
+
+		/* if no ':' is here, than we read the end */
+		if (*cur != ':') {
+			end = memparse(cur, &cur);
+			if (end <= start) {
+				printk(KERN_WARNING "crashkernel: end <= start\n");
+				return -EINVAL;
+			}
+		}
+
+		if (*cur != ':') {
+			printk(KERN_WARNING "crashkernel: ':' expected\n");
+			return -EINVAL;
+		}
+		cur++;
+
+		size = memparse(cur, &cur);
+		if (size < 0) {
+			printk(KERN_WARNING "crashkernel: invalid size\n");
+			return -EINVAL;
+		}
+
+		/* match ? */
+		if (system_ram >= start  && system_ram <= end) {
+			*crash_size = size;
+			break;
+		}
+	} while (*cur++ == ',');
+
+	if (*crash_size > 0) {
+		while (*cur != ' ' && *cur != '@')
+			cur++;
+		if (*cur == '@')
+			*crash_base = memparse(cur+1, &cur);
+	}
+
+	return 0;
+}
+
+/*
+ * That function parses "simple" (old) crashkernel command lines like
+ *
+ * 	crashkernel=size[@base]
+ *
+ * It returns 0 on success and -EINVAL on failure.
+ */
+static int __init parse_crashkernel_simple(char 		*cmdline,
+					   unsigned long long 	*crash_size,
+					   unsigned long long 	*crash_base)
+{
+	char *cur = cmdline;
+
+	*crash_size = memparse(cmdline, &cur);
+	if (cmdline == cur)
+		return -EINVAL;
+
+	if (*cur == '@')
+		*crash_base = memparse(cur+1, &cur);
+
+	return 0;
+}
+
+/*
+ * That function is the entry point for command line parsing and should be
+ * called from the arch-specific code.
+ */
+int __init parse_crashkernel(char 		 *cmdline,
+			     unsigned long long system_ram,
+			     unsigned long long *crash_size,
+			     unsigned long long *crash_base)
+{
+	char 	*p = cmdline, *ck_cmdline = NULL;
+	char	*first_colon, *first_space;
+
+	*crash_size = 0;
+	*crash_base = 0;
+
+	/* find crashkernel and use the last one if there are more */
+	p = strstr(p, "crashkernel=");
+	while (p) {
+		ck_cmdline = p;
+		p = strstr(p+1, "crashkernel=");
+	}
+
+	if (!ck_cmdline)
+		return -EINVAL;
+
+	ck_cmdline += 12; /* strlen("crashkernel=") */
+
+	/*
+	 * if the commandline contains a ':', then that's the extended
+	 * syntax -- if not, it must be the classic syntax
+	 */
+	first_colon = strchr(ck_cmdline, ':');
+	first_space = strchr(ck_cmdline, ' ');
+	if (first_colon && (!first_space || first_colon < first_space))
+		return parse_crashkernel_mem(ck_cmdline, system_ram,
+				crash_size, crash_base);
+	else
+		return parse_crashkernel_simple(ck_cmdline, crash_size,
+				crash_base);
+
+	return 0;
+}
+
+
+
 void crash_save_vmcoreinfo(void)
 {
 	u32 *buf;

-- 
