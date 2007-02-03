Return-Path: <linux-kernel-owner+w=401wt.eu-S1946217AbXBCBk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946217AbXBCBk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946216AbXBCBk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:40:26 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47459 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946217AbXBCBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:40:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>, "Lu, Yinghai" <yinghai.lu@amd.com>,
       "Luigi Genoni" <luigi.genoni@pirelli.com>, Ingo Molnar <mingo@elte.hu>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070202170500.57b6c3a3.akpm@linux-foundation.org>
Date: Fri, 02 Feb 2007 18:39:15 -0700
In-Reply-To: <20070202170500.57b6c3a3.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 2 Feb 2007 17:05:00 -0800")
Message-ID: <m1fy9o3tq4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@osdl.org> writes:

> So is this a for-2.6.20 thing?  The bug was present in 2.6.19, so
> I assume it doesn't affect many people?

If it's not to late, and this patch isn't too scary.

It's a really rare set of circumstances that trigger it, but the
possibility of being hit is pretty widespread, anything with
more than one cpu, and more then one irq could see this.

The easiest way to trigger this is to have two level triggered irqs on
two different cpus using the same vector.  In that case if one acks
it's irq while the other irq is migrating to a different cpu 2.6.19
get completely confused and stop handling interrupts properly.

With my previous bug fix (not to drop the ack when we are confused)
the machine will stay up, and that is obviously correct and can't
affect anything else so is probably a candidate for the stable tree.

With this fix everything just works.

I don't know how often a legitimate case of the exact same irq
going off twice in a row is, but that is a possibility as well
especially with edge triggered interrupts.

Setting up the test scenario was a pain, but by extremely limiting
my choice of vectors I was able to confirm I survived several hundred
of these events with in a couple of minutes no problem.

Eric
