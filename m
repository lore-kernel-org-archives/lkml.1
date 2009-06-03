Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZFCVNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZFCVNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZFCVNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:13:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49627 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZFCVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:13:30 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining triggered "active" device IRQ interrruption
References: <20090602193216.GC7282@us.ibm.com>
	<m1prdlttgz.fsf@fess.ebiederm.org> <20090603170617.GB7566@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 14:13:23 -0700
In-Reply-To: <20090603170617.GB7566@us.ibm.com> (Gary Hade's message of "Wed\, 3 Jun 2009 10\:06\:17 -0700")
Message-ID: <m1oct5nhqk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> Correct, after the fix was applied my testing did _not_ show
> the lockups that you are referring to.  I wonder if there is a
> chance that the root cause of those old failures and the root
> cause of issue that my fix addresses are the same?
>
> Can you provide the test case that demonstrated the old failure
> cases so I can try it on our systems?  Also, do you recall what
> mainline version demonstrated the old failure 

The irq migration has already been moved to interrupt context by the
time I started working on it.  And I managed to verify that there were
indeed problems with moving it out of interrupt context before my code
merged.

So if you want to reproduce it reduce your irq migration to the essentials.
Set IRQ_MOVE_PCNTXT, and always migrate the irqs from process context
immediately.

Then migrate an irq that fires at a high rate rapidly from one cpu to
another.

Right now you are insulated from most of the failures because you still
don't have IRQ_MOVE_PCNTXT.  So you are only really testing your new code
in the cpu hotunplug path.

Now that I look at it in more detail you are doing a double
mask_IO_APIC_irq and unmask_IO_APIC_irq on the fast path and
duplicating the pending irq check.  All of which are pretty atrocious
in and of themselves.

Eric



