Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZGNMnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZGNMnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZGNMnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:43:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37358 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207AbZGNMnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:43:46 -0400
Subject: Re: [PATCH] x86: _edata should include all .data.* sections on
	X86_64
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org
In-Reply-To: <4A5C5FD0.3020204@fisher-privat.net>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
	 <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
	 <4A5C5FD0.3020204@fisher-privat.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 13:42:27 +0100
Message-Id: <1247575347.28240.76.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 12:42:28.0825 (UTC) FILETIME=[8C377490:01CA0480]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 12:37 +0200, Alexey Fisher wrote:
> this is complete trace from debug/kmemleak .
> i will compile now latest linux-arm.org/linux-2.6.git
> 
> but i think i need step by step howto... it's really new for me.

>From my experience, debugging the memory leaks is very time consuming.
Kmemleak just reports what it thinks are leaks and where they were
allocated but not where they should be freed. With the recent patches,
persistent kmemleak false positives dropped to nearly 0 (you may get a
few transient reports but subsequent scans should eliminate them).

Apart from the ext4 leak, there are some comments below:

> unreferenced object 0xffff88013711c2a8 (size 64):
>    comm "swapper", pid 1, jiffies 4294892383
>    backtrace:
>      [<ffffffff810fbaca>] create_object+0x13a/0x2c0
>      [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
>      [<ffffffff810f596b>] __kmalloc+0x11b/0x210
>      [<ffffffff81263b41>] kzalloc+0xf/0x11
>      [<ffffffff8126416d>] acpi_add_single_object+0x5b0/0xd5a
>      [<ffffffff81264b32>] acpi_bus_scan+0x125/0x1af
>      [<ffffffff8176dcb7>] acpi_scan_init+0xc8/0xe9
>      [<ffffffff8176da72>] acpi_init+0x21f/0x265
>      [<ffffffff8100905b>] do_one_initcall+0x4b/0x190
>      [<ffffffff8174b6ef>] kernel_init+0x169/0x1bf
>      [<ffffffff8100c69a>] child_rip+0xa/0x20
>      [<ffffffffffffffff>] 0xffffffffffffffff

I get ACPI reports as well and it's possible they are real leaks but the
code is too complex to debug.

> unreferenced object 0xffff8801329ac708 (size 128):
>    comm "udevd", pid 1710, jiffies 4294894924
>    backtrace:
>      [<ffffffff810fbaca>] create_object+0x13a/0x2c0
>      [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
>      [<ffffffff810f4b8b>] kmem_cache_alloc+0xfb/0x180
>      [<ffffffff811325fa>] sys_inotify_add_watch+0xca/0x350
>      [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
>      [<ffffffffffffffff>] 0xffffffffffffffff

Real leak - reported here http://lkml.org/lkml/2009/7/6/334 and a patch
should be merged into mainline at some point.

-- 
Catalin

