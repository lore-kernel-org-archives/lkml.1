Return-Path: <linux-kernel-owner+w=401wt.eu-S1030871AbXAZQ4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871AbXAZQ4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030756AbXAZQzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:55:41 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:59478 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030910AbXAZQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:55:28 -0500
Date: Fri, 26 Jan 2007 17:55:21 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: hongjie@us.ibm.com
Subject: [S390] boot from NSS support
Message-ID: <20070126165521.GY11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hongjie Yang <hongjie@us.ibm.com>

[S390] boot from NSS support

Add support to boot from a named saved segment (NSS).

Signed-off-by: Hongjie Yang <hongjie@us.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/head31.S      |   34 +------
 arch/s390/kernel/head64.S      |   30 +-----
 arch/s390/kernel/ipl.c         |   87 ++++++++++++++++++++
 arch/s390/kernel/setup.c       |  178 +++++++++++++++++++++++++++++++++++++++--
 arch/s390/kernel/vmlinux.lds.S |   10 +-
 include/asm-s390/setup.h       |    8 +
 6 files changed, 282 insertions(+), 65 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/head31.S linux-2.6-patched/arch/s390/kernel/head31.S
--- linux-2.6/arch/s390/kernel/head31.S	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head31.S	2007-01-26 17:29:33.000000000 +0100
@@ -51,20 +51,12 @@ startup_continue:
 	st	%r15,__LC_KERNEL_STACK	# set end of kernel stack
 	ahi	%r15,-96
 	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15) # clear backchain
-
-	l	%r14,.Lipl_save_parameters-.LPG1(%r13)
-	basr	%r14,%r14
 #
-# clear bss memory
+# Save ipl parameters, clear bss memory, initialize storage key for kernel pages,
+# and create a kernel NSS if the SAVESYS= parm is defined
 #
-	l	%r2,.Lbss_bgn-.LPG1(%r13) # start of bss
-	l	%r3,.Lbss_end-.LPG1(%r13) # end of bss
-	sr	%r3,%r2			# length of bss
-	sr	%r4,%r4
-	sr	%r5,%r5			# set src,length and pad to zero
-	sr	%r0,%r0
-	mvcle	%r2,%r4,0		# clear mem
-	jo	.-4			# branch back, if not finish
+	l	%r14,.Lstartup_init-.LPG1(%r13)
+	basr	%r14,%r14
 
 	l	%r2,.Lrcp-.LPG1(%r13)	# Read SCP forced command word
 .Lservicecall:
@@ -125,10 +117,10 @@ startup_continue:
 	b	.Lfchunk-.LPG1(%r13)
 
 	.align 4
-.Lipl_save_parameters:
-	.long	ipl_save_parameters
 .Linittu:
 	.long	init_thread_union
+.Lstartup_init:
+	.long	startup_init
 .Lpmask:
 	.byte	0
 	.align	8
@@ -207,20 +199,6 @@ startup_continue:
 .Ldonemem:
 	l	%r12,.Lmflags-.LPG1(%r13) # get address of machine_flags
 #
-# find out if we are running under VM
-#
-	stidp	__LC_CPUID		# store cpuid
-	tm	__LC_CPUID,0xff		# running under VM ?
-	bno	.Lnovm-.LPG1(%r13)
-	oi	3(%r12),1		# set VM flag
-.Lnovm:
-	lh	%r0,__LC_CPUID+4	# get cpu version
-	chi	%r0,0x7490		# running on a P/390 ?
-	bne	.Lnop390-.LPG1(%r13)
-	oi	3(%r12),4		# set P/390 flag
-.Lnop390:
-
-#
 # find out if we have an IEEE fpu
 #
 	mvc	__LC_PGM_NEW_PSW(8),.Lpcfpu-.LPG1(%r13)
diff -urpN linux-2.6/arch/s390/kernel/head64.S linux-2.6-patched/arch/s390/kernel/head64.S
--- linux-2.6/arch/s390/kernel/head64.S	2007-01-26 17:27:56.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/head64.S	2007-01-26 17:29:33.000000000 +0100
@@ -58,18 +58,11 @@ startup_continue:
 	stg	%r15,__LC_KERNEL_STACK	# set end of kernel stack
 	aghi	%r15,-160
 	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15) # clear backchain
