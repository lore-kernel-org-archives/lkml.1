Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbXGJQw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbXGJQw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXGJQwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:52:18 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:34310 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbXGJQwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:52:17 -0400
Date: Tue, 10 Jul 2007 19:52:01 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Neil Horman <nhorman@redhat.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070710165201.GA7984@localdomain>
References: <20070706132814.GA7079@suse.de> <20070706145804.GA31409@localdomain> <20070710064817.GC5471@in.ibm.com> <20070710120904.GB10121@hmsendeavour.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20070710120904.GB10121@hmsendeavour.rdu.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 10, 2007 at 08:09:04AM -0400, Neil Horman wrote:
> On Tue, Jul 10, 2007 at 12:18:17PM +0530, Vivek Goyal wrote:
> > On Fri, Jul 06, 2007 at 05:58:04PM +0300, Dan Aloni wrote:
> > > On Fri, Jul 06, 2007 at 03:28:14PM +0200, Bernhard Walle wrote:
> > > > Hello,
[...]
> > > It contains enough information in order to make a compact kernel
> > > dump (makedumpinfo needs to go over the struct page arrays). As
> > > you see, it also contains the kernel version.
> > > 
> > 
> > But this will not solve Bernhard's problem where looking at a vmcore
> > he wants to know which vmlinux (kernel version with time stamp) has
> > generated this vmcore. So adding a ELF NOTE should help.
> > 
> I think an ELF note would be a fine idea.

Okay, so here's an implemenation.

See the attached proof-of-concept patches to the kernel-side kexec and 
kexec-tools (might need some cleanup though). Next to follow, a patch 
to makedumpfile. With these patches a new "LINUX" elf note generated 
by the kernel in the format that makedumpfile expects and is being 
passed on by the kexec util to the kdump kernel.

As a bonus, with this patch you don't even have to compile the kernel 
with debug information in order for the filtering to work.

As Vivek mentioned in another mail, the output of makedumpfile is not
really a standard. However, I believe we should start making standards
where no standard exists. :)

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il

--ibTvN161/egqYuK8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="kernel-kexec-mkdfinfo-note.diff"

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 8c2c7fc..a0412ce 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -121,6 +121,8 @@ extern struct page *kimage_alloc_control_pages(struct kimage *image,
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
+void crash_save_mkdfinfo(void);
+
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
@@ -153,7 +155,10 @@ extern struct kimage *kexec_crash_image;
 extern struct resource crashk_res;
 typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
 extern note_buf_t *crash_notes;
-
+extern unsigned char mkdfinfo_data[MAX_NOTE_BYTES];
+extern unsigned int mkdfinfo_size;
+extern unsigned int mkdfinfo_max_size;
+extern note_buf_t mkdfinfo_note;
 
 #else /* !CONFIG_KEXEC */
 struct pt_regs;
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 25db14b..25228e3 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -22,6 +22,8 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/utsrelease.h>
+#include <linux/utsname.h> 
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -32,6 +34,12 @@
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
 
+/* mkdfinfo stuff */
+unsigned char mkdfinfo_data[MAX_NOTE_BYTES];
+unsigned int mkdfinfo_size = 0;
+unsigned int mkdfinfo_max_size = sizeof(mkdfinfo_data);
+note_buf_t mkdfinfo_note;
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1062,6 +1070,7 @@ void crash_kexec(struct pt_regs *regs)
 			struct pt_regs fixed_regs;
 			crash_setup_regs(&fixed_regs, regs);
 			machine_crash_shutdown(&fixed_regs);
+			crash_save_mkdfinfo();
 			machine_kexec(kexec_crash_image);
 		}
 		locked = xchg(&kexec_lock, 0);
@@ -1135,3 +1144,88 @@ static int __init crash_notes_memory_init(void)
 	return 0;
 }
 module_init(crash_notes_memory_init)
