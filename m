Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbXHYAQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbXHYAQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbXHYAQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:16:41 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:56387 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756910AbXHYAQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:16:40 -0400
Date: Fri, 24 Aug 2007 20:16:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
Subject: Re: kernel BUG with 2.6.23-rc3-mm1: skb_over_panic
Message-ID: <20070825001638.GB9811@Krystal>
References: <20070824224707.GA7275@Krystal> <20070824161029.6236a5f4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070824161029.6236a5f4.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:15:35 up 26 days, 34 min,  2 users,  load average: 0.13, 0.20, 0.22
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 24 Aug 2007 18:47:07 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Andrew,
> > 
> > I get the following BUG when booting 2.6.23-rc3-mm1 on i386. I wonder if
> > you would have some ideas about what is causing this problem. I'll start
> > bissecting it soon. I seems to be caused by an buggy skb_put call in
> > kobject_uevent_env.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > 
> 
> hm, don't know, sorry.  Kay fixed a few things in there, but iirc pretty
> much all of the fixes were in rc3-mm1 anyway.
> 
> I doubt if bisection will tell us a lot: it'll probably point at
> gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch.
> 
> What we _would_ like to know is which sysfs file is being written to.  We
> used to have a debug patch to exactly address this problem but it got
> transferred into Greg's tree from whence it mysteriously disappeared.
> 

Ok, here it is:

filename :

/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev

