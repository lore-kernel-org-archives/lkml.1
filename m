Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZBSOgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZBSOgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZBSOfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:35:52 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:59125 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZBSOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:35:51 -0500
Date: Thu, 19 Feb 2009 15:35:47 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 updates for 2.6.29-rc5
Message-ID: <20090219153547.29625b6a@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Christian Borntraeger (1):
      [S390] Fix timeval regression on s390

Heiko Carstens (1):
      [S390] fix "mem=" handling in case of standby memory

Peter Oberparleiter (1):
      [S390] sclp: handle empty event buffers

 arch/s390/include/asm/cputime.h |    2 +-
 arch/s390/include/asm/setup.h   |    2 ++
 arch/s390/kernel/setup.c        |    9 +++++++--
 drivers/s390/char/sclp.c        |    5 ++++-
 drivers/s390/char/sclp_cmd.c    |    5 +++++
 5 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index 5217264..95b0f7d 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -145,7 +145,7 @@ cputime_to_timeval(const cputime_t cputime, struct timeval *value)
 	value->tv_usec = rp.subreg.even / 4096;
 	value->tv_sec = rp.subreg.odd;
 #else
-	value->tv_usec = cputime % 4096000000ULL;
+	value->tv_usec = (cputime % 4096000000ULL) / 4096;
 	value->tv_sec = cputime / 4096000000ULL;
 #endif
 }
diff --git a/arch/s390/include/asm/setup.h b/arch/s390/include/asm/setup.h
index 2bd9fae..e8bd6ac 100644
--- a/arch/s390/include/asm/setup.h
+++ b/arch/s390/include/asm/setup.h
@@ -43,6 +43,8 @@ struct mem_chunk {
 
 extern struct mem_chunk memory_chunk[];
 extern unsigned long real_memory_size;
+extern int memory_end_set;
+extern unsigned long memory_end;
 
 void detect_memory_layout(struct mem_chunk chunk[]);
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index d825f49..c5cfb61 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -82,7 +82,9 @@ char elf_platform[ELF_PLATFORM_SIZE];
 
 struct mem_chunk __initdata memory_chunk[MEMORY_CHUNKS];
 volatile int __cpu_logical_map[NR_CPUS]; /* logical cpu to cpu address */
-static unsigned long __initdata memory_end;
+
+int __initdata memory_end_set;
+unsigned long __initdata memory_end;
 
 /*
  * This is set up by the setup-routine at boot-time
@@ -281,6 +283,7 @@ void (*pm_power_off)(void) = machine_power_off;
 static int __init early_parse_mem(char *p)
 {
 	memory_end = memparse(p, &p);
+	memory_end_set = 1;
 	return 0;
 }
 early_param("mem", early_parse_mem);
@@ -508,8 +511,10 @@ static void __init setup_memory_end(void)
 	int i;
 
 #if defined(CONFIG_ZFCPDUMP) || defined(CONFIG_ZFCPDUMP_MODULE)
-	if (ipl_info.type == IPL_TYPE_FCP_DUMP)
+	if (ipl_info.type == IPL_TYPE_FCP_DUMP) {
 		memory_end = ZFCPDUMP_HSA_SIZE;
+		memory_end_set = 1;
+	}
 #endif
 	memory_size = 0;
 	memory_end &= PAGE_MASK;
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index 1fd8f21..4377e93 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -280,8 +280,11 @@ sclp_dispatch_evbufs(struct sccb_header *sccb)
 	rc = 0;
 	for (offset = sizeof(struct sccb_header); offset < sccb->length;
 	     offset += evbuf->length) {
-		/* Search for event handler */
 		evbuf = (struct evbuf_header *) ((addr_t) sccb + offset);
+		/* Check for malformed hardware response */
+		if (evbuf->length == 0)
+			break;
+		/* Search for event handler */
 		reg = NULL;
 		list_for_each(l, &sclp_reg_list) {
 			reg = list_entry(l, struct sclp_register, list);
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 5063904..77ab6e3 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -19,6 +19,7 @@
 #include <linux/memory.h>
 #include <asm/chpid.h>
 #include <asm/sclp.h>
+#include <asm/setup.h>
 
 #include "sclp.h"
 
@@ -474,6 +475,10 @@ static void __init add_memory_merged(u16 rn)
 		goto skip_add;
 	if (start + size > VMEM_MAX_PHYS)
 		size = VMEM_MAX_PHYS - start;
+	if (memory_end_set && (start >= memory_end))
+		goto skip_add;
+	if (memory_end_set && (start + size > memory_end))
+		size = memory_end - start;
 	add_memory(0, start, size);
 skip_add:
 	first_rn = rn;