-
-	brasl	%r14,ipl_save_parameters
 #
-# clear bss memory
+# Save ipl parameters, clear bss memory, initialize storage key for kernel pages,
+# and create a kernel NSS if the SAVESYS= parm is defined
 #
-	larl	%r2,__bss_start 	# start of bss segment
-	larl	%r3,_end		# end of bss segment
-	sgr	%r3,%r2 		# length of bss
-	sgr	%r4,%r4 		#
-	sgr	%r5,%r5 		# set src,length and pad to zero
-	mvcle	%r2,%r4,0		# clear mem
-	jo	.-4			# branch back, if not finish
+	brasl	%r14,startup_init
 					# set program check new psw mask
 	mvc	__LC_PGM_NEW_PSW(8),.Lpcmsk-.LPG1(%r13)
 	larl	%r1,.Lslowmemdetect	# set program check address
@@ -78,6 +71,10 @@ startup_continue:
 	diag	%r0,%r1,0x260		# get memory size of virtual machine
 	cgr	%r0,%r1			# different? -> old detection routine
 	jne	.Lslowmemdetect
+	larl	%r3,ipl_flags
+	llgt	%r3,0(%r3)
+	chi	%r3,4			# ipled from an kernel NSS
+	je	.Lslowmemdetect
 	aghi	%r1,1			# size is one more than end
 	larl	%r2,memory_chunk
 	stg	%r1,8(%r2)		# store size of chunk
@@ -226,19 +223,6 @@ startup_continue:
 
 	larl	%r12,machine_flags
 #
-# find out if we are running under VM
-#
-	stidp	__LC_CPUID		# store cpuid
-	tm	__LC_CPUID,0xff 	# running under VM ?
-	bno	0f-.LPG1(%r13)
-	oi	7(%r12),1		# set VM flag
-0:	lh	%r0,__LC_CPUID+4	# get cpu version
-	chi	%r0,0x7490		# running on a P/390 ?
-	bne	1f-.LPG1(%r13)
-	oi	7(%r12),4		# set P/390 flag
-1:
-
-#
 # find out if we have the MVPG instruction
 #
 	la	%r1,0f-.LPG1(%r13)	# set program check address
diff -urpN linux-2.6/arch/s390/kernel/ipl.c linux-2.6-patched/arch/s390/kernel/ipl.c
--- linux-2.6/arch/s390/kernel/ipl.c	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/ipl.c	2007-01-26 17:29:33.000000000 +0100
@@ -34,12 +34,14 @@ enum ipl_type {
 	IPL_TYPE_UNKNOWN = 2,
 	IPL_TYPE_CCW	 = 4,
 	IPL_TYPE_FCP	 = 8,
+	IPL_TYPE_NSS	 = 16,
 };
 
 #define IPL_NONE_STR	 "none"
 #define IPL_UNKNOWN_STR  "unknown"
 #define IPL_CCW_STR	 "ccw"
 #define IPL_FCP_STR	 "fcp"
