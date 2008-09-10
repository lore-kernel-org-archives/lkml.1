Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYIJMMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYIJMMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYIJMMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:12:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51200 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbYIJMM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:12:29 -0400
Date: Wed, 10 Sep 2008 14:12:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910121217.GA16013@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910114755.GA9696@elte.hu>
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

> > shouldn't some of that be conditional on pagefault_disable() 'n 
> > such?
> 
> i dont think so - those have their own special __atomic user-copy 
> primitives which Nick didnt touch.

hm, but the prefetch bits were touched, and -tip testing stumbled upon 
this false positive:

[   66.187448] PM: Adding info for No Bus:vcsa12
[   67.138685] evbug.c: Event. Dev: input0, Type: 20, Code: 0, Value: 500
[   80.149087] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:122
[   80.157344] in_atomic(): 1, irqs_disabled(): 0, pid: 6811, name: gam_server
[   80.164315] no locks held by gam_server/6811.
[   80.168685] Pid: 6811, comm: gam_server Not tainted 2.6.27-rc6-tip-00187-gbfd4ed7-dirty #2
[   80.177013] Call Trace:
[   80.179454]  [<ffffffff8026c1e8>] ? __debug_show_held_locks+0x22/0x24
[   80.185876]  [<ffffffff80242c4d>] __might_sleep+0x104/0x109
[   80.191430]  [<ffffffff8022fd25>] is_prefetch+0xe8/0x228
[   80.196760]  [<ffffffff8023050b>] do_page_fault+0x5d8/0x9a9
[   80.202361]  [<ffffffff802c8218>] ? sys_newstat+0x36/0x41
[   80.207774]  [<ffffffff80c3b2fa>] error_exit+0x0/0xb9

so i've excluded these commits for now. (once there's a fix i can 
continue testing it)

	Ingo
