Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbXL1Hfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbXL1Hfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755312AbXL1Hfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:35:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbXL1Hfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:35:30 -0500
Date: Thu, 27 Dec 2007 23:34:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-mm1 - crash in tick_sched_timer/update_process_times
Message-Id: <20071227233411.c1114622.akpm@linux-foundation.org>
In-Reply-To: <18487.1198778074@turing-police.cc.vt.edu>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<18487.1198778074@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2007 12:54:34 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Sat, 22 Dec 2007 23:30:56 PST, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> 
> I seem to be on a roll here... :)

Yup.  But please do try to get the cc's right.  Especially when I'm lying
on a beach.

> X86_64 kernel, Dell Latitude D820, Core2 T7200 processor...
> 
> (Yes, I know it's tainted.  If I *have* to, I'll try to get an untainted one,
> which will be a pain - the oss 'nv' driver is a tad busticated on my box at
> the moment).

I doubt if the nvidia driver is involved in this.

> Took me a bunch of hours to find a way to repeat this one, but it seems
> pretty consistent - I exit an 'Eterm' process and ka-blam.  First guess
> I have is that we hit a race and the timer popped right in the middle of
> a process exiting and we try to update process times on an already-defunct
> process table entry?
> 
> This ring any bells or brown-paper-bag D'Oh!s before I go bisecting?
> 
> [15345.901919] Unable to handle kernel paging request at 000000af008c00cd RIP:
> [15345.901934]  [<ffffffff802310d9>] scheduler_tick+0xdb/0x1c4
> [15345.901952] PGD 0
> [15345.901959] Oops: 0000 [1] PREEMPT SMP
> [15345.901972] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
> [15345.901978] CPU 1
> [15345.901984] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic acpi_cpufreq tpm_tis pcmcia gspca(U) iwl3945 firmware_class iTCO_wdt yenta_socket compat_ioctl32 ohci1394 rsrc_nonstatic iTCO_vendor_support mac80211 ieee1394 pcmcia_core nvidia(P)(U) watchdog_core battery videodev ac watchdog_dev v4l2_common snd_hda_intel v4l1_compat thermal power_supply cfg80211 button intel_agp processor rtc
> [15345.902170] Pid: 0, comm: Eterm Tainted: P        2.6.24-rc6-mm1 #4
> [15345.902176] RIP: 0010:[<ffffffff802310d9>]  [<ffffffff802310d9>] scheduler_tick+0xdb/0x1c4
> [15345.902189] RSP: 0018:ffff81007f8a3eb8  EFLAGS: 00010083
> [15345.902195] RAX: 000000af008c005d RBX: 00000df4fefac7d9 RCX: 0000000000000004
> [15345.902202] RDX: 0000000000000004 RSI: ffff81007e405600 RDI: ffff810001011180
> [15345.902208] RBP: ffff81007f8a3ed8 R08: 0000000000000010 R09: 0000000000000001
> [15345.902214] R10: ffff8100808f4000 R11: ffffffff8071d180 R12: ffff810001011180
> [15345.902219] R13: 0000000000000001 R14: ffff81007e405600 R15: 0000000000000001
> [15345.902226] FS:  0000000000000000(0000) GS:ffff81007f86f9c0(0063) knlGS:00000000f7dab6c0
> [15345.902233] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [15345.902238] CR2: 000000af008c00cd CR3: 00000000766c8000 CR4: 00000000000006e0
> [15345.902244] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [15345.902249] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [15345.902256] Process Eterm (pid: 0, threadinfo 4394404dffffffff, task ffff81007e405600)
> [15345.902261] Stack:  0000000000000001 0000000000000000 ffff81007e405600 00000c71d7bbe7da
> [15345.902279]  ffff81007f8a3f08 ffffffff8023f913 ffff81007f8a3f08 ffff81000100e060
> [15345.902293]  ffff810077161b08 ffff81000100df60 ffff81007f8a3f38 ffffffff80251b7d
> [15345.902306] Call Trace:
> [15345.902312]  <IRQ>  [<ffffffff8023f913>] update_process_times+0x4a/0x5b
> [15345.902334]  [<ffffffff80251b7d>] tick_sched_timer+0x8e/0xcb
> [15345.902345]  [<ffffffff8024ce2c>] hrtimer_interrupt+0x111/0x1a1
> [15345.902357]  [<ffffffff8022733e>] ia32_setup_frame+0xb5/0x1b7
> [15345.902367]  [<ffffffff8021f174>] smp_apic_timer_interrupt+0x86/0xa6
> [15345.902377]  [<ffffffff8020cca6>] apic_timer_interrupt+0x66/0x70
> [15345.902383]  <EOI>
> [15345.902389]
> [15345.902390] Code: ff 50 70 4c 89 e7 e8 4a 2d 2f 00 44 89 ef e8 85 9f ff ff 41
> [15345.902445] RIP  [<ffffffff802310d9>] scheduler_tick+0xdb/0x1c4
> [15345.902455]  RSP <ffff81007f8a3eb8>
> [15345.902461] CR2: 000000af008c00cd
> 
> 
