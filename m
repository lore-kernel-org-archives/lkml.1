Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYGINee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYGINee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYGINe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:34:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37614 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYGINeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:34:25 -0400
Date: Wed, 9 Jul 2008 15:33:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>, Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH RFC 0/4] Paravirtual spinlocks
Message-ID: <20080709133358.GA7005@elte.hu>
References: <20080707190749.299430659@goop.org> <20080709122852.GA30579@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709122852.GA30579@elte.hu>
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


the patches caused a boot hang with this config:

 http://redhat.com/~mingo/misc/config-Wed_Jul__9_14_47_04_CEST_2008.bad

i have bisected it down to:

  commit e17b58c2e85bc2ad2afc07fb8d898017c2b75ed1
  Author: Jeremy Fitzhardinge <jeremy@goop.org>
  Date:   Mon Jul 7 12:07:53 2008 -0700

      xen: implement Xen-specific spinlocks

i.e. applying that patch alone causes the hang. The hang happens in the 
ftrace self-test:

  initcall utsname_sysctl_init+0x0/0x19 returned 0 after 0 msecs
  calling  init_sched_switch_trace+0x0/0x4c
  Testing tracer sched_switch: PASSED
  initcall init_sched_switch_trace+0x0/0x4c returned 0 after 167 msecs
  calling  init_function_trace+0x0/0x12
  Testing tracer ftrace: 
  [hard hang]

it should have continued like this:

  Testing tracer ftrace: PASSED
  initcall init_function_trace+0x0/0x12 returned 0 after 198 msecs
  calling  init_irqsoff_tracer+0x0/0x14
  Testing tracer irqsoff: PASSED
  initcall init_irqsoff_tracer+0x0/0x14 returned 0 after 3 msecs
  calling  init_mmio_trace+0x0/0x12
  initcall init_mmio_trace+0x0/0x12 returned 0 after 0 msecs

note: ftrace is a user of raw spinlocks. Another speciality of the 
config is that it has paravirt enabled (obviously), and that it also has 
lock debugging enabled.

	Ingo
