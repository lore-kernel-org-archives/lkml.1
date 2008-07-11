Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYGKJWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYGKJWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYGKJWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:22:03 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49217 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYGKJWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:22:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080710181634.764954000@linux-os.sc.intel.com>
	<20080710182237.489115000@linux-os.sc.intel.com>
	<m13amhgwx8.fsf@frodo.ebiederm.org>
	<20080711054106.GS1678@linux-os.sc.intel.com>
Date: Fri, 11 Jul 2008 02:19:05 -0700
In-Reply-To: <20080711054106.GS1678@linux-os.sc.intel.com> (Suresh Siddha's
	message of "Thu, 10 Jul 2008 22:41:06 -0700")
Message-ID: <m1zloo93sm.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Suresh Siddha <suresh.b.siddha@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4592]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [patch 11/26] x64, x2apic/intr-remap: generic irq migration support from process context
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> You are referring to desc->lock portion?

yes.

> Two reasons:
>
> a. Other code in CONFIG_GENERIC_PENDING_IRQ, assuming that desc->lock is held
> while calling set_affinity. like fixup_irqs(). Just wanted to be same
> across the board.

Almost useful fixup_irqs is and always has been broken.  So it doesn't really count.

> b. for level triggered, we still touch irq_desc and set IRQ_MOVE_PENDING,
> when we fail to move the irq (if there is already some level triggered
> interrupt happening in parallel). while, we can acquire the lock inside
> the set_affinity, I thought this simplifies things.

Actually if you acquire the lock inside of set_affinity you can sleep,
which may simplify things more.

Fixup_irqs assumes everything happens atomically with irqs disabled so
it doesn't unless you busy wait until the irq is handled.  The best
you can do is if you have an ioxapic force the issue by sending a
directed EOI.  For older apics there is nothing you can do because IPI
are edge triggered and only the acknowledgement of level triggered
interrupts triggers a broadcast EOI for a vector.

Unless you just plain get interested or have a business interest in
true cpu hotplug I don't expect you to fix fixup_irqs.  That is more
work then unifying io_apic.c between x86_32 and x86_64.  Adding yet
another kludge to the kludge is probably fine for now.

Eric