+#define IPL_NSS_STR	 "nss"
 
 static char *ipl_type_str(enum ipl_type type)
 {
@@ -50,6 +52,8 @@ static char *ipl_type_str(enum ipl_type 
 		return IPL_CCW_STR;
 	case IPL_TYPE_FCP:
 		return IPL_FCP_STR;
+	case IPL_TYPE_NSS:
+		return IPL_NSS_STR;
 	case IPL_TYPE_UNKNOWN:
 	default:
 		return IPL_UNKNOWN_STR;
@@ -64,6 +68,7 @@ enum ipl_method {
 	IPL_METHOD_FCP_RO_DIAG,
 	IPL_METHOD_FCP_RW_DIAG,
 	IPL_METHOD_FCP_RO_VM,
+	IPL_METHOD_NSS,
 };
 
 enum shutdown_action {
@@ -114,11 +119,14 @@ enum diag308_rc {
 static int diag308_set_works = 0;
 
 static int reipl_capabilities = IPL_TYPE_UNKNOWN;
+
 static enum ipl_type reipl_type = IPL_TYPE_UNKNOWN;
 static enum ipl_method reipl_method = IPL_METHOD_NONE;
 static struct ipl_parameter_block *reipl_block_fcp;
 static struct ipl_parameter_block *reipl_block_ccw;
 
+static char reipl_nss_name[NSS_NAME_SIZE + 1];
+
 static int dump_capabilities = IPL_TYPE_NONE;
 static enum ipl_type dump_type = IPL_TYPE_NONE;
 static enum ipl_method dump_method = IPL_METHOD_NONE;
@@ -173,6 +181,24 @@ static struct subsys_attribute sys_##_pr
 			sys_##_prefix##_##_name##_show,			\
 			sys_##_prefix##_##_name##_store);
 
+#define DEFINE_IPL_ATTR_STR_RW(_prefix, _name, _fmt_out, _fmt_in, _value)\
+static ssize_t sys_##_prefix##_##_name##_show(struct subsystem *subsys,	\
+		char *page)						\
+{									\
+	return sprintf(page, _fmt_out, _value);				\
+}									\
+static ssize_t sys_##_prefix##_##_name##_store(struct subsystem *subsys,\
+		const char *buf, size_t len)				\
+{									\
+	if (sscanf(buf, _fmt_in, _value) != 1)				\
+		return -EINVAL;						\
+	return len;							\
+}									\
+static struct subsys_attribute sys_##_prefix##_##_name##_attr =		\
+	__ATTR(_name,(S_IRUGO | S_IWUSR),				\
+			sys_##_prefix##_##_name##_show,			\
+			sys_##_prefix##_##_name##_store);
+
 static void make_attrs_ro(struct attribute **attrs)
 {
 	while (*attrs) {
@@ -189,6 +215,8 @@ static enum ipl_type ipl_get_type(void)
 {
 	struct ipl_parameter_block *ipl = IPL_PARMBLOCK_START;
 
+	if (ipl_flags & IPL_NSS_VALID)
+		return IPL_TYPE_NSS;
 	if (!(ipl_flags & IPL_DEVNO_VALID))
 		return IPL_TYPE_UNKNOWN;
 	if (!(ipl_flags & IPL_PARMBLOCK_VALID))
@@ -324,6 +352,20 @@ static struct attribute_group ipl_ccw_at
 	.attrs = ipl_ccw_attrs,
 };
 
+/* NSS ipl device attributes */
+
+DEFINE_IPL_ATTR_RO(ipl_nss, name, "%s\n", kernel_nss_name);
+
+static struct attribute *ipl_nss_attrs[] = {
+	&sys_ipl_type_attr.attr,
+	&sys_ipl_nss_name_attr.attr,
+	NULL,
+};
+
+static struct attribute_group ipl_nss_attr_group = {
+	.attrs = ipl_nss_attrs,
+};
+
 /* UNKNOWN ipl device attributes */
 
 static struct attribute *ipl_unknown_attrs[] = {
@@ -432,6 +474,21 @@ static struct attribute_group reipl_ccw_
 	.attrs = reipl_ccw_attrs,
 };
 
+
+/* NSS reipl device attributes */
+
+DEFINE_IPL_ATTR_STR_RW(reipl_nss, name, "%s\n", "%s\n", reipl_nss_name);
+
+static struct attribute *reipl_nss_attrs[] = {
+	&sys_reipl_nss_name_attr.attr,
+	NULL,
+};
+
+static struct attribute_group reipl_nss_attr_group = {
+	.name  = IPL_NSS_STR,
+	.attrs = reipl_nss_attrs,
+};
+
 /* reipl type */
 
 static int reipl_set_type(enum ipl_type type)
@@ -454,6 +511,9 @@ static int reipl_set_type(enum ipl_type 
 		else
 			reipl_method = IPL_METHOD_FCP_RO_DIAG;
 		break;
+	case IPL_TYPE_NSS:
+		reipl_method = IPL_METHOD_NSS;
+		break;
 	default:
 		reipl_method = IPL_METHOD_NONE;
 	}
@@ -475,6 +535,8 @@ static ssize_t reipl_type_store(struct s
 		rc = reipl_set_type(IPL_TYPE_CCW);
 	else if (strncmp(buf, IPL_FCP_STR, strlen(IPL_FCP_STR)) == 0)
 		rc = reipl_set_type(IPL_TYPE_FCP);
+	else if (strncmp(buf, IPL_NSS_STR, strlen(IPL_NSS_STR)) == 0)
+		rc = reipl_set_type(IPL_TYPE_NSS);
 	return (rc != 0) ? rc : len;
 }
 
@@ -647,6 +709,10 @@ void do_reipl(void)
 	case IPL_METHOD_FCP_RO_VM:
 		__cpcmd("IPL", NULL, 0, NULL);
 		break;
+	case IPL_METHOD_NSS:
+		sprintf(buf, "IPL %s", reipl_nss_name);
+		__cpcmd(buf, NULL, 0, NULL);
+		break;
 	case IPL_METHOD_NONE:
 	default:
 		if (MACHINE_IS_VM)
@@ -733,6 +799,10 @@ static int __init ipl_init(void)
 	case IPL_TYPE_FCP:
 		rc = ipl_register_fcp_files();
 		break;
+	case IPL_TYPE_NSS:
+		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+					&ipl_nss_attr_group);
+		break;
 	default:
 		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
 					&ipl_unknown_attr_group);
@@ -755,6 +825,20 @@ static void __init reipl_probe(void)
 	free_page((unsigned long)buffer);
 }
 
+static int __init reipl_nss_init(void)
+{
+	int rc;
+
+	if (!MACHINE_IS_VM)
+		return 0;
+	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_nss_attr_group);
+	if (rc)
+		return rc;
+	strncpy(reipl_nss_name, kernel_nss_name, NSS_NAME_SIZE + 1);
+	reipl_capabilities |= IPL_TYPE_NSS;
+	return 0;
+}
+
 static int __init reipl_ccw_init(void)
 {
 	int rc;
@@ -837,6 +921,9 @@ static int __init reipl_init(void)
 	rc = reipl_fcp_init();
 	if (rc)
 		return rc;
+	rc = reipl_nss_init();
+	if (rc)
+		return rc;
 	rc = reipl_set_type(ipl_get_type());
 	if (rc)
 		return rc;
diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-01-26 17:29:33.000000000 +0100
@@ -38,6 +38,7 @@
 #include <linux/device.h>
 #include <linux/notifier.h>
 #include <linux/pfn.h>
+#include <linux/ctype.h>
 #include <linux/reboot.h>
 
 #include <asm/uaccess.h>
@@ -50,6 +51,7 @@
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/sections.h>
+#include <asm/ebcdic.h>
 #include <asm/compat.h>
 
 long psw_kernel_bits	= (PSW_BASE_BITS | PSW_MASK_DAT | PSW_ASC_PRIMARY |
@@ -282,6 +284,140 @@ static void __init conmode_default(void)
 	}
 }
 
+/*
+ * Create a Kernel NSS if the SAVESYS= parameter is defined
+*/
+#define DEFSYS_CMD_SIZE	96
+#define SAVESYS_CMD_SIZE	32
+
+extern int _eshared;
+char kernel_nss_name[NSS_NAME_SIZE + 1];
+
+#ifdef CONFIG_SHARED_KERNEL
+static __init void create_kernel_nss(void)
+{
+	unsigned int i, stext_pfn, eshared_pfn, end_pfn, min_size;
+#ifdef CONFIG_BLK_DEV_INITRD
+	unsigned int sinitrd_pfn, einitrd_pfn;
+#endif
+	int response;
+	char *savesys_ptr;
+	char upper_command_line[COMMAND_LINE_SIZE];
+	char defsys_cmd[DEFSYS_CMD_SIZE];
+	char savesys_cmd[SAVESYS_CMD_SIZE];
+
+	/* Do nothing if we are not running under VM */
+	if (!MACHINE_IS_VM)
+		return;
+
+	/* Convert COMMAND_LINE to upper case */
+	for (i = 0; i < strlen(COMMAND_LINE); i++)
+		upper_command_line[i] = toupper(COMMAND_LINE[i]);
+
+	savesys_ptr = strstr(upper_command_line, "SAVESYS=");
+
+	if (!savesys_ptr)
+		return;
+
+	savesys_ptr += 8;    /* Point to the beginning of the NSS name */
+	for (i = 0; i < NSS_NAME_SIZE; i++) {
+		if (savesys_ptr[i] == ' ' || savesys_ptr[i] == '\0')
+			break;
+		kernel_nss_name[i] = savesys_ptr[i];
+	}
+
+	stext_pfn = PFN_DOWN(__pa(&_stext));
+	eshared_pfn = PFN_DOWN(__pa(&_eshared));
+	end_pfn = PFN_UP(__pa(&_end));
+	min_size = end_pfn << 2;
+
+	sprintf(defsys_cmd, "DEFSYS %s 00000-%.5X EW %.5X-%.5X SR %.5X-%.5X",
+		kernel_nss_name, stext_pfn - 1, stext_pfn, eshared_pfn - 1,
+		eshared_pfn, end_pfn);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (INITRD_START && INITRD_SIZE) {
+		sinitrd_pfn = PFN_DOWN(__pa(INITRD_START));
+		einitrd_pfn = PFN_UP(__pa(INITRD_START + INITRD_SIZE));
+		min_size = einitrd_pfn << 2;
+		sprintf(defsys_cmd, "%s EW %.5X-%.5X", defsys_cmd,
+		sinitrd_pfn, einitrd_pfn);
+	}
+#endif
+
+	sprintf(defsys_cmd, "%s EW MINSIZE=%.7iK", defsys_cmd, min_size);
+	sprintf(savesys_cmd, "SAVESYS %s \n IPL %s",
+		kernel_nss_name, kernel_nss_name);
+
+	__cpcmd(defsys_cmd, NULL, 0, &response);
+
+	if (response != 0)
+		return;
+
+	__cpcmd(savesys_cmd, NULL, 0, &response);
+
+	if (response != strlen(savesys_cmd))
+		return;
+
+	ipl_flags = IPL_NSS_VALID;
+}
+
+#else /* CONFIG_SHARED_KERNEL */
+
+static inline void create_kernel_nss(void) { }
+
+#endif /* CONFIG_SHARED_KERNEL */
+
+/*
+ * Clear bss memory
+ */
+static __init void clear_bss_section(void)
+{
+	memset(__bss_start, 0, _end - __bss_start);
+}
+
+/*
+ * Initialize storage key for kernel pages
+ */
+static __init void init_kernel_storage_key(void)
+{
+	unsigned long end_pfn, init_pfn;
+
+	end_pfn = PFN_UP(__pa(&_end));
+
+	for (init_pfn = 0 ; init_pfn < end_pfn; init_pfn++)
+		page_set_storage_key(init_pfn << PAGE_SHIFT, PAGE_DEFAULT_KEY);
+}
+
+static __init void detect_machine_type(void)
+{
+	struct cpuinfo_S390 *cpuinfo = &S390_lowcore.cpu_data;
+
+	asm volatile("stidp %0" : "=m" (S390_lowcore.cpu_data.cpu_id));
+
+	/* Running under z/VM ? */
+	if (cpuinfo->cpu_id.version == 0xff)
+		machine_flags |= 1;
+
+	/* Running on a P/390 ? */
+	if (cpuinfo->cpu_id.machine == 0x7490)
+		machine_flags |= 4;
+}
+
+/*
+ * Save ipl parameters, clear bss memory, initialize storage keys
+ * and create a kernel NSS at startup if the SAVESYS= parm is defined
+ */
+void __init startup_init(void)
+{
+	ipl_save_parameters();
+	clear_bss_section();
+	init_kernel_storage_key();
+	lockdep_init();
+	detect_machine_type();
+	create_kernel_nss();
+}
+
 #ifdef CONFIG_SMP
 void (*_machine_restart)(char *command) = machine_restart_smp;
 void (*_machine_halt)(void) = machine_halt_smp;
@@ -523,7 +659,7 @@ setup_lowcore(void)
 static void __init
 setup_resources(void)
 {
-	struct resource *res;
+	struct resource *res, *sub_res;
 	int i;
 
 	code_resource.start = (unsigned long) &_text;
@@ -548,8 +684,38 @@ setup_resources(void)
 		res->start = memory_chunk[i].addr;
 		res->end = memory_chunk[i].addr +  memory_chunk[i].size - 1;
 		request_resource(&iomem_resource, res);
-		request_resource(res, &code_resource);
-		request_resource(res, &data_resource);
+
+		if (code_resource.start >= res->start  &&
+			code_resource.start <= res->end &&
+			code_resource.end > res->end) {
+			sub_res = alloc_bootmem_low(sizeof(struct resource));
+			memcpy(sub_res, &code_resource,
+				sizeof(struct resource));
+			sub_res->end = res->end;
+			code_resource.start = res->end + 1;
+			request_resource(res, sub_res);
+		}
+
+		if (code_resource.start >= res->start &&
+			code_resource.start <= res->end &&
+			code_resource.end <= res->end)
+			request_resource(res, &code_resource);
+
+		if (data_resource.start >= res->start &&
+			data_resource.start <= res->end &&
+			data_resource.end > res->end) {
+			sub_res = alloc_bootmem_low(sizeof(struct resource));
+			memcpy(sub_res, &data_resource,
+				sizeof(struct resource));
+			sub_res->end = res->end;
+			data_resource.start = res->end + 1;
+			request_resource(res, sub_res);
+		}
+
+		if (data_resource.start >= res->start &&
+			data_resource.start <= res->end &&
+			data_resource.end <= res->end)
+			request_resource(res, &data_resource);
 	}
 }
 
