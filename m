Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZFFK54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZFFK54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZFFK5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:57:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:44017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbZFFK5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:57:49 -0400
Message-ID: <4A2A4B80.1010605@kernel.org>
Date: Sat, 06 Jun 2009 03:57:04 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com>
In-Reply-To: <4A2A3969.5030101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so sth like

---
 include/linux/cpumask.h |   15 +++++++++++++++
 lib/cpumask.c           |   12 ++++++++++++
 2 files changed, 27 insertions(+)

Index: linux-2.6/include/linux/cpumask.h
===================================================================
--- linux-2.6.orig/include/linux/cpumask.h
+++ linux-2.6/include/linux/cpumask.h
@@ -1022,6 +1022,8 @@ typedef struct cpumask *cpumask_var_t;
 
 bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
 bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
+bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
+bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
 void alloc_bootmem_cpumask_var(cpumask_var_t *mask);
 void free_cpumask_var(cpumask_var_t mask);
 void free_bootmem_cpumask_var(cpumask_var_t mask);
@@ -1040,6 +1042,19 @@ static inline bool alloc_cpumask_var_nod
 	return true;
 }
 
+static inline bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	cpumask_clear(*mask);
+	return true;
+}
+
+static inline bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags,
+					  int node)
+{
+	cpumask_clear(*mask);
+	return true;
+}
+
 static inline void alloc_bootmem_cpumask_var(cpumask_var_t *mask)
 {
 }
Index: linux-2.6/lib/cpumask.c
===================================================================
--- linux-2.6.orig/lib/cpumask.c
+++ linux-2.6/lib/cpumask.c
@@ -119,6 +119,12 @@ bool alloc_cpumask_var_node(cpumask_var_
 }
 EXPORT_SYMBOL(alloc_cpumask_var_node);
 
+bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node)
+{
+	return alloc_cpumask_var_node(mask, flags | __GFP_ZERO, node);
+}
+EXPORT_SYMBOL(zalloc_cpumask_var_node);
+
 /**
  * alloc_cpumask_var - allocate a struct cpumask
  * @mask: pointer to cpumask_var_t where the cpumask is returned
@@ -135,6 +141,12 @@ bool alloc_cpumask_var(cpumask_var_t *ma
 }
 EXPORT_SYMBOL(alloc_cpumask_var);
 
+bool zalloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	return alloc_cpumask_var(mask, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(zalloc_cpumask_var);
+
 /**
  * alloc_bootmem_cpumask_var - allocate a struct cpumask from the bootmem arena.
  * @mask: pointer to cpumask_var_t where the cpumask is returned
