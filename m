Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYKRPLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYKRPLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYKRPL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:11:28 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:53044 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYKRPL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=bvZTNtZflvMcLQ4Mt62GY5OWU89k9X9WTGaHvDR+jkl/U0RleQNiAxFfJQEv4bQ60h
         hkaWClervhQ1mBr5nN4Ocv9xtaYH7Aa87xUASFC+5UxMyIgoLth6rXR76A5yfVsxO9DG
         n8xykOEzmPRKmlgKsU7iEuuvRiNcqzVwxzyZQ=
Message-ID: <386072610811180711y57642faexa5dfb61a1bfa5a2@mail.gmail.com>
Date: Tue, 18 Nov 2008 23:11:23 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin bug fixing for 2.6.28-rc5+
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 4c6ab1bdf5fc737b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/include/asm/bfin-global.h    |    2 +-
 arch/blackfin/include/asm/dma-mapping.h    |    6 +++++-
 arch/blackfin/kernel/bfin_gpio.c           |    2 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c |    9 +++++----
 arch/blackfin/kernel/process.c             |    7 ++++++-
 arch/blackfin/kernel/setup.c               |   12 ++++++------
 arch/blackfin/kernel/traps.c               |   11 +++++++----
 arch/blackfin/mach-common/cache.S          |    8 ++++++--
 arch/blackfin/mach-common/cpufreq.c        |   14 +++++++-------
 arch/blackfin/mach-common/entry.S          |    2 +-
 arch/blackfin/mm/sram-alloc.c              |    8 ++++----
 11 files changed, 49 insertions(+), 32 deletions(-)

Graf Yang (2):
      Blackfin arch: fix bug - Fail to boot jffs2 kernel for BF561
with SMP patch
      Blackfin arch: fix bug - Turn on DEBUG_DOUBLEFAULT, booting SMP
kernel crash

Jie Zhang (1):
      Blackfin arch: fix bug - shared lib function in L2 failed be called

Michael Hennerich (1):
      Blackfin arch: fix bug - Cpufreq assumes clocks in kHz and not Hz.

Mike Frysinger (6):
      Blackfin arch: don't copy bss when copying L1
      Blackfin arch: fix bug - dmacopy test case fail on all platform
      Blackfin arch: fix bug - kernel build with write back policy
fails to be booted up
      Blackfin arch: dont warn when running a kernel on the oldest
supported silicon
      Blackfin arch: fix incorrect limit check for bf54x check_gpio
      Blackfin arch: fix a broken define in dma-mapping

Robin Getz (1):
      Blackfin arch: Fix typo when adding CONFIG_DEBUG_VERBOSE

Tim Pepper (1):
      Blackfin arch: handle case of d_path() returning error in decode_address()

diff --git a/arch/blackfin/include/asm/bfin-global.h
b/arch/blackfin/include/asm/bfin-global.h
index 56dcb0a..7729566 100644
--- a/arch/blackfin/include/asm/bfin-global.h
+++ b/arch/blackfin/include/asm/bfin-global.h
@@ -101,7 +101,7 @@ extern u16 _bfin_swrst; /* shadow for Software
Reset Register (SWRST) */
 extern unsigned long _ramstart, _ramend, _rambase;
 extern unsigned long memory_start, memory_end, physical_mem_end;
 extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
-	_ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _ebss_b_l1[],
+	_ebss_l1[], _l1_lma_start[], _sdata_b_l1[], _sbss_b_l1[], _ebss_b_l1[],
 	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
 	_ebss_l2[], _l2_lma_start[];

diff --git a/arch/blackfin/include/asm/dma-mapping.h
b/arch/blackfin/include/asm/dma-mapping.h
index ede748d..d7d9148 100644
--- a/arch/blackfin/include/asm/dma-mapping.h
+++ b/arch/blackfin/include/asm/dma-mapping.h
@@ -15,7 +15,11 @@ void dma_free_coherent(struct device *dev, size_t
size, void *vaddr,
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)

-#define dma_mapping_error
+static inline
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}

 /*
  * Map a single buffer of the indicated size for DMA in streaming mode.
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 6e08f42..5c0800a 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -218,7 +218,7 @@ inline int check_gpio(unsigned gpio)
 	if (gpio == GPIO_PB15 || gpio == GPIO_PC14 || gpio == GPIO_PC15
 	    || gpio == GPIO_PH14 || gpio == GPIO_PH15
 	    || gpio == GPIO_PJ14 || gpio == GPIO_PJ15
-	    || gpio > MAX_BLACKFIN_GPIOS)
+	    || gpio >= MAX_BLACKFIN_GPIOS)
 		return -EINVAL;
 	return 0;
 }
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 512f8c9..2debc90 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -188,10 +188,11 @@ static struct cplb_desc cplb_data[] = {

 static u16 __init lock_kernel_check(u32 start, u32 end)
 {
-	if ((end   <= (u32) _end && end   >= (u32)_stext) ||
-	    (start <= (u32) _end && start >= (u32)_stext))
-		return IN_KERNEL;
-	return 0;
+	if (start >= (u32)_end || end <= (u32)_stext)
+		return 0;
+
+	/* This cplb block overlapped with kernel area. */
+	return IN_KERNEL;
 }

 static unsigned short __init
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 77800dd..0c3ea11 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -351,10 +351,15 @@ int _access_ok(unsigned long addr, unsigned long size)
 		return 1;
 #endif
 #if L1_DATA_B_LENGTH != 0
