Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYG1TmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYG1TmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 15:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYG1Tlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 15:41:53 -0400
Received: from www.tglx.de ([62.245.132.106]:39556 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYG1Tlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 15:41:52 -0400
Date: Mon, 28 Jul 2008 21:38:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI/CPUIDLE: prevent setting pm_idle to NULL
In-Reply-To: <20080728174644.GC30344@one.firstfloor.org>
Message-ID: <alpine.LFD.1.10.0807282107500.14925@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807272343480.574@apollo.tec.linutronix.de> <20080728174644.GC30344@one.firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, Andi Kleen wrote:
> > +	/*
> > +	 * Fall back to the default idle loop, when pm_idle_save had
> > +	 * been initialized.
> > +	 */
> > +	if (pm_idle_save) {
> > +		pm_idle = pm_idle_save;
> > +		/* Relies on interrupts forcing exit from idle. */
> > +		synchronize_sched();
> > +	}
> 
> I think it would be better to fall  back to default_idle (which
> might need to be exported) when the old pointer is NULL.

No, falling back to default_idle is wrong as hell. When pm_idle was
set to mwait_idle or whatever then you override pm_idle to
default_idle for no good reason.

The problem here is that the acpi/cpuidle code can be in a state where
the _save/old variables _ARE_ NULL because they had not been
initialized with the original pm_idle before the module is removed or
the cst state changes. So all we have to do is to prevent pm_idle to
be set to NULL.

> Now with your patch 
> the cpuidle idle code would run with inconsistent state for some time,
> which is probably not good.

Err, this happens when the original pm_idle pointer _is_ restored. But
if the _save/old pointer is NULL we crash the system and that's what
my patch prevents.

So nothing runs with an inconsistent state. If pm_idle_save contains
the original pm_idle value we restore, if it is NULL we do not touch
pm_idle and keep the original value.

Thanks,

	tglx
