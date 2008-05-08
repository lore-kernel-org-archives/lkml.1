Return-Path: <linux-kernel-owner+w=401wt.eu-S933968AbYEHWDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968AbYEHWDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbYEHWCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:02:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330AbYEHWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:02:48 -0400
Date: Fri, 9 May 2008 00:02:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix
	AIM7 40% regression with 2.6.26-rc1)
Message-ID: <20080508220229.GA15099@elte.hu>
References: <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org> <20080508214557.GA13311@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508214557.GA13311@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> yeah, i captured a trace of all the down()s that happen in the 
> workload, using ftrace/sched_switch + stacktrace + a tracepoint in 
> down(). Here's the semaphore activities in the trace:

i've updated the trace with a better one:

>    http://redhat.com/~mingo/misc/aim7-ftrace.txt

the first one had some idle time in it as well plus the effects of a 
2000-task Ctrl-Z - which skewed the histograms.

the new stats are more straightforward. down() callsite histogram:

     42  down <= lock_kernel <= de_put <= proc_delete_inode <
     42  down <= lock_kernel <= proc_lookup_de <= proc_lookup <
     78  down <= lock_kernel <= proc_lookup_de <= proc_lookup <
    310  down <= lock_kernel <= sys_fcntl <= system_call_after_swapgs <
    332  down <= lock_kernel <= vfs_ioctl <= do_vfs_ioctl <
    380  down <= lock_kernel <= tty_release <= __fput <
    422  down <= lock_kernel <= chrdev_open <= __dentry_open <

hm, why is chrdev_open() called all that often?

top-5 wakeups:

      4  default_wake_function <= __wake_up_common <= complete <= migration_thread <= kthread <= child_rip <
      4  wake_up_process <= sched_exec <= do_execve <= sys_execve <= stub_execve <=  <
      8  wake_up_process <= __mutex_unlock_slowpath <= mutex_unlock <= do_filp_open <= do_sys_open <= sys_open <
     40  default_wake_function <= autoremove_wake_function <= __wake_up_common <= __wake_up <= sock_def_wakeup <= tcp_rcv_state_process <
     98  default_wake_function <= __wake_up_common <= __wake_up_sync <= do_notify_parent <= do_exit <= do_group_exit <

i.e. very little wakeup activities. Top 10 scheduling points:

     10  schedule <= kjournald <= kthread <= child_rip <
     12  schedule <= __down_write_nested <= __down_write <= down_write <
     29  schedule <= worker_thread <= kthread <= child_rip <
     40  schedule <= schedule_timeout <= inet_stream_connect <= sys_connect <
     59  schedule <= __cond_resched <= _cond_resched <= generic_file_buffered_write <
    111  schedule <= ksoftirqd <= kthread <= child_rip <
    119  schedule <= do_wait <= sys_wait4 <= system_call_after_swapgs <
    659  schedule <= do_exit <= do_group_exit <= sys_exit_group <
    781  schedule <= sysret_careful <=  <= 0 <
   1347  schedule <= retint_careful <=  <= 0 <

> and here's a few seconds worth of NMI driven readprofile output:

the NMI profiling results were accurate.

	Ingo
