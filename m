Return-Path: <linux-kernel-owner+w=401wt.eu-S1946167AbXBCBF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946167AbXBCBF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946203AbXBCBF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:05:26 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946167AbXBCBFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:05:25 -0500
Date: Fri, 2 Feb 2007 17:05:00 -0800
From: Andrew Morton <akpm@osdl.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: <linux-kernel@vger.kernel.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq
 migration.
Message-Id: <20070202170500.57b6c3a3.akpm@linux-foundation.org>
In-Reply-To: <m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Feb 2007 17:35:31 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> When making the interrupt vectors per cpu I failed to handle a case
> during irq migration.  If the same interrupt comes in while we are
> servicing the irq but before we migrate it the pending bit in the
> local apic IRR register will be set for that irq.
> 
> After migrating the irq to another cpu and or vector the data
> structures will no longer be setup to handle this pending irq.  Then as
> soon as we return from servicing the irq we just migrated we will get
> a nasty: "No irq handler for vector" message. 
> 
> Since we do not disable irqs for edge triggered interrupts except
> in the smallest possible window during migration I cannot avoid
> migrating an irq in the unlikely event that it becomes pending.
> This is because by the time the irq could no longer become pending
> I have already updated all of my data structures.
> 
> Therefore this patch introduces an intermediate state that
> exists soley on the cpu where we are handling the irq during
> migration.  The irq number is changed to negative in the
> vector_irq data structure.
> 
> Once the migration operation is complete we know we will receive
> no more interrupts on this vector so the irq pending state for
> this irq will no longer be updated.  If the irq is not pending and
> we are in the intermediate state we immediately free the vector,
> otherwise in we free the vector in do_IRQ when the pending irq
> arrives.

So is this a for-2.6.20 thing?  The bug was present in 2.6.19, so
I assume it doesn't affect many people?
