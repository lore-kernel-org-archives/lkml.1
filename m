Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZBWJWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZBWJWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZBWJWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:22:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49869 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbZBWJWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:22:38 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl>
	<alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
	<200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl>
	<m1ab8ddfbr.fsf@fess.ebiederm.org> <20090223084400.GB9582@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Feb 2009 01:22:55 -0800
In-Reply-To: <20090223084400.GB9582@elte.hu> (Ingo Molnar's message of "Mon\, 23 Feb 2009 09\:44\:00 +0100")
Message-ID: <m17i3ha4nk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, rjw@sisk.pl
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
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

Ingo Molnar <mingo@elte.hu> writes:


> I think this aspect has been well-understood during the 
> discussion of this topic and it's just a slightly misleading 
> changelog.

As I was a member of that discussion I did not see that.

It took me several passes through the patches to realize
the goal is to allow drivers to be able to sleep while they
are in their late pm shutdown routines.

Why we want this I don't know.  But it seems simple enough
to implement, and it makes it harder to get the late pm
suspend routines wrong, which is always good.

> The new suspend code does not rely on truly disabling IRQs on 
> the low level. The purpose is to not get IRQs to drivers - which 
> might crash/hang/race/misbehave.

Reasonable.  I expect one of the problems with drivers getting it
wrong is that the interface is too complex for mortal humans to
understand.

> Still, it might make sense to not just use the ->disable 
> sequence but primarily the ->shutdown irqchip method (when it's 
> available in the irqchip).

Disable seems fine to me.  This is interesting in the context
of all of the irqs that will when masked show up somewhere
else (think boot interrupts).

> While we obviously cannot turn off the PIC that delivers timer 
> IRQs at this stage - there's no theoretical reason why the 
> suspend sequence couldnt power down some secondary PICs as well 
> - in some arch code, or maybe even in the generic driver suspend 
> sequence if the device tree is structured carefully enough so 
> that the PIC gets turned off last.

If the point is simply to prevent deliver of irqs to the drivers
I don't see the point of anything more than what the patch does
now.

Eric
