Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYKIUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYKIUid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbYKIUiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:38:17 -0500
Received: from ppp-111-41.adsl.restena.lu ([158.64.111.41]:52673 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756891AbYKIUiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:38:15 -0500
Date: Sun, 9 Nov 2008 21:38:11 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: JosephChan@via.com.tw, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-ID: <20081109213811.4b85adc6@neptune.home>
In-Reply-To: <20081109122515.1deb9ec2@infradead.org>
References: <20081109202537.33ead0a2@neptune.home>
	<20081109113603.d45361ad.akpm@linux-foundation.org>
	<20081109122515.1deb9ec2@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 November 2008 Arjan van de Ven wrote:
> On Sun, 9 Nov 2008 Andrew Morton wrote:
> > On Sun, 9 Nov 2008 Bruno Prémont wrote:
> > 
> > > The function viafb_cursor() uses 2 stack-variables of CURSOR_SIZE
> > > bits; CURSOR_SIZE is defined as (8 * 1024). Using up twice 1k on
> > > stack is too much for 4k-stack (though it works with 8k-stacks).
> > 
> > >  
> > >  	if (viacursor.enable)
> > 
> > Is the ->fb_cursor handler allowed to perform GFP_KERNEL memory
> > allocations?  It's never called from atomic contexts?
> 
> if it's allowed to do GFP_KERNEL memory allocations the statement that
> it works with 8k stacks is a bit overstated... since irq's can come in
> and take several KB of stack as well ;)
I don't know if it can be called from atomic contexts or not :(


In addition I get panics some time after start-up which I'm not sure
what to associate them with (apparently unrelated)
It could be some stack overflow by calling fbset (I will to more testing
in order to find out)

First attempt: calling fbset via ssh:

