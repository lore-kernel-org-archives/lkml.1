Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbXCEXhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbXCEXhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXCEXhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:37:16 -0500
Received: from www.osadl.org ([213.239.205.134]:42882 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752470AbXCEXhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:37:14 -0500
Subject: Re: [5/6] 2.6.21-rc2: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070305015040.GJ3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015040.GJ3441@stusta.de>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 00:43:13 +0100
Message-Id: <1173138193.24738.236.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 02:50 +0100, Adrian Bunk wrote:
> Subject    : ThinkPad T60: system doesn't come out of suspend to RAM
>              (CONFIG_NO_HZ)
> References : http://lkml.org/lkml/2007/2/22/391
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
>              Ingo Molnar <mingo@elte.hu>
> Status     : unknown
> 
> Subject    : macbook pro suspend to ram broken  (clockevents)
> References : http://lkml.org/lkml/2007/3/4/110
> Submitter  : Soeren Sonnenburg <kernel@nn7.de>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Status     : unknown

I can reproduce this on my dual core VAIO. There are some issues:

1) clockevents code needs probably a resume fix, which I'm working on

2) The BOGOMIPS calibration of CPU#1 after resume is completely hosed.
CPU#1 has ~ 200000 Bogomips after resume, which is off by factor 500.
BOGOMIPS is calibrated vs. jiffies, This was also observed by Ingo on
his T60. This is similar to the LAPIC calibration problems I had seen
before the LAPIC rework. IRQ#0 comes in extremly slow (probably caused
by SMM crap, e.g. PS/2 keyboard emulation)

3) on suspend we shut down CPU#1 on dual core machines. resume restarts
CPU#1. Now one would expect that acpi_processor_power_verify would be
called, so that the "LAPIC/TSC stops in C3"-workaround gets applied to
CPU#1. Len confirmed that it should be called, when the cpu is brought
online. This was not noticed before as the old apic code kept the
broadcast bit on cpu shutdown.

Len, can you please look into #3 ?

> Subject    : dynticks makes ksoftirqd1 use unreasonable amount of cpu time
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8100
> Submitter  : Emil Karlson <jkarlson@cc.hut.fi>
> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> Status     : problem is being debugged

Delayed until the above is sorted out.

	tglx


