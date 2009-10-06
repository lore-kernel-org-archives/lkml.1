Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZJFAcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZJFAcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZJFAcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:32:52 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61647 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbZJFAcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:32:51 -0400
Date: Tue, 6 Oct 2009 09:12:54 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Alok Kataria <akataria@vmware.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [000/136] 2.6.31.2-stable review
Message-Id: <20091006091254.448d45e2.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20091002012911.GA18542@kroah.com>
References: <20091002012911.GA18542@kroah.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Greg.

Could you consider adding the following commit in linus-tree to 2.6.31-stable ?
I've verified the commit can be applied onto v2.6.31.2.


commit 31a5639623a487d6db996c8138c9e53fef2e2d91
Author: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Date:   Mon Sep 21 17:02:50 2009 -0700

    mm: add_to_swap_cache() must not sleep

    After commit 355cfa73 ("mm: modify swap_map and add SWAP_HAS_CACHE flag"),
    read_swap_cache_async() will busy-wait while a entry doesn't exist in swap
    cache but it has SWAP_HAS_CACHE flag.

    Such entries can exist on add/delete path of swap cache.  On add path,
    add_to_swap_cache() is called soon after SWAP_HAS_CACHE flag is set, and
    on delete path, swapcache_free() will be called (SWAP_HAS_CACHE flag is
    cleared) soon after __delete_from_swap_cache() is called.  So, the
    busy-wait works well in most cases.

    But this mechanism can cause soft lockup if add_to_swap_cache() sleeps and
    read_swap_cache_async() tries to swap-in the same entry on the same cpu.

    This patch calls radix_tree_preload() before swapcache_prepare() and
    divides add_to_swap_cache() into two part: radix_tree_preload() part and
    radix_tree_insert() part(define it as __add_to_swap_cache()).

    Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
    Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


This is a fix for a soft lockup bug introduced at 2.6.31-rc1.

It was rare, but I saw the bug several times, and Alok-san reported me the bug
also happens on Ubuntu 9.10(alpha).

  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/433646


Thanks,
Daisuke Nishimura.
