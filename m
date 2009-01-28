Return-Path: <linux-kernel-owner+w=401wt.eu-S1753009AbZA1Psx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbZA1Psx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZA1Pso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:48:44 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:54115 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZA1Psn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:48:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwEALgJgElMQWt2/2dsb2JhbACBbspkhUcG
Date: Wed, 28 Jan 2009 10:48:24 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [BUG][kprobes][vunmap?]: kprobes may cause memory corruption
Message-ID: <20090128154824.GA6025@Krystal>
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <497FE895.1080708@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:23:26 up 27 days, 15:21,  3 users,  load average: 0.89, 1.04,
	0.95
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Masami Hiramatsu wrote:
>> Hi
>> I found that 2.6.28-rc1+ kernel might cause a random memory corruption
>> including double fault when repeating load/unload kprobe-using module on
>> i386 with CONFIG_HIGHMEN4G=y.
>
> I think there might be two different bugs.
>
> - First bug may be related to vunmap change.
>    - I'm not sure the root cause of this bug.
>    - However, this bug seems to be fixed by my patch(use vm_map_ram in 
> text_poke()).
>
> - Second bug is kprobe_fault_handler bug
>    - I found a clue of this bug which I reported below by using 
> kdump&crash.
>      http://sources.redhat.com/bugzilla/show_bug.cgi?id=9740#c21
>    - I thought this bug should not be fixed by my patch, but as far as I 
> tested,
>      this bug disappeared with my patch.
>

Hi Masami,

This would not surprise me if it came from bug in the new vmap()
implementation done in this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=db64fe02258f1507e13fe5212a989922323685ce

Especially because going from vmap -> vm_map_ram makes this behavior
disappear.

Looking at the commit, I notice that it delays vunmap so it's done in
batch to minimize locking effect. I think it would be good to create a
test case to try to isolate this, without any kprobes/text_poke
involved, which does something like this :

load module (this is also doing vmalloc, so it might be part of the
             problem)
  for i (i=0; i < 400; i++) {
    vmap()
    vfree()
  }
unload module

Another interesting test would be :

  for i (i=0; i < 400; i++) {
    vmalloc()
    vfree()
  }


All this called in a loop. This would help isolating the "vmap" part of
the issue. If this test is not enough, then we should maybe try
something like this in a kernel module (which does what text_poke does
with vmalloc, more or less) in a loop :

char somedata[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
char copydata[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));

void test_vmap(void)
}
  struct page *pages[2];
  char *vaddr;
  int i;

  for (i = 0; i < 2 * PAGE_SIZE; i++)
    copydata[i] = somedata[i];
  page[0] = virt_to_page(&somedata);
  BUG_ON(!page[0]);
  page[1] = virt_to_page(&somedata + PAGE_SIZE);
  BUG_ON(!page[1]);
  vaddr = vmap(pages, 2, VM_MAP, PAGE_KERNEL);
  BUG_ON(!vaddr);

  for (i = 0; i < 2 * PAGE_SIZE; i++)
    vaddr[i] = copydata[i] + 1;
  
  vunmap(vaddr);
  
  for (i = 0; i < 2 * PAGE_SIZE; i++)
    BUG_ON(somedata[i] != copydata[i] + 1);
}


Given you don't seem to have hit the
        for (i = 0; i < len; i++)
                BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
test at the end of text_poke, I suspect the write through the vmapped
area is correctly done, but that the problem may lay in the mm layer.
Maybe it's running out of pre-allocated vmap areas or something like
this ?

Best regards,

Mathieu

>> A set of test code which written in plain c is attached,
>> make genkprobe.ko and run testmod.sh, then the bug will
>> be occurred.
>
> If my thought is correct, previous test-code is only for the second bug.
> I attached a bit different test code(just disabled the fault handler)
> for the first bug.
>
> Thank you,
>
> -- 
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>
>

> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/init.h>
> #include <linux/kprobes.h>
> 
> MODULE_LICENSE("GPL");
> 
> static int kph(struct kprobe *kp, struct pt_regs *regs)
> {
> 	return 0;
> }
> #if 0
> static int kpfh(struct kprobe *kp, struct pt_regs *regs, int nr)
> {
>   printk("fault occurred on kprobes at %p(@%lx:%d)\n", kp->addr, regs->ip, nr);
> 	return 0;
> }
> #else
> #define kpfh NULL
> #endif
> static struct kprobe kp[] = {
> [0]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_accept"},
> [1]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_access"},
> [2]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_acct"},
> [3]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_add_key"},
> [4]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_adjtimex"},
> [5]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_alarm"},
> [6]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_bdflush"},
> [7]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_bind"},
> [8]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_brk"},
> [9]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_capget"},
> [10]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_capset"},
> [11]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_chdir"},
> [12]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_chmod"},
> [13]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_chown"},
> [14]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_chown16"},
> [15]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_chroot"},
> [16]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_clock_getres"},
> [17]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_clock_gettime"},
> [18]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_clock_nanosleep"},
> [19]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_clock_settime"},
> [20]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_close"},
> [21]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_connect"},
> [22]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_creat"},
> [23]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_delete_module"},
> [24]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_dup"},
> [25]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_dup2"},
> [26]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_epoll_create"},
> [27]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_epoll_ctl"},
> [28]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_epoll_pwait"},
> [29]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_epoll_wait"},
> [30]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_eventfd"},
> [31]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="do_execve"},
> [32]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="do_exit"},
> [33]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_exit_group"},
> [34]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_faccessat"},
> [35]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fadvise64"},
> [36]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fadvise64_64"},
> [37]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fchdir"},
> [38]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fchmod"},
> [39]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fchmodat"},
> [40]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fchown"},
> [41]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fchown16"},
> [42]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fchownat"},
> [43]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fcntl"},
> [44]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fcntl64"},
> [45]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fdatasync"},
> [46]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fgetxattr"},
> [47]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_flistxattr"},
> [48]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_flock"},
> [49]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="do_fork"},
> [50]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fremovexattr"},
> [51]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fsetxattr"},
> [52]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fstat"},
> [53]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fstat64"},
> [54]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_newfstat"},
> [55]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fstatat64"},
> [56]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fstatfs"},
> [57]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fstatfs64"},
> [58]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_fsync"},
> [59]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ftruncate"},
> [60]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ftruncate64"},
> [61]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_futex"},
> [62]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_futimesat"},
> [63]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_get_thread_area"},
> [64]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getcwd"},
> [65]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getdents"},
> [66]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getdents64"},
> [67]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getegid16"},
> [68]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getegid"},
> [69]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_geteuid16"},
> [70]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_geteuid"},
> [71]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getgid16"},
> [72]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getgid"},
> [73]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getgroups"},
> [74]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getgroups16"},
> [75]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_gethostname"},
> [76]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getitimer"},
> [77]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getpeername"},
> [78]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getpgid"},
> [79]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getpgrp"},
> [80]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getpid"},
> [81]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getppid"},
> [82]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getpriority"},
> [83]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getresgid16"},
> [84]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getresgid"},
> [85]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getresuid16"},
> [86]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getresuid"},
> [87]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getrlimit"},
> [88]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_old_getrlimit"},
> [89]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getrusage"},
> [90]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getsid"},
> [91]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getsockname"},
> [92]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getsockopt"},
> [93]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_gettid"},
> [94]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_gettimeofday"},
> [95]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getuid16"},
> [96]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getuid"},
> [97]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_getxattr"},
> [98]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_init_module"},
> [99]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_inotify_add_watch"},
> [100]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_inotify_init"},
> [101]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_inotify_rm_watch"},
> [102]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_io_cancel"},
> [103]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_io_destroy"},
> [104]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_io_getevents"},
> [105]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_io_setup"},
> [106]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_io_submit"},
> [107]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ioctl"},
> [108]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ioperm"},
> [109]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_iopl"},
> [110]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ioprio_get"},
> [111]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ioprio_set"},
> [112]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ipc"},
> [113]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_kexec_load"},
> [114]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_keyctl"},
> [115]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_kill"},
> [116]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lchown"},
> [117]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lchown16"},
> [118]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lgetxattr"},
> [119]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_link"},
> [120]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_linkat"},
> [121]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_listen"},
> [122]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_listxattr"},
> [123]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_llistxattr"},
> [124]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_llseek"},
> [125]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lookup_dcookie"},
> [126]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lremovexattr"},
> [127]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lseek"},
> [128]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lsetxattr"},
> [129]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lstat"},
> [130]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_newlstat"},
> [131]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_lstat64"},
> [132]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_madvise"},
> [133]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mincore"},
> [134]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mkdir"},
> [135]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mkdirat"},
> [136]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mknod"},
> [137]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mknodat"},
> [138]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mlock"},
> [139]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mlockall"},
> [140]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mmap2"},
> [141]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_modify_ldt"},
> [142]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mount"},
> [143]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mprotect"},
> [144]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mq_getsetattr"},
> [145]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mq_notify"},
> [146]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mq_open"},
> [147]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mq_timedreceive"},
> [148]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mq_timedsend"},
> [149]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mq_unlink"},
> [150]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_mremap"},
> [151]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_msgctl"},
> [152]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_msgget"},
> [153]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_msgrcv"},
> [154]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_msgsnd"},
> [155]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_msync"},
> [156]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_munlock"},
> [157]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_munlockall"},
> [158]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_munmap"},
> [159]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_nanosleep"},
> [160]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_nfsservctl"},
> [161]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ni_syscall"},
> [162]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_nice"},
> [163]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_open"},
> [164]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_openat"},
> [165]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_pause"},
> [166]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_personality"},
> [167]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_pipe"},
> [168]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_pivot_root"},
> [169]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_poll"},
> [170]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ppoll"},
> [171]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_prctl"},
> [172]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_pread64"},
> [173]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_pselect6"},
> [174]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ptrace"},
> [175]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_pwrite64"},
> [176]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_quotactl"},
> [177]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_read"},
> [178]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_readahead"},
> [179]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_readlink"},
> [180]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_readlinkat"},
> [181]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_readv"},
> [182]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_reboot"},
> [183]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_recv"},
> [184]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_recvfrom"},
> [185]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_recvmsg"},
> [186]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_remap_file_pages"},
> [187]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_removexattr"},
> [188]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rename"},
> [189]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_renameat"},
> [190]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_request_key"},
> [191]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_restart_syscall"},
> [192]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rmdir"},
> [193]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigaction"},
> [194]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigpending"},
> [195]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigprocmask"},
> [196]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigqueueinfo"},
> [197]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigreturn"},
> [198]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigsuspend"},
> [199]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_rt_sigtimedwait"},
> [200]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_get_priority_max"},
> [201]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_get_priority_min"},
> [202]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_getaffinity"},
> [203]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_getparam"},
> [204]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_getscheduler"},
> [205]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_rr_get_interval"},
> [206]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_setaffinity"},
> [207]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_setparam"},
> [208]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_setscheduler"},
> [209]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sched_yield"},
> [210]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_select"},
> [211]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_semctl"},
> [212]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_semget"},
> [213]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_semtimedop"},
> [214]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_semtimedop"},
> [215]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_send"},
> [216]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sendfile"},
> [217]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sendfile64"},
> [218]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sendmsg"},
> [219]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sendto"},
> [220]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_set_thread_area"},
> [221]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_set_tid_address"},
> [222]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setdomainname"},
> [223]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setfsgid"},
> [224]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setfsgid16"},
> [225]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setfsuid"},
> [226]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setfsuid16"},
> [227]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setgid"},
> [228]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setgid16"},
> [229]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setgroups"},
> [230]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setgroups16"},
> [231]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sethostname"},
> [232]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setitimer"},
> [233]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setpgid"},
> [234]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setpriority"},
> [235]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setregid"},
> [236]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setregid16"},
> [237]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setresgid"},
> [238]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setresgid16"},
> [239]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setresuid"},
> [240]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setresuid16"},
> [241]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setreuid"},
> [242]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setreuid16"},
> [243]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setrlimit"},
> [244]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setsid"},
> [245]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setsockopt"},
> [246]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_settimeofday"},
> [247]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setuid16"},
> [248]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setuid"},
> [249]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_setxattr"},
> [250]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sgetmask"},
> [251]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_shmat"},
> [252]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_shmctl"},
> [253]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_shmdt"},
> [254]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_shmget"},
> [255]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_shutdown"},
> [256]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sigaction"},
> [257]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sigaltstack"},
> [258]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_signal"},
> [259]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_signalfd"},
> [260]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sigpending"},
> [261]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sigprocmask"},
> [262]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sigreturn"},
> [263]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sigsuspend"},
> [264]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_socket"},
> [265]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_socketpair"},
> [266]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_splice"},
> [267]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ssetmask"},
> [268]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_stat"},
> [269]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_newstat"},
> [270]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_stat64"},
> [271]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_statfs"},
> [272]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_statfs64"},
> [273]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_stime"},
> [274]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_swapoff"},
> [275]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_swapon"},
> [276]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_symlink"},
> [277]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_symlinkat"},
> [278]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sync"},
> [279]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sysctl"},
> [280]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sysfs"},
> [281]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_sysinfo"},
> [282]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_syslog"},
> [283]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_tee"},
> [284]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_tgkill"},
> [285]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_time"},
> [286]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_timer_create"},
> [287]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_timer_delete"},
> [288]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_timer_getoverrun"},
> [289]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_timer_gettime"},
> [290]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_timer_settime"},
> [291]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_times"},
> [292]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_tkill"},
> [293]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_truncate"},
> [294]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_truncate64"},
> [295]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_umask"},
> [296]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_umount"},
> [297]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_uname"},
> [298]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_olduname"},
> [299]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_newuname"},
> [300]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_unlink"},
> [301]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_unlinkat"},
> [302]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_unshare"},
> [303]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_uselib"},
> [304]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_ustat"},
> [305]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_utime"},
> [306]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_utimensat"},
> [307]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_utimes"},
> [308]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_vhangup"},
> [309]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_vm86"},
> [310]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_vm86old"},
> [311]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_vmsplice"},
> [312]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_wait4"},
> [313]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_waitid"},
> [314]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_write"},
> [315]={.pre_handler=kph, .fault_handler=kpfh, .symbol_name="sys_writev"},
> };
> #define NRPB 316
> 
> static struct kprobe *kps[NRPB];
> 
> int __gen_init(void)
> {
> 	int ret, i;
> 	for (i=0;i<NRPB;i++)
> 		kps[i]=&kp[i];
> 	printk("registering...");
> 	ret = register_kprobes(kps, NRPB);
> 	if (ret) {
> 		printk("failed to register kprobes\n");
> 		return ret;
> 	}
> 	printk("registered\n");
> 	return 0;
> }
> 
> void __gen_exit(void)
> {
> 	printk("unregistering...");
> 	unregister_kprobes(kps, NRPB);
> 	printk("unregistered\n");
> }
> 
> module_init(__gen_init);
> module_exit(__gen_exit);
> 


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
