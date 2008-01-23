Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYAWAAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYAWAAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 19:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbYAWAAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 19:00:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYAWAAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 19:00:35 -0500
Date: Wed, 23 Jan 2008 01:00:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, venkatesh.pallipadi@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr
	patch series v3)
Message-ID: <20080123000017.GA16576@elte.hu>
References: <200801161114.239449000@suse.de> <200801181819.58675.ak@suse.de> <20080121164052.GA11364@elte.hu> <200801211813.45102.ak@suse.de> <alpine.LFD.1.00.0801221119180.3199@apollo.tec.linutronix.de> <20080122132355.GA24320@wotan.suse.de> <alpine.LFD.1.00.0801221439520.3199@apollo.tec.linutronix.de> <20080122142147.GD19936@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122142147.GD19936@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > because it interferes/interacts with CPA and the page table code. So
> 
> No that is not its main problem I believe. Main problem are all the 
> driver and other subsystem interactions (it is a little bit similar to 
> power management where you have lots of little bits all over right 
> instead of a single big one). [...]

that is (yet another) major misconception on your part. "Drivers" are an 
easy to blame target (i guess because there's no one out there to defend 
a vague "drivers" accusation), and they are not the problem here _at 
all_.

Drivers tell the architecture code which physical pages they'd like to 
have access to (or which page range they'd like to see different cache 
attributes on) and that's it. They are plain users of the ioremap() and 
change_page_attr() APIs. Nothing more, nothing less.

It is the utmost duty of architecture code to make those APIs 
fool-proof. Hardware _will_ mess up the physical parameters that get 
passed in every possible way - and drivers just try to use what the 
hardware tells them to use. So robustness is key and there's just no 
"driver reason" why these APIs cannot be robust.

so you are delusional if you think that the c_p_a() problems are "driver 
and other subsystem interactions".

And your analogy with power management could not be more mistaken. Power 
management and suspend/resume in particular is so complex because it is 
analogous to a _full bootup and shutdown cycle_, with the following, 
hard to meet expectation from the user: 'this stuff must work all the 
time, and must be instantaneous'. Suspend/resume is an _incredibly 
complex_ machinery and the user does not realize (and does not accept 
the concequences) of this complexity. It is a codepath that is affected 
by tens and tens of thousands of driver and core kernel code. Just one 
single mistake and "resume does not work".

ioremap() and change_page_attr() on the other hand is a small, few 
hundred lines codebase for a stable and well-defined purpose. There's no 
significant "subsystem interactions" whatsoever.

by far the most intense and most high-frequency user of the 
change_page_attr() code is CONFIG_DEBUG_PAGEALLOC=y. It does a cpa call 
for every single page and slab allocation/freeing. But this debug 
feature ... is not enabled on the 64-bit side - why? So unfortunately we 
dont have any real robustness track record of the 64-bit side of the CPA 
code, and that's exactly the code your clflush and gbpages code changes.

oh, and due to that i'll probably revert these two patches of yours:

  Subject: x86: c_p_a(), change kernel_map_pages to not use c_p_a()
  Subject: x86: c_p_a(), change 32-bit back to init_mm semaphore locking

as with these changes you've removed _the_ most important stress-tester 
for the c_p_a() code: DEBUG_PAGEALLOC.

	Ingo
