Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbZJ1DHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbZJ1DHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932476AbZJ1DHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:07:13 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:43174 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbZJ1DHM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZrOTq2UHMa4WyLJxRz77yciFj2Zlu0PgvHWHgZ2JXpPsDddoDYTAy73JtbuKTV4wdP
         DksSvL+8iwgPRy3HpR+8EjkLm4y1aGvbDKbfLDbWADSMohsXXgZGidTCEGlb5PIpEi8c
         IY6y2B7uqDpdPgPcZJluJXYl5kwwc29f48oD0=
MIME-Version: 1.0
In-Reply-To: <55e03a0a0910271350r6900aaf3qed4cbf31b6359727@mail.gmail.com>
References: <55e03a0a0910271350r6900aaf3qed4cbf31b6359727@mail.gmail.com>
Date: Wed, 28 Oct 2009 11:07:13 +0800
Message-ID: <7b6bb4a50910272007i2c931012y13d204402d65a589@mail.gmail.com>
Subject: Re: 2.6.32-rc5-git3 compile problems
From: Xiaotian Feng <xtfeng@gmail.com>
To: Alex <mysqlstudent@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try this patch, thanks.
---
index b40ac57..04a4272 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -292,8 +292,24 @@ DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);

 #else /* #ifdef RCU_TREE_NONCORE */

-/* Forward declarations for rcutree_plugin.h */
-static inline void rcu_bootup_announce(void);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+/*
+ * Tell them what RCU they are running.
+ */
+static inline void rcu_bootup_announce(void)
+{
+        printk(KERN_INFO
+               "Experimental preemptable hierarchical RCU implementation.\n");
+}
+#else
+/*
+ * Tell them what RCU they are running.
+ */
+static inline void rcu_bootup_announce(void)
+{
+        printk(KERN_INFO "Hierarchical RCU implementation.\n");
+}
+#endif
 long rcu_batches_completed(void);
 static void rcu_preempt_note_context_switch(int cpu);
 static int rcu_preempted_readers(struct rcu_node *rnp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c0cb783..1b96445 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -31,15 +31,6 @@ struct rcu_state rcu_preempt_state =
RCU_STATE_INITIALIZER(rcu_preempt_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);

 /*
- * Tell them what RCU they are running.
- */
-static inline void rcu_bootup_announce(void)
-{
-       printk(KERN_INFO
-              "Experimental preemptable hierarchical RCU implementation.\n");
-}
-
-/*
  * Return the number of RCU-preempt batches processed thus far
  * for debug and statistics.
  */
@@ -462,14 +453,6 @@ void exit_rcu(void)
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */

 /*
- * Tell them what RCU they are running.
- */
-static inline void rcu_bootup_announce(void)
-{
-       printk(KERN_INFO "Hierarchical RCU implementation.\n");
-}
-
-/*
  * Return the number of RCU batches processed thus far for debug & stats.
  */
 long rcu_batches_completed(void)

On Wed, Oct 28, 2009 at 4:50 AM, Alex <mysqlstudent@gmail.com> wrote:
> Hi,
>
> I receive the following error when using defconfig on 2.6.32-rc5-git3:
>
>  CC      kernel/seccomp.o
>  CC      kernel/rcutree.o
> kernel/rcutree.c: In function `__rcu_init':
> kernel/rcutree.h:296: sorry, unimplemented: inlining failed in call to
> 'rcu_bootup_announce': function body not available
> kernel/rcutree.c:1702: sorry, unimplemented: called from here
> make[1]: *** [kernel/rcutree.o] Error 1
> make: *** [kernel] Error 2
>
> Is this something I'm doing wrong? I'm actually trying to compile
> 2.6.31.5 with the default config, and it too fails, for another
> reason. I'm having difficulty compiling 2.6.31 and 2.6.31.5 on x86
> with gcc-3.4.4 and binutils-2.20.51.0.2. I'm also using glibc-2.3.6.
>
>  AS      arch/x86/lib/thunk_32.o
>  CC      arch/x86/lib/usercopy_32.o
>  AR      arch/x86/lib/lib.a
>  LD      vmlinux.o
>  MODPOST vmlinux.o
>  GEN     .version
>  CHK     include/linux/compile.h
>  UPD     include/linux/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
> drivers/built-in.o: In function `con_init':
> vt.c:(.init.text+0x3c5b): undefined reference to `.L1446'
> make: *** [.tmp_vmlinux1] Error 1
>
> I'd sure appreciate any pointers on how to troubleshoot this.
>
> Thanks,
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