-	if (addr >= L1_DATA_B_START
+	if (addr >= L1_DATA_B_START + (_ebss_b_l1 - _sdata_b_l1)
 	    && addr + size <= L1_DATA_B_START + L1_DATA_B_LENGTH)
 		return 1;
 #endif
+#if L2_LENGTH != 0
+	if (addr >= L2_START + (_ebss_l2 - _stext_l2)
+	    && addr + size <= L2_START + L2_LENGTH)
+		return 1;
+#endif
 	return 0;
 }
 EXPORT_SYMBOL(_access_ok);
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 7f35d10..71a9a8c 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -119,23 +119,23 @@ void __init bfin_relocate_l1_mem(void)
 	/* Copy _stext_l1 to _etext_l1 to L1 instruction SRAM */
 	dma_memcpy(_stext_l1, _l1_lma_start, l1_code_length);

-	l1_data_a_length = _ebss_l1 - _sdata_l1;
+	l1_data_a_length = _sbss_l1 - _sdata_l1;
 	if (l1_data_a_length > L1_DATA_A_LENGTH)
 		panic("L1 Data SRAM Bank A Overflow\n");

-	/* Copy _sdata_l1 to _ebss_l1 to L1 data bank A SRAM */
+	/* Copy _sdata_l1 to _sbss_l1 to L1 data bank A SRAM */
 	dma_memcpy(_sdata_l1, _l1_lma_start + l1_code_length, l1_data_a_length);

-	l1_data_b_length = _ebss_b_l1 - _sdata_b_l1;
+	l1_data_b_length = _sbss_b_l1 - _sdata_b_l1;
 	if (l1_data_b_length > L1_DATA_B_LENGTH)
 		panic("L1 Data SRAM Bank B Overflow\n");

-	/* Copy _sdata_b_l1 to _ebss_b_l1 to L1 data bank B SRAM */
+	/* Copy _sdata_b_l1 to _sbss_b_l1 to L1 data bank B SRAM */
 	dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
 			l1_data_a_length, l1_data_b_length);

 	if (L2_LENGTH != 0) {
-		l2_length = _ebss_l2 - _stext_l2;
+		l2_length = _sbss_l2 - _stext_l2;
 		if (l2_length > L2_LENGTH)
 			panic("L2 SRAM Overflow\n");

@@ -827,7 +827,7 @@ void __init setup_arch(char **cmdline_p)
 				printk(KERN_ERR "Warning: Compiled for Rev %d, but running on Rev %d\n",
 				       bfin_compiled_revid(), bfin_revid());
 		}
-		if (bfin_revid() <= CONFIG_BF_REV_MIN || bfin_revid() > CONFIG_BF_REV_MAX)
+		if (bfin_revid() < CONFIG_BF_REV_MIN || bfin_revid() > CONFIG_BF_REV_MAX)
 			printk(KERN_ERR "Warning: Unsupported Chip Revision ADSP-%s Rev
0.%d detected\n",
 			       CPU, bfin_revid());
 	}
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 1aa2c78..bef025b 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -59,7 +59,7 @@
 #endif


