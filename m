Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbYARJ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbYARJ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYARJ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:28:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYARJ2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:28:25 -0500
Date: Fri, 18 Jan 2008 10:28:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Debug warning: early ioremap leak of 2 areas detected.
Message-ID: <20080118092812.GI24337@elte.hu>
References: <478FDC52.5010002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478FDC52.5010002@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I got this when doing a test boot of a current x86 kernel under kvm.

sidenote, is this failure normal:

> acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed

?

the leaked ioremap seems to be:

> early_ioremap(2fff0a10, 00000040) [1] => Pid: 1, comm: swapper Not tainted 2.6.24-rc8 #1877
> [<c04e3913>] early_ioremap+0x49/0x157
> [<c0117057>] __acpi_map_table+0x2f/0x31
> [<c0279459>] acpi_os_map_memory+0x1a/0x1c
> [<c028b4fc>] acpi_tb_verify_table+0x20/0x4d
> [<c028acea>] acpi_get_table+0x4a/0x91
> [<c04ec303>] acpi_processor_init+0x35/0xcf
> [<c04d44b8>] kernel_init+0x14f/0x2a5
> [<c0107c12>] ? ret_from_fork+0x6/0x1c
> [<c04d4369>] ? kernel_init+0x0/0x2a5
> [<c04d4369>] ? kernel_init+0x0/0x2a5
> [<c01089f3>] kernel_thread_helper+0x7/0x10
> =======================
> 00000a10 + ffd40000

> Debug warning: early ioremap leak of 2 areas detected.
> please boot with early_ioremap_debug and report the dmesg.

hm, why does it say 2? I only see a single backtrace in the dmesg you 
sent. ( Could you boot with ignore_loglevel to make sure you get all 
printks to the log? )

Btw., did the bootup otherwise go fine? The typical nesting is at most 2 
levels, and i've kept the max nesting at 4 so the typical 1-2 leaks 
should have no functional/correctness aspect on the bootup, just that 
warning message. Once we hit the 5th leaked ioremap we start rejecting 
early_ioremap()s and that might result in boot failures.

	Ingo
