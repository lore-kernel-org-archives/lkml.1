Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbYDZTyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbYDZTyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbYDZTyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:54:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758518AbYDZTyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:54:24 -0400
Date: Sat, 26 Apr 2008 21:54:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: [git pull] "big box" x86 changes, boot protocol
Message-ID: <20080426195407.GA13729@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the following x86 changes from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-bootparam.git for-linus

these are boot parameter extensions for really large SGI UV boxes. The 
change was seen and acked by the boot protocol guys. (well, Peter that 
is ;-)

Thanks,

	Ingo

------------------>
Huang, Ying (4):
      x86, boot: add free_early to early reservation machanism
      x86, boot: add linked list of struct setup_data
      x86, boot: export linked list of struct setup_data via debugfs
      x86, boot: Document for linked list of struct setup_data

 Documentation/i386/boot.txt |   26 +++++++
 arch/x86/boot/header.S      |    6 ++-
 arch/x86/kernel/e820_64.c   |   22 ++++++
 arch/x86/kernel/head64.c    |   20 +++++
 arch/x86/kernel/kdebugfs.c  |  163 +++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/setup_64.c  |   24 ++++++
 include/asm-x86/bootparam.h |   14 ++++
 include/asm-x86/e820_64.h   |    1 +
 8 files changed, 270 insertions(+), 6 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 2eb1610..0fac346 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -42,6 +42,8 @@ Protocol 2.05:	(Kernel 2.6.20) Make protected mode kernel relocatable.
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
 		the boot command line
 
+Protocol 2.09:	(kernel 2.6.26) Added a field of 64-bit physical
+		pointer to single linked list of struct	setup_data.
 
 **** MEMORY LAYOUT
 
@@ -172,6 +174,8 @@ Offset	Proto	Name		Meaning
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
 0248/4	2.08+	payload_offset	Offset of kernel payload
 024C/4	2.08+	payload_length	Length of kernel payload
+0250/8	2.09+	setup_data	64-bit physical pointer to linked list
+				of struct setup_data
 
 (1) For backwards compatibility, if the setup_sects field contains 0, the
     real value is 4.
@@ -572,6 +576,28 @@ command line is entered using the following protocol:
 	covered by setup_move_size, so you may need to adjust this
 	field.
 
+Field name:	setup_data
+Type:		write (obligatory)
+Offset/size:	0x250/8
+Protocol:	2.09+
+
+  The 64-bit physical pointer to NULL terminated single linked list of
+  struct setup_data. This is used to define a more extensible boot
+  parameters passing mechanism. The definition of struct setup_data is
+  as follow:
+
+  struct setup_data {
+	  u64 next;
+	  u32 type;
+	  u32 len;
+	  u8  data[0];
+  };
+
+  Where, the next is a 64-bit physical pointer to the next node of
+  linked list, the next field of the last node is 0; the type is used
+  to identify the contents of data; the len is the length of data
+  field; the data holds the real payload.
+
 
 **** MEMORY LAYOUT OF THE REAL-MODE CODE
 
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 6d2df8d..af86e43 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -120,7 +120,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x0208		# header version number (>= 0x0105)
+		.word	0x0209		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -227,6 +227,10 @@ hardware_subarch_data:	.quad 0
 payload_offset:		.long input_data
 payload_length:		.long input_data_end-input_data
 
+setup_data:		.quad 0			# 64-bit physical pointer to
+						# single linked list of
+						# struct setup_data
+
 # End of setup header #####################################################
 
 	.section ".inittext", "ax"
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index cbd42e5..79f0d52 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -84,6 +84,28 @@ void __init reserve_early(unsigned long start, unsigned long end, char *name)
 		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
+void __init free_early(unsigned long start, unsigned long end)
+{
+	struct early_res *r;
+	int i, j;
+
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (start == r->start && end == r->end)
+			break;
+	}
+	if (i >= MAX_EARLY_RES || !early_res[i].end)
+		panic("free_early on not reserved area: %lx-%lx!", start, end);
+
+	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
+		;
+
+	memcpy(&early_res[i], &early_res[i + 1],
+	       (j - 1 - i) * sizeof(struct early_res));
+
+	early_res[j - 1].end = 0;
+}
+
 void __init early_res_to_bootmem(void)
 {
 	int i;
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index d31d6b7..e25c57b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/percpu.h>
 #include <linux/start_kernel.h>
+#include <linux/io.h>
 
 #include <asm/processor.h>
 #include <asm/proto.h>
@@ -100,6 +101,24 @@ static void __init reserve_ebda_region(void)
 	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
 
+static void __init reserve_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+	char buf[32];
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, sizeof(*data));
+		sprintf(buf, "setup data %x", data->type);
+		reserve_early(pa_data, pa_data+sizeof(*data)+data->len, buf);
+		pa_data = data->next;
+		early_iounmap(data, sizeof(*data));
+	}
+}
+
 void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
@@ -156,6 +175,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 #endif
 
 	reserve_ebda_region();
+	reserve_setup_data();
 
 	/*
 	 * At this point everything still needed from the boot loader
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 7335430..c032059 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -6,23 +6,171 @@
  *
  * This file is released under the GPLv2.
  */
-
 #include <linux/debugfs.h>
