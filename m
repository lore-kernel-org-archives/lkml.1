Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXFXApy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXFXApy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 20:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXFXApr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 20:45:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53825 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbXFXApq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 20:45:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
References: <20070606231642.GH13751@tree.beaverton.ibm.com>
	<20070619204929.GM9751@tree.beaverton.ibm.com>
	<20070619220812.GG7160@linux-os.sc.intel.com>
	<200706240154.53351.rjw@sisk.pl>
	<20070623165841.1c8f705c.akpm@linux-foundation.org>
Date: Sat, 23 Jun 2007 18:45:05 -0600
In-Reply-To: <20070623165841.1c8f705c.akpm@linux-foundation.org> (Andrew
	Morton's message of "Sat, 23 Jun 2007 16:58:41 -0700")
Message-ID: <m1abuq89ke.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sun, 24 Jun 2007 01:54:52 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> On Wednesday, 20 June 2007 00:08, Siddha, Suresh B wrote:
>> > On Tue, Jun 19, 2007 at 01:49:30PM -0700, Darrick J. Wong wrote:
>> > > 
>> > > This fixes the problem!  Hurrah!
>> > 
>> > Great!  Andrew, please include the appended patch in -mm.
>> > 
>> > ----
>> > Subject: [patch] x86_64, irq: use mask/unmask and proper locking in
> fixup_irqs
>> > From: Suresh Siddha <suresh.b.siddha@intel.com>
>> > 
>> > Force irq migration path during cpu offline, is not using proper
>> > locks and irq_chip mask/unmask routines. This will result in
>> > some races(especially the device generating the interrupt can see
>> > some inconsistent state, resulting in issues like stuck irq,..).
>> > 
>> > Appended patch fixes the issue by taking proper lock and
>> > encapsulating irq_chip set_affinity() with a mask() before and an
>> > unmask() after.
>> > 
>> > This fixes a MSI irq stuck issue reported by Darrick Wong.
>> > 
>> > There are several more general bugs in this area(irq migration in the
>> > process context). For example,
>> > 
>> > 1. Possibility of missing edge triggered irq.
>> > 2. Reliable method of migrating level triggered irq in the process context.
>> > 
>> > We plan to look and close these in the near future.
>> 
>> This patch breaks hibernation on my Turion 64 X2 - based testbox (HPC nx6325).
>> 
>> _cpu_down() just hangs as though there were a deadlock in there, 100% of the
>> time.
>> 
>
> Thanks, I dropped it.

Hmm.  It looks like Siddha sent the wrong version of the patch.
The working tested version had an additional test to ensure
the mask and unmask methods were implemented.

i.e.
+		if (irq_desc[irq].chip->mask)
+			irq_desc[irq].chip->mask(irq);
and

+		if (irq_desc[irq].chip->unmask)
+			irq_desc[irq].chip->unmask(irq);
+

Siddha think you can resend the correct version.

Rafael.  Think you can add those two ifs and see if you test bed box
works?

I'm still not convinced that we can make fixup_irqs work in general
but if we aren't going to yank it we should at least make it
consistent with the rest of the code.

Eric

