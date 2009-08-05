Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbZHEJuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbZHEJuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbZHEJuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:50:55 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:55180 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933096AbZHEJuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:50:54 -0400
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: spinlock bad magic on CPU#1, swapper/1
Date: Wed, 5 Aug 2009 11:50:52 +0200
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>
References: <200908051136.44908.elendil@planet.nl>
In-Reply-To: <200908051136.44908.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051150.53301.elendil@planet.nl>
X-OriginalArrivalTime: 05 Aug 2009 09:50:54.0017 (UTC) FILETIME=[391EEB10:01CA15B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Frans Pop wrote:
> Current v2.6.31-rc5-246-g90bc1a6 gives me:
>
> BUG: spinlock bad magic on CPU#1, swapper/1
>  lock: ffff88007e1889c8, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> Pid: 1, comm: swapper Not tainted 2.6.31-rc5 #4 
> Call Trace:
>  [<ffffffff811345e8>] spin_bug+0xa2/0xaa
>  [<ffffffff8113469e>] _raw_spin_lock+0x23/0x135
>  [<ffffffff8125664e>] _spin_lock_bh+0x19/0x1e
>  [<ffffffff811e3702>] alloc_netdev_mq+0x127/0x211
>  [<ffffffff81433487>] ? netdev_init+0x6a/0xac
>  [<ffffffff811a81eb>] ? loopback_setup+0x0/0x7b
>  [<ffffffff8142e718>] loopback_net_init+0x30/0x7a
>  [<ffffffff811dd62e>] register_pernet_device+0x2b/0x58
>  [<ffffffff814336bd>] net_dev_init+0x13d/0x19b
>  [<ffffffff81433580>] ? net_dev_init+0x0/0x19b
>  [<ffffffff8100905c>] do_one_initcall+0x56/0x12b
>  [<ffffffff8106f55b>] ? register_irq_proc+0xb0/0xcc
>  [<ffffffff810e0000>] ? proc_pid_cmdline+0x5a/0xf9
>  [<ffffffff8140f65d>] kernel_init+0x14d/0x1a3
>  [<ffffffff8100ca7a>] child_rip+0xa/0x20
>  [<ffffffff8140f510>] ? kernel_init+0x0/0x1a3
>  [<ffffffff8100ca70>] ? child_rip+0x0/0x20
>
> Error occurs during early boot (between PCI/ACPI init and PnP init).

Reverting the following commit fixes it:
commit a6ac65db2329e7685299666f5f7b6093c7b0f3a0
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Thu Jul 30 01:06:12 2009 +0000

    net: restore the original spinlock to protect unicast list

    There is a path when an assetion in dev_unicast_sync() appears.

    igmp6_group_added -> dev_mc_add -> __dev_set_rx_mode ->
    -> vlan_dev_set_rx_mode -> dev_unicast_sync

    Therefore we cannot protect this list with rtnl. This patch restores the
    original protecting this list with spinlock.

    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
    Tested-by: Meelis Roos <mroos@linux.ee>
    Signed-off-by: David S. Miller <davem@davemloft.net>
