Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483Ab0AEAf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0AEAf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419Ab0AEAfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:47 -0500
Received: from kroah.org ([198.145.64.141]:34445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0AEAfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 59/97] NOMMU: Optimise away the {dac_,}mmap_min_addr tests
Date: Mon,  4 Jan 2010 16:33:12 -0800
Message-Id: <1262651630-7354-59-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 6e1415467614e854fee660ff6648bd10fa976e95 upstream.

In NOMMU mode clamp dac_mmap_min_addr to zero to cause the tests on it to be
skipped by the compiler.  We do this as the minimum mmap address doesn't make
any sense in NOMMU mode.

mmap_min_addr and round_hint_to_min() can be discarded entirely in NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/security.h |    7 +++++++
 kernel/sysctl.c          |    2 ++
 mm/Kconfig               |    1 +
 security/Makefile        |    3 ++-
 4 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 239e40d..d40d23f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -95,8 +95,13 @@ struct seq_file;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
+#ifdef CONFIG_MMU
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
+#else
+#define dac_mmap_min_addr	0UL
+#endif
+
 /*
  * Values used in the task_security_ops calls
  */
@@ -121,6 +126,7 @@ struct request_sock;
 #define LSM_UNSAFE_PTRACE	2
 #define LSM_UNSAFE_PTRACE_CAP	4
 
+#ifdef CONFIG_MMU
 /*
  * If a hint addr is less than mmap_min_addr change hint to be as
  * low as possible but still greater than mmap_min_addr
@@ -135,6 +141,7 @@ static inline unsigned long round_hint_to_min(unsigned long hint)
 }
 extern int mmap_min_addr_handler(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
 
 #ifdef CONFIG_SECURITY
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..db23ab7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1200,6 +1200,7 @@ static struct ctl_table vm_table[] = {
 		.extra2		= (void *)&hugetlb_infinity,
 	},
 #endif
+#ifdef CONFIG_MMU
 	{
 		.ctl_name	= VM_LOWMEM_RESERVE_RATIO,
 		.procname	= "lowmem_reserve_ratio",
@@ -1353,6 +1354,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &mmap_min_addr_handler,
 	},
+#endif
 #ifdef CONFIG_NUMA
 	{
 		.ctl_name	= CTL_UNNUMBERED,
diff --git a/mm/Kconfig b/mm/Kconfig
index 44cf6f0..2c19c0b 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -227,6 +227,7 @@ config KSM
 
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
+	depends on MMU
         default 4096
         help
 	  This is the portion of low virtual memory which should be protected
diff --git a/security/Makefile b/security/Makefile
index 95ecc06..510bbc8 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -8,7 +8,8 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 
 # always enable default capabilities
-obj-y		+= commoncap.o min_addr.o
+obj-y					+= commoncap.o
+obj-$(CONFIG_MMU)			+= min_addr.o
 
 # Object file lists
 obj-$(CONFIG_SECURITY)			+= security.o capability.o
-- 
1.6.6

