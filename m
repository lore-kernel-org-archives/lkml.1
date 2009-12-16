Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbZLPX4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbZLPX4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761642AbZLPX4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:56:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761665AbZLPX4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:56:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] NOMMU: Optimise away the {dac_,}mmap_min_addr tests
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, vapier@gentoo.org, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>
Date: Wed, 16 Dec 2009 23:55:58 +0000
Message-ID: <20091216235558.4310.19365.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In NOMMU mode clamp dac_mmap_min_addr to zero to cause the tests on it to be
skipped by the compiler.  We do this as the minimum mmap address doesn't make
any sense in NOMMU mode.

mmap_min_addr and round_hint_to_min() can be discarded entirely in NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Eric Paris <eparis@redhat.com>
---

 include/linux/security.h |    7 +++++++
 kernel/sysctl.c          |    2 ++
 mm/Kconfig               |    1 +
 security/Makefile        |    3 ++-
 4 files changed, 12 insertions(+), 1 deletions(-)


diff --git a/include/linux/security.h b/include/linux/security.h
index 466cbad..2c627d3 100644
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
index 45e4bef..856a24e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1214,6 +1214,7 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 #endif
+#ifdef CONFIG_MMU
 	{
 		.procname	= "mmap_min_addr",
 		.data		= &dac_mmap_min_addr,
@@ -1221,6 +1222,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= mmap_min_addr_handler,
 	},
+#endif
 #ifdef CONFIG_NUMA
 	{
 		.procname	= "numa_zonelist_order",
diff --git a/mm/Kconfig b/mm/Kconfig
index 43ea8c3..ee9f3e0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -221,6 +221,7 @@ config KSM
 
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
+	depends on MMU
         default 4096
         help
 	  This is the portion of low virtual memory which should be protected
diff --git a/security/Makefile b/security/Makefile
index bb44e35..da20a19 100644
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

