Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZFDUFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZFDUFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 16:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZFDUEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 16:04:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39231 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFDUEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 16:04:54 -0400
Date: Thu, 4 Jun 2009 13:04:37 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "active" device IRQ interrruption
Message-ID: <20090604200437.GA9213@us.ibm.com>
References: <20090602193216.GC7282@us.ibm.com> <m1prdlttgz.fsf@fess.ebiederm.org> <20090603170617.GB7566@us.ibm.com> <m1oct5nhqk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1oct5nhqk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 02:13:23PM -0700, Eric W. Biederman wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
> 
> > Correct, after the fix was applied my testing did _not_ show
> > the lockups that you are referring to.  I wonder if there is a
> > chance that the root cause of those old failures and the root
> > cause of issue that my fix addresses are the same?
> >
> > Can you provide the test case that demonstrated the old failure
> > cases so I can try it on our systems?  Also, do you recall what
> > mainline version demonstrated the old failure 
> 
> The irq migration has already been moved to interrupt context by the
> time I started working on it.  And I managed to verify that there were
> indeed problems with moving it out of interrupt context before my code
> merged.
> 
> So if you want to reproduce it reduce your irq migration to the essentials.
> Set IRQ_MOVE_PCNTXT, and always migrate the irqs from process context
> immediately.
> 
> Then migrate an irq that fires at a high rate rapidly from one cpu to
> another.
> 
> Right now you are insulated from most of the failures because you still
> don't have IRQ_MOVE_PCNTXT.  So you are only really testing your new code
> in the cpu hotunplug path.

OK, I'm confused. 

It sounds like you want me force IRQ_MOVE_PCNTXT so that I can
test in a configuration that you say is already broken.  Why
in the heck would this config, where you expect lockups without 
the fix, be a productive environment in which to test the fix?  

> 
> Now that I look at it in more detail you are doing a double
> mask_IO_APIC_irq and unmask_IO_APIC_irq on the fast path

Good question.  I had based my changes on the previous
CONFIG_INTR_REMAP IRQ migration delay code that was doing
the same thing.  I had assumed that the CONFIG_INTR_REMAP
code was correct and that the nesting of
mask_IO_APIC_irq_desc/unmask_IO_APIC_irq_desc sequences
was OK.  Now that I look at how mask_IO_APIC_irq_desc and
unmask_IO_APIC_irq_desc are implemented I see that there
is e.g. no reference counting to assure that only the last
caller of unmask_IO_APIC_irq_desc wins.  This reduces the
range of code that is executed with the IRQ masked.

Do you see any reason why the IRQ needs to be masked 
downstream of the unmask_IO_APIC_irq_desc call that the
patch adds?

> and duplicating the pending irq check.

Yes, I was aware of this and had considered removing
the current check but I was trying to minimize the changes
as much as possible, especially those changes affecting
the normal IRQ migration path.

Removal of the current check would simplify the code
and would also eliminate the failed affinity change
requests from user level that can result from the
current check.

Do you think it would be a good idea to remove this
extra check?  If so, I would prefer to do it with a
separate patch so that I can do a good job of testing it.

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

