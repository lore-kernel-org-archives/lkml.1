Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbZCQVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbZCQVNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZCQVNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:13:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbZCQVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:13:03 -0400
Date: Tue, 17 Mar 2009 13:54:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: 29-rc-mmotm - HID/USB wedge w/ WARNING: at
 kernel/workqueue.c:371
Message-Id: <20090317135424.9151c4f8.akpm@linux-foundation.org>
In-Reply-To: <6648.1237271589@turing-police.cc.vt.edu>
References: <6648.1237271589@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009 02:33:09 -0400 Valdis.Kletnieks@vt.edu wrote:

> 29-rc3-mmotm0129 is OK, I hit it a few times under rc5-mmotm0214, but I'm
> seeing it a lot under -rc8-mmotm0313 (have triggered it 6 times in the past 4
> hours).  Very consistent traceback out of the HID and USB stack - the events/0
> kernel thread loses its shit:
> 
> [ 3816.196809] ------------[ cut here ]------------
> [ 3816.196815] WARNING: at kernel/workqueue.c:371 flush_cpu_workqueue+0x32/0x82()
> [ 3816.196820] Hardware name: Latitude D820                   
> [ 3816.196823] Modules linked in: irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp sunrpc nf_conntrack_ftp xt_pkttype nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT xt_recent ipt_LOG xt_u32 xt_multiport iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_x86_64 aes_generic rtc acpi_cpufreq tpm_tis tpm tpm_bios arc4 ecb nvidia(P) iwl3945 iwlcore mac80211 ohci1394 pcmcia ieee1394 dell_laptop yenta_socket led_class snd_hda_codec_idt video processor uhci_hcd iTCO_wdt rsrc_nonstatic cfg80211 snd_hda_intel intel_agp pcmcia_core iTCO_vendor_support rfkill output snd_hda_codec button battery thermal ac dcdbas [last unloaded: microcode]
> [ 3816.196950] Pid: 9, comm: events/0 Tainted: P           2.6.29-rc8-mmotm0313 #3
> [ 3816.196955] Call Trace:
> [ 3816.196965]  [<ffffffff80233e53>] warn_slowpath+0xaf/0xd6
> [ 3816.196974]  [<ffffffff803b78a5>] ? extract_buf+0x8e/0xc3
> [ 3816.196983]  [<ffffffff8027e07a>] ? list_add+0xc/0xe
> [ 3816.196990]  [<ffffffff8027eb0b>] ? __free_one_page+0x17f/0x1e6
> [ 3816.196997]  [<ffffffff80243ea6>] flush_cpu_workqueue+0x32/0x82
> [ 3816.197032]  [<ffffffff804214dd>] ? usb_hcd_unlink_urb+0x48/0x84
> [ 3816.197040]  [<ffffffff80422762>] ? usb_kill_urb+0x21/0xce
> [ 3816.197046]  [<ffffffff802444d7>] flush_workqueue+0x4d/0x67
> [ 3816.197053]  [<ffffffff80244501>] flush_scheduled_work+0x10/0x12
> [ 3816.197061]  [<ffffffff8045da33>] hid_cease_io+0x3b/0x40
> [ 3816.197067]  [<ffffffff8045da7b>] hid_pre_reset+0x43/0x4a
> [ 3816.197073]  [<ffffffff8041e627>] usb_reset_device+0x6c/0x11c
> [ 3816.197080]  [<ffffffff8045e535>] hid_reset+0x9e/0x12e
> [ 3816.197086]  [<ffffffff8045e497>] ? hid_reset+0x0/0x12e
> [ 3816.197092]  [<ffffffff80243bca>] worker_thread+0x1d3/0x27b
> [ 3816.197100]  [<ffffffff802477c1>] ? autoremove_wake_function+0x0/0x34
> [ 3816.197106]  [<ffffffff802439f7>] ? worker_thread+0x0/0x27b
> [ 3816.197113]  [<ffffffff802473bb>] kthread+0x55/0x80
> [ 3816.197120]  [<ffffffff8020c15a>] child_rip+0xa/0x20
> [ 3816.197128]  [<ffffffff8020bb2d>] ? restore_args+0x0/0x30
> [ 3816.197135]  [<ffffffff80247366>] ? kthread+0x0/0x80
> [ 3816.197140]  [<ffffffff8020c150>] ? child_rip+0x0/0x20
> [ 3816.197145] ---[ end trace 1e05d800555b77d7 ]---

It's an error in workqueue-avoid-recursion-in-run_workqueue.patch, methinks.

We used to permit keventd to run flush_workqueue():

static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
{
	int active;

	if (cwq->thread == current) {
		/*
		 * Probably keventd trying to flush its own queue. So simply run
		 * it by hand rather than deadlocking.
		 */
		run_workqueue(cwq);
		active = 1;
	} else {
		struct wq_barrier barr;

		active = 0;
		spin_lock_irq(&cwq->lock);
		if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
			insert_wq_barrier(cwq, &barr, &cwq->worklist);
			active = 1;
		}
		spin_unlock_irq(&cwq->lock);

		if (active)
			wait_for_completion(&barr.done);
	}

	return active;
}

but after workqueue-avoid-recursion-in-run_workqueue.patch, we warn
instead:

static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
{
	int active = 0;
	struct wq_barrier barr;

	WARN_ON(cwq->thread == current);

	spin_lock_irq(&cwq->lock);
	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
		insert_wq_barrier(cwq, &barr, &cwq->worklist);
		active = 1;
	}
	spin_unlock_irq(&cwq->lock);

	if (active)
		wait_for_completion(&barr.done);

	return active;
}

