Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbYBMH30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbYBMH30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbYBMH3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:29:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156AbYBMH3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:29:12 -0500
Date: Tue, 12 Feb 2008 23:27:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ignacy Gawedzki <lkml@qult.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: Oops with hostap_pci (?)
Message-Id: <20080212232706.3921f1d9.akpm@linux-foundation.org>
In-Reply-To: <20080211122300.GA13931@zenon.in.qult.net>
References: <20080211031935.GA12563@zenon.in.qult.net>
	<20080211122300.GA13931@zenon.in.qult.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 13:23:00 +0100 Ignacy Gawedzki <lkml@qult.net> wrote:

> On Mon, Feb 11, 2008 at 04:19:35AM +0100, thus spake Ignacy Gawedzki:
> > Hi,
> > 
> > A few days back I started having strange lockups on a gateway machine so I
> > started looking at things.  Then I compiled the 2.6.24.1 kernel and started
> > having oopses not long after upping the wlan0 (hostap_pci) interface.
> > 
> > So I enabled netconsole and got a few logs.  Now the sad point is that I'm
> > getting an oops even with my older kernel which used to be fine (2.6.23.9).  I
> > also checked with 2.6.24 and the effects are the same: I boot, I up the wlan0
> > interface and a few seconds or minutes later, boom!  Sometimes only rmmod'ing
> > hostap_pci triggers the oops.  I'm suspecting some hardware problem and have
> > already checked the ram with memtest86+ and tested with only one memory module
> > out of two plugged: same thing.
> > 
> > If anybody could take a look at these and shed some light on that issue...
> 
> Okay, false alarm... it's all my fault. :/
> 
> The cause of the problem was my previous tampering with udev rules.  The udev
> rules as such (on Ubuntu Gutsy) were bad for hostapd, since persistent rules
> were written for the wlan0ap interface name created by hostapd.  So I changed
> a few things that had the unexpected effect of renaming the initial
> hostap_pci's wifi0 into wlan0ap.  This in turn made hostap_pci oops in many
> cases.
> 
> Anyway, I've modified my udev rules again and hopefully this will be it. =)
> 

No, you found a bug.  The kernel shouldn't oops in reaction to userspace
activity, even udev.  Ever.


With kernel 2.6.24.1

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
printing eip: f08f50c2 *pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: lirc_serial(F) lirc_dev cls_fw sch_prio sch_htb iptable_nat xt_limit xt_state ipt_REJECT xt_tcpudp ipt_LOG xt_DSCP xt_dscp xt_mark nf_conntrack_ipv4 xt_CONNMARK xt_MARK iptable_mangle iptable_filter ip_tables x_tables nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack ipv6 evdev hostap_pci i2c_viapro hostap via686a ieee80211_crypt ide_cd

Pid: 0, comm: swapper Tainted: GF       (2.6.24.1 #5)
EIP: 0060:[<f08f50c2>] EFLAGS: 00010297 CPU: 0
EIP is at hostap_80211_rx+0x41d/0xecf [hostap]
EAX: eec28460 EBX: 00000000 ECX: eec28444 EDX: 00000000
ESI: efbb8434 EDI: 00000000 EBP: efbb843e ESP: c0419e74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c0418000 task=c03e4300 task.ti=c0418000)
Stack: 00000000 00000080 0000004c 00000001 c0419f2c c0419f30 ef3ab760 00000018 
       00000100 eec28444 00001148 00000040 0000c9c0 00000001 ef8d3370 00002a40 
       04b1cd93 000a1e00 00001148 013a1148 685b0900 ef8d3000 1f714b23 685b0900 
Call Trace:
 [<f090ffca>] hostap_rx_tasklet+0x11f/0x145 [hostap_pci]
 [<c011e399>] run_timer_softirq+0x11/0x12f
 [<c011bbbc>] tasklet_action+0x32/0x52
 [<c011bb24>] __do_softirq+0x35/0x75
 [<c011bb86>] do_softirq+0x22/0x26
 [<c011bdb3>] irq_exit+0x29/0x58
 [<c0105bc0>] do_IRQ+0x58/0x6b
 [<c010455b>] common_interrupt+0x23/0x28
 [<c013007b>] mod_sysfs_init+0x17/0x6d
 [<c011007b>] arch_setup_additional_pages+0x121/0x13a
 [<c023f4a0>] acpi_processor_idle+0x244/0x3c4
 [<c01024fc>] cpu_idle+0x43/0x5d
 [<c041a9ac>] start_kernel+0x237/0x23c
 [<c041a303>] unknown_bootoption+0x0/0x195
 =======================
Code: 0a 8b 4c 24 24 8b 59 1c eb 21 83 bb d8 00 00 00 04 75 16 8d 83 dc 00 00 00 b9 06 00 00 00 89 ea e8 0b d1 91 cf 85 c0 74 18 89 fb <8b> 3b 0f 18 07 90 8b 44 24 24 83 c0 1c 39 c3 75 ce e9 44 0a 00 
EIP: [<f08f50c2>] hostap_80211_rx+0x41d/0xecf [hostap] SS:ESP 0068:c0419e74
Kernel panic - not syncing: Fatal exception in interrupt
wlan0ap: SW TICK stuck? bits=0x0 EvStat=8001 IntEn=e018