@@ -585,7 +751,7 @@ static void __init
 setup_memory(void)
 {
         unsigned long bootmap_size;
-	unsigned long start_pfn, end_pfn, init_pfn;
+	unsigned long start_pfn, end_pfn;
 	int i;
 
 	/*
@@ -595,10 +761,6 @@ setup_memory(void)
 	start_pfn = PFN_UP(__pa(&_end));
 	end_pfn = max_pfn = PFN_DOWN(memory_end);
 
-	/* Initialize storage key for kernel pages */
-	for (init_pfn = 0 ; init_pfn < start_pfn; init_pfn++)
-		page_set_storage_key(init_pfn << PAGE_SHIFT, PAGE_DEFAULT_KEY);
-
 #ifdef CONFIG_BLK_DEV_INITRD
 	/*
 	 * Move the initrd in case the bitmap of the bootmem allocater
diff -urpN linux-2.6/arch/s390/kernel/vmlinux.lds.S linux-2.6-patched/arch/s390/kernel/vmlinux.lds.S
--- linux-2.6/arch/s390/kernel/vmlinux.lds.S	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/vmlinux.lds.S	2007-01-26 17:29:33.000000000 +0100
@@ -31,11 +31,6 @@ SECTIONS
 
   _etext = .;			/* End of text section */
 
-  . = ALIGN(16);		/* Exception table */
-  __start___ex_table = .;
-  __ex_table : { *(__ex_table) }
-  __stop___ex_table = .;
-
   RODATA
 
 #ifdef CONFIG_SHARED_KERNEL
@@ -44,6 +39,11 @@ SECTIONS
   _eshared = .;			/* End of shareable data */
 #endif
 
+  . = ALIGN(16);		/* Exception table */
+  __start___ex_table = .;
+  __ex_table : { *(__ex_table) }
+  __stop___ex_table = .;
+
   .data : {			/* Data */
 	*(.data)
 	CONSTRUCTORS
diff -urpN linux-2.6/include/asm-s390/setup.h linux-2.6-patched/include/asm-s390/setup.h
--- linux-2.6/include/asm-s390/setup.h	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/setup.h	2007-01-26 17:29:33.000000000 +0100
@@ -156,13 +156,19 @@ struct ipl_parameter_block {
 extern u32 ipl_flags;
 extern u16 ipl_devno;
 
-void do_reipl(void);
+extern void do_reipl(void);
+extern void ipl_save_parameters(void);
 
 enum {
 	IPL_DEVNO_VALID	= 1,
 	IPL_PARMBLOCK_VALID = 2,
+	IPL_NSS_VALID = 4,
 };
 
+#define NSS_NAME_SIZE	8
+
+extern char kernel_nss_name[];
+
 #define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
 				 IPL_PARMBLOCK_ORIGIN)
 #define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
