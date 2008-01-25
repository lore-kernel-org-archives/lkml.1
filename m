Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYAYAYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYAYAYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYAYAYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:24:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53003 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYAYAYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:24:13 -0500
Date: Fri, 25 Jan 2008 01:24:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86.git] new CPA implementation
Message-ID: <20080125002401.GA31745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

> > please unify the files first, we dont want to let pageattr_32.c and 
> > pageattr_64.c diverge even more. Once we get these files unified we 
> > layer more features ontop of it.
> 
> They work significantly differently in a few important areas (e.g. 
> particularly regarding NX handling and the kernel mapping) Off the top 
> of my head I don't know of a clean way to unify them. 32bit and 64bit 
> kernel mappings differ in many significant ways. Maybe it's possible, 
> but it's certainly not something I would want to tackle short term in 
> a hurry. [...]

FYI, we've unified and streamlined them in latest x86.git. There's now a 
single arch/x86/mm/pagattr.c implementation of the c_p_a() APIs that is 
used by both the 32-bit and by the 64-bit x86 kernel.

It's a significantly cleaner and simpler c_p_a() implementation, and 
it's also structured in a way to make it easy for gbpages (and clflush) 
to be added as well.

One of the big simplifications was to remove largepage reassembly. (We 
could perhaps still add that back in the future, if someone shows the 
performance benefits and real-life significance of it. But the 
refcounting was nasty and error-prone and was buggy even with your 
latest CPA patches.)

other features:

- the new implementation is much more scalable, because it is lockless 
  in the fastpath - while previous c_p_a() implementations used a global 
  spinlock / or the global init_task.mmap_sem semaphore.

- new 64-bit CONFIG_DEBUG_PAGEALLOC support has been implemented and 
  has been tested to work fine.

- PAGEALLOC does not require PSE to be cleared from the CPU anymore. 
  (The pagetables will still be broken up into 4K ptes during bootup, 
   but that happens as part of the regular c_p_a() sequence. (and thus 
   we get more testing of the largepage-splitup code)

- the CPA-testsuite now passes without failures on both 32-bit and 
  64-bit. (it never fully worked with your CPA series.)

> The kernel mappings between 32bit and 64bit are quite different. [...]

10 lines of code (out of 300 lines of pageattr.c) handles that 
difference.

the new code is still being tested, but it's looking pretty good so far. 
(Note: certain bits within the new cpa series are not backmerged yet.)

	Ingo
