Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZKIJCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZKIJCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZKIJCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:02:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35688 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbZKIJB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:01:59 -0500
Date: Mon, 9 Nov 2009 10:01:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
 external to a process (v7)
Message-ID: <20091109090143.GB24020@elte.hu>
References: <20091012201304.GG32088@hmsreliant.think-freely.org>
 <20091020005214.GA8886@localhost.localdomain>
 <20091102152520.GG23776@elte.hu>
 <20091102175407.GE4075@hmsreliant.think-freely.org>
 <20091102185137.GA28803@elte.hu>
 <20091103002355.GB19891@localhost.localdomain>
 <20091104112632.GA9243@elte.hu>
 <20091105204843.GA2980@hmsreliant.think-freely.org>
 <20091106092600.GC22505@elte.hu>
 <4AF7D8C2.60807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF7D8C2.60807@gmail.com>
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


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 11/06/2009 10:26 AM, Ingo Molnar wrote:
> > Also, the locking there looks messy:
> > 
> > +       /* optimization: 'current' doesn't need locking, e.g. setrlimit */
> > +       if (tsk != current) {
> > +               /* protect tsk->signal and tsk->sighand from disappearing */
> > +               read_lock(&tasklist_lock);
> > +               if (!tsk->sighand) {
> > +                       retval = -ESRCH;
> > +                       goto out;
> > +               }
> >         }
> > 
> > Neil's splitup into a helper function looks _far_ cleaner.
> 
> Oops, I don't understand here. Looking at
> http://patchwork.kernel.org/patch/54863/
> and
> http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=linux.git;a=commitdiff;h=ba9ba971a9241250646091935d77d2f31b7c15af
> 
> They are almost identical. That 'if' above is added by:
> http://decibel.fi.muni.cz/cgi-bin/gitweb.cgi?p=linux.git;a=commitdiff;h=bab65b1e6c0fd797a1ecdb32911faa82947effd0
> 
> The latter commit is to avoid performance penalty introduced for 
> setrlimit syscall by the added lock (as it's unneeded for 'current'). 
> If you find that crappy, there is no problem to drop it, indeed.

Looks a bit ugly but i agree that it's a real speedup as before this 
change we never had to take the tasklist lock for current task rlimit 
setting. (which was the only method possible.)

So i guess renaming setrlimit to do_setrlimit and adding the syscall 
from Neil's patch should bring the two series into sync, right?

	Ingo
