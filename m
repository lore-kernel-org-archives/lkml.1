Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZFEBrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZFEBrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZFEBrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:47:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39767 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZFEBrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:47:31 -0400
To: suresh.b.siddha@intel.com
Cc: "mingo\@elte.hu" <mingo@elte.hu>, "hpa\@zytor.com" <hpa@zytor.com>,
       "tglx\@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak\@linux.intel.com" <ak@linux.intel.com>,
       "travis\@sgi.com" <travis@sgi.com>,
       "steiner\@sgi.com" <steiner@sgi.com>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
References: <1244141989.27006.10369.camel@localhost.localdomain>
	<m1iqjbd243.fsf@fess.ebiederm.org>
	<1244164694.27006.10374.camel@localhost.localdomain>
	<1244164783.27006.10375.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 04 Jun 2009 18:47:25 -0700
In-Reply-To: <1244164783.27006.10375.camel@localhost.localdomain> (Suresh Siddha's message of "Thu\, 04 Jun 2009 18\:19\:43 -0700")
Message-ID: <m1vdnb4fki.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: suresh.b.siddha@intel.com, garyhade@us.ibm.com, steiner@sgi.com, travis@sgi.com, ak@linux.intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> On Thu, 2009-06-04 at 18:18 -0700, Suresh Siddha wrote:
>> On Thu, 2009-06-04 at 16:13 -0700, Eric W. Biederman wrote:
>> > Suresh Siddha <suresh.b.siddha@intel.com> writes:
>> > 
>> > > From: Suresh Siddha <suresh.b.siddha@intel.com>
>> > > Subject: x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
>> > >
>> > > In the presence of interrupt-remapping, irqs will be migrated in the
>> > > process context and we don't do (and there is no need to) irq_chip mask/unmask
>> > > while migrating the interrupt.
>> > >
>> > > Similarly fix the fixup_irqs() that get called during cpu offline and avoid
>> > > calling irq_chip mask/unmask for irqs that are ok to be migrated in the
>> > > process context.
>> > >
>> > > While we didn't observe any race condition with the existing code,
>> > > this change takes complete advantage of interrupt-remapping in
>> > > the newer generation platforms and avoids any potential HW lockup's
>> > > (that often worry Eric :)
>> > 
>> > You now apparently fail to migrate the irq threads in tandem with
>> > the rest of the irqs.
>> 
>> Eric, Are you referring to Gary's issues? As far as I understand, they
>> don't happen in the presence of interrupt-remapping.
>> 
>> Can you ack this patch, as this avoid touching IO-APIC and MSI entries
>> and does fixup_irqs() in a much more reliable fashion.
>
> in the presence of interrupt-remapping ofcourse :)

As far as this patch goes it looks like an improvement.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

However after looking at Gary's issues I see some things that are still wrong
on this path.

1) We don't do the part of irq migration that moves irq threads.
   We aren't using irq threads yet but still

   If we could figure out how to call irq_set_affinity for the IRQ_MOVE_PCNTXT
   code path that would make the maintenance a lot simpler.

2) We still diverge on 32bit vs 64bit for no reason.
   I expect the fixed 64bit version should be moved into apic/io_apic.c

3) We still enable irqs for a short while after this to let things drain.
   I am wondering if that is really necessary.    It does very simply
   allow the irq cleanup ipi to happen, and it unjams any irqs that happened
   before we migrated them.

   If we wanted to very strictly follow the rules I guess we could do something
   like the cleanup_ipi by hand on the cpu that is going down and rebroadcast
   all of the pending irqs to another cpu to process.

Eric
