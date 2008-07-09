Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYGIIet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYGIIet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYGIIem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:34:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYGIIel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:34:41 -0400
Date: Wed, 9 Jul 2008 10:34:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: not overmap than end in init_memory_mapping -
	64bit
Message-ID: <20080709083425.GA23952@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <20080709073844.GB30428@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709073844.GB30428@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > handle head and tail that can not aligned to big pages.
> > 
> > with this patch, on system that support gbpages
> > change
> > last_map_addr: 1080000000 end: 1078000000
> > to
> > last_map_addr: 1078000000 end: 1078000000
> > 
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> applied to tip/x86/core, thanks Yinghai.

found an early boot crash on a testbox:

[    0.000000] last_pfn = 0x3fff0 max_arch_pfn = 0x3ffffffff
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] kernel direct mapping tables up to 3fff0000 @ 8000-b000
[    0.000000] last_map_addr: 40000000 end: 3fff0000
[    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
PANIC: early exception 0e rip 10:ffffffff803d3b8a error 0 cr2 ffff88003fff3040
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26-rc9-tip-00118-g95f03c7-dirty #16954
[    0.000000]
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff80c05196>] early_idt_handler+0x56/0x6a
[    0.000000]  [<ffffffff803d3b8a>] ? acpi_tb_print_table_header+0xe/0xd5
[    0.000000]  [<ffffffff803d3bfc>] ? acpi_tb_print_table_header+0x80/0xd5
[    0.000000]  [<ffffffff803d42f4>] ? acpi_tb_scan_memory_for_rsdp+0xc8/0xd3

i bisected it down to:

|  a1007454854803f6fc63f0a881518cea87df6d9a is first bad commit
|  commit a1007454854803f6fc63f0a881518cea87df6d9a
|  Author: Yinghai Lu <yhlu.kernel@gmail.com>
|  Date:   Tue Jul 8 01:43:27 2008 -0700
|
|      x86: not overmap more than the end of RAM in init_memory_mapping - 64bit

with this config:

  http://redhat.com/~mingo/misc/config-Wed_Jul__9_09_43_06_CEST_2008.bad

crashlog:

 http://redhat.com/~mingo/misc/crashlog-Wed_Jul__9_09_43_06_CEST_2008.bad

i've pushed the failing tree out to tip/tmp.x86.Jul__9_09_43

reverting the commit solves the crash. The crash seems to be because 
ACPI is unable to access that memory range. (perhaps early_ioremap 
fails?)

	Ingo
