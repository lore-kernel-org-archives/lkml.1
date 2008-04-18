Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbYDRToR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbYDRToR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 15:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759708AbYDRToJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 15:44:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbYDRToI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 15:44:08 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
X-Fcc: ~/Mail/linus
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080418194334.7483627037C@magilla.localdomain>
Date: Fri, 18 Apr 2008 12:43:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this was a good idea:

	commit 5b0e508415a83989fe704b4718a1a214bc333ca7
	Author: Jan Beulich <jbeulich@novell.com>
	Date:   Mon Mar 10 13:11:17 2008 +0000

	    x86: prevent unconditional writes to DebugCtl MSR

It's already a bug if there is any unconditional use of the MSR.
Silenting ignoring it is just wrong.

There was such a bug before this fix:

	commit 4ba51fd75cc3789be83f0d6f878dabbb0cb19bca
	Author: Roland McGrath <roland@redhat.com>
	Date:   Thu Apr 3 14:18:55 2008 -0700

	    x86 ptrace: avoid unnecessary wrmsr

But there should not be any more.  The use of the MSR for block-step is
controlled by arch_has_block_step(), which uses the same condition.  Any
use of the MSR for other purposes (DS et al) should be controlled by more
specific CPU model checks.  

If TIF_DEBUGCTLMSR is ever set on a machine without the support, that is a
bug we should diagnose earlier.  If you want some paranoia, then keep
update_debugctlmsr but make it do:

	BUG_ON(boot_cpu_data.x86 < 6);

instead.


Thanks,
Roland
