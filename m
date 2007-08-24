Return-Path: <linux-kernel-owner+w=401wt.eu-S1765580AbXHXXKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765580AbXHXXKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759807AbXHXXKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:10:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689AbXHXXKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:10:40 -0400
Date: Fri, 24 Aug 2007 16:10:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
Message-Id: <20070824161029.6236a5f4.akpm@linux-foundation.org>
In-Reply-To: <20070824224707.GA7275@Krystal>
References: <20070824224707.GA7275@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 18:47:07 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Andrew,
> 
> I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> you would have some ideas about what is causing this problem. I'll start
> bissecting it soon. I seems to be caused by an buggy skb_put call in
> kobject_uevent_env.
> 
> Thanks,
> 
> Mathieu
> 
> 
> Synthesizing the initial hotplug events...[   13.738308] skb_over_panic: text:c0252ede len:97 put:11 head:c2237e00 data:c2237e00 tail:0xc2237e61 end:0xc2237e60 dev:<NULL>
> [   13.772252] ------------[ cut here ]------------
> [   13.786057] Kernel BUG at c039e27c [verbose debug info unavailable]
> [   13.804788] invalid opcode: 0000 [#1] PREEMPT SMP 
> [   13.819195] Modules linked in:
> [   13.828350] 
> [   13.832805] Pid: 1038, comm: udevtrigger Not tainted (2.6.23-rc3-mm1-testssmp #281)
> [   13.855695] EIP: 0060:[<c039e27c>] EFLAGS: 00010286 CPU: 0
> [   13.872090] EIP is at skb_over_panic+0x5c/0x60
> [   13.885368] EAX: 00000084 EBX: c2237e00 ECX: 10000000 EDX: 00000000
> [   13.904093] ESI: 00000000 EDI: c2237e56 EBP: c2243eb4 ESP: c2243e88
> [   13.922820]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [   13.938951] Process udevtrigger (pid: 1038, ti=c2242000 task=c22a94f0 task.ti=c2242000)
> [   13.962348] Stack: c05010ac c0252ede 00000061 0000000b c2237e00 c2237e00 c2237e61 c2237e60 
> [   13.987584]        c04d2181 c2bc1e80 00000005 c2243efc c0252ee3 c2237e00 c04d2124 c04ce0b8 
> [   14.012823]        c2b9ed20 00000000 c04ce0b8 c2b9ed20 c04e2e6b c05401a0 c2ac9000 c2243f04 
> [   14.038065] Call Trace:
> [   14.045931]  [<c010971a>] show_trace_log_lvl+0x1a/0x30
> [   14.061321]  [<c01097d8>] show_stack_log_lvl+0xa8/0xe0
> [   14.076707]  [<c01098da>] show_registers+0xca/0x250
> [   14.091312]  [<c0109b70>] die+0x110/0x280
> [   14.103323]  [<c04187c1>] do_trap+0x91/0xc0
> [   14.115857]  [<c0109fc9>] do_invalid_op+0x89/0xa0
> [   14.129944]  [<c041857a>] error_code+0x72/0x78
> [   14.143252]  [<c0252ee3>] kobject_uevent_env+0x353/0x380
> [   14.159155]  [<c0252f1a>] kobject_uevent+0xa/0x10
> [   14.173244]  [<c02c524b>] store_uevent+0x2b/0x70
> [   14.187076]  [<c02c4f6f>] dev_attr_store+0x2f/0x40
> [   14.201425]  [<c01cd0e0>] sysfs_write_file+0xa0/0x100
> [   14.216553]  [<c018cbf9>] vfs_write+0x99/0x130
> [   14.229862]  [<c018d2dd>] sys_write+0x3d/0x70
> [   14.242911]  [<c0108596>] syscall_call+0x7/0xb
> [   14.256223]  =======================
> [   14.266906] INFO: lockdep is turned off.
> [   14.278624] Code: 00 00 89 5c 24 14 8b 98 8c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 ac 10 50 c0 89 44 24 08 e8 64 1f d9 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec  
> [   14.336986] EIP: [<c039e27c>] skb_over_panic+0x5c/0x60 SS:ESP 0068:c2243e88
> 

hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
much all of the fixes were in rc3-mm1 anyway.

I doubt if bisection will tell us a lot: it'll probably point at
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.

What we _would_ like to know is which sysfs file is being written to.  We
used to have a debug patch to exactly address this problem but it got
transferred into Greg's tree from whence it mysteriously disappeared.


Here it is again:


Print the name of the last-accessed sysfs file when we oops, to help track
down oopses which occur in sysfs store/read handlers.  Because these oopses
tend to not leave any trace of the offending code in the stack traces.

Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c   |    1 +
 arch/x86_64/kernel/traps.c |    1 +
 fs/sysfs/file.c            |   14 ++++++++++++++
 include/linux/sysfs.h      |    5 +++++
 4 files changed, 21 insertions(+)

diff -puN arch/i386/kernel/traps.c~sysfs-crash-debugging arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~sysfs-crash-debugging
+++ a/arch/i386/kernel/traps.c
@@ -452,6 +452,7 @@ void die(const char * str, struct pt_reg
 #endif
 		printk("\n");
 
+		sysfs_printk_last_file();
 		if (notify_die(DIE_OOPS, str, regs, err,
 					current->thread.trap_no, SIGSEGV) !=
 				NOTIFY_STOP) {
diff -puN arch/x86_64/kernel/traps.c~sysfs-crash-debugging arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~sysfs-crash-debugging
+++ a/arch/x86_64/kernel/traps.c
@@ -588,6 +588,7 @@ void __kprobes __die(const char * str, s
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
+	sysfs_printk_last_file();
 	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
 	show_registers(regs);
 	add_taint(TAINT_DIE);
diff -puN fs/sysfs/file.c~sysfs-crash-debugging fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-crash-debugging
+++ a/fs/sysfs/file.c
@@ -9,12 +9,20 @@
 #include <linux/poll.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/limits.h>
 #include <asm/uaccess.h>
 
 #include "sysfs.h"
 
 #define to_sattr(a) container_of(a,struct subsys_attribute, attr)
 
+/* used in crash dumps to help with debugging */
+static char last_sysfs_file[PATH_MAX];
+void sysfs_printk_last_file(void)
+{
+	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
+}
+
 /*
  * Subsystem file operations.
  * These operations allow subsystems to have files that can be 
@@ -245,6 +253,12 @@ static int sysfs_open_file(struct inode 
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
+	char *p;
+
+	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
+		   sizeof(last_sysfs_file));
+	if (p)
+		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
 	if (!sysfs_get_active_two(attr_sd))
diff -puN include/linux/sysfs.h~sysfs-crash-debugging include/linux/sysfs.h
--- a/include/linux/sysfs.h~sysfs-crash-debugging
+++ a/include/linux/sysfs.h
@@ -133,6 +133,7 @@ void sysfs_remove_file_from_group(struct
 		const struct attribute *attr, const char *group);
 
 void sysfs_notify(struct kobject * k, char *dir, char *attr);
+void sysfs_printk_last_file(void);
 
 extern int __must_check sysfs_init(void);
 
@@ -234,6 +235,10 @@ static inline int __must_check sysfs_ini
 	return 0;
 }
 
+static inline void sysfs_printk_last_file(void)
+{
+}
+
 #endif /* CONFIG_SYSFS */
 
 #endif /* _SYSFS_H_ */
_