[   13.737735] ------------[ cut here ]------------
[   13.751544] Kernel BUG at c039e11c [verbose debug info unavailable]
[   13.770287] invalid opcode: 0000 [#1] PREEMPT SMP 
[   13.784736] last sysfs file: /devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/rev
[   13.809714] Modules linked in:
[   13.818873] 
[   13.823330] Pid: 1038, comm: udevtrigger Not tainted (2.6.23-rc3-mm1-testssmp #283)
[   13.846218] EIP: 0060:[<c039e11c>] EFLAGS: 00010286 CPU: 1
[   13.862616] EIP is at skb_over_panic+0x5c/0x60
[   13.875894] EAX: 00000084 EBX: c2227e00 ECX: 10000000 EDX: 00000000
[   13.894632] ESI: 00000000 EDI: c2227e56 EBP: c2ea9eb4 ESP: c2ea9e88
[   13.913372]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   13.929516] Process udevtrigger (pid: 1038, ti=c2ea8000 task=c2baa070 task.ti=c2ea8000)
[   13.952918] Stack: c05010f0 c0252e3e 00000061 0000000b c2227e00 c2227e00 c2227e61 c2227e60 
[   13.978200]        c04d21c5 c2287c80 00000005 c2ea9efc c0252e43 c2227e00 c04d2168 c04ce0e4 
[   14.003471]        c20fc2a0 00000000 c04ce0e4 c20fc2a0 c04e2eaf c05401e0 c225a000 c2ea9f04 
[   14.028749] Call Trace:
[   14.036622]  [<c010971a>] show_trace_log_lvl+0x1a/0x30
[   14.052019]  [<c01097d8>] show_stack_log_lvl+0xa8/0xe0
[   14.067412]  [<c01098da>] show_registers+0xca/0x250
[   14.082028]  [<c0109b75>] die+0x115/0x280
[   14.094047]  [<c04187c1>] do_trap+0x91/0xc0
[   14.106586]  [<c0109fc9>] do_invalid_op+0x89/0xa0
[   14.120680]  [<c041857a>] error_code+0x72/0x78
[   14.134002]  [<c0252e43>] kobject_uevent_env+0x353/0x380
[   14.149915]  [<c0252e7a>] kobject_uevent+0xa/0x10
[   14.164012]  [<c02c523b>] store_uevent+0x2b/0x70
[   14.177851]  [<c02c4f5f>] dev_attr_store+0x2f/0x40
[   14.192207]  [<c01cd080>] sysfs_write_file+0xa0/0x100
[   14.207344]  [<c018cb89>] vfs_write+0x99/0x130
[   14.220661]  [<c018d26d>] sys_write+0x3d/0x70
[   14.233720]  [<c0108596>] syscall_call+0x7/0xb
[   14.247036]  =======================
[   14.257723] INFO: lockdep is turned off.
[   14.269448] Code: 00 00 89 5c 24 14 8b 98 8c 00 00 00 89 54 24 0c 89 5c 24 10 8b 40 50 89 4c 24 04 c7 04 24 f0 10 50 c0 89 44 24 08 e8 94 20 d9 ff <0f> 0b eb fe 55 89 e5 56 89 d6 53 89 c3 83 ec 0c 8b 40 50 39 
[   14.328022] EIP: [<c039e11c>] skb_over_panic+0x5c/0x60 SS:ESP 0068:c2ea9e88
/etc/rcS.d/S03udev: line 253:  1038 Segmentation fault      udevtrigger

> 
> Here it is again:
> 
> 
> Print the name of the last-accessed sysfs file when we oops, to help track
> down oopses which occur in sysfs store/read handlers.  Because these oopses
> tend to not leave any trace of the offending code in the stack traces.
> 
> Cc: Greg KH <greg@kroah.com>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/i386/kernel/traps.c   |    1 +
>  arch/x86_64/kernel/traps.c |    1 +
>  fs/sysfs/file.c            |   14 ++++++++++++++
>  include/linux/sysfs.h      |    5 +++++
>  4 files changed, 21 insertions(+)
> 
> diff -puN arch/i386/kernel/traps.c~sysfs-crash-debugging arch/i386/kernel/traps.c
> --- a/arch/i386/kernel/traps.c~sysfs-crash-debugging
> +++ a/arch/i386/kernel/traps.c
> @@ -452,6 +452,7 @@ void die(const char * str, struct pt_reg
>  #endif
>  		printk("\n");
>  
> +		sysfs_printk_last_file();
>  		if (notify_die(DIE_OOPS, str, regs, err,
>  					current->thread.trap_no, SIGSEGV) !=
>  				NOTIFY_STOP) {
> diff -puN arch/x86_64/kernel/traps.c~sysfs-crash-debugging arch/x86_64/kernel/traps.c
> --- a/arch/x86_64/kernel/traps.c~sysfs-crash-debugging
> +++ a/arch/x86_64/kernel/traps.c
> @@ -588,6 +588,7 @@ void __kprobes __die(const char * str, s
>  	printk("DEBUG_PAGEALLOC");
>  #endif
>  	printk("\n");
> +	sysfs_printk_last_file();
>  	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
>  	show_registers(regs);
>  	add_taint(TAINT_DIE);
> diff -puN fs/sysfs/file.c~sysfs-crash-debugging fs/sysfs/file.c
> --- a/fs/sysfs/file.c~sysfs-crash-debugging
> +++ a/fs/sysfs/file.c
> @@ -9,12 +9,20 @@
>  #include <linux/poll.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> +#include <linux/limits.h>
>  #include <asm/uaccess.h>
>  
>  #include "sysfs.h"
>  
>  #define to_sattr(a) container_of(a,struct subsys_attribute, attr)
>  
> +/* used in crash dumps to help with debugging */
> +static char last_sysfs_file[PATH_MAX];
> +void sysfs_printk_last_file(void)
> +{
> +	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> +}
> +
>  /*
>   * Subsystem file operations.
>   * These operations allow subsystems to have files that can be 
> @@ -245,6 +253,12 @@ static int sysfs_open_file(struct inode 
>  	struct sysfs_buffer * buffer;
>  	struct sysfs_ops * ops = NULL;
>  	int error;
> +	char *p;
> +
> +	p = d_path(file->f_dentry, sysfs_mount, last_sysfs_file,
> +		   sizeof(last_sysfs_file));
> +	if (p)
> +		memmove(last_sysfs_file, p, strlen(p) + 1);
>  
>  	/* need attr_sd for attr and ops, its parent for kobj */
>  	if (!sysfs_get_active_two(attr_sd))
> diff -puN include/linux/sysfs.h~sysfs-crash-debugging include/linux/sysfs.h
> --- a/include/linux/sysfs.h~sysfs-crash-debugging
> +++ a/include/linux/sysfs.h
> @@ -133,6 +133,7 @@ void sysfs_remove_file_from_group(struct
>  		const struct attribute *attr, const char *group);
>  
>  void sysfs_notify(struct kobject * k, char *dir, char *attr);
> +void sysfs_printk_last_file(void);
>  
>  extern int __must_check sysfs_init(void);
>  
> @@ -234,6 +235,10 @@ static inline int __must_check sysfs_ini
>  	return 0;
>  }
>  
> +static inline void sysfs_printk_last_file(void)
> +{
> +}
> +
>  #endif /* CONFIG_SYSFS */
>  
>  #endif /* _SYSFS_H_ */
> _
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
