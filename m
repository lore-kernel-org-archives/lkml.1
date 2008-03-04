Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYCDIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYCDIZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYCDIZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:25:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYCDIZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:25:41 -0500
Date: Tue, 4 Mar 2008 00:25:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: srinivasa <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, srikar@linux.vnet.ibm.com
Subject: Re: [RFC] [PATCH] To refuse users from probing preempt_schedule()
Message-Id: <20080304002521.2e67d7a5.akpm@linux-foundation.org>
In-Reply-To: <200802251127.40579.srinivasa@in.ibm.com>
References: <200802251127.40579.srinivasa@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 11:27:40 +0530 srinivasa <srinivasa@in.ibm.com> wrote:

> From: Srinivasa Ds <srinivasa@in.ibm.com>
> 
> This patch prohibits user from probing preempt_schedule(). One way of
> prohibiting the user from probing functions is by marking such 
> functions with __kprobes. But this method doesn't work for those functions,
> which are already marked to different section like preempt_schedule()
> (belongs to __sched section). So we use blacklist approach to refuse user
> from probing these functions.
> 
> In blacklist approach we populate the blacklisted function's starting
> address and its size in kprobe_blacklist structure. Then we verify the user
> specified address against start and end of the blacklisted function.
> So any attempt to register probe on blacklisted functions will be rejected.
> 
> please let me know your comments.
> 

sparc64:

kernel/kprobes.c: In function `in_kprobes_functions':
kernel/kprobes.c:516: error: `kprobe_blacklist' undeclared (first use in this function)
kernel/kprobes.c:516: error: (Each undeclared identifier is reported only once
kernel/kprobes.c:516: error: for each function it appears in.)
kernel/kprobes.c: In function `init_kprobes':
kernel/kprobes.c:860: error: `kprobe_blacklist' undeclared (first use in this function)


> ---
>  include/linux/kprobes.h |    7 ++++++
>  kernel/kprobes.c        |   52 
> ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> Index: linux-2.6.25-rc3/include/linux/kprobes.h
> ===================================================================
> --- linux-2.6.25-rc3.orig/include/linux/kprobes.h
> +++ linux-2.6.25-rc3/include/linux/kprobes.h
> @@ -173,6 +173,13 @@ struct kretprobe_blackpoint {
>  	const char *name;
>  	void *addr;
>  };
> +
> +struct kprobe_blackpoint {
> +	const char *name;
> +	unsigned long start_addr;
> +	unsigned long range;
> +};
> +

I'm assuming that the placement of this definition inside
__ARCH_WANT_KPROBES_INSN_SLOT wqs accidental?

--- a/kernel/kprobes.c~kprobes-prevent-probing-of-preempt_schedule-fix
+++ a/kernel/kprobes.c
@@ -72,6 +72,18 @@ DEFINE_MUTEX(kprobe_mutex);		/* Protects
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 
+/*
+ * Normally, functions that we'd want to prohibit kprobes in, are marked
+ * __kprobes. But, there are cases where such functions already belong to
+ * a different section (__sched for preempt_schedule)
+ *
+ * For such cases, we now have a blacklist
+ */
+struct kprobe_blackpoint kprobe_blacklist[] = {
+        {"preempt_schedule",},
+        {NULL}    /* Terminator */
+};
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -89,18 +101,6 @@ struct kprobe_insn_page {
 	int ngarbage;
 };
 
-/*
- * Normally, functions that we'd want to prohibit kprobes in, are marked
- * __kprobes. But, there are cases where such functions already belong to
- * a different section (__sched for preempt_schedule)
- *
- * For such cases, we now have a blacklist
- */
-struct kprobe_blackpoint kprobe_blacklist[] = {
-        {"preempt_schedule",},
-        {NULL}    /* Terminator */
-};
-
 enum kprobe_slot_state {
 	SLOT_CLEAN = 0,
 	SLOT_DIRTY = 1,
_

