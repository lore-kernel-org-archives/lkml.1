Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYAWCAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYAWCAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 21:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYAWCAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 21:00:35 -0500
Received: from keil-draco.com ([216.193.185.50]:50904 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYAWCAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 21:00:33 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.24-rc8: iwl3945 gets stuck
Date: Tue, 22 Jan 2008 21:00:21 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Harald Dunkel <harald.dunkel@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <479657F3.2030901@t-online.de> <20080122221542.GD3206@tuxdriver.com>
In-Reply-To: <20080122221542.GD3206@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801222100.22334.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2008 17:15:42 John W. Linville wrote:
> On Tue, Jan 22, 2008 at 09:54:11PM +0100, Harald Dunkel wrote:
> > If I put some heavy load on the iwl3945, then the network connection
> > gets stuck after a some time. To fix it I have to reload the module.
>
> Can you quantify this a bit more?  What constitutes a "heavey load"?
> What (if any) encryption are you using?  Are you using any options
> for iwl3945 in /etc/modprobe.conf?
>
> Could you include the output of dmesg and/or the contents of
> /var/log/messages (trimmed for the most recent boot)?
>
> > AFAICS this problem was a topic on lkml almost 3 months ago. Any news
> > about this? I would be glad to help to track this down, but I have
> > no idea how to change the scaling algorithm to iwl-3945-rs .
>
> This should happen automatically now.
>
> John

I've been getting a warning in the dmesg of my laptop with every boot since I 
started using 2.6.24-rc7 that might be related.

This doesn't appear to cause any problems, but from looking at the source 
of the warning it appears that the ipw3945 hardware might be causing the 
problem.
 
[   31.460143] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   31.549722] WARNING: at net/mac80211/rx.c:1486 __ieee80211_rx()
[   31.549817] Pid: 4436, comm: amixer Not tainted 2.6.24-rc7-git2 #1
[   31.549903]
[   31.549904] Call Trace:
[   31.550063]  <IRQ>  [<ffffffff8823c309>] :mac80211:__ieee80211_rx+0xc99/0xd60
[   31.550236]  [<ffffffff80473a36>] _spin_unlock_irqrestore+0x16/0x40
[   31.550332]  [<ffffffff8828930a>] :iwl3945:iwl_rx_queue_restock+0xca/0x170
[   31.550422]  [<ffffffff80473a36>] _spin_unlock_irqrestore+0x16/0x40
[   31.550520]  [<ffffffff8822d228>] :mac80211:ieee80211_tasklet_handler+0xb8/0x120
[   31.550646]  [<ffffffff80246741>] tasklet_action+0x51/0xc0
[   31.550732]  [<ffffffff80473974>] _spin_unlock+0x14/0x40
[   31.550820]  [<ffffffff80246644>] __do_softirq+0x64/0xe0
[   31.550909]  [<ffffffff8020d57c>] call_softirq+0x1c/0x30
[   31.550995]  [<ffffffff8020ef0d>] do_softirq+0x3d/0x90
[   31.551083]  [<ffffffff80246558>] irq_exit+0x88/0xa0
[   31.551169]  [<ffffffff8020f025>] do_IRQ+0xc5/0x1b0
[   31.551257]  [<ffffffff8020c8d1>] ret_from_intr+0x0/0xa
[   31.551369]  <EOI>  [<ffffffff802874be>] get_page_from_freelist+0x30e/0x670
[   31.551519]  [<ffffffff802878ce>] __alloc_pages+0x6e/0x3b0
[   31.551608]  [<ffffffff80283417>] generic_file_aio_read+0xd7/0x180
[   31.551699]  [<ffffffff802a256c>] alloc_page_vma+0x9c/0xf0
[   31.551788]  [<ffffffff8029281e>] handle_mm_fault+0x50e/0x780
[   31.551874]  [<ffffffff80473974>] _spin_unlock+0x14/0x40
[   31.551962]  [<ffffffff80473a36>] _spin_unlock_irqrestore+0x16/0x40
[   31.552052]  [<ffffffff80475a68>] do_page_fault+0x228/0x970
[   31.552146]  [<ffffffff80473974>] _spin_unlock+0x14/0x40
[   31.552251]  [<ffffffff802b2b5e>] vfs_read+0x13e/0x180
[   31.552340]  [<ffffffff80473cc9>] error_exit+0x0/0x51
[   31.552436]

The location of the warning is:
        hdrlen = ieee80211_get_hdrlen(rx.fc);
line in question -->        WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);

        if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
                local->dot11ReceivedFragmentCount++;

        sta = rx.sta = sta_info_get(local, hdr->addr2);

Now, the problem is that this might be nothing, and it might be the cause 
of the problem. (I don't think it is the cause, myself, because I've subjected
my laptop to a lot of activity - to the point that the card was starting to drop
packets - and have seen no problems)

DRH

--
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
