Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbYD3BTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbYD3BTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbYD3BTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:19:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51515 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYD3BTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:19:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Gabriel C <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281244.56938.yhlu.kernel@gmail.com>
	<200804281316.14168.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
	<m1wsmg32qk.fsf@frodo.ebiederm.org>
	<86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
	<m1abjcz9ow.fsf@frodo.ebiederm.org>
	<86802c440804291457k79099d84w53110fabf59e9e37@mail.gmail.com>
	<m11w4oxq9i.fsf@frodo.ebiederm.org>
	<alpine.LFD.1.10.0804300050070.6003@apollo.tec.linutronix.de>
Date: Tue, 29 Apr 2008 18:16:44 -0700
In-Reply-To: <alpine.LFD.1.10.0804300050070.6003@apollo.tec.linutronix.de>
	(Thomas Gleixner's message of "Wed, 30 Apr 2008 00:54:28 +0200
	(CEST)")
Message-ID: <m18wywuooz.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0153]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Tue, 29 Apr 2008, Eric W. Biederman wrote:
>> Think of SMM mode is a lightweight hypervisor that we can't get rid
>> of, if you want to understand the worst case.
>> 
>> In theory SMM mode is completely unnecessary as soon as we enable
>> ACPI.  In practice ACPI appears to frequently trap into SMM mode.
>
> SMM does more than that. It emulates legacy hardware and fixes
> chip(set) bugs as well. Disabling it just makes your box stop
> working. There are certain types of systems where essential safety
> nets rely on SMIs (you can deep-fry P4s by disabling SMIs).

There is truth in that but it is over dramatic.  P4s don't deep fry
they almost always turn off before they overheat (you make take
physical damage to your motherboard though).


The best definition I have heard of SMM mode is: smack the stupid OS
that isn't doing what it should be doing at runtime mode.

It is the way board designers and BIOS writers can work around what
they perceive as broken OS code, that keeps them from doing what
they need to do.  Getting them to give up SMM mode even though
technically possible is requesting they give up a degree of control
and thus a major social engineering challenge for anyone who wishes
to achieve it.


So any time we tread on territory that could mess up SMM mode
we need to be careful, especially as we can not turn it off to
diagnose problems.  The interactions can be hard to root cause.


Replacing overlapping MTRRs with a non overlapping set to allow
X to set a WB region as YH is doing appears safe and reasonable, and
worth doing. 

Going one step farther and reducing some of the WB memory to UC
so we can free up an MTRR for video and to accelerate X is a
bit chancy and something I don't feel comfortable with enabling
by default.  Especially as we have a better long term fix on
the way.

This problem is hitting enough people and the odds of something
really bad happening when you take a 100x or 1000x slowdown in 
SMM are pretty low so I do think it is useful to have a kernel
option that rounds down the amount of memory you have converts WB
memory to UC to accelerate X.

Hopefully by this point we are all now reminded how this can
interact with SMM mode (although no one has ever seen a bad
interaction) and how interacting with SMM mode can be a problem.

Eric
