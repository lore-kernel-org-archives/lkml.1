Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYIXTpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYIXTpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYIXTpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:45:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47689 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYIXTpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:45:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <48D94B64.3070004@goop.org> <20080924084558.GD5576@elte.hu>
	<m18wthna2f.fsf@frodo.ebiederm.org> <48DA8806.4060405@goop.org>
Date: Wed, 24 Sep 2008 12:34:09 -0700
In-Reply-To: <48DA8806.4060405@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 24 Sep 2008 11:33:42 -0700")
Message-ID: <m1d4itl4ni.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: jeremy@goop.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0064]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus, or just to this cpu?
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> I found handle_percpu_irq() which addresses my concerns.  It doesn't
> attempt to mask the interrupt, takes no locks, and doesn't set or test
> IRQ_INPROGRESS in desc->status, so it will scale perfectly across
> multiple cpus.  It makes no changes to the desc structure, so there
> isn't even any cacheline bouncing.

kstat_irqs.  Is arguably part of the irq structure.
And kstat_irqs is a major pain in my book.

And for a rare event you have a cacheline read.
I don't think we are quite there yet but we really want to allocate
irq_desc on the right NUMA node in a multi socket system, to reduce
the cache miss times.

Is it a big deal?  Probably not.  But I think it would be a bad
idea to increasingly use infrastructure that will make it hard
to optimize the code.

Especially since the common case in high performance drivers
is going to be, individually routable irq sources.  Having
one queue per cpu and one irq per queue.  Which sounds like
the same case you have.

Eric


