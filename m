Return-Path: <linux-kernel-owner+w=401wt.eu-S1760480AbZBYE70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480AbZBYE70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZBYE7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:59:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34047 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbZBYE7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:59:17 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902232239.05926.rjw@sisk.pl>
	<m1iqn01ph3.fsf@fess.ebiederm.org> <200902242342.07721.rjw@sisk.pl>
	<alpine.LFD.2.00.0902241449221.3111@localhost.localdomain>
	<m18wnvup53.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0902242020120.3111@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Feb 2009 20:59:43 -0800
In-Reply-To: <alpine.LFD.2.00.0902242020120.3111@localhost.localdomain> (Linus Torvalds's message of "Tue\, 24 Feb 2009 20\:26\:29 -0800 \(PST\)")
Message-ID: <m1eixnru0w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 24 Feb 2009, Eric W. Biederman wrote:
>> The question I was asking is:
>> Can we get the broken cpu hotunplug code out of the suspend path?
>
> I think we can move it around. I don't think we can get rid of it.
>
>> If we can get the devices into a low power state and not generating
>> interrupts by the time we disable cpus then we do not need to migrate
>> irqs from process context and risk hitting the ioapic bugs.
>
> At least one issue is that the actual final "go to sleep" is something 
> that has to happen on just one CPU. And I'm pretty sure the others have to 
> have gone through the shutdown sequence before that.
>
> And knowing ACPI, the ordering requirements will boil down to something 
> insane, like "you have to turn off the other CPU's _before_ you turn off 
> some od the core devices, because turning off the other CPU's may involve 
> them". 
>
> So if what you would _want_ to do is to move the "turn off CPU's" into the 
> very innermost layer, so that different architectures can then decide 
> whether they even need to go through that whole thing or not (because 
> turning off one core will automatically turn off all the others, simply 
> because the power was turned off), I suspect the answer is "no".
>
> So you were probably hoping to never have to have that whole horrible 
> issue with moving interrupts around. I'm afraid I'm not seeing it happen. 
> But maybe we can have it happen after we've disabled all the non-system 
> devices, so that in practice there simply won't be any new interrupts 
> coming in any more.

Right.  That is what I am hoping for.  No device interrupts coming into the
cpus at the time we turn them off.

We can disable the devices and thus disable the interrupts the devices
are sending before we disable the cpus.  That should make cpu disable
on suspend much easier to get solid then general x86 cpu hot-unplug.

Eric
