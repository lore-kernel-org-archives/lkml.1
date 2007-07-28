Return-Path: <linux-kernel-owner+w=401wt.eu-S938071AbXG1Ijk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938071AbXG1Ijk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 04:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbXG1Ijb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 04:39:31 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbXG1Ij3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 04:39:29 -0400
Date: Sat, 28 Jul 2007 01:38:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Dag Brattli" <dagb@cs.uit.no>,
       samuel@sortiz.org, Paul Menage <menage@google.com>
Subject: Re: 2.6.23-rc1-mm1 -- INFO: possible recursive locking detected --
 (&hashbin->hb_spinlock){....}, at: [<c03d95d3>] irias_seq_show+0xba/0x1a8
Message-Id: <20070728013859.5125f685.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0707280001o54f479edqf1139c9c79c52ec9@mail.gmail.com>
References: <a44ae5cd0707280001o54f479edqf1139c9c79c52ec9@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007 00:01:23 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> Looking to see whether reading /proc files made things unhappy:
> 
>        find /proc/ | xargs cat
>        find /proc/ -name "[g-z]*" | xargs cat
>        find /proc/ -name "[a-g]*" | xargs file
> 
> dmesg shows:

I'm unable to reproduce this.

> process `cat' is using deprecated sysctl (syscall)
> net.ipv6.neigh.default.retrans_time; Use
> net.ipv6.neigh.default.retrans_time_ms instead.
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.23-rc1-mm1 #15
> ---------------------------------------------
> cat/5333 is trying to acquire lock:
>  (&hashbin->hb_spinlock){....}, at: [<c03d95d3>] irias_seq_show+0xba/0x1a8
> 
> but task is already holding lock:
>  (&hashbin->hb_spinlock){....}, at: [<c03d96e7>] irias_seq_start+0x14/0x4e
> 
> other info that might help us debug this:
> 2 locks held by cat/5333:
>  #0:  (&p->lock){--..}, at: [<c042f868>] mutex_lock+0x1c/0x1f
>  #1:  (&hashbin->hb_spinlock){....}, at: [<c03d96e7>] irias_seq_start+0x14/0x4e
> 
> stack backtrace:
>  [<c01050bf>] show_trace_log_lvl+0x1a/0x2f
>  [<c0105c70>] show_trace+0x12/0x14
>  [<c0105d90>] dump_stack+0x16/0x18
>  [<c0144545>] __lock_acquire+0x18d/0xc20
>  [<c0145049>] lock_acquire+0x71/0x8b
>  [<c0430ae7>] _spin_lock+0x35/0x42
>  [<c03d95d3>] irias_seq_show+0xba/0x1a8
>  [<c0197754>] seq_read+0x192/0x266
>  [<c01adbb1>] proc_reg_read+0x63/0x76
>  [<c0181398>] vfs_read+0x8e/0x117
>  [<c01817c9>] sys_read+0x3d/0x61
>  [<c010401e>] sysenter_past_esp+0x5f/0x99
>  =======================

It'd be useful if you could display the name of each /proc file as it is
read, so we know which one went boom.

> BUG: unable to handle kernel NULL pointer dereference at virtual
> address 0000003c
>  printing eip:
> c01536a7
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT SMP
> Modules linked in: binfmt_misc cpufreq_conservative cpufreq_powersave
> cpufreq_performance sbp2 parport_pc lp parport snd_intel8x0
> snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss pcmcia snd_pcm
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq firewire_ohci snd_timer yenta_socket firewire_core
> snd_seq_device sdhci rsrc_nonstatic tifm_7xx1 crc_itu_t tifm_core
> pcmcia_core mmc_core ipw2200 snd rng_core iTCO_wdt iTCO_vendor_support
> soundcore shpchp pci_hotplug snd_page_alloc rtc 8139cp 8139too mii
> ehci_hcd uhci_hcd ohci1394 ieee1394 usbcore
> CPU:    0
> EIP:    0060:[<c01536a7>]    Not tainted VLI
> EFLAGS: 00210286   (2.6.23-rc1-mm1 #15)
> EIP is at container_path+0x20/0x7b
> eax: c6e8b05f   ebx: c6e8b060   ecx: 00001000   edx: c0880434
> esi: 00000000   edi: c6e8a060   ebp: c5ccff14   esp: c5ccff00
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process cat (pid: 5412, ti=c5ccf000 task=c6cf6390 task.ti=c5ccf000)
> Stack: c6e8a060 c0880434 c1c58000 c6f01c60 c6e8a060 c5ccff30 c0154ad2 c10dd100
>        fffffffd c5c9f500 c6f01c60 00000001 c5ccff70 c01976b1 00000400 08054000
>        c5c9f500 c6f01c80 00000000 c5ccff60 08054000 00000400 c5ccffb0 00000000
> Call Trace:
>  [<c01050bf>] show_trace_log_lvl+0x1a/0x2f
>  [<c0105171>] show_stack_log_lvl+0x9d/0xac
>  [<c0105371>] show_registers+0x1f1/0x332
>  [<c01055c4>] die+0x112/0x247
>  [<c011d0ee>] do_page_fault+0x4ea/0x5c8
>  [<c0431312>] error_code+0x72/0x78
>  [<c0154ad2>] proc_cpuset_show+0x5e/0xb9
>  [<c01976b1>] seq_read+0xef/0x266
>  [<c0181398>] vfs_read+0x8e/0x117
>  [<c01817c9>] sys_read+0x3d/0x61
>  [<c010401e>] sysenter_past_esp+0x5f/0x99
>  =======================
> INFO: lockdep is turned off.
> Code: 00 89 d8 83 c4 0c 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 08 89
> 45 f0 89 55 ec 89 d3 01 cb 8d 43 ff c6 43 ff 00 8b 55 f0 8b 72 1c <8b>
> 56 3c 29 d0 3b 45 ec 72 45 89 d1 c1 e9 02 8b 76 40 89 c7 f3
> EIP: [<c01536a7>] container_path+0x20/0x7b SS:ESP 0068:c5ccff00

Ditto, thanks.