+#include <linux/uaccess.h>
 #include <linux/stat.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/mm.h>
 
 #include <asm/setup.h>
 
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
+struct setup_data_node {
+	u64 paddr;
+	u32 type;
+	u32 len;
+};
+
+static ssize_t
+setup_data_read(struct file *file, char __user *user_buf, size_t count,
+		loff_t *ppos)
+{
+	struct setup_data_node *node = file->private_data;
+	unsigned long remain;
+	loff_t pos = *ppos;
+	struct page *pg;
+	void *p;
+	u64 pa;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= node->len)
+		return 0;
+
+	if (count > node->len - pos)
+		count = node->len - pos;
+	pa = node->paddr + sizeof(struct setup_data) + pos;
+	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
+	if (PageHighMem(pg)) {
+		p = ioremap_cache(pa, count);
+		if (!p)
+			return -ENXIO;
+	} else {
+		p = __va(pa);
+	}
+
+	remain = copy_to_user(user_buf, p, count);
+
+	if (PageHighMem(pg))
+		iounmap(p);
+
+	if (remain)
+		return -EFAULT;
+
+	*ppos = pos + count;
+
+	return count;
+}
+
+static int setup_data_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations fops_setup_data = {
+	.read =		setup_data_read,
+	.open =		setup_data_open,
+};
+
+static int __init
+create_setup_data_node(struct dentry *parent, int no,
+		       struct setup_data_node *node)
+{
+	struct dentry *d, *type, *data;
+	char buf[16];
+	int error;
+
+	sprintf(buf, "%d", no);
+	d = debugfs_create_dir(buf, parent);
+	if (!d) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+	type = debugfs_create_x32("type", S_IRUGO, d, &node->type);
+	if (!type) {
+		error = -ENOMEM;
+		goto err_dir;
+	}
+	data = debugfs_create_file("data", S_IRUGO, d, node, &fops_setup_data);
+	if (!data) {
+		error = -ENOMEM;
+		goto err_type;
+	}
+	return 0;
+
+err_type:
+	debugfs_remove(type);
+err_dir:
+	debugfs_remove(d);
+err_return:
+	return error;
+}
+
+static int __init create_setup_data_nodes(struct dentry *parent)
+{
+	struct setup_data_node *node;
+	struct setup_data *data;
+	int error, no = 0;
+	struct dentry *d;
+	struct page *pg;
+	u64 pa_data;
+
+	d = debugfs_create_dir("setup_data", parent);
+	if (!d) {
+		error = -ENOMEM;
+		goto err_return;
+	}
+
+	pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		if (!node) {
+			error = -ENOMEM;
+			goto err_dir;
+		}
+		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
+		if (PageHighMem(pg)) {
+			data = ioremap_cache(pa_data, sizeof(*data));
+			if (!data) {
+				error = -ENXIO;
+				goto err_dir;
+			}
+		} else {
+			data = __va(pa_data);
+		}
+
+		node->paddr = pa_data;
+		node->type = data->type;
+		node->len = data->len;
+		error = create_setup_data_node(d, no, node);
+		pa_data = data->next;
+
+		if (PageHighMem(pg))
+			iounmap(data);
+		if (error)
+			goto err_dir;
+		no++;
+	}
+	return 0;
+
+err_dir:
+	debugfs_remove(d);
+err_return:
+	return error;
+}
+
 static struct debugfs_blob_wrapper boot_params_blob = {
-	.data = &boot_params,
-	.size = sizeof(boot_params),
+	.data		= &boot_params,
+	.size		= sizeof(boot_params),
 };
 
 static int __init boot_params_kdebugfs_init(void)
 {
-	int error;
 	struct dentry *dbp, *version, *data;
+	int error;
 
 	dbp = debugfs_create_dir("boot_params", NULL);
 	if (!dbp) {
@@ -41,7 +189,13 @@ static int __init boot_params_kdebugfs_init(void)
 		error = -ENOMEM;
 		goto err_version;
 	}
+	error = create_setup_data_nodes(dbp);
+	if (error)
+		goto err_data;
 	return 0;
+
+err_data:
+	debugfs_remove(data);
 err_version:
 	debugfs_remove(version);
 err_dir:
@@ -61,5 +215,4 @@ static int __init arch_kdebugfs_init(void)
 
 	return error;
 }
-
 arch_initcall(arch_kdebugfs_init);
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 17bdf23..b04e2c0 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -264,6 +264,28 @@ void __attribute__((weak)) __init memory_setup(void)
        machine_specific_memory_setup();
 }
 
+static void __init parse_setup_data(void)
+{
+	struct setup_data *data;
+	unsigned long pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return;
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = early_ioremap(pa_data, PAGE_SIZE);
+		switch (data->type) {
+		default:
+			break;
+		}
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+		free_early(pa_data, pa_data+sizeof(*data)+data->len);
+#endif
+		pa_data = data->next;
+		early_iounmap(data, PAGE_SIZE);
+	}
+}
+
 /*
  * setup_arch - architecture-specific boot-time initializations
  *
@@ -316,6 +338,8 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	parse_setup_data();
+
 	parse_early_param();
 
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
diff --git a/include/asm-x86/bootparam.h b/include/asm-x86/bootparam.h
index 5115135..e865990 100644
--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -9,6 +9,17 @@
 #include <asm/ist.h>
 #include <video/edid.h>
 
+/* setup data types */
+#define SETUP_NONE			0
+
+/* extensible setup data list node */
+struct setup_data {
+	u64 next;
+	u32 type;
+	u32 len;
+	u8 data[0];
+};
+
 struct setup_header {
 	__u8	setup_sects;
 	__u16	root_flags;
@@ -46,6 +57,9 @@ struct setup_header {
 	__u32	cmdline_size;
 	__u32	hardware_subarch;
 	__u64	hardware_subarch_data;
+	__u32	payload_offset;
+	__u32	payload_length;
+	__u64	setup_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
diff --git a/include/asm-x86/e820_64.h b/include/asm-x86/e820_64.h
index f478c57..b5e02e3 100644
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -48,6 +48,7 @@ extern struct e820map e820;
 extern void update_e820(void);
 
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
+extern void free_early(unsigned long start, unsigned long end);
 extern void early_res_to_bootmem(void);
 
 #endif/*!__ASSEMBLY__*/

