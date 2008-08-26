Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYHZKhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYHZKhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYHZKgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:36:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59724 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbYHZKgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:36:50 -0400
Date: Tue, 26 Aug 2008 12:36:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Avi Kivity <avi@qumranet.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826103634.GA10144@elte.hu>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com> <20080826095032.GA309@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826095032.GA309@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> On Mon 2008-08-25 13:11:27, Avi Kivity wrote:
> > Triple-fault and keyboard reset may assert INIT instead of RESET; however
> > INIT is blocked when Intel VT is enabled.  This leads to a partially reset
> > machine when invoking emergency_restart via sysrq-b: the processor is still
> > working but other parts of the system are dead.
> > 
> > Default to rebooting via ACPI, which correctly asserts RESET and reboots the
> > machine.
> > 
> > This is safe since we will fall back to keyboard reset and triple fault if
> > acpi is not enabled or if the reset is not successful.
> > 
> > Signed-off-by: Avi Kivity <avi@qumranet.com>
> 
> "ACPI" and "safe" in one sentence. /me bets this will break lot of 
> machines.

maybe. OTOH, it's just about PIO accesses and those tend to be pretty 
safe. I would not be surprised if Windows used the ACPI reboot sequence 
too by default.

PIO access cannot really fail or fault (other than locking up in SMM 
mode) - it can in practice be at most non-effective (the box wont 
reboot) - in which case we'll still cycle through all the other current 
reboot methods.

So i think we are on the safe side. Not for v2.6.27 obviously, but maybe 
for v2.6.28, if all testing is a success. (which it is on a healthy 
range of x86 hardware we test -tip on)

> What about only doing that when enabling VT?

hm, i'd much rather have consistent behavior, so that we have less 
variables. If this breaks anywhere, we want to know about it ASAP and it 
should be pretty debuggable. ('box hangs/crashes during reboot')

In fact this change might unbreak some systems - we have a ton of DMI 
driven reboot quirks and i dont think they are anywhere close to 
complete. It's also very easy to revert, if it were to cause any 
trouble.

What do you think?

	Ingo
