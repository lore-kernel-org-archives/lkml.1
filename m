Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbYCDI5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbYCDI5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYCDI5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:57:14 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:41964 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752193AbYCDI5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:57:13 -0500
From: Srinivasa DS <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] To refuse users from probing preempt_schedule()
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, srikar@linux.vnet.ibm.com
References: <200802251127.40579.srinivasa@in.ibm.com> <20080304002521.2e67d7a5.akpm@linux-foundation.org>
In-Reply-To: <20080304002521.2e67d7a5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 4 Mar 2008 14:26:37 +0530
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803041426.37293.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008 01:55:21 pm Andrew Morton wrote:
> On Mon, 25 Feb 2008 11:27:40 +0530 srinivasa <srinivasa@in.ibm.com> wrote:
> > From: Srinivasa Ds <srinivasa@in.ibm.com>
> >
> > This patch prohibits user from probing preempt_schedule(). One way of
> > prohibiting the user from probing functions is by marking such
> > functions with __kprobes. But this method doesn't work for those
> > functions, which are already marked to different section like
> > preempt_schedule() (belongs to __sched section). So we use blacklist
> > approach to refuse user from probing these functions.
> >
> > In blacklist approach we populate the blacklisted function's starting
> > address and its size in kprobe_blacklist structure. Then we verify the
> > user specified address against start and end of the blacklisted function.
> > So any attempt to register probe on blacklisted functions will be
> > rejected.
> >
> > please let me know your comments.
>
> sparc64:
>
> kernel/kprobes.c: In function `in_kprobes_functions':
> kernel/kprobes.c:516: error: `kprobe_blacklist' undeclared (first use in
> this function) kernel/kprobes.c:516: error: (Each undeclared identifier is
> reported only once kernel/kprobes.c:516: error: for each function it
> appears in.)
> kernel/kprobes.c: In function `init_kprobes':
> kernel/kprobes.c:860: error: `kprobe_blacklist' undeclared (first use in
> this function)
>
> > ---
> >  include/linux/kprobes.h |    7 ++++++
> >  kernel/kprobes.c        |   52
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 59 insertions(+)
> >
> > Index: linux-2.6.25-rc3/include/linux/kprobes.h
> > ===================================================================
> > --- linux-2.6.25-rc3.orig/include/linux/kprobes.h
> > +++ linux-2.6.25-rc3/include/linux/kprobes.h
> > @@ -173,6 +173,13 @@ struct kretprobe_blackpoint {
> >  	const char *name;
> >  	void *addr;
> >  };
> > +
> > +struct kprobe_blackpoint {
> > +	const char *name;
> > +	unsigned long start_addr;
> > +	unsigned long range;
> > +};
> > +
>
> I'm assuming that the placement of this definition inside
> __ARCH_WANT_KPROBES_INSN_SLOT wqs accidental?

Yes Andrew.  Sorry I over looked __ARCH_WANT_KPROBES_INSN_SLOT and placed the 
struct kprobe_black_point in a wrong place. 

    Patch, that you have attached below looks good, but for your reference, 
Iam attaching the modified patch below.

>
> --- a/kernel/kprobes.c~kprobes-prevent-probing-of-preempt_schedule-fix
> +++ a/kernel/kprobes.c
> @@ -72,6 +72,18 @@ DEFINE_MUTEX(kprobe_mutex);		/* Protects
>  DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
>  static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
>
> +/*
> + * Normally, functions that we'd want to prohibit kprobes in, are marked
> + * __kprobes. But, there are cases where such functions already belong to
> + * a different section (__sched for preempt_schedule)
> + *
> + * For such cases, we now have a blacklist
> + */
> +struct kprobe_blackpoint kprobe_blacklist[] = {
> +        {"preempt_schedule",},
> +        {NULL}    /* Terminator */
> +};
> +
>  #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
>  /*
>   * kprobe->ainsn.insn points to the copy of the instruction to be
> @@ -89,18 +101,6 @@ struct kprobe_insn_page {
>  	int ngarbage;
>  };
>
> -/*
> - * Normally, functions that we'd want to prohibit kprobes in, are marked
> - * __kprobes. But, there are cases where such functions already belong to
> - * a different section (__sched for preempt_schedule)
> - *
> - * For such cases, we now have a blacklist
> - */
> -struct kprobe_blackpoint kprobe_blacklist[] = {
> -        {"preempt_schedule",},
> -        {NULL}    /* Terminator */
> -};
> -
>  enum kprobe_slot_state {
>  	SLOT_CLEAN = 0,
>  	SLOT_DIRTY = 1,
> _


---
 include/linux/kprobes.h |    7 ++++++
 kernel/kprobes.c        |   51 
++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

Index: linux-2.6.25-rc3/include/linux/kprobes.h
===================================================================
--- linux-2.6.25-rc3.orig/include/linux/kprobes.h
+++ linux-2.6.25-rc3/include/linux/kprobes.h
@@ -173,6 +173,13 @@ struct kretprobe_blackpoint {
 	const char *name;
 	void *addr;
 };
+
+struct kprobe_blackpoint {
+	const char *name;
+	unsigned long start_addr;
+	unsigned long range;
+};
+
 extern struct kretprobe_blackpoint kretprobe_blacklist[];
 
 static inline void kretprobe_assert(struct kretprobe_instance *ri,
Index: linux-2.6.25-rc3/kernel/kprobes.c
===================================================================
--- linux-2.6.25-rc3.orig/kernel/kprobes.c
+++ linux-2.6.25-rc3/kernel/kprobes.c
@@ -72,6 +72,17 @@ DEFINE_MUTEX(kprobe_mutex);		/* Protects
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
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -492,9 +503,22 @@ static int __kprobes register_aggr_kprob
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
+	struct kprobe_blackpoint *kb;
+
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
+	/*
+	 * If there exists a kprobe_blacklist, verify and
+	 * fail any probe registration in the prohibited area
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		if (kb->start_addr) {
+			if (addr >= kb->start_addr &&
+			    addr < (kb->start_addr + kb->range))
+				return -EINVAL;
+		}
+	}
 	return 0;
 }
 
@@ -805,6 +829,11 @@ void __kprobes unregister_kretprobe(stru
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
+	unsigned long offset = 0, size = 0;
+	char *modname, namebuf[128];
+	const char *symbol_name;
+	void *addr;
+	struct kprobe_blackpoint *kb;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -813,6 +842,28 @@ static int __init init_kprobes(void)
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 	}
 
+	/*
+	 * Lookup and populate the kprobe_blacklist.
+	 *
+	 * Unlike the kretprobe blacklist, we'll need to determine
+	 * the range of addresses that belong to the said functions,
+	 * since a kprobe need not necessarily be at the beginning
+	 * of a function.
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		kprobe_lookup_name(kb->name, addr);
+		if (!addr)
+			continue;
+
+		kb->start_addr = (unsigned long)addr;
+		symbol_name = kallsyms_lookup(kb->start_addr,
+				&size, &offset, &modname, namebuf);
+		if (!symbol_name)
+			kb->range = 0;
+		else
+			kb->range = size;
+	}
+
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {



