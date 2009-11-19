Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZKSC2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZKSC2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 21:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757412AbZKSC2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 21:28:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbZKSC2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 21:28:45 -0500
Date: Thu, 19 Nov 2009 03:28:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiri Slaby <jslaby@novell.com>,
       "jirislaby@gmail.com" <jirislaby@gmail.com>,
       "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
       "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "marcin.slusarz@gmail.com" <marcin.slusarz@gmail.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 03/16] IA64: use ACCESS_ONCE for rlimits
Message-ID: <20091119022816.GA27729@elte.hu>
References: <4B040A03.2020508@gmail.com>
 <1258555922-2064-3-git-send-email-jslaby@novell.com>
 <57C9024A16AD2D4C97DC78E552063EA3E38E71DD@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.0911181138120.2261@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911181138120.2261@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So the rule is: if you access unlocked values, you use ACCESS_ONCE(). 
> You don't say "but it can't matter". Because you simply don't know.

Most of the time we are being lax about it, especially when it's some 
global value we are accessing, which can only be changed as a sysadmin 
via a sysctl or so.

[ For example we access pid_max in kernel/pid.c, outside of any lock and 
  without ACCESS_ONCE() - but that particular case is not a big deal 
  because changes to pid_max via a sysctl are so rare and are 
  privileged, and because the effects of any race there are benign. ]

But this patch series is about setrlimit, which makes the per task 
rlimit value pretty SMP-volatile (a parallel, unprivileged setrlimit can 
race with usage of the value elsewhere) - and the rlimits have security 
relevance as well so some extra care in accessing them outside of locks 
is prudent IMO.

	Ingo
