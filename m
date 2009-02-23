Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZBWDEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZBWDEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 22:04:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZBWDDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 22:03:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35563 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZBWDDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 22:03:53 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl>
	<alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
	<200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 22 Feb 2009 19:04:08 -0800
In-Reply-To: <200902230048.33635.rjw@sisk.pl> (Rafael J. Wysocki's message of "Mon\, 23 Feb 2009 00\:48\:32 +0100")
Message-ID: <m1ab8ddfbr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: rjw@sisk.pl, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Sunday 22 February 2009, Rafael J. Wysocki wrote:
>> On Sunday 22 February 2009, Linus Torvalds wrote:
>> > 
>> > On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
> [--snip--]
>> 
>> Thanks a lot for your comments, I'll send an updated patch shortly.
>
> The updated patch is appended.
>
> It has been initially tested, but requires more testing, especially with APM,
> XEN, kexec jump etc.
>
> Thanks,
> Rafael
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Rework handling of interrupts during suspend-resume (rev. 2)
>
> Introduce two helper functions allowing us to disable device
> interrupts (at the IO-APIC level) during suspend or hibernation
> and enable them during the subsequent resume, respectively, so that
> the timer interrupts are enabled while "late" suspend callbacks and
> "early" resume callbacks provided by device drivers are being
> executed.
>
> Use these functions to rework the handling of interrupts during
> suspend (hibernation) and resume.  Namely, interrupts will only be
> disabled on the CPU right before suspending sysdevs, while device
> interrupts will be disabled (at the IO-APIC level), with the help of
> the new helper function, before calling "late" suspend callbacks
> provided by device drivers and analogously during resume.

I don't have an issue with the code, but I do have an issue with
this description of it.

Calling disable especially for ioapics does nothing directly.
It simply arranges for the irq to be marked pending and for the
irq to be masked if the irq happens.

So what you are doing is arranging so that no interrupts will be
delivered to drivers.  Not really disabling interrupts at the IO-APIC
level.

In addition not all interrupts (even on x86) go through an IO-APIC anymore
so describing the patch in terms of an IO-APIC makes it a bit hard to
understand what your intent actually is.


Eric
