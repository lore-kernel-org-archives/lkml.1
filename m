Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbZBXDaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbZBXDaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbZBXD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:29:59 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58879 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbZBXD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:29:58 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902231203.09082.rjw@sisk.pl>
	<m18wnx41h5.fsf@fess.ebiederm.org> <200902232239.05926.rjw@sisk.pl>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Feb 2009 19:30:16 -0800
In-Reply-To: <200902232239.05926.rjw@sisk.pl> (Rafael J. Wysocki's message of "Mon\, 23 Feb 2009 22\:39\:04 +0100")
Message-ID: <m1iqn01ph3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: rjw@sisk.pl, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu
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
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday 23 February 2009, Eric W. Biederman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> >> I don't know where in the state machine this is getting called but
>> >> I would suggest doing this before we shutdown cpus.
>> >
>> > This is the plan.  In fact, I'm going to do this in the next patch after the
>> > $subject one has been tested and found acceptable.
>> 
>> Good to hear.  Then let's please get a version of the irq disable that calls
>> shutdown, so we can be certain we don't have hardware irqs in flight.
>> 
>> For the drivers it should not matter for clean cpu shutdown it will.
>
> OK, I will.

My apologies I was wrong.  Calling shutdown is not safe.

I just remembered that masking an ioapic from anywhere besides the
irq handler can lock the ioapic state machine, and lead to non-recoverable
interrupts.  It is rare but I have seen it happen.  I wanted to figure out
how to migrate interrupts outside of interrupt context and this was what
prevented me.  A suspend/resume cycle might be enough of a reset to
get the ioapic out of that state but I don't know.

The only safe way on x86 to shutdown a level triggered ioapic irq
outside of irq context is for the driver to program the hardware to
not generate an irq.

Therefore doing anything with the irqs at the point where we are
suspending them is a formality, and perhaps simply code that ensures
in-flight irqs don't make it past a certain point.

I believe we just need to call disable() and print a big nasty warning
if any irq comes in after the suspend stage.

Eric
