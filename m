Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZESNhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZESNhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZESNhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:37:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36014 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZESNhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:37:34 -0400
Date: Tue, 19 May 2009 15:32:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
Message-ID: <20090519133245.GB14782@redhat.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.K7C._ZzDKB@chimera> <alpine.LFD.2.01.0905171206330.3301@localhost.localdomain> <20090518144132.GA18607@redhat.com> <20090519091631.GB31404@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090519091631.GB31404@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > And I don't think the kernel is buggy, this is expected behaviour.
> > With this commit (actually, there were several patches) /sbin/init
> > respects SIGSTOP if the caller has rights to send it, this change
> > is intentional. I'd even say this is fix.
> >
> > Note that even root can't stop init, SIGSTOP should be sent from
> > the parent namespace, or from ptracer. And ptracer could obviously
> > ptrace_stop() init even before this patch.
>
> There's one important aspect here: _if_ a change results in
> user-space visible behavioral change, it does not matter how correct
> it is in the grand scheme of things. (beyond plain bugfixes solving
> crashes, etc.) What matters is whether there's any app out there
> that might possibly rely on the old behavior.
>
> The LTP testcase might be synthetic, and it could be fixed and the
> commit might even end up being correct - but some thought should be
> expended on compatibility and real-life impact (and scope) here -
> not just on strict 'correctness'.

Yes, agreed.

But hopefully in this case we can't break the user-space. Because the
tracing of /sbin/init is special, and this was forbidden till 2.6.25.
Not only you can make the system unusable, it is very easy to crash
the kernel if you trace init. I don't think any "good" app can rely
on the wrong old behaviour, but of course any behavioral change is
dangerous.

And please note that the old behaviour was known to be wrong. If we
take the sub-namespace inits into account, it was very wrong. Of course,
we can add the special is_global_init() hack to preserve the current
behaviour at least for the root namespace, but this doesn't look good.

Oleg.

