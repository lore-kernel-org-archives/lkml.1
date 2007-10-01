Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXJAK31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXJAK31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXJAK3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:29:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:34125 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbXJAK3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:29:19 -0400
To: Sami Farin <safari-kernel@safari.iki.fi>
Cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: 2.6.22.6 + oprofile oops
References: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Oct 2007 12:29:18 +0200
In-Reply-To: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi>
Message-ID: <p73ejgf6sch.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sami Farin <safari-kernel@safari.iki.fi> writes:

> x86_64 SMP kernel v2.6.22.6 (not using callgraph).
> sometimes oprofile works for a longer time... but not this time.
> 
> 2007-09-22 13:53:32.527237777 <1>[ 3372.390188] Unable to handle kernel NULL pointer dereference at 0000000000000650 RIP: 
> 2007-09-22 13:53:32.527245948 <1>[ 3372.390195]  [<ffffffff80652f44>] _spin_lock+0x4/0x20
> 2007-09-22 13:53:32.527247694 <4>[ 3372.390211] PGD 13a6c067 PUD 3ad91067 PMD 0 
> 2007-09-22 13:53:32.527249371 <0>[ 3372.390216] Oops: 0002 [1] SMP 
> 2007-09-22 13:53:32.527250837 <4>[ 3372.390220] CPU 0 
> 2007-09-22 13:53:32.527252304 <4>[ 3372.390227] Modules linked in: i915 oprofile xt_CLASSIFY ipt_ECN xt_CONNMARK xt_connlimit xt_length ipt_set xt_multiport ip_set_iphash ip_set_nethash ip_set_portmap sch_esfq ipt_REJECT ip6t_LOG xt_limit ipt_LOG xt_hashlimit ipt_owner nf_conntrack_ipv4 xt_state xt_tcpudp ip6table_filter ip6table_mangle ip6_tables iptable_filter iptable_mangle iptable_raw ip_tables tcp_highspeed tcp_htcp tcp_hybla tcp_scalable tcp_vegas tcp_westwood ip_set sch_netem sch_hfsc sch_htb sch_sfq cls_fw cls_u32 cls_route sch_ingress sch_red sch_tbf sch_teql sch_prio sch_gred cls_rsvp cls_rsvp6 cls_tcindex sch_cbq sch_dsmark nf_conntrack xt_TARPIT x_tables perfctr dccp_diag dccp ioatdma cmtp kernelcapi l2cap bluetooth intelfb i2c_algo_bit i810 lp i2c_dev ftdi_sio usbserial usb_st
>  orage eeprom ohci_hcd irlan irda crc_ccitt binfmt_misc loop dm_mod video dock button battery ac tcp_cubic nvram snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss parport_p
> 2007-09-22 13:53:32.527328363 c snd_pcm parport snd_timer ohci1394 ieee1394 snd i2c_i801 i2c_core soundcore ehci_hcd uhci_hcd e1000 snd_page_alloc iTCO_wdt iTCO_vendor_support
> 2007-09-22 13:53:32.527330808 <4>[ 3372.390363] Pid: 7, comm: events/0 Not tainted 2.6.22.6-cfs-v20.5-64-2 #7

Can you reproduce it with a non tainted kernel without any patches like CFS applied?

The oops happens because oprofile tries to reference a NULL task in
its event buffer for a context switch, which might well be a minor
merging mistake or similar in the CFS backport.

-Andi

> 2007-09-22 13:53:32.527332623 <4>[ 3372.390366] RIP: 0010:[<ffffffff80652f44>]  [<ffffffff80652f44>] _spin_lock+0x4/0x20
> 2007-09-22 13:53:32.527334439 <4>[ 3372.390373] RSP: 0018:ffff81003e5fddc0  EFLAGS: 00010282
> 2007-09-22 13:53:32.527336116 <4>[ 3372.390380] RAX: 000000000000000d RBX: 0000000000000004 RCX: 0000000000018000
> 2007-09-22 13:53:32.527346033 <4>[ 3372.390383] RDX: 00000000000155ae RSI: 0000000000000000 RDI: 0000000000000650
> 2007-09-22 13:53:32.527347849 <4>[ 3372.390387] RBP: ffff81003e5fddc0 R08: 2222222222222222 R09: 2222222222222222
> 2007-09-22 13:53:32.527349595 <4>[ 3372.390391] R10: 2222222222222222 R11: 2222222222222222 R12: 0000000000000004
> 2007-09-22 13:53:32.527351411 <4>[ 3372.390398] R13: ffffffffffffffff R14: ffffffff88321d00 R15: 000000000000000d
> 2007-09-22 13:53:32.527365100 <4>[ 3372.390402] FS:  0000000000000000(0000) GS:ffffffff80805000(0000) knlGS:0000000000000000
> 2007-09-22 13:53:32.527367056 <4>[ 3372.390406] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> 2007-09-22 13:53:32.527368662 <4>[ 3372.390409] CR2: 0000000000000650 CR3: 0000000011d52000 CR4: 00000000000006e0
> 2007-09-22 13:53:32.527370478 <4>[ 3372.390417] Process events/0 (pid: 7, threadinfo ffff81003e5fc000, task ffff810001ffb100)
> 2007-09-22 13:53:32.527380117 <4>[ 3372.390419] Stack:  ffff81003e5fdde0 ffffffff80232b88 ffff81003e5fdeb0 00000000000000ba
> 2007-09-22 13:53:32.527382002 <4>[ 3372.390427]  ffff81003e5fde60 ffffffff8831abd4 ffffffff88321d70 0000000000000000
> 2007-09-22 13:53:32.527383818 <4>[ 3372.390437]  0000000000000000 0000000000000000 0000000100000001 00000000000000ba
> 2007-09-22 13:53:32.527385634 <4>[ 3372.390442] Call Trace:
> 2007-09-22 13:53:32.527390314 <4>[ 3372.390457]  [<ffffffff80232b88>] get_task_mm+0x18/0x60
> 2007-09-22 13:53:32.527391990 <4>[ 3372.390484]  [<ffffffff8831abd4>] :oprofile:sync_buffer+0xf4/0x480
> 2007-09-22 13:53:32.527393666 <4>[ 3372.390544]  [<ffffffff8831a6b0>] :oprofile:wq_sync_buffer+0x0/0x60
> 2007-09-22 13:53:32.527399673 <4>[ 3372.390576]  [<ffffffff8831a6e3>] :oprofile:wq_sync_buffer+0x33/0x60
> 2007-09-22 13:53:32.527401419 <4>[ 3372.390602]  [<ffffffff80244bfd>] run_workqueue+0xcd/0x170
> 2007-09-22 13:53:32.527406238 <4>[ 3372.390635]  [<ffffffff802456b3>] worker_thread+0xb3/0x120
> 2007-09-22 13:53:32.527421324 <4>[ 3372.390652]  [<ffffffff80249000>] autoremove_wake_function+0x0/0x40
> 2007-09-22 13:53:32.527423140 <4>[ 3372.390684]  [<ffffffff80245600>] worker_thread+0x0/0x120
> 2007-09-22 13:53:32.527424816 <4>[ 3372.390697]  [<ffffffff80248bfd>] kthread+0x4d/0x80
> 2007-09-22 13:53:32.527426423 <4>[ 3372.390730]  [<ffffffff8020abc8>] child_rip+0xa/0x12
> 2007-09-22 13:53:32.527428099 <4>[ 3372.390810]  [<ffffffff80248bb0>] kthread+0x0/0x80
> 2007-09-22 13:53:32.527444931 <4>[ 3372.390822]  [<ffffffff8020abbe>] child_rip+0x0/0x12
