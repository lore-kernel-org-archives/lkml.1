Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab0BRFBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 00:01:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36373 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0BRFA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 00:00:59 -0500
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
	<1266014143-29444-9-git-send-email-jason.wessel@windriver.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 17 Feb 2010 21:00:49 -0800
In-Reply-To: <1266014143-29444-9-git-send-email-jason.wessel@windriver.com> (Jason Wessel's message of "Fri\, 12 Feb 2010 16\:35\:23 -0600")
Message-ID: <m1zl37xhmm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jason Wessel <jason.wessel@windriver.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 08/28] kdb: core for kgdb back end (2 of 2)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel <jason.wessel@windriver.com> writes:

> This patch contains the hooks and instrumentation into kernel which
> live outside the kernel/debug directory, which the kdb core
> will call to run commands like lsmod, dmesg, bt etc...

You know this dropping the locks from vmalloc_info and swap_info
is down right ugly, and I don't believe it is safe.  That code
was not designed to run while the write_lock is held.

How does kdb build if NOMMU is set?

Similarly with si_swapinfo.  What makes it safe to run the
code without it's locks.  Safe as in no null pointer deferences
or other nasties.

I am not impressed with the mess you make of meminfo_proc_show.
That looks like a maintenance hazard if I ever saw one.  An innocent
change to get some additional info (that happens to take a lock)
will cause kdb to deadlock.

The weird magic include of kdb.h in fs/proc/meminfo.c is also ugly.

Eric

> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 1f24a3e..36d55e1 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -32,11 +32,11 @@ extern struct mm_struct *mm_for_maps(struct task_struct *);
>  
>  #ifdef CONFIG_MMU
>  #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
> -extern void get_vmalloc_info(struct vmalloc_info *vmi);
> +extern void get_vmalloc_info(struct vmalloc_info *vmi, int lock);
>  #else
>  
>  #define VMALLOC_TOTAL 0UL
> -#define get_vmalloc_info(vmi)			\
> +#define get_vmalloc_info(vmi, lock)		\
>  do {						\
>  	(vmi)->used = 0;			\
>  	(vmi)->largest_chunk = 0;		\
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index a65239c..b967cf2 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -10,6 +10,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/swap.h>
>  #include <linux/vmstat.h>
> +#include <linux/kdb.h>
>  #include <asm/atomic.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
> @@ -19,7 +20,7 @@ void __attribute__((weak)) arch_report_meminfo(struct seq_file *m)
>  {
>  }
>  
> -static int meminfo_proc_show(struct seq_file *m, void *v)
> +int _meminfo_proc_show(struct seq_file *m, void *v, int lock)
>  {
>  	struct sysinfo i;
>  	unsigned long committed;
> @@ -34,7 +35,10 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>   */
>  #define K(x) ((x) << (PAGE_SHIFT - 10))
>  	si_meminfo(&i);
> -	si_swapinfo(&i);
> +	if (lock)
> +		si_swapinfo(&i);
> +	else
> +		__si_swapinfo(&i);
>  	committed = percpu_counter_read_positive(&vm_committed_as);
>  	allowed = ((totalram_pages - hugetlb_total_pages())
>  		* sysctl_overcommit_ratio / 100) + total_swap_pages;
> @@ -44,7 +48,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	if (cached < 0)
>  		cached = 0;
>  
> -	get_vmalloc_info(&vmi);
> +	get_vmalloc_info(&vmi, lock);
>  
>  	for (lru = LRU_BASE; lru < NR_LRU_LISTS; lru++)
>  		pages[lru] = global_page_state(NR_LRU_BASE + lru);
> @@ -161,6 +165,11 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  #undef K
>  }
>  
> +static int meminfo_proc_show(struct seq_file *m, void *v)
> +{
> +	return _meminfo_proc_show(m, v, 1);
> +}
> +
>  static int meminfo_proc_open(struct inode *inode, struct file *file)
>  {
>  	return single_open(file, meminfo_proc_show, NULL);
> diff --git a/fs/proc/mmu.c b/fs/proc/mmu.c
> index 8ae221d..10a0f8b 100644
> --- a/fs/proc/mmu.c
> +++ b/fs/proc/mmu.c
> @@ -14,7 +14,7 @@
>  #include <asm/pgtable.h>
>  #include "internal.h"
>  
> -void get_vmalloc_info(struct vmalloc_info *vmi)
> +void get_vmalloc_info(struct vmalloc_info *vmi, int lock)
>  {
>  	struct vm_struct *vma;
>  	unsigned long free_area_size;
> @@ -30,7 +30,8 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
>  
>  		prev_end = VMALLOC_START;
>  
> -		read_lock(&vmlist_lock);
> +		if (lock)
> +			read_lock(&vmlist_lock);
>  
>  		for (vma = vmlist; vma; vma = vma->next) {
>  			unsigned long addr = (unsigned long) vma->addr;
> @@ -55,6 +56,7 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
>  		if (VMALLOC_END - prev_end > vmi->largest_chunk)
>  			vmi->largest_chunk = VMALLOC_END - prev_end;
>  
> -		read_unlock(&vmlist_lock);
> +		if (lock)
> +			read_unlock(&vmlist_lock);
>  	}
>  }
> diff --git a/include/asm-generic/kmap_types.h b/include/asm-generic/kmap_types.h
> index e5f234a..97e807c 100644
> --- a/include/asm-generic/kmap_types.h
> +++ b/include/asm-generic/kmap_types.h
> @@ -28,7 +28,8 @@ KMAP_D(15)	KM_UML_USERCOPY,
>  KMAP_D(16)	KM_IRQ_PTE,
>  KMAP_D(17)	KM_NMI,
>  KMAP_D(18)	KM_NMI_PTE,
> -KMAP_D(19)	KM_TYPE_NR
> +KMAP_D(19)	KM_KDB,
> +KMAP_D(20)	KM_TYPE_NR
>  };
>  
>  #undef KMAP_D
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index a2602a8..c326282 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -312,6 +312,7 @@ extern struct page *swapin_readahead(swp_entry_t, gfp_t,
>  /* linux/mm/swapfile.c */
>  extern long nr_swap_pages;
>  extern long total_swap_pages;
> +extern void __si_swapinfo(struct sysinfo *);
>  extern void si_swapinfo(struct sysinfo *);
>  extern swp_entry_t get_swap_page(void);
>  extern swp_entry_t get_swap_page_of_type(int);
> @@ -377,6 +378,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
>  
>  #define si_swapinfo(val) \
>  	do { (val)->freeswap = (val)->totalswap = 0; } while (0)
> +#define __si_swapinfo(val) si_swapinfo(val)
>  /* only sparc can not include linux/pagemap.h in this file
>   * so leave page_cache_release and release_pages undeclared... */
>  #define free_page_and_swap_cache(page) \
> diff --git a/init/main.c b/init/main.c
> index 4cb47a1..9d415a1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -63,6 +63,7 @@
>  #include <linux/sched.h>
>  #include <linux/signal.h>
>  #include <linux/idr.h>
> +#include <linux/kdb.h>
>  #include <linux/ftrace.h>
>  #include <linux/async.h>
>  #include <linux/kmemcheck.h>
> @@ -659,6 +660,7 @@ asmlinkage void __init start_kernel(void)
>  	key_init();
>  	radix_tree_init();
>  	security_init();
> +	kdb_init(KDB_INIT_FULL);
>  	vfs_caches_init(totalram_pages);
>  	signals_init();
>  	/* rootfs populating might need page-writeback */
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 8e5288a..dc08f8b 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -16,6 +16,7 @@
>  #include <linux/init.h>
>  #include <linux/seq_file.h>
>  #include <linux/fs.h>
> +#include <linux/kdb.h>
>  #include <linux/err.h>
>  #include <linux/proc_fs.h>
>  #include <linux/sched.h>	/* for cond_resched */
> @@ -515,6 +516,26 @@ static int kallsyms_open(struct inode *inode, struct file *file)
>  	return ret;
>  }
>  
> +#ifdef	CONFIG_KGDB_KDB
> +const char *kdb_walk_kallsyms(loff_t *pos)
> +{
> +	static struct kallsym_iter kdb_walk_kallsyms_iter;
> +	if (*pos == 0) {
> +		memset(&kdb_walk_kallsyms_iter, 0,
> +		       sizeof(kdb_walk_kallsyms_iter));
> +		reset_iter(&kdb_walk_kallsyms_iter, 0);
> +	}
> +	while (1) {
> +		if (!update_iter(&kdb_walk_kallsyms_iter, *pos))
> +			return NULL;
> +		++*pos;
> +		/* Some debugging symbols have no name.  Ignore them. */
> +		if (kdb_walk_kallsyms_iter.name[0])
> +			return kdb_walk_kallsyms_iter.name;
> +	}
> +}
> +#endif	/* CONFIG_KGDB_KDB */
> +
>  static const struct file_operations kallsyms_operations = {
>  	.open = kallsyms_open,
>  	.read = seq_read,
> diff --git a/kernel/module.c b/kernel/module.c
> index f82386b..e59aca1 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -79,6 +79,10 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
>  DEFINE_MUTEX(module_mutex);
>  EXPORT_SYMBOL_GPL(module_mutex);
>  static LIST_HEAD(modules);
> +#ifdef CONFIG_KGDB_KDB
> +struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
> +#endif /* CONFIG_KGDB_KDB */
> +
>  
>  /* Block module loading/unloading? */
>  int modules_disabled = 0;
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1751c45..d86c91a 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -420,6 +420,22 @@ SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
>  	return do_syslog(type, buf, len);
>  }
>  
> +#ifdef	CONFIG_KGDB_KDB
> +/* kdb dmesg command needs access to the syslog buffer.  do_syslog()
> + * uses locks so it cannot be used during debugging.  Just tell kdb
> + * where the start and end of the physical and logical logs are.  This
> + * is equivalent to do_syslog(3).
> + */
> +void kdb_syslog_data(char *syslog_data[4])
> +{
> +	syslog_data[0] = log_buf;
> +	syslog_data[1] = log_buf + log_buf_len;
> +	syslog_data[2] = log_buf + log_end -
> +		(logged_chars < log_buf_len ? logged_chars : log_buf_len);
> +	syslog_data[3] = log_buf + log_end;
> +}
> +#endif	/* CONFIG_KGDB_KDB */
> +
>  /*
>   * Call the console drivers on a range of log_buf
>   */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 3a8fb30..92ab8b8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9802,9 +9802,9 @@ void normalize_rt_tasks(void)
>  
>  #endif /* CONFIG_MAGIC_SYSRQ */
>  
> -#ifdef CONFIG_IA64
> +#if defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
>  /*
> - * These functions are only useful for the IA64 MCA handling.
> + * These functions are only useful for the IA64 MCA handling, or kdb.
>   *
>   * They can only be called when the whole system has been
>   * stopped - every CPU needs to be quiescent, and no scheduling
> @@ -9824,6 +9824,9 @@ struct task_struct *curr_task(int cpu)
>  	return cpu_curr(cpu);
>  }
>  
> +#endif /* defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB) */
> +
> +#ifdef CONFIG_IA64
>  /**
>   * set_curr_task - set the current task for a given cpu.
>   * @cpu: the processor in question.
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 934ae5e..96ecbf8 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2718,3 +2718,43 @@ void __init signals_init(void)
>  {
>  	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
>  }
> +
> +#ifdef CONFIG_KGDB_KDB
> +#include <linux/kdb.h>
> +/*
> + * kdb_send_sig_info - Allows kdb to send signals without exposing
> + * signal internals.  This function checks if the required locks are
> + * available before calling the main signal code, to avoid kdb
> + * deadlocks.
> + */
> +void
> +kdb_send_sig_info(struct task_struct *t, struct siginfo *info)
> +{
> +	static struct task_struct *kdb_prev_t;
> +	int sig, new_t;
> +	if (!spin_trylock(&t->sighand->siglock)) {
> +		kdb_printf("Can't do kill command now.\n"
> +			   "The sigmask lock is held somewhere else in "
> +			   "kernel, try again later\n");
> +		return;
> +	}
> +	spin_unlock(&t->sighand->siglock);
> +	new_t = kdb_prev_t != t;
> +	kdb_prev_t = t;
> +	if (t->state != TASK_RUNNING && new_t) {
> +		kdb_printf("Process is not RUNNING, sending a signal from "
> +			   "kdb risks deadlock\n"
> +			   "on the run queue locks. "
> +			   "The signal has _not_ been sent.\n"
> +			   "Reissue the kill command if you want to risk "
> +			   "the deadlock.\n");
> +		return;
> +	}
> +	sig = info->si_signo;
> +	if (send_sig_info(sig, info, t))
> +		kdb_printf("Fail to deliver Signal %d to process %d.\n",
> +			   sig, t->pid);
> +	else
> +		kdb_printf("Signal %d is sent to process %d.\n", sig, t->pid);
> +}
> +#endif	/* CONFIG_KGDB_KDB */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6c0585b..dc2039e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -13,6 +13,7 @@
>  #include <linux/swap.h>
>  #include <linux/vmalloc.h>
>  #include <linux/pagemap.h>
> +#include <linux/kdb.h>
>  #include <linux/namei.h>
>  #include <linux/shm.h>
>  #include <linux/blkdev.h>
> @@ -2056,12 +2057,11 @@ out:
>  	return error;
>  }
>  
> -void si_swapinfo(struct sysinfo *val)
> +void __si_swapinfo(struct sysinfo *val)
>  {
>  	unsigned int type;
>  	unsigned long nr_to_be_unused = 0;
>  
> -	spin_lock(&swap_lock);
>  	for (type = 0; type < nr_swapfiles; type++) {
>  		struct swap_info_struct *si = swap_info[type];
>  
> @@ -2070,6 +2070,12 @@ void si_swapinfo(struct sysinfo *val)
>  	}
>  	val->freeswap = nr_swap_pages + nr_to_be_unused;
>  	val->totalswap = total_swap_pages + nr_to_be_unused;
> +}
> +
> +void si_swapinfo(struct sysinfo *val)
> +{
> +	spin_lock(&swap_lock);
> +	__si_swapinfo(val);
>  	spin_unlock(&swap_lock);
>  }
>  
> -- 
> 1.6.4.rc1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
