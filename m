Return-Path: <linux-kernel-owner+w=401wt.eu-S1762461AbZE3UXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762461AbZE3UXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 16:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZE3UXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 16:23:24 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:50800 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZE3UXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 16:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JrpBRlf2KNp7be2SXKWdxkZ/zxWwBkkGSSie+50TKGxgtFHsyWngfrkFKbetTIpn4m
         AIrLyGDyi4J2EPOWxwgHA4alSD/ESVY5GLWibYQx330QJcrlrY3x9m91yc/MpLg62Fnp
         zA8p9S0NOxbbZ9KSNLHx/YGcTZR3R/LeWxe6c=
MIME-Version: 1.0
Date: Sat, 30 May 2009 22:23:24 +0200
Message-ID: <19f34abd0905301323k1498ca3fv31b271de65d60afc@mail.gmail.com>
Subject: net: uninitialized loopback addr leaks to userspace
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Linux Netdev List <netdev@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems that loopback's hardware address is never initialized by the
kernel. So if userspace attempts to read this address before it has
been set, the kernel will return some uninitialized data (only 6
bytes, though). This can be demonstrated by creating a new network
namespace (CLONE_NEWNET), which creates a new loopback device, then
call ioctl() with SIOCGIFHWADDR on "lo". If this is done in a loop,
with some background load, or by running multiple instances, random
data will start to show up in the returned address.

[  406.750329] WARNING: kmemcheck: Caught 16-bit read from
uninitialized memory (ffff880007220974)
[  406.753555] 18a2d7060088ffff18a2d7060088ffff00000000010000000100000003000000
[  406.758862]  i i i i i i i i i i i i i i i i i u u u u u u u u u u u u u u u
[  406.766224]                                          ^
[  406.768792] Modules linked in:
[  406.770416] Pid: 757, comm: ifconfig Not tainted
2.6.30-rc7-next-20090529 #404
[  406.772876] RIP: 0010:[<ffffffff80664789>]  [<ffffffff80664789>]
dev_ioctl+0x5d9/0x600
[  406.804677]  [<ffffffff8064ff75>] sock_ioctl+0x95/0x2a0
[  406.807242]  [<ffffffff802c35eb>] vfs_ioctl+0x1b/0x70
[  406.809348]  [<ffffffff802c36fa>] do_vfs_ioctl+0x8a/0x570
[  406.811419]  [<ffffffff802c3c79>] sys_ioctl+0x99/0xa0
[  406.813400]  [<ffffffff802f3941>] dev_ifsioc+0x81/0x2f0
[  406.815424]  [<ffffffff802f454d>] compat_sys_ioctl+0xed/0x3c0
[  406.817596]  [<ffffffff8022d476>] cstar_dispatch+0x7/0x26
[  406.819978]  [<ffffffffffffffff>] 0xffffffffffffffff

This is the code that triggers the warning, in net/core/dev.c, around line 4150:

    memcpy(ifr->ifr_hwaddr.sa_data, dev->dev_addr,
        min(sizeof ifr->ifr_hwaddr.sa_data, (size_t) dev->addr_len));

So it's dev->dev_addr that is the pointer to the uninitialized data.

I didn't know how to fix it.


Vegard
