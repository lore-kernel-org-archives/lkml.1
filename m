Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYHAUXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYHAUXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYHAUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:23:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40732 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbYHAUXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:23:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com>
	<200807292138.41720.yhlu.kernel@gmail.com>
	<200807300311.48510.yhlu.kernel@gmail.com>
	<200807301210.31511.yhlu.kernel@gmail.com>
Date: Fri, 01 Aug 2008 13:13:45 -0700
In-Reply-To: <200807301210.31511.yhlu.kernel@gmail.com> (Yinghai Lu's message
	of "Wed, 30 Jul 2008 12:10:30 -0700")
Message-ID: <m11w18xzly.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yhlu.kernel@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4994]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/7] dyn_array support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ugh.  Looks like I forgot to hit send on this.

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> please check the patches adding dyn_array and nr_irqs

YH thank you for working on this.

To fix the post rc1 regression I believe your patch series is very
much overkill.  We need to fix this but the bug should be fixed first
by restoring the old heuristics for NR_IRQS.  I will carefully look at
your first patch and see if it successfully restores the old
heuristics, I don't think it quite does.

I very much do not like this approach of introducing nr_irqs instead
of NR_IRQS.  It does not kill NR_IRQS it just renames it and it does
not appear to me to solve the real issues, and it seems to entrench
some current mistakes instead of clean them up.  When I said NR_IRQS
must die I meant the concept not the spelling.  Having a fixed sized
array is only part of it.  We actually use that array very sparsely.
So even having an array of irq_desc structures is painful.

Further we want to user our irq numbers sparsely so that we can have a stable
irq numbers even for things such as msis.

Outside of the arch specific code and the irq implementation there are
currently only 40 mentions of NR_IRQS, and only 7 mentions of NR_IRQS as
an array size.

git-ls-files | grep -v '^arch' | grep -v '^include/asm' | \
  grep -v '^kernel/irq' | grep -v 'drivers/xen/events.c' | \
  xargs grep '[^A-Za-z0-9_]NR_IRQS[^A-Za-z0-9_]' |  wc -l

There is little to no excuse for the generic code to be using NR_IRQS.
The usage in /dev/random should be moved in some form into irq_desc.
The usage in the serial code and in intr_remapping are failures to
use current best practices.  For most of the rest simply introducing
an irq valid helper function would solve the issue.

Further once we have killed the usage of NR_IRQS outside of the arch
code.  We don't need to introduce new infrastructure.  We can call
alloc_bootmem as appropriate, and we can consider important things
such as NUMA affinity with the irq controllers, and where we expect
the irqs to be serviced.

Plus we don't have to allocate anything beyond the gsi or their mptable
equivalents until someone actually uses the msi or htirq interrupt.

Which means we can be a lot leaner, allocating precisely the irqs we need,
and a lot more efficient with NUMA affinity and by allocating irqs as
they show up.

Eric
