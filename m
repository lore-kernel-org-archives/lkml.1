Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbXLQW46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbXLQW46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759855AbXLQW4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:56:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759777AbXLQW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:56:47 -0500
Date: Mon, 17 Dec 2007 14:56:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - wonky disk cache and CDROM behavior...
Message-Id: <20071217145644.2d6374e4.akpm@linux-foundation.org>
In-Reply-To: <30457.1197931451@turing-police.cc.vt.edu>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<30457.1197931451@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 17:44:11 -0500
Valdis.Kletnieks@vt.edu wrote:

> On Thu, 13 Dec 2007 02:40:50 PST, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/
> 
> OK, so I'm trying to 'dd' a CD and the drive on the laptop is having issues
> reading the disk.
> 
> I try it once, and get an I/O error about 117M in - dd reports 1.7M/sec.
> 
> I try it again, and it reports it died at the same exact place, but in about
> 2 seconds flat, and reports 91M/sec transfer.  OK, that's *weird*, I didn't
> think that blocks read from /dev/cdrom would get cached, but OK.

It'll remain cached if something is holding the device open.

>  So I try
> the obviously stupid thing:
> 
> # echo 1 >| /proc/sys/vm/drop_caches
> 
> Alas, that hangs gloriously - 'echo t > /proc/sysrq-trigger' tells me:
> 
> Dec 17 17:30:02 turing-police kernel: [20235.823201] bash          D 0000000000000001  5288 15123  15085
> Dec 17 17:30:02 turing-police kernel: [20235.823206]  ffff81007ba7de28 0000000000000086 0000000000000000 0000000000000000
> Dec 17 17:30:02 turing-police kernel: [20235.823210]  ffff81007bbd9000 ffff81007d70e000 ffff81007bbd9248 00000001019e3e48
> Dec 17 17:30:02 turing-police kernel: [20235.823214]  ffffe20000f36028 ffffe200012b9978 ffffe20000eece48 ffffe20001164188
> Dec 17 17:30:02 turing-police kernel: [20235.823218] Call Trace:
> Dec 17 17:30:02 turing-police kernel: [20235.823224]  [<ffffffff80523e20>] __down_read+0x87/0xa1
> Dec 17 17:30:02 turing-police kernel: [20235.823229]  [<ffffffff8024bc13>] down_read+0x9/0xe
> Dec 17 17:30:02 turing-police kernel: [20235.823232]  [<ffffffff802abafe>] drop_pagecache+0x3a/0x8c
> Dec 17 17:30:02 turing-police kernel: [20235.823235]  [<ffffffff802abb72>] drop_caches_sysctl_handler+0x22/0x38
> Dec 17 17:30:02 turing-police kernel: [20235.823239]  [<ffffffff802d2b70>] proc_sys_write+0x7e/0xa6
> Dec 17 17:30:02 turing-police kernel: [20235.823244]  [<ffffffff8028e18c>] vfs_write+0xc7/0x170
> Dec 17 17:30:02 turing-police kernel: [20235.823248]  [<ffffffff8028e772>] sys_write+0x47/0x70
> Dec 17 17:30:02 turing-police kernel: [20235.823251]  [<ffffffff8020c34c>] tracesys+0xdc/0xe1
> 

Something's holding s_umount for writing I guess.  Possibly busted error
handling somewhere totally different.
