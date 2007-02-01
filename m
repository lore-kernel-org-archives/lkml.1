Return-Path: <linux-kernel-owner+w=401wt.eu-S1161238AbXBAHU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161238AbXBAHU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161244AbXBAHU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:20:56 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40529 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238AbXBAHU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:20:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<Pine.LNX.4.64.0701232052330.32111@baldios.it.pirelli.com>
	<m1bqkfbnep.fsf@ebiederm.dsl.xmission.com>
	<200701311549.22512.luigi.genoni@pirelli.com>
Date: Thu, 01 Feb 2007 00:20:21 -0700
In-Reply-To: <200701311549.22512.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Wed, 31 Jan 2007 15:49:22 +0100")
Message-ID: <m1veim739m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luigi Genoni" <luigi.genoni@pirelli.com> writes:

> OK,
> willing to test any patch.

Ok. I've finally figured out what is going on.  The code is
race free but the programmer was an idiot.

In the local apic there are two relevant registers.
ISR (in service register) describing all of the
interrupts that the cpu in the process of handling.
IRR (intrerupt request register) which lists all of
the interrupts that are currently pending.

Well it happens that IRR is used to catch the case
when we are servicing an interrupt and that same interrupt
comes in again.  When that happens as soon as we are
done service the interrupt that same interrupt fires again.

We perform interrupt migration in an interrupt handler, so
we can be race free.

It turns out that if I'm performing migration (updating all
of the data structures and hardware registers) while IRR
is set the interrupt will happen in the old location immediate after
my migration work is complete.  And since the kernel is not
setup to deal with it we get an ugly error message.

Anyway now that I know what is going on I'm going to have to think
about this a little bit more to figure out how to fix this.  My hunch
is the easy fix will be simply not to migrate until I have an
interrupt instance when IRR is clear.  

Anyway with a little luck tomorrow I will be able to figure it out,
it's to bed with me now.

Eric
