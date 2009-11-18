Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZKRTtC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZKRTtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 14:49:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbZKRTtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 14:49:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758341AbZKRTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 14:49:00 -0500
Date: Wed, 18 Nov 2009 11:48:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Luck, Tony" <tony.luck@intel.com>
cc: Jiri Slaby <jslaby@novell.com>,
       "jirislaby@gmail.com" <jirislaby@gmail.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
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
Subject: RE: [PATCH 03/16] IA64: use ACCESS_ONCE for rlimits
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E38E71DD@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0911181138120.2261@localhost.localdomain>
References: <4B040A03.2020508@gmail.com> <1258555922-2064-3-git-send-email-jslaby@novell.com> <57C9024A16AD2D4C97DC78E552063EA3E38E71DD@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Nov 2009, Luck, Tony wrote:
>
> > Make sure compiler won't do weird things with limits. E.g. fetching
> > them twice may return 2 different values after writable limits are
> > implemented.
> 
> -	if (size > task->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
> +	if (size > ACCESS_ONCE(task->signal->rlim[RLIMIT_MEMLOCK].rlim_cur))
> 
> I don't see how this helps.  If someone else is changing limits while
> we are looking at them, then there is a race.  We either get the old
> or the new value.  Using ACCESS_ONCE (which on ia64 forces a "volatile"
> access, which will make the compiler generate "ld.acq" rather than a
> plain "ld") won't make any difference to this race.
> 
> Please explain what issue you see with the current code.

The problem may not be in _that_ particular code, but imagine code like 
this:

	if (a > MEMORY) {
		do1;
		do2;
		do3;
	} else {
		do2;
	}

where the compiler could actually turn this into (having noticed that 
neither "do1" nor "do2" can alias with MEMORY):

	if (a > MEMORY)
		do1;
	do2;
	if (a > MEMORY)
		do3;

and now what you end up having is a situation where it's possible that 
"do1" gets executed but "do3" does not (or vice versa).

Notice how when you look at the code, it looks impossible, and then you 
get subtle security bugs.

Now, you may say that "but _my_ code doesn't have that "else" statement", 
and maybe you're right. In fact, maybe the source code was really just

	if (a > MEMORY)
		return something();
	return do_something_else();

and you are _sure_ that the ACCESS_ONCE() cannot possibly be needed. But 
what if those 'something()' and 'do_something_else()' were inlines, and 
the compiler internally turns it into

	if (a > MEMORY) {
		ret = something();
	} else {
		ret = do_something_else();
	}
	return ret;

and you now hit the case above where part of it was shared after all, and 
the compiler for some strange reason (register reload, whatever) ends up 
doing it as two conditionals after all?

The thing is, you can't _prove_ that the compiler won't do it, especially 
if you end up changing the code later (without thinking about the fact 
that you're loading things without locking).

So the rule is: if you access unlocked values, you use ACCESS_ONCE(). You 
don't say "but it can't matter". Because you simply don't know.

			Linus