-#ifdef CONFIG_VERBOSE_DEBUG
+#ifdef CONFIG_DEBUG_VERBOSE
 #define verbose_printk(fmt, arg...) \
 	printk(fmt, ##arg)
 #else
@@ -147,9 +147,12 @@ static void decode_address(char *buf, unsigned
long address)
 				char *name = p->comm;
 				struct file *file = vma->vm_file;

-				if (file)
-					name = d_path(&file->f_path, _tmpbuf,
+				if (file) {
+					char *d_name = d_path(&file->f_path, _tmpbuf,
 						      sizeof(_tmpbuf));
+					if (!IS_ERR(d_name))
+						name = d_name;
+				}

 				/* FLAT does not have its text aligned to the start of
 				 * the map while FDPIC ELF does ...
@@ -571,7 +574,7 @@ asmlinkage void trap_c(struct pt_regs *fp)
 #endif
 			panic("Kernel exception");
 		} else {
-#ifdef CONFIG_VERBOSE_DEBUG
+#ifdef CONFIG_DEBUG_VERBOSE
 			unsigned long *stack;
 			/* Dump the user space stack */
 			stack = (unsigned long *)rdusp();
diff --git a/arch/blackfin/mach-common/cache.S
b/arch/blackfin/mach-common/cache.S
index db53218..a028e94 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -25,9 +25,13 @@
  */
 .macro do_flush flushins:req optflushins optnopins label

+	R2 = -L1_CACHE_BYTES;
+
+	/* start = (start & -L1_CACHE_BYTES) */
+	R0 = R0 & R2;
+
 	/* end = ((end - 1) & -L1_CACHE_BYTES) + L1_CACHE_BYTES; */
 	R1 += -1;
-	R2 = -L1_CACHE_BYTES;
 	R1 = R1 & R2;
 	R1 += L1_CACHE_BYTES;

@@ -63,7 +67,7 @@ ENDPROC(_blackfin_icache_flush_range)

 /* Flush all cache lines assocoiated with this area of memory. */
 ENTRY(_blackfin_icache_dcache_flush_range)
-	do_flush IFLUSH, FLUSH
+	do_flush FLUSH, IFLUSH
 ENDPROC(_blackfin_icache_dcache_flush_range)

 /* Throw away all D-cached data in specified region without any obligation to
diff --git a/arch/blackfin/mach-common/cpufreq.c
b/arch/blackfin/mach-common/cpufreq.c
index c22c47b..dda5443 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -72,13 +72,13 @@ unsigned int __bfin_cycles_mod;

 /**************************************************************************/

-static unsigned int bfin_getfreq(unsigned int cpu)
+static unsigned int bfin_getfreq_khz(unsigned int cpu)
 {
 	/* The driver only support single cpu */
 	if (cpu != 0)
 		return -1;

-	return get_cclk();
+	return get_cclk() / 1000;
 }


@@ -96,7 +96,7 @@ static int bfin_target(struct cpufreq_policy *policy,

 	cclk_hz = bfin_freq_table[index].frequency;

-	freqs.old = bfin_getfreq(0);
+	freqs.old = bfin_getfreq_khz(0);
 	freqs.new = cclk_hz;
 	freqs.cpu = 0;

@@ -137,8 +137,8 @@ static int __init __bfin_cpu_init(struct
cpufreq_policy *policy)
 	if (policy->cpu != 0)
 		return -EINVAL;

-	cclk = get_cclk();
-	sclk = get_sclk();
+	cclk = get_cclk() / 1000;
+	sclk = get_sclk() / 1000;

 #if ANOMALY_05000273 || (!defined(CONFIG_BF54x) && defined(CONFIG_BFIN_DCACHE))
 	min_cclk = sclk * 2;
@@ -152,7 +152,7 @@ static int __init __bfin_cpu_init(struct
cpufreq_policy *policy)
 		dpm_state_table[index].csel = csel << 4; /* Shift now into PLL_DIV bitpos */
 		dpm_state_table[index].tscale =  (TIME_SCALE / (1 << csel)) - 1;

-		pr_debug("cpufreq: freq:%d csel:%d tscale:%d\n",
+		pr_debug("cpufreq: freq:%d csel:0x%x tscale:%d\n",
 						 bfin_freq_table[index].frequency,
 						 dpm_state_table[index].csel,
 						 dpm_state_table[index].tscale);
@@ -173,7 +173,7 @@ static struct freq_attr *bfin_freq_attr[] = {
 static struct cpufreq_driver bfin_driver = {
 	.verify = bfin_verify_speed,
 	.target = bfin_target,
-	.get = bfin_getfreq,
+	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
 	.name = "bfin cpufreq",
 	.owner = THIS_MODULE,
diff --git a/arch/blackfin/mach-common/entry.S
b/arch/blackfin/mach-common/entry.S
index c13fa8d..bde6dc4 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -277,7 +277,7 @@ ENTRY(_bfin_return_from_exception)
 	p5.h = hi(ILAT);
 	r6 = [p5];
 	r7 = 0x20;		/* Did I just cause anther HW error? */
-	r7 = r7 & r1;
+	r6 = r7 & r6;
 	CC = R7 == R6;
 	if CC JUMP _double_fault;
 #endif
diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 0f1ca69..cc6f336 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -183,10 +183,10 @@ static void __init l2_sram_init(void)
 		return;
 	}

-	free_l2_sram_head.next->paddr = (void *)L2_START +
-		(_etext_l2 - _stext_l2) + (_edata_l2 - _sdata_l2);
-	free_l2_sram_head.next->size = L2_LENGTH -
-		(_etext_l2 - _stext_l2) + (_edata_l2 - _sdata_l2);
+	free_l2_sram_head.next->paddr =
+		(void *)L2_START + (_ebss_l2 - _stext_l2);
+	free_l2_sram_head.next->size =
+		L2_LENGTH - (_ebss_l2 - _stext_l2);
 	free_l2_sram_head.next->pid = 0;
 	free_l2_sram_head.next->next = NULL;