[ 1806.952151] BUG: unable to handle kernel NULL pointer dereference at 00000123
[ 1806.952601] IP: [<c03d2737>] icmpv6_send+0x387/0x580
[ 1806.952934] *pde = 00000000 
[ 1806.953125] Oops: 0000 [#1] 
[ 1806.953310] last sysfs file: /sys/devices/platform/w83627hf.656/temp2_input
[ 1806.953717] Modules linked in: snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc sg
[ 1806.954328] 
[ 1806.954430] Pid: 1855, comm: sshd Not tainted (2.6.28-rc3-git6 #1) CX700+W697HG
[ 1806.954863] EIP: 0060:[<c03d2737>] EFLAGS: 00010206 CPU: 0
[ 1806.955194] EIP is at icmpv6_send+0x387/0x580
[ 1806.955456] EAX: ffffffff EBX: f713c704 ECX: f6bc26a8 EDX: 0000006c
[ 1806.955827] ESI: f713c500 EDI: 00000040 EBP: f6babca0 ESP: f6babbf8
[ 1806.956197]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1806.956520] Process sshd (pid: 1855, ti=f6bab000 task=f70e7440 task.ti=f6bab000)
[ 1806.956952] Stack:
[ 1806.957074]  00000000 00007515 ffffffcc f6babc51 f6babc51 c05f6045 f6babc8c 00000296
[ 1806.957614]  f6babc3c 00000000 00000002 f6bc26a8 00000200 38b782ca f713c704 00000000
[ 1806.958321]  00000000 00000000 00000000 00000000 60090120 0000ab07 ff1d0302 300005fe
[ 1806.958882] Call Trace:
[ 1806.959037]  [<c03bf600>] ? ip6_xmit+0x230/0x3f0
[ 1806.959339]  [<c03de873>] ? inet6_csk_xmit+0x103/0x190
[ 1806.959669]  [<c03d9281>] ? tcp_v6_send_check+0x51/0x100
[ 1806.960011]  [<c0399103>] ? tcp_transmit_skb+0x373/0x670
[ 1806.960016]  [<c039a6f0>] ? tcp_push_one+0xa0/0xd0
[ 1806.960016]  [<c038fd64>] ? tcp_sendmsg+0x264/0xa30
[ 1806.960016]  [<c0179157>] ? core_sys_select+0x207/0x2c0
[ 1806.960016]  [<c03581ab>] ? sock_aio_write+0xeb/0x110
[ 1806.960016]  [<c016c76c>] ? do_sync_write+0xcc/0x110
[ 1806.960016]  [<c02b9ee5>] ? pty_unthrottle+0x15/0x20
[ 1806.960016]  [<c0133400>] ? autoremove_wake_function+0x0/0x50
[ 1806.960016]  [<c01263e6>] ? current_fs_time+0x16/0x20
[ 1806.960016]  [<c016d0d0>] ? vfs_write+0x110/0x120
[ 1806.960016]  [<c016d18d>] ? sys_write+0x3d/0x70
[ 1806.960016]  [<c0103bc1>] ? sysenter_do_call+0x12/0x25
[ 1806.960016] Code: 0f b6 4d 89 89 45 dc 88 4d e0 8b 52 50 29 c2 b8 d0 04 00 00 81 fa d0 04 00 00 0f 47 d0 85 d2 0f 88 91 01 00 00 8b 4d 84 8b 41 14 <8b> 98 24 01 00 00 85 db 74 06 ff 83 80 00 00 00 b8 40 00 00 00 
[ 1806.960016] EIP: [<c03d2737>] icmpv6_send+0x387/0x580 SS:ESP 0068:f6babbf8
[ 1807.067511] Kernel panic - not syncing: Fatal exception in interrupt


Second attempt, delayed after calling fbset from console:

[  217.260426] BUG: unable to handle kernel NULL pointer dereference at 000000c7
[  217.260915] IP: [<c0380b46>] rt_worker_func+0xb6/0x160
[  217.261264] *pde = 00000000 
[  217.261458] Oops: 0000 [#1] 
[  217.261649] last sysfs file: /sys/devices/platform/w83627hf.656/temp2_input
[  217.262058] Modules linked in: snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc sg
[  217.262691] 
[  217.262795] Pid: 5, comm: events/0 Not tainted (2.6.28-rc3-git6 #1) CX700+W697HG
[  217.263236] EIP: 0060:[<c0380b46>] EFLAGS: 00010286 CPU: 0
[  217.263570] EIP is at rt_worker_func+0xb6/0x160
[  217.263846] EAX: 00000002 EBX: ffffffff ECX: c0606e20 EDX: fffffed4
[  217.270015] ESI: f7172c5c EDI: 00007530 EBP: f7032f80 ESP: f7032f6c
[  217.270015]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  217.270015] Process events/0 (pid: 5, ti=f7032000 task=f702ad80 task.ti=f7032000)
[  217.270015] Stack:
[  217.270015]  000001b5 00004b17 c053d7a0 f7008180 c0380a90 f7032fa4 c0130117 f702b440
[  217.270015]  f702ad80 c0510180 00000246 f7008188 f7008180 f7032fac f7032fcc c0130747
[  217.270015]  00000000 f702ad80 c0133400 f7032fb8 f7032fb8 fffffffc f7008180 c01306b0
[  217.270015] Call Trace:
[  217.270015]  [<c0380a90>] ? rt_worker_func+0x0/0x160
[  217.270015]  [<c0130117>] ? run_workqueue+0x67/0xe0
[  217.270015]  [<c0130747>] ? worker_thread+0x97/0xf0
[  217.270015]  [<c0133400>] ? autoremove_wake_function+0x0/0x50
[  217.270015]  [<c01306b0>] ? worker_thread+0x0/0xf0
[  217.270015]  [<c0133032>] ? kthread+0x42/0x70
[  217.270015]  [<c0132ff0>] ? kthread+0x0/0x70
[  217.270015]  [<c0104847>] ? kernel_thread_helper+0x7/0x10
[  217.270015] Code: f0 ff ff f6 40 08 08 0f 85 bb 00 00 00 8b 06 85 c0 74 49 89 df e8 8b 5c da ff 8d 74 26 00 8d bc 27 00 00 00 00 8b 1e 85 db 74 2c <8b> 83 c8 00 00 00 3b 05 dc c9 61 c0 75 4c 8b 53 18 85 d2 74 2c 
[  217.270015] EIP: [<c0380b46>] rt_worker_func+0xb6/0x160 SS:ESP 0068:f7032f6c
[  217.526097] Kernel panic - not syncing: Fatal exception in interrupt
