Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbYJUKjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbYJUKjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYJUKjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:39:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYJUKjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:39:23 -0400
Date: Tue, 21 Oct 2008 12:38:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Rik van Riel <riel@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, lee.schermerhorn@hp.com,
       lizf@cn.fujitsu.com
Subject: Re: [crash, -git] NULL pointer dereference, IP: [<c0190884>]
	page_cgroup_zoneinfo+0xf/0x1b
Message-ID: <20081021103843.GA18150@elte.hu>
References: <20081021100935.GA7100@elte.hu> <20081021192143.67361afc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021192143.67361afc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > IP: [<c018faa4>] page_cgroup_zoneinfo+0xf/0x1b
[...]
> > bad:   a9b6148: USB: Fix unused label warnings in drivers/usb/host/ehci-hcd.c
> > good:  c813b4e: Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/
> >
> yes, now chasing. and have found
> 
>  page_cgroup->page is NULL because of unknown reason.

i've attempted to bisect it - but the most critical part of this series 
is not bisectable, the bootup hangs at this tree:

  40b6a76: cpuset.c: remove extra variable

It hangs in the mm/cgroups code at:

 [<c01895fe>] ? constant_test_bit+0xe/0x1b
 [<c01898a1>] lock_page_cgroup+0x13/0x25
 [<c0189e5f>] mem_cgroup_charge_common+0xfd/0x1bf
 [<c018a56f>] mem_cgroup_cache_charge+0x7c/0x8a
 [<c016bceb>] add_to_page_cache_locked+0x2f/0xc4
 [<c016bda3>] add_to_page_cache_lru+0x23/0x5e
 [<c016c3e9>] find_or_create_page+0x3f/0x62
 [<c01a4709>] __getblk+0xfa/0x1cc
 [<c01ff4fb>] jread+0x110/0x1ed
 [<c01ff6d4>] do_one_pass+0xfc/0x476
 [<c01408b0>] ? wake_bit_function+0x0/0x43
 [<c01ffac8>] journal_recover+0x7a/0x13d
 [<c0200d8e>] ? buffer_uptodate+0xc/0xe
 [<c0201bd9>] journal_load+0x42/0x76
 [<c01f810b>] ext3_fill_super+0xd9c/0x1491

My bisection got this far:

 # good: [c813b4e1] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # bad:  [a9b6148d] USB: Fix unused label warnings in drivers/usb/host
 # bad:  [656eb2cd] add CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
 # good: [bdbf0ac7] Merge branch 'hwmon-for-linus' of git://jdelvare.p
 # good: [f7ea4a4b] Merge branch 'drm-next' of git://git.kernel.org/pu
 # good: [556adecb] vmscan: second chance replacement for anonymous pa
 # good: [28f74e71] hwmon/pc87360 separate alarm files: define some co
 # good: [46d01a22] ext3: fix ext3 block reservation early ENOSPC issu
 # good: [47c59803] devcgroup: remove spin_lock()

The remaining bisection window of uncategorized commits is:

 nr of bisection commits: 14
 ----------------------------
 656eb2c: add CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS
 6409324: coredump: format_corename: don't append .%pid if  multi-threaded
 b747c8c: make ptrace_untrace() static
 c459643: bitmask: remove bitmap_scnprintf_len()
 30e8e13: cpuset: use seq_*mask_* to print masks
 3eda201: seq_file: add seq_cpumask_list(), seq_nodemask_list()
 85dd030: seq_file: don't call bitmap_scnprintf_len()
 40b6a76: cpuset.c: remove extra variable
 52d4b9a: memcg: allocate all page_cgroup at boot
 c05555b: memcg: atomic ops for page_cgroup->flags
 addb9ef: memcg: optimize per-cpu statistics
 5b4e655: memcg: avoid accounting special pages
 b7abea9: memcg: make page->mapping NULL before uncharge
 073e587: memcg: move charge swapin under lock

i'll poke in the middle - maybe i'm lucky and can find a 
working/crashing tree to nudge the bisection back into life.

	Ingo