+
+void crash_save_mkdfinfo(void)
+{
+	u32 *buf;
+
+	if (!mkdfinfo_size)
+		return;
+
+	buf = (u32 *)mkdfinfo_note;
+	buf = append_elf_note(buf, "LINUX", 0, mkdfinfo_data,
+			      mkdfinfo_size);
+	final_note(buf);
+}
+
+void mkdfinfo_append_str(const char *fmt, ...)
+{
+	va_list args;
+	char buf[0x50];
+	int r;
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+	
+	if (r + mkdfinfo_size > mkdfinfo_max_size)
+		r = mkdfinfo_max_size - mkdfinfo_size;
+
+	memcpy(&mkdfinfo_data[mkdfinfo_size], buf, r);
+
+	mkdfinfo_size += r;
+}
+
+#define SYMBOL(name) \
+	mkdfinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
+#define SIZE(name) \
+	mkdfinfo_append_str("SIZE(%s)=%d\n", #name, sizeof(struct name))
+#define OFFSET(name, field) \
+	mkdfinfo_append_str("OFFSET(%s.%s)=%d\n", #name, #field, &(((struct name *)0)->field))
+#define LENGTH(name, field) \
+	mkdfinfo_append_str("LENGTH(%s.%s)=%d\n", #name, #field, sizeof(((struct name *)0)->field))
+
+static int __init crash_save_mkdfinfo_init(void)
+{
+	extern char _stext;
+
+	mkdfinfo_append_str("OSRELEASE=%s\n", UTS_RELEASE);
+	mkdfinfo_append_str("PAGESIZE=%d\n", PAGE_SIZE);
+
+	SYMBOL(mem_map);
+	SYMBOL(init_uts_ns);
+	SYMBOL(_stext);
+	SYMBOL(node_online_map);
+	SYMBOL(contig_page_data);
+	SIZE(page);
+	SIZE(pglist_data);
+	SIZE(zone);
+	SIZE(free_area);
+	SIZE(list_head);
+	OFFSET(page, flags);
+	OFFSET(page, _count);
+	OFFSET(page, mapping);
+	OFFSET(page, lru);
+	OFFSET(pglist_data, node_zones);
+	OFFSET(pglist_data, nr_zones);
+	OFFSET(pglist_data, node_mem_map);
+	OFFSET(pglist_data, node_start_pfn);
+	OFFSET(pglist_data, node_spanned_pages);
+	OFFSET(zone, free_area);
+	OFFSET(zone, vm_stat);
+	OFFSET(zone, spanned_pages);
+	OFFSET(free_area, free_list);
+	OFFSET(list_head, next);
+	OFFSET(list_head, prev);
+	LENGTH(zone, free_area);
+
+#ifdef __PAGETABLE_PUD_FOLDED
+	mkdfinfo_append_str("SRCFILE(pud_t)=include/asm-generic/pgtable-nopud.h\n");
+#else
+	mkdfinfo_append_str("SRCFILE(pud_t)=include/asm/page.h\n");
+#endif
+
+	return 0;
+}
+
+module_init(crash_save_mkdfinfo_init)
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 559deca..70ddca2 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -60,6 +60,15 @@ static ssize_t kexec_crash_loaded_show(struct kset *kset, char *page)
 	return sprintf(page, "%d\n", !!kexec_crash_image);
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
+
+static ssize_t mkdfinfo_show(struct subsystem *subsys, char *page)
+{
+	return sprintf(page, "%lx %x\n", 
+		       __pa((unsigned long)(char *)&mkdfinfo_note), 
+		       MAX_NOTE_BYTES);
+}
+KERNEL_ATTR_RO(mkdfinfo);
+
 #endif /* CONFIG_KEXEC */
 
 decl_subsys(kernel, NULL, NULL);
@@ -73,6 +82,7 @@ static struct attribute * kernel_attrs[] = {
 #ifdef CONFIG_KEXEC
 	&kexec_loaded_attr.attr,
 	&kexec_crash_loaded_attr.attr,
+	&mkdfinfo_attr.attr,
 #endif
 	NULL
 };

--ibTvN161/egqYuK8
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="kexec-tools-mkdfinfo-note.diff"

diff --git a/kexec/crashdump-elf.c b/kexec/crashdump-elf.c
index c048f75..e77b9db 100644
--- a/kexec/crashdump-elf.c
+++ b/kexec/crashdump-elf.c
@@ -34,6 +34,8 @@ int FUNC(struct kexec_info *info,
 	char *bufp;
 	long int nr_cpus = 0;
 	uint64_t notes_addr, notes_len;
+	uint64_t mkdfinfo_addr, mkdfinfo_len;
+	int has_mkdfinfo = 0;
 	int (*get_note_info)(int cpu, uint64_t *addr, uint64_t *len);
 
 	if (xen_present())
@@ -45,7 +47,11 @@ int FUNC(struct kexec_info *info,
 		return -1;
 	}
 
-	sz = sizeof(EHDR) + nr_cpus * sizeof(PHDR) + ranges * sizeof(PHDR);
+	if (get_kernel_mkdfinfo( &mkdfinfo_addr, &mkdfinfo_len) == 0) {
+		has_mkdfinfo = 1;
+	}
+
+	sz = sizeof(EHDR) + (nr_cpus + has_mkdfinfo) * sizeof(PHDR) + ranges * sizeof(PHDR);
 
 	/*
 	 * Certain architectures such as x86_64 and ia64 require a separate
@@ -146,6 +152,21 @@ int FUNC(struct kexec_info *info,
 		dbgprintf_phdr("Elf header", phdr);
 	}
 
+	if (has_mkdfinfo) {
+		phdr = (PHDR *) bufp;
+		bufp += sizeof(PHDR);
+		phdr->p_type	= PT_NOTE;
+		phdr->p_flags	= 0;
+		phdr->p_offset  = phdr->p_paddr = mkdfinfo_addr;
+		phdr->p_vaddr   = 0;
+		phdr->p_filesz	= phdr->p_memsz	= mkdfinfo_len;
+		/* Do we need any alignment of segments? */
+		phdr->p_align	= 0;
+
+		(elf->e_phnum)++;
+		dbgprintf_phdr("mkde header", phdr);
+	}
+
 	/* Setup an PT_LOAD type program header for the region where
 	 * Kernel is mapped if info->kern_size is non-zero.
 	 */
diff --git a/kexec/crashdump.c b/kexec/crashdump.c
index 1c08606..7a46efa 100644
--- a/kexec/crashdump.c
+++ b/kexec/crashdump.c
@@ -108,3 +108,35 @@ int get_crash_notes_per_cpu(int cpu, uint64_t *addr, uint64_t *len)
 
 	return 0;
 }
+
+/* Returns the physical address of start of crash notes buffer for a kernel. */
+int get_kernel_mkdfinfo(uint64_t *addr, uint64_t *len)
+{
+	char kdump_info[PATH_MAX];
+	char line[MAX_LINE];
+	int count;
+	FILE *fp;
+	unsigned long long temp, temp2;
+
+	*addr = 0;
+	*len = 0;
+
+	sprintf(kdump_info, "/sys/kernel/mkdfinfo");
+	fp = fopen(kdump_info, "r");
+	if (!fp) {
+		die("Could not open \"%s\": %s\n", kdump_info,
+		    strerror(errno));
+		return -1;
+	}
+
+	if (!fgets(line, sizeof(line), fp))
+		die("Cannot parse %s: %s\n", kdump_info, strerror(errno));
+	count = sscanf(line, "%Lx %Lx", &temp, &temp2);
+	if (count != 2)
+		die("Cannot parse %s: %s\n", kdump_info, strerror(errno));
+
+	*addr = (uint64_t) temp;
+	*len = (uint64_t) temp2;
+
+	return 0;
+}
diff --git a/kexec/crashdump.h b/kexec/crashdump.h
index e99bdd2..9d31169 100644
--- a/kexec/crashdump.h
+++ b/kexec/crashdump.h
@@ -2,6 +2,7 @@
 #define CRASHDUMP_H
 
 extern int get_crash_notes_per_cpu(int cpu, uint64_t *addr, uint64_t *len);
+extern int get_kernel_mkdfinfo(uint64_t *addr, uint64_t *len);
 
 /* Need to find a better way to determine per cpu notes section size. */
 #define MAX_NOTE_BYTES		1024

--ibTvN161/egqYuK8--
