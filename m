Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0CEK1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 05:27:19 -0500
Received: from mail-yw0-f184.google.com ([209.85.211.184]:49089 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0CEK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 05:27:18 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 05:27:18 EST
MIME-Version: 1.0
Date: Fri, 5 Mar 2010 15:52:13 +0530
Message-ID: <d760cf2d1003050222m6e509ffaqa498645c52f7d98e@mail.gmail.com>
Subject: [PATCH 0/3] ramzswap: Eliminate stale data in compressed memory
From: Nitin Gupta <ngupta@vflare.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@gmail.com>, andi@firstfloor.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ramzswap driver creates RAM based block devices which can be
used (only) as swap disks. Pages swapped to these disks are
compressed and stored in memory itself.

However, these devices do not get any notification when a swap
slot is freed (swap_map[i] reaches 0). So, we cannot free memory
allocated corresponding to this swap slot. Such stale data can
quickly accumulate in (compressed) memory defeating the whole
purpose of such devices.

To overcome this problem, we now add a callback in 'struct swap_info_struct'
which is called as soon as a swap slot is freed.

Adding handler for this callback:
	swapon notifier --> set_swap_free_notify(swap_type, fn)

Removing handler:
	swapoff notifier --> set_swap_free_notify(swap_type, NULL)


Alternative approaches:
1) Add callback directly in 'struct block_device_operations' but
that is considered too hacky.
2) Use swap discard mechanism: It involves unncessary overhead of
allocating 'discard bio' requests and its too slow to serve ramzswap
needs.

 drivers/staging/ramzswap/ramzswap_drv.c   |   91 +++++++++++++++++++++++++++++
 drivers/staging/ramzswap/ramzswap_drv.h   |    1 +
 drivers/staging/ramzswap/ramzswap_ioctl.h |    1 +
 include/linux/swap.h                      |   16 +++++-
 mm/swapfile.c                             |   78 ++++++++++++++++++++++++
 5 files changed, 185 insertions(+), 2 deletions(-)
