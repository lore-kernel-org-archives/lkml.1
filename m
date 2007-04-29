Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXD2FgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXD2FgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 01:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbXD2FgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 01:36:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:35978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968AbXD2FgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 01:36:06 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: tglx@linutronix.de, venkatesh.pallipadi@intel.com
Subject: send_IPI_mask_bitmask() (Re: 2.6.21 known regressions (v2) (for -stable team))
Date: Sun, 29 Apr 2007 01:34:38 -0400
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Jeff Chua <jeff.chua.linux@gmail.com>
References: <463375E5.5040108@googlemail.com> <1177779533.7646.264.camel@localhost.localdomain>
In-Reply-To: <1177779533.7646.264.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704290134.39048.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 April 2007 12:58, Thomas Gleixner wrote:
> On Sat, 2007-04-28 at 18:27 +0200, Michal Piotrowski wrote:
> > Hi all,
> > 
> > Here is a list of known regressions reported after 2.6.21 release.
> 
> Michal, thanks for stepping up !
> 
> > Subject    : 2.6.21 - BUG: at arch/i386/kernel/smp.c:177 send_IPI_mask_bitmask()
> > References : http://lkml.org/lkml/2007/4/27/621
> > Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> > Status     : unknown
> 
> Len,
> 
> clockevents_notify() is called with the power verify information for an
> offline CPU. I can handle this in the clockevents code, but I think acpi
> is the correct place.

So the CONFIG_GENERIC_CLOCKEVENTS=y case is broken,
but the CONFIG_GENERIC_CLOCKEVENTS=n below is okay?
Not immediately clear why both cases can't fail.

Maybe Venki can explain.

-Len


static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
{
#ifdef CONFIG_GENERIC_CLOCKEVENTS
        unsigned long reason;

        reason = pr->power.timer_broadcast_on_state < INT_MAX ?
                CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;

        clockevents_notify(reason, &pr->id);
#else
        cpumask_t mask = cpumask_of_cpu(pr->id);

        if (pr->power.timer_broadcast_on_state < INT_MAX)
                on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
        else
                on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
#endif
}
